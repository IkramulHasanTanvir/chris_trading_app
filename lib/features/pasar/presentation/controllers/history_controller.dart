import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/features/pasar/data/models/trade_history_model.dart';
import 'package:flutter_task/features/pasar/domain/services/history_service.dart';
import 'package:get/get.dart';

class HistoryController extends GetxController {
  final HistoryService _service;

  HistoryController({required HistoryService service}) : _service = service;

  static HistoryController get to => Get.find();

  // ─── State ────────────────────────────────────────────────────────
  final _loadingState = LoadingState.initial.obs;
  final _errorMessage = ''.obs;

  LoadingState get loadingState => _loadingState.value;
  String get errorMessage => _errorMessage.value;

  // ─── Data ─────────────────────────────────────────────────────────
  final _pendingTrades = <Trades>[].obs;
  final _pendingSummary = Rxn<Summary>();
  final _completedTrades = <Trades>[].obs;
  final _completedSummary = Rxn<Summary>();

  List<Trades> get pendingTrades => _pendingTrades;
  Summary? get pendingSummary => _pendingSummary.value;
  List<Trades> get completedTrades => _completedTrades;
  Summary? get completedSummary => _completedSummary.value;

  // ─── Pagination ───────────────────────────────────────────────────
  static const int _pageSize = 10;

  int _pendingPage = 1;
  int _completedPage = 1;

  final _isLoadingMorePending = false.obs;
  final _isLoadingMoreCompleted = false.obs;
  final _hasMorePending = true.obs;
  final _hasMoreCompleted = true.obs;

  bool get isLoadingMorePending => _isLoadingMorePending.value;
  bool get isLoadingMoreCompleted => _isLoadingMoreCompleted.value;
  bool get hasMorePending => _hasMorePending.value;
  bool get hasMoreCompleted => _hasMoreCompleted.value;


  RxSet<String> expandedItems = <String>{}.obs;

  void toggleExpanded(String id) {
    if (expandedItems.contains(id)) {
      expandedItems.remove(id);
    } else {
      expandedItems.add(id);
    }
  }

  bool isExpanded(String id) => expandedItems.contains(id);


  // ─── Scroll Controllers ───────────────────────────────────────────
  ScrollController? pendingScrollController;
  ScrollController? completedScrollController;

  @override
  void onInit() {
    super.onInit();
    pendingScrollController = ScrollController()
      ..addListener(_onPendingScroll);
    completedScrollController = ScrollController()
      ..addListener(_onCompletedScroll);
    loadData();
  }

  // ─── Scroll Listeners ─────────────────────────────────────────────
  void _onPendingScroll() {
    if (pendingScrollController == null) return;
    final position = pendingScrollController!.position;
    if (position.pixels >= position.maxScrollExtent - 200 &&
        !isLoadingMorePending &&
        hasMorePending) {
      loadMorePending();
    }
  }

  void _onCompletedScroll() {
    if (completedScrollController == null) return;
    final position = completedScrollController!.position;
    if (position.pixels >= position.maxScrollExtent - 200 &&
        !isLoadingMoreCompleted &&
        hasMoreCompleted) {
      loadMoreCompleted();
    }
  }

  // ─── Load All ─────────────────────────────────────────────────────
  Future<void> loadData() async {
    try {
      _errorMessage.value = '';

      final hasCache = _service.hasCache();
      if (hasCache) {
        final cached = _service.getCachedAllData();
        _setPendingData(cached.pending);
        _setCompletedData(cached.completed);
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.loading;
      }

      await _service.fetchAllHistoryData();

      final fresh = _service.getCachedAllData();
      _setPendingData(fresh.pending);
      _setCompletedData(fresh.completed);

      _hasMorePending.value =
          (fresh.pending?.trades?.length ?? 0) >= _pageSize;
      _hasMoreCompleted.value =
          (fresh.completed?.trades?.length ?? 0) >= _pageSize;

      _loadingState.value = LoadingState.loaded;
    } catch (e) {
      if (!_service.hasCache()) {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = e.errorMessage;
      }
    }
  }

  // ─── Load More ────────────────────────────────────────────────────
  Future<void> loadMorePending() async {
    if (isLoadingMorePending || !hasMorePending) return;
    try {
      _isLoadingMorePending.value = true;
      _pendingPage++;

      final result = await _service.fetchMoreHistory(
        page: _pendingPage,
        limit: _pageSize,
        status: 'pending',
      );

      final newTrades = result.trades ?? [];
      if (newTrades.length < _pageSize) _hasMorePending.value = false;

      _pendingTrades.addAll(newTrades);
      _pendingSummary.value = result.summary;
    } catch (e) {
      _pendingPage--;
      ToastMessageHelper.show(e.errorMessage);
    } finally {
      _isLoadingMorePending.value = false;
    }
  }

  Future<void> loadMoreCompleted() async {
    if (isLoadingMoreCompleted || !hasMoreCompleted) return;
    try {
      _isLoadingMoreCompleted.value = true;
      _completedPage++;

      final result = await _service.fetchMoreHistory(
        page: _completedPage,
        limit: _pageSize,
        status: 'completed',
      );

      final newTrades = result.trades ?? [];
      if (newTrades.length < _pageSize) _hasMoreCompleted.value = false;

      _completedTrades.addAll(newTrades);
      _completedSummary.value = result.summary;
    } catch (e) {
      _completedPage--;
      ToastMessageHelper.show(e.errorMessage);
    } finally {
      _isLoadingMoreCompleted.value = false;
    }
  }

  // ─── Retry & Refresh ──────────────────────────────────────────────
  Future<void> retry() async => await loadData();

  // ─── Private Helpers ──────────────────────────────────────────────
  void _setPendingData(TradeHistoryModel? data) {
    if (data?.trades != null) {
      _pendingTrades.assignAll(data!.trades!);
      _pendingSummary.value = data.summary;
    }
  }

  void _setCompletedData(TradeHistoryModel? data) {
    if (data?.trades != null) {
      _completedTrades.assignAll(data!.trades!);
      _completedSummary.value = data.summary;
    }
  }

  // ─── Dispose ──────────────────────────────────────────────────────
  @override
  void onClose() {
    pendingScrollController?.removeListener(_onPendingScroll);
    pendingScrollController?.dispose();
    pendingScrollController = null;

    completedScrollController?.removeListener(_onCompletedScroll);
    completedScrollController?.dispose();
    completedScrollController = null;

    super.onClose();
  }
}