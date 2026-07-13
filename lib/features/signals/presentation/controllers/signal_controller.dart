import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/core/services/connectivity_service.dart';
import 'package:flutter_task/core/services/paginated_list.dart';
import 'package:flutter_task/core/services/paginated_loader_ui.dart';
import 'package:flutter_task/core/services/search_service.dart';
import 'package:flutter_task/features/pasar/presentation/controllers/history_controller.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/signals/data/models/comment_model.dart';
import 'package:flutter_task/features/signals/data/models/log_signal_model.dart';
import 'package:flutter_task/features/signals/data/models/platform_model.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';
import 'package:flutter_task/features/signals/domain/services/signal_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignalsController extends GetxController with PaginatedLoaderUi {
  final SignalsService _service;
  final ConnectivityService _connectivityService;

  static SignalsController get to => Get.find();

  SignalsController({
    required SignalsService service,
    required ConnectivityService connectivityService,
  })  : _service = service,
        _connectivityService = connectivityService;

  final RxString _expandedId = ''.obs;
  bool isExpanded(String id) => _expandedId.value == id;

  void toggleExpanded(String id) {
    _expandedId.value = _expandedId.value == id ? '' : id;
  }

  final entryController = TextEditingController();
  final exitController = TextEditingController();
  final lotController = TextEditingController();
  final pnlController = TextEditingController();
  final notesController = TextEditingController();
  final commentController = TextEditingController();
  final searchController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxString _outcome = 'win'.obs;
  final RxString _platform = 'binance'.obs;
  final RxString _pnlUnit = 'usd'.obs;
  final RxString _imageUrl = ''.obs;
  final Rx<File?> _selectedImage = Rx<File?>(null);
  final RxString _selectedAssetType = ''.obs;
  final RxString _symbolQuery = ''.obs;
  final Map<String, List<SignalsModel>> _categoryCache = {};

  final _platforms = <PlatformModel>[].obs;

  File? get selectedImage => _selectedImage.value;
  String get outcome => _outcome.value;
  String get platform => _platform.value;
  String get pnlUnit => _pnlUnit.value;
  String get imageUrl => _imageUrl.value;
  String get selectedAssetType => _selectedAssetType.value;
  List<PlatformModel> get platforms => _platforms;

  void onOutcomeChanged(String? value) {
    if (value != null) _outcome.value = value;
  }

  void onPlatformChanged(String? value) {
    if (value != null) _platform.value = value;
  }

  void onPnlUnitChanged(String? value) {
    if (value != null) _pnlUnit.value = value;
  }

  void onAssetTypeChanged(String? value) {
    _selectedAssetType.value = value ?? '';
    applyFilters();
  }

  void onImagePicked(XFile file) {
    if (file.path.isNotEmpty) {
      _selectedImage.value = File(file.path);
      _imageUrl.value = '';
      uploadImage();
    }
  }

  void onImageRemoved() {
    _selectedImage.value = null;
    _imageUrl.value = '';
  }

  final _loadingState = LoadingState.initial.obs;
  final _copyState = LoadingState.initial.obs;
  final _logState = LoadingState.initial.obs;
  final _imageState = LoadingState.initial.obs;
  final _detailsState = LoadingState.initial.obs;
  final _addCommentState = LoadingState.initial.obs;
  final _errorMessage = ''.obs;

  LoadingState get loadingState => _loadingState.value;
  LoadingState get copyState => _copyState.value;
  LoadingState get logState => _logState.value;
  LoadingState get imageState => _imageState.value;
  LoadingState get detailsState => _detailsState.value;
  LoadingState get addCommentState => _addCommentState.value;
  String get errorMessage => _errorMessage.value;

  late final PaginatedList<SignalsModel> signalsList;
  late final PaginatedList<CommentModel> commentsList;
  late final SearchService<SignalsModel> search;
  String? _activeCommentSignalId;

  List<SignalsModel> get signals => signalsList.items;
  SignalsModel? get signalDetail => _signalDetail.value;
  List<CommentModel> get comments => commentsList.items;
  final _signalDetail = Rxn<SignalsModel>();

  ScrollController? get scrollController => signalsList.scrollController;
  bool get isLoadingMoreComments => commentsList.isLoadingMore.value;
  bool get hasMoreComments => commentsList.hasMore.value;

  @override
  LoadingState get paginationContentState => loadingState;

  @override
  PaginatedList<dynamic> get paginatedList => signalsList;

  @override
  void onInit() {
    super.onInit();
    signalsList = PaginatedList<SignalsModel>(
      limit: 10,
      fetchPage: _fetchSignalsPage,
      onError: (e) => ToastMessageHelper.show(e.errorMessage),
    );
    commentsList = PaginatedList<CommentModel>(
      limit: 10,
      fetchPage: _fetchCommentsPage,
      onError: (e) => ToastMessageHelper.show(e.errorMessage),
    );
    search = SearchService(fetcher: _fetchSearch);
    signalsList.initScroll();
    loadData();
    loadPlatforms();
  }

  Future<List<SignalsModel>> _fetchSearch(String query) async {
    final q = query.toLowerCase();
    final fromCache = _service
        .getCachedData()
        .signals
        .where((s) {
          final symbol = (s.symbol ?? '').toLowerCase();
          final title = (s.title ?? '').toLowerCase();
          return symbol.contains(q) || title.contains(q);
        })
        .toList();
    if (fromCache.isNotEmpty) return fromCache;

    final isOnline = await _connectivityService.checkConnectivity();
    if (!isOnline) return [];

    await _service.fetchAllSignalsData(
      search: query,
      assetType: selectedAssetType.isEmpty ? null : selectedAssetType,
      sortBy: 'newest',
    );
    return _service.getCachedData().signals;
  }

  void applySearchQuery(String query) {
    searchController.text = query;
    applyFilters();
  }

  Future<List<SignalsModel>> _fetchSignalsPage(int page, int limit) async {
    final assetType =
        selectedAssetType.isEmpty ? null : selectedAssetType;
    final symbol = _symbolQuery.value.trim().isEmpty
        ? null
        : _symbolQuery.value.trim();

    if (page == 1) {
      await _service.fetchAllSignalsData(
        assetType: assetType,
        symbol: symbol,
        sortBy: 'newest',
      );
      return _service.getCachedData().signals;
    }
    return _service.fetchMoreSignals(
      page: page,
      limit: limit,
      assetType: assetType,
      symbol: symbol,
      sortBy: 'newest',
    );
  }

  Future<List<CommentModel>> _fetchCommentsPage(int page, int limit) async {
    final signalId = _activeCommentSignalId;
    if (signalId == null || signalId.isEmpty) return [];
    if (page == 1) {
      await _service.fetchInitialComments(signalId);
      return _service.getCachedData().comments;
    }
    return _service.fetchMoreComments(
      signalId: signalId,
      page: page,
      limit: limit,
    );
  }

  Future<void> loadData() async {
    try {
      _errorMessage.value = '';
      final hasCache = _service.hasCache();
      if (hasCache && selectedAssetType.isEmpty && _symbolQuery.isEmpty) {
        final cached = _service.getCachedData();
        signalsList.items.assignAll(cached.signals);
        _loadingState.value = LoadingState.loaded;
        _categoryCache[''] = List.from(cached.signals);
      } else {
        _loadingState.value = LoadingState.loading;
      }
      await signalsList.loadFirst();
      _loadingState.value = LoadingState.loaded;
      if (_symbolQuery.isEmpty) {
        _categoryCache[_selectedAssetType.value] = List.from(signalsList.items);
      }
    } catch (e) {
      if (!_service.hasCache()) {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = e.errorMessage;
      }
    }
  }

  Future<void> applyFilters() async {
    final query = searchController.text.trim();
    _symbolQuery.value = query;
    
    final category = _selectedAssetType.value;
    final isSearchActive = query.isNotEmpty;
    
    // Check if we have cached items specifically for this category and no search is active
    final hasCategoryCache = !isSearchActive && _categoryCache.containsKey(category);
    
    if (hasCategoryCache) {
      signalsList.items.assignAll(_categoryCache[category]!);
      _loadingState.value = LoadingState.loaded;
    } else {
      signalsList.items.clear();
      _loadingState.value = LoadingState.loading;
    }
    
    try {
      await signalsList.loadFirst();
      _loadingState.value = LoadingState.loaded;
      
      // Cache the result for this category
      if (!isSearchActive) {
        _categoryCache[category] = List.from(signalsList.items);
      }
    } catch (e) {
      _loadingState.value = LoadingState.error;
      _errorMessage.value = e.errorMessage;
    }
  }

  void clearFilters() {
    searchController.clear();
    _symbolQuery.value = '';
    _selectedAssetType.value = '';
    applyFilters();
  }

  Future<void> loadPlatforms() async {
    try {
      final list = await _service.getPlatforms();
      if (list.isEmpty) {
        _platforms.assignAll(const [
          PlatformModel(value: 'binance', label: 'Binance'),
          PlatformModel(value: 'mt4', label: 'MT4'),
          PlatformModel(value: 'mt5', label: 'MT5'),
          PlatformModel(value: 'bybit', label: 'Bybit'),
        ]);
      } else {
        _platforms.assignAll(list);
      }
      if (_platforms.every((e) => e.value != platform)) {
        _platform.value = _platforms.first.value;
      }
    } catch (_) {
      _platforms.assignAll(const [
        PlatformModel(value: 'binance', label: 'Binance'),
        PlatformModel(value: 'mt4', label: 'MT4'),
        PlatformModel(value: 'mt5', label: 'MT5'),
        PlatformModel(value: 'bybit', label: 'Bybit'),
      ]);
    }
  }

  @override
  Future<void> refresh() => signalsList.refreshWith(loadData);

  Future<void> getSignalDetails(
    String signalId, {
    bool showLoader = true,
  }) async {
    try {
      _errorMessage.value = '';
      if (showLoader) {
        _signalDetail.value = null;
        _detailsState.value = LoadingState.loading;
      }
      final data = await _service.getSignalDetails(signalId);
      _signalDetail.value = data;
      _detailsState.value = LoadingState.loaded;
    } catch (e) {
      if (showLoader || _signalDetail.value == null) {
        _detailsState.value = LoadingState.error;
      }
      _errorMessage.value = e.errorMessage;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  Future<void> loadComments(String signalId, {bool refresh = false}) async {
    _activeCommentSignalId = signalId;
    try {
      await commentsList.loadFirst();
    } catch (e) {
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  Future<void> loadMoreComments(String signalId) async {
    _activeCommentSignalId = signalId;
    await commentsList.loadMore();
  }

  Future<void> submitComment(String signalId) async {
    final text = commentController.text.trim();
    if (text.isEmpty) return;

    final user = ProfileController.to.userData;
    final tempId = DateTime.now().millisecondsSinceEpoch.toString();
    final optimisticComment = CommentModel(
      sId: tempId,
      message: text,
      userId: UserId(
        sId: user?.sId,
        name: user?.name,
        userProfileUrl: user?.userProfileUrl,
      ),
      createdAt: DateTime.now().toIso8601String(),
      isPending: true,
    );

    commentController.clear();
    commentsList.items.insert(0, optimisticComment);

    try {
      _addCommentState.value = LoadingState.loading;
      await _service.addComment(signalId: signalId, comment: text);
      _addCommentState.value = LoadingState.loaded;
      await loadComments(signalId, refresh: true);
    } catch (e) {
      commentsList.items.removeWhere((c) => c.sId == tempId);
      _addCommentState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  void _markSignalCopied(String signalId) {
    final index = signalsList.items.indexWhere((e) => e.sId == signalId);
    if (index != -1) {
      final item = signalsList.items[index];
      item.isCopied = true;
      signalsList.items[index] = item;
      signalsList.items.refresh();
    }
    if (_signalDetail.value?.sId == signalId) {
      _signalDetail.value?.isCopied = true;
      _signalDetail.refresh();
    }
  }

  Future<void> copyTradingSignal({required String signalId}) async {
    if (signalId.isEmpty) return;
    try {
      _copyState.value = LoadingState.loading;
      await _service.copyTradingSignal(signalId: signalId);
      _markSignalCopied(signalId);
      _copyState.value = LoadingState.loaded;
      if (Get.isRegistered<HistoryController>()) {
        await HistoryController.to.retry();
      }
      ToastMessageHelper.show('Signal copied successfully');
    } catch (e) {
      _copyState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  Future<void> logTradingSignal(String signalId) async {
    if (!formKey.currentState!.validate()) return;

    if (selectedImage == null) {
      ToastMessageHelper.show('Please add a screenshot');
      return;
    }
    if (imageState.isLoading) {
      ToastMessageHelper.show('Please wait for screenshot upload');
      return;
    }
    if (imageUrl.isEmpty) {
      ToastMessageHelper.show('Screenshot upload failed. Please try again');
      return;
    }

    try {
      _logState.value = LoadingState.loading;
      await _service.logTradingSignal(
        LogTradingSignalModel(
          entryPrice: double.tryParse(entryController.text) ?? 0,
          exitPrice: double.tryParse(exitController.text) ?? 0,
          lotSize: double.tryParse(lotController.text) ?? 0,
          outcome: outcome,
          notes: notesController.text,
          signalId: signalId,
          resultPnl: double.tryParse(pnlController.text) ?? 0,
          screenshotUrl: imageUrl,
          externalPlatform: platform,
          pnlUnit: pnlUnit,
        ),
      );
      _logState.value = LoadingState.loaded;
      if (Get.isRegistered<HistoryController>()) {
        await HistoryController.to.retry();
      }
      entryController.clear();
      exitController.clear();
      lotController.clear();
      pnlController.clear();
      notesController.clear();
      _selectedImage.value = null;
      _imageUrl.value = '';
      _pnlUnit.value = 'usd';
      Get.back(canPop: true);
      ToastMessageHelper.show('Signal logged successfully');
    } catch (e) {
      _logState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  Future<void> uploadImage() async {
    if (selectedImage == null) return;
    try {
      _imageState.value = LoadingState.loading;
      final url = await _service.uploadImage(selectedImage!);
      _imageState.value = LoadingState.loaded;
      _imageUrl.value = url;
    } catch (e) {
      _imageState.value = LoadingState.error;
      _imageUrl.value = '';
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  Future<void> retry() async => await loadData();

  List<String> get assetTypeOptions => ApiConstants.assetTypes;

  @override
  void onClose() {
    signalsList.dispose();
    commentsList.dispose();
    entryController.dispose();
    exitController.dispose();
    lotController.dispose();
    pnlController.dispose();
    notesController.dispose();
    commentController.dispose();
    searchController.dispose();
    super.onClose();
  }
}
