import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/features/notification/data/models/notification_model.dart';
import 'package:flutter_task/features/notification/data/repositories/notification_repository.dart';

class NotificationServices {
  final NotificationRepository _repository;

  NotificationServices({required NotificationRepository repository})
      : _repository = repository;

  // ─── Fetch All ────────────────────────────────────────────────────
  Future<void> fetchAllNotification() async {
    try {
      await Future.wait([
       _repository.getNotification(1, 10),
        _repository.getNotificationCount(),

    ]);
    } on AppException {
      if (!hasCache()) {
        rethrow;
      }
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<NotificationModel>> fetchMoreNotification({
    required int page,
    required int limit,
  }) async {
    try {
      return await _repository.fetchMoreNotification(page: page, limit: limit);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> markNotificationRead(String id) async {
    try {
      await _repository.markNotificationRead(id);
      await _repository.refreshUnreadCount();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<int> getUnreadCount() async {
    try {
      return await _repository.getNotificationCount();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }



  // ─── Cache ────────────────────────────────────────────────────────
  bool hasCache() {
    return _repository.hasCache();
  }

  NotificationData getCachedData() {
    return NotificationData(
      notification: _repository.getCachedNotification() ?? [],
      notificationCount: _repository.getCachedNotificationCount() ?? 0,
    );
  }
}

// ─── Screen Data Model ────────────────────────────────────────────────
class NotificationData {
  final List<NotificationModel> notification;
  final int notificationCount;

  NotificationData( {required this.notification,required this.notificationCount,});
}