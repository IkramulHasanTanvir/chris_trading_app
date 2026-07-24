import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/services/paginated_list.dart';
import 'package:flutter_task/core/services/paginated_loader_ui.dart';
import 'package:flutter_task/features/notification/data/models/notification_model.dart';
import 'package:flutter_task/features/notification/domain/services/notification_services.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController
    with PaginatedLoaderUi, WidgetsBindingObserver {
  final NotificationServices _service;

  static NotificationController get to => Get.find();

  NotificationController({required NotificationServices service})
      : _service = service;

  final _loadingState = LoadingState.initial.obs;
  final _errorMessage = ''.obs;

  LoadingState get loadingState => _loadingState.value;
  String get errorMessage => _errorMessage.value;

  final _notificationCount = 0.obs;
  int get notificationCount => _notificationCount.value;

  late final PaginatedList<NotificationModel> notificationList;

  List<NotificationModel> get notification => notificationList.items;
  ScrollController? get scrollController => notificationList.scrollController;

  @override
  LoadingState get paginationContentState => loadingState;

  @override
  PaginatedList<dynamic> get paginatedList => notificationList;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    notificationList = PaginatedList<NotificationModel>(
      limit: 10,
      fetchPage: _fetchPage,
      onError: (e) => ToastMessageHelper.show(e.errorMessage),
    );
    notificationList.initScroll();
    loadData();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Pull unread count when app returns to foreground (helps reduce stale delays).
      _refreshUnreadCountQuietly();
    }
  }

  Future<void> _refreshUnreadCountQuietly() async {
    try {
      final count = await _service.getUnreadCount();
      _notificationCount.value = count;
    } catch (_) {}
  }

  Future<List<NotificationModel>> _fetchPage(int page, int limit) async {
    if (page == 1) {
      await _service.fetchAllNotification();
      final fresh = _service.getCachedData();
      _notificationCount.value = fresh.notificationCount;
      return fresh.notification;
    }
    return _service.fetchMoreNotification(page: page, limit: limit);
  }

  Future<void> loadData() async {
    try {
      _errorMessage.value = '';
      if (_service.hasCache()) {
        final cached = _service.getCachedData();
        notificationList.items.assignAll(cached.notification);
        _notificationCount.value = cached.notificationCount;
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.loading;
      }
      await notificationList.loadFirst();
      _loadingState.value = LoadingState.loaded;
    } catch (e) {
      if (!_service.hasCache()) {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = e.errorMessage;
      }
    }
  }

  Future<void> onNotificationTap(NotificationModel item) async {
    final wasUnread = item.isRead != true;
    if (wasUnread && (item.sId ?? '').isNotEmpty) {
      item.isRead = true;
      notificationList.items.refresh();
      if (_notificationCount.value > 0) {
        _notificationCount.value = _notificationCount.value - 1;
      }
      _markAsReadInBackground(item);
    }

    final signalId = item.data?.signalId;
    if (signalId != null && signalId.isNotEmpty) {
      Get.toNamed(AppRoutes.signalsDetailsScreen, arguments: signalId);
    }
  }

  Future<void> _markAsReadInBackground(NotificationModel item) async {
    try {
      await _service.markNotificationRead(item.sId!);
      final count = await _service.getUnreadCount();
      _notificationCount.value = count;
    } catch (e) {
      item.isRead = false;
      notificationList.items.refresh();
      _notificationCount.value = _notificationCount.value + 1;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  Future<void> markAllAsRead() async {
    final hasUnread = notificationList.items.any((e) => e.isRead != true);
    if (!hasUnread) {
      ToastMessageHelper.show('No unread notifications');
      return;
    }

    for (final item in notificationList.items) {
      item.isRead = true;
    }
    notificationList.items.refresh();
    _notificationCount.value = 0;

    try {
      await _service.markAllNotificationsRead();
      final count = await _service.getUnreadCount();
      _notificationCount.value = count;
      ToastMessageHelper.show('All notifications marked as read');
    } catch (e) {
      ToastMessageHelper.show(e.errorMessage);
      await loadData();
    }
  }

  Future<void> retry() async => await loadData();

  @override
  Future<void> refresh() => notificationList.refreshWith(loadData);

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    notificationList.dispose();
    super.onClose();
  }
}
