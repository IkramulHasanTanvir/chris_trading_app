import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/features/signals/data/models/comment_model.dart';
import 'package:flutter_task/features/signals/data/models/log_signal_model.dart';
import 'package:flutter_task/features/signals/data/models/platform_model.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';

class SignalsRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  SignalsRepository({
    required ApiService apiService,
    required CacheService cacheService,
  }) : _apiService = apiService,
       _cacheService = cacheService;

  Future<List<SignalsModel>> getSignalData({
    required int page,
    required int limit,
    String? assetType,
    String? symbol,
    String? search,
    String sortBy = 'newest',
  }) async {
    try {
      final response = await _apiService.get(
        ApiConstants.signals(
          page: page,
          limit: limit,
          assetType: assetType,
          symbol: symbol,
          search: search,
          sortBy: sortBy,
        ),
      );
      final list = response.data['data'] as List? ?? [];
      final model = list.map((e) => SignalsModel.fromJson(e)).toList();
      if (page == 1) {
        await _cacheService.put(
          AppConstants.cacheSignals,
          model.map((e) => e.toJson()).toList(),
        );
      }
      return model;
    } on AppException {
      if (page == 1) {
        final cached = getCachedSignalData();
        if (cached != null) return cached;
      }
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<SignalsModel>> fetchMoreSignalData({
    required int page,
    required int limit,
    String? assetType,
    String? symbol,
    String? search,
    String sortBy = 'newest',
  }) async {
    final newData = await getSignalData(
      page: page,
      limit: limit,
      assetType: assetType,
      symbol: symbol,
      search: search,
      sortBy: sortBy,
    );
    if (newData.isNotEmpty) {
      final current = getCachedSignalData() ?? [];
      final merged = [...current, ...newData];
      await _cacheService.put(
        AppConstants.cacheSignals,
        merged.map((e) => e.toJson()).toList(),
      );
    }
    return newData;
  }

  List<SignalsModel>? getCachedSignalData() {
    try {
      final jsonList = _cacheService.get<List>(
        AppConstants.cacheSignals,
        defaultValue: null,
      );
      if (jsonList == null) return null;
      return jsonList
          .map((json) => SignalsModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting cached signal data: $e');
      return null;
    }
  }

  Future<SignalsModel> getSignalDetails(String signalId) async {
    try {
      final response = await _apiService.get(
        ApiConstants.signalDetails(signalId),
      );
      return SignalsModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> copyTradingSignal({required String signalId}) async {
    try {
      await _apiService.post(ApiConstants.copySignals(signalId));
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> logTradingSignal(LogTradingSignalModel data) async {
    try {
      await _apiService.post(ApiConstants.logSignals, data: data.toJson());
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<String> uploadImage(File file) async {
    final image = await MultipartFile.fromFile(file.path);
    try {
      final response = await _apiService.uploadFile(
        ApiConstants.imageUpload,
        file: image,
      );
      final data = response.data;
      if (data is Map) {
        if (data['url'] != null) return data['url'].toString();
        final nested = data['data'];
        if (nested is Map && nested['url'] != null) {
          return nested['url'].toString();
        }
      }
      throw UnknownException('Upload URL missing in response');
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<PlatformModel>> getPlatforms() async {
    try {
      final response = await _apiService.get(
        ApiConstants.platforms,
        options: ApiService.withoutAuth,
      );
      final list = response.data['data'] as List? ?? [];
      return list
          .map((e) => PlatformModel.fromJson(e as Map<String, dynamic>))
          .where((e) => e.value.isNotEmpty)
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<CommentModel>> getComments(
    String signalId,
    int page,
    int limit,
  ) async {
    try {
      final response = await _apiService.get(
        ApiConstants.comments(signalId, page, limit),
      );
      final list = response.data['data'] as List? ?? [];
      final model = list.map((e) => CommentModel.fromJson(e)).toList();
      if (page == 1) {
        await _cacheService.put(
          AppConstants.cacheComments,
          model.map((e) => e.toJson()).toList(),
        );
      }
      return model;
    } on AppException {
      if (page == 1) {
        final cached = getCachedComments();
        if (cached != null) return cached;
      }
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<CommentModel>> fetchMoreComments({
    required int page,
    required int limit,
    required String signalId,
  }) async {
    final newData = await getComments(signalId, page, limit);
    if (newData.isNotEmpty) {
      final current = getCachedComments() ?? [];
      final merged = [...current, ...newData];
      await _cacheService.put(
        AppConstants.cacheComments,
        merged.map((e) => e.toJson()).toList(),
      );
    }
    return newData;
  }

  List<CommentModel>? getCachedComments() {
    try {
      final jsonList = _cacheService.get<List>(
        AppConstants.cacheComments,
        defaultValue: null,
      );
      if (jsonList == null) return null;
      return jsonList
          .map((json) => CommentModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting cached comments: $e');
      return null;
    }
  }

  Future<void> addComment({
    required String signalId,
    required String comment,
  }) async {
    try {
      await _apiService.post(
        ApiConstants.addComment,
        data: {'signalId': signalId, 'message': comment},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}
