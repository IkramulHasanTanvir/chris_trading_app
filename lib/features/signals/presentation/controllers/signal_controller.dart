import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/features/signals/data/models/log_signal_model.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';
import 'package:flutter_task/features/signals/domain/services/signal_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class SignalsController extends GetxController {
  final SignalsService _service;

  static SignalsController get to => Get.find();

  SignalsController({required SignalsService service}) : _service = service;

  // ─── Expansion ────────────────────────────────────────────────────
  final RxBool _isExpanded = false.obs;
  final RxBool _isLiked = false.obs;

  bool get isExpanded => _isExpanded.value;

  bool get isLiked => _isLiked.value;

  void toggleExpanded() {
    _isExpanded.value = !_isExpanded.value;
  }

  void toggleLike() {
    _isLiked.value = !_isLiked.value;
  }

  // ─── Controller ───────────────────────────────────────────────────
  final entryController = TextEditingController();
  final exitController = TextEditingController();
  final lotController = TextEditingController();
  final pnlController = TextEditingController();
  final notesController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final RxString _outcome = 'win'.obs;
  final RxString _platform = 'binance'.obs;
  final Rx<File?> _selectedImage = Rx<File?>(null);
  File? get selectedImage => _selectedImage.value;

  String get outcome => _outcome.value;

  String get platform => _platform.value;

  void onOutcomeChanged(String? value) {
    if (value != null) {
      _outcome.value = value;
    }
  }

  void onPlatformChanged(String? value) {
    if (value != null) {
      _platform.value = value;
    }
  }

  void onImagePicked(XFile file) {
    if (file.path.isNotEmpty) {
      _selectedImage.value = File(file.path);
      print("Image path: ${file.path}");
    } else {
      print("Image path is empty!");
    }
  }


  void onImageRemoved() {
    _selectedImage.value = null;
  }


  // ─── State ────────────────────────────────────────────────────────
  final _loadingState = LoadingState.initial.obs;
  final _copyState = LoadingState.initial.obs;
  final _logState = LoadingState.initial.obs;
  final _errorMessage = ''.obs;

  LoadingState get loadingState => _loadingState.value;

  LoadingState get copyState => _copyState.value;

  LoadingState get logState => _logState.value;

  String get errorMessage => _errorMessage.value;

  // ─── Data ─────────────────────────────────────────────────────────
  final _signals = <SignalsModel>[].obs;

  List<SignalsModel> get signals => _signals;

  // ─── Pagination ───────────────────────────────────────────────────
  int _currentPage = 1;
  static const int _pageSize = 10;

  final _isLoadingMore = false.obs;
  final _hasMore = true.obs;

  bool get isLoadingMore => _isLoadingMore.value;

  bool get hasMore => _hasMore.value;

  // ─── Scroll ───────────────────────────────────────────────────────
  ScrollController? scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_onScroll);
    loadData();
  }

  void _onScroll() {
    if (scrollController == null) return;
    final position = scrollController!.position;

    if (position.pixels >= position.maxScrollExtent - 200 &&
        !isLoadingMore &&
        hasMore) {
      loadMore();
    }
  }

  // ─── Load All ─────────────────────────────────────────────────────
  Future<void> loadData() async {
    try {
      _errorMessage.value = '';

      final hasCache = _service.hasCache();
      if (hasCache) {
        final cached = _service.getCachedData();
        _signals.assignAll(cached.signals);
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.loading;
      }

      await _service.fetchAllSignalsData();

      final fresh = _service.getCachedData();
      _signals.assignAll(fresh.signals);
      _hasMore.value = _signals.length >= _pageSize;
      _loadingState.value = LoadingState.loaded;
    } catch (e) {
      if (!_service.hasCache()) {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = e.errorMessage;
      }
    }
  }

  // ─── Pagination ───────────────────────────────────────────────────
  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;

    try {
      _isLoadingMore.value = true;
      _currentPage++;

      final data = await _service.fetchMoreSignals(
        page: _currentPage,
        limit: _pageSize,
      );
      _signals.addAll(data);

      if (data.length < _pageSize) _hasMore.value = false;
    } catch (e) {
      _currentPage--;
      ToastMessageHelper.show(e.errorMessage);
    } finally {
      _isLoadingMore.value = false;
    }
  }

  // ─── Copy Signal ──────────────────────────────────────────────────
  Future<void> copyTradingSignal({required String signalId}) async {
    try {
      _copyState.value = LoadingState.loading;
      await _service.copyTradingSignal(signalId: signalId);
      _copyState.value = LoadingState.loaded;
      ToastMessageHelper.show('Signal copied successfully');
    } catch (e) {
      _copyState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  // ─── Log Signal ───────────────────────────────────────────────────
  Future<void> logTradingSignal(String signalId) async {
    if(!formKey.currentState!.validate() || selectedImage == null) return;
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
          screenshotUrl: 'https://example.com/screenshot.png',
          externalPlatform: platform,
        ),
      );
      _logState.value = LoadingState.loaded;
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

  Future<void> retry() async => await loadData();

  // ─── Dispose ──────────────────────────────────────────────────────
  @override
  void onClose() {
    scrollController?.removeListener(_onScroll);
    scrollController?.dispose();
    scrollController = null;
    entryController.dispose();
    exitController.dispose();
    lotController.dispose();
    pnlController.dispose();
    notesController.dispose();
    super.onClose();
  }
}
