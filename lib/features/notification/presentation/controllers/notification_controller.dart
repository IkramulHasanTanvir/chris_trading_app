import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/core/services/paginated_list.dart';
import 'package:flutter_task/core/services/paginated_loader_ui.dart';
import 'package:flutter_task/features/notification/data/models/notification_model.dart';
import 'package:flutter_task/features/notification/domain/services/notification_services.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController with PaginatedLoaderUi {
  final NotificationServices _service;

  static NotificationController get to => Get.find();

  NotificationController({required NotificationServices service})
      : _service = service;

  // ─── Loading States ───────────────────────────────────────────────
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
    notificationList = PaginatedList<NotificationModel>(
      limit: 10,
      fetchPage: _fetchPage,
      onError: (e) => ToastMessageHelper.show(e.errorMessage),
    );
    notificationList.initScroll();
    loadData();
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

  Future<void> retry() async => await loadData();

  @override
  Future<void> refresh() => notificationList.refreshWith(loadData);

  @override
  void onClose() {
    notificationList.dispose();
    super.onClose();
  }
}
