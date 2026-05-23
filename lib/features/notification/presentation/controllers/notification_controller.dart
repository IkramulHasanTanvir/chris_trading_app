import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/features/notification/data/models/notification_model.dart';
import 'package:flutter_task/features/notification/domain/services/notification_services.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController {
  final NotificationServices _service;

  static NotificationController get to => Get.find();

  NotificationController({required NotificationServices service})
    : _service = service;

  // ─── Loading States ───────────────────────────────────────────────
  final _loadingState = LoadingState.initial.obs;

  LoadingState get loadingState => _loadingState.value;

  // ─── Data ─────────────────────────────────────────────────────────
  final _notification = <NotificationModel>[].obs;

  final _notificationCount = 0.obs;

  int get notificationCount => _notificationCount.value;

  List<NotificationModel> get notification => _notification;

  // ─── Signals Pagination ───────────────────────────────────────────
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

  // ─── Load notification ─────────────────────────────────────────────────
  Future<void> loadData() async {
    try {
      if (_service.hasCache()) {
        _notification.assignAll(_service.getCachedData().notification);
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.loading;
      }

      await _service.fetchAllNotification();
      final fresh = _service.getCachedData().notification;
      _notificationCount.value = _service.getCachedData().notificationCount;
      _notification.assignAll(fresh);

      _hasMore.value = fresh.length >= _pageSize;
      _loadingState.value = LoadingState.loaded;

    } catch (e) {
      if (!_service.hasCache()) {
        _loadingState.value = LoadingState.error;

      }
    }
  }

  // ─── Load More Signals ────────────────────────────────────────────
  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;

    try {
      _isLoadingMore.value = true;
      _currentPage++;

      final data = await _service.fetchMoreNotification(
        page: _currentPage,
        limit: _pageSize,
      );
      _notification.addAll(data);

      if (data.length < _pageSize) _hasMore.value = false;
    } catch (e) {
      _currentPage--;
      ToastMessageHelper.show(e.errorMessage);
    } finally {
      _isLoadingMore.value = false;
    }
  }

  Future<void> retry() async => await loadData();

  // ─── Dispose ──────────────────────────────────────────────────────
  @override
  void onClose() {
    scrollController?.removeListener(_onScroll);
    scrollController?.dispose();
    scrollController = null;
    super.onClose();
  }
}
