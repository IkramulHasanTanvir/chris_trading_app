import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/core/services/paginated_list.dart';
import 'package:flutter_task/core/services/paginated_loader_ui.dart';
import 'package:flutter_task/features/pasar/presentation/controllers/history_controller.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/signals/data/models/comment_model.dart';
import 'package:flutter_task/features/signals/data/models/log_signal_model.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';
import 'package:flutter_task/features/signals/domain/services/signal_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignalsController extends GetxController with PaginatedLoaderUi {
  final SignalsService _service;

  static SignalsController get to => Get.find();

  SignalsController({required SignalsService service}) : _service = service;

  // ─── Expansion ────────────────────────────────────────────────────
  final RxString _expandedId = ''.obs;

  bool isExpanded(String id) => _expandedId.value == id;

  void toggleExpanded(String id) {
    if (_expandedId.value == id) {
      _expandedId.value = '';
    } else {
      _expandedId.value = id;
    }
  }

  // ─── Text Controllers ─────────────────────────────────────────────
  final entryController = TextEditingController();
  final exitController = TextEditingController();
  final lotController = TextEditingController();
  final pnlController = TextEditingController();
  final notesController = TextEditingController();
  final commentController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  // ─── Observables ──────────────────────────────────────────────────
  final RxString _outcome = 'win'.obs;
  final RxString _platform = 'binance'.obs;
  final RxString _imageUrl = ''.obs;
  final Rx<File?> _selectedImage = Rx<File?>(null);

  File? get selectedImage => _selectedImage.value;
  String get outcome => _outcome.value;
  String get platform => _platform.value;
  String get imageUrl => _imageUrl.value;

  void onOutcomeChanged(String? value) {
    if (value != null) _outcome.value = value;
  }

  void onPlatformChanged(String? value) {
    if (value != null) _platform.value = value;
  }

  void onImagePicked(XFile file) {
    if (file.path.isNotEmpty) {
      _selectedImage.value = File(file.path);
      uploadImage();
    }
  }

  void onImageRemoved() {
    _selectedImage.value = null;
  }

  // ─── Loading States ───────────────────────────────────────────────
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

  // ─── Signals Pagination ───────────────────────────────────────────
  late final PaginatedList<SignalsModel> signalsList;
  late final PaginatedList<CommentModel> commentsList;

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
    signalsList.initScroll();
    loadData();
  }

  Future<List<SignalsModel>> _fetchSignalsPage(int page, int limit) async {
    if (page == 1) {
      await _service.fetchAllSignalsData();
      return _service.getCachedData().signals;
    }
    return _service.fetchMoreSignals(page: page, limit: limit);
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
      if (hasCache) {
        final cached = _service.getCachedData();
        signalsList.items.assignAll(cached.signals);
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.loading;
      }

      await signalsList.loadFirst();
      _loadingState.value = LoadingState.loaded;
    } catch (e) {
      if (!_service.hasCache()) {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = e.errorMessage;
      }
    }
  }

  @override
  Future<void> refresh() => signalsList.refreshWith(loadData);

  // ─── Signal Details ───────────────────────────────────────────────
  Future<void> getSignalDetails(String signalId) async {
    try {
      _signalDetail.value = null;
      _detailsState.value = LoadingState.loading;
      final data = await _service.getSignalDetails(signalId);
      _signalDetail.value = data;
      _detailsState.value = LoadingState.loaded;
    } catch (e) {
      _detailsState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  // ─── Load Comments ────────────────────────────────────────────────
  Future<void> loadComments(String signalId, {bool refresh = false}) async {
    _activeCommentSignalId = signalId;
    try {
      if (refresh) {
        await commentsList.loadFirst();
      } else {
        await commentsList.loadFirst();
      }
    } catch (e) {
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  Future<void> loadMoreComments(String signalId) async {
    _activeCommentSignalId = signalId;
    await commentsList.loadMore();
  }

  // ─── Submit Comment ───────────────────────────────────────────────
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

  // ─── Copy Signal ──────────────────────────────────────────────────
  Future<void> copyTradingSignal({required String signalId}) async {
    try {
      _copyState.value = LoadingState.loading;
      await _service.copyTradingSignal(signalId: signalId);
      _copyState.value = LoadingState.loaded;
      await HistoryController.to.retry();
      ToastMessageHelper.show('Signal copied successfully');
    } catch (e) {
      _copyState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  // ─── Log Signal ───────────────────────────────────────────────────
  Future<void> logTradingSignal(String signalId) async {
    if (!formKey.currentState!.validate() || selectedImage == null) return;

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
        ),
      );
      _logState.value = LoadingState.loaded;
      await HistoryController.to.retry();
      entryController.clear();
      exitController.clear();
      lotController.clear();
      pnlController.clear();
      notesController.clear();
      _selectedImage.value = null;
      Get.back(canPop: true);
      ToastMessageHelper.show('Signal logged successfully');
    } catch (e) {
      _logState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  // ─── Upload Image ─────────────────────────────────────────────────
  Future<void> uploadImage() async {
    if (selectedImage == null) return;

    try {
      _imageState.value = LoadingState.loading;
      final url = await _service.uploadImage(selectedImage!);
      _imageState.value = LoadingState.loaded;
      _imageUrl.value = url;
    } catch (e) {
      _imageState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  Future<void> retry() async => await loadData();

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
    super.onClose();
  }
}
