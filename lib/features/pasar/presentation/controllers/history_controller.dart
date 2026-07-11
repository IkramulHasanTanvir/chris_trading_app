import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/core/services/paginated_list.dart';
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

  // ─── Summaries ────────────────────────────────────────────────────
  final _pendingSummary = Rxn<Summary>();
  final _completedSummary = Rxn<Summary>();

  Summary? get pendingSummary => _pendingSummary.value;
  Summary? get completedSummary => _completedSummary.value;

  // ─── Paginated lists ──────────────────────────────────────────────
  late final PaginatedList<Trades> pendingList;
  late final PaginatedList<Trades> completedList;

  List<Trades> get pendingTrades => pendingList.items;
  List<Trades> get completedTrades => completedList.items;

  ScrollController? get pendingScrollController => pendingList.scrollController;
  ScrollController? get completedScrollController =>
      completedList.scrollController;

  bool get isLoadingMorePending => pendingList.showLoadMoreLoader;
  bool get isLoadingMoreCompleted => completedList.showLoadMoreLoader;
  bool get hasMorePending => pendingList.hasMore.value;
  bool get hasMoreCompleted => completedList.hasMore.value;

  RxSet<String> expandedItems = <String>{}.obs;

  void toggleExpanded(String id) {
    if (expandedItems.contains(id)) {
      expandedItems.remove(id);
    } else {
      expandedItems.add(id);
    }
  }

  bool isExpanded(String id) => expandedItems.contains(id);

  @override
  void onInit() {
    super.onInit();
    void onError(Object e) => ToastMessageHelper.show(e.errorMessage);

    pendingList = PaginatedList<Trades>(
      limit: 10,
      fetchPage: _fetchPendingPage,
      onError: onError,
    );
    completedList = PaginatedList<Trades>(
      limit: 10,
      fetchPage: _fetchCompletedPage,
      onError: onError,
    );

    loadData();
  }

  Future<List<Trades>> _fetchPendingPage(int page, int limit) async {
    if (page == 1) {
      final cached = _service.getCachedData('pending');
      _pendingSummary.value = cached?.summary;
      return cached?.trades ?? [];
    }
    final result = await _service.fetchMoreHistory(
      page: page,
      limit: limit,
      status: 'pending',
    );
    _pendingSummary.value = result.summary;
    return result.trades ?? [];
  }

  Future<List<Trades>> _fetchCompletedPage(int page, int limit) async {
    if (page == 1) {
      final cached = _service.getCachedData('completed');
      _completedSummary.value = cached?.summary;
      return cached?.trades ?? [];
    }
    final result = await _service.fetchMoreHistory(
      page: page,
      limit: limit,
      status: 'completed',
    );
    _completedSummary.value = result.summary;
    return result.trades ?? [];
  }

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
      await Future.wait([
        pendingList.loadFirst(),
        completedList.loadFirst(),
      ]);

      _loadingState.value = LoadingState.loaded;
    } catch (e) {
      if (!_service.hasCache()) {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = e.errorMessage;
      }
    }
  }

  Future<void> retry() async => await loadData();

  @override
  Future<void> refresh() => pendingList.refreshWith(loadData);

  void _setPendingData(TradeHistoryModel? data) {
    if (data?.trades != null) {
      pendingList.items.assignAll(data!.trades!);
      _pendingSummary.value = data.summary;
    }
  }

  void _setCompletedData(TradeHistoryModel? data) {
    if (data?.trades != null) {
      completedList.items.assignAll(data!.trades!);
      _completedSummary.value = data.summary;
    }
  }

  @override
  void onClose() {
    pendingList.dispose();
    completedList.dispose();
    super.onClose();
  }
}
