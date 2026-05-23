import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/features/notification/data/models/notification_model.dart';
import 'package:flutter_task/features/profile/data/models/user_response_model.dart';
import 'package:image_picker/image_picker.dart';

class NotificationRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  NotificationRepository({
    required ApiService apiService,
    required CacheService cacheService,
  }) : _apiService = apiService,
       _cacheService = cacheService;



  Future<List<NotificationModel>> getNotification(int page, int limit) async {
    try {
      final response = await _apiService.get(ApiConstants.notifications(page, limit));
      final list = response.data['data'] as List? ?? [];
      final model = list.map((e) => NotificationModel.fromJson(e)).toList();
      await _cacheService.put(
        AppConstants.cacheNotifications,
        model.map((e) => e.toJson()).toList(),
      );
      return model;
    } on AppException {
      final cached = getCachedNotification();
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<NotificationModel>> fetchMoreNotification({
    required int page,
    required int limit,
  }) async {
    final newData = await getNotification(page, limit);
    if (newData.isNotEmpty) {
      final current = getCachedNotification() ?? [];
      final merged = [...current, ...newData];
      await _cacheService.put(
        AppConstants.cacheNotifications,
        merged.map((e) => e.toJson()).toList(),
      );
    }
    return newData;
  }

  List<NotificationModel>? getCachedNotification() {
    try {
      final jsonList = _cacheService.get<List>(
        AppConstants.cacheNotifications,
        defaultValue: null,
      );
      if (jsonList == null) return null;
      return jsonList
          .map((json) => NotificationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting cached referral data: $e');
      return null;
    }
  }




  Future<int> getNotificationCount() async {
    try {
      final response = await _apiService.get(ApiConstants.notificationCount);
      final data = response.data['data'] as Map<String, dynamic>?;
      final count = (data?['unreadCount'] as num?)?.toInt() ?? 0;
      await _cacheService.put(
        AppConstants.cacheNotificationCount, count);
      return count;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  int? getCachedNotificationCount() {
    try {
      final json = _cacheService.get<int>(
        AppConstants.cacheNotificationCount,
        defaultValue: null,
      );
      if (json == null) return null;
      return (json as num?)?.toInt() ?? 0;
      } catch (e) {
      debugPrint('Error getting cached referral data: $e');
      return null;
    }
  }



  bool hasCache() {
    return _cacheService.containsKey(AppConstants.cacheNotifications);
  }


}
