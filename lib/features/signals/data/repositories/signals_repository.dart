import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/features/signals/data/models/log_signal_model.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';

class SignalsRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  SignalsRepository({
    required ApiService apiService,
    required CacheService cacheService,
  }) : _apiService = apiService,
       _cacheService = cacheService;

  // ─── signals Data ───────────────────────────────────────────────
  Future<List<SignalsModel>> getSignalData(int page, int limit) async {
    try {
      final response = await _apiService.get(ApiConstants.signals(page, limit));
      final list = response.data['data'] as List? ?? [];
      final model = list.map((e) => SignalsModel.fromJson(e)).toList();
      await _cacheService.put(
        AppConstants.cacheSignals,
        model.map((e) => e.toJson()).toList(),
      );
      return model;
    } on AppException {
      final cached = getCachedSignalData();
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<SignalsModel>> fetchMoreSignalData({
    required int page,
    required int limit,
  }) async {
    final newData = await getSignalData(page, limit);
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
      debugPrint('Error getting cached referral data: $e');
      return null;
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
      await _apiService.post(ApiConstants.logSignals,data: data.toJson());
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }


  Future<String> uploadImage(File file) async {

    final image = await MultipartFile.fromFile(file.path);
    try{
      final response = await _apiService.uploadFile(ApiConstants.imageUpload,file: image);
      return response.data['url'];

    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }

  }
}
