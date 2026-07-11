import 'package:flutter/material.dart';
import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/features/pasar/data/models/trade_history_model.dart';

class HistoryRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  HistoryRepository({
    required ApiService apiService,
    required CacheService cacheService,
  })  : _apiService = apiService,
        _cacheService = cacheService;

  // ─── Cache Key Helper ─────────────────────────────────────────────────
  String _cacheKeyForStatus(String status) {
    switch (status) {
      case 'pending':
        return AppConstants.cacheTradeHistoryPending;
      case 'completed':
        return AppConstants.cacheTradeHistoryCompleted;
      default:
        return 'trade_history_$status';
    }
  }

  // ─── Trade History Data ───────────────────────────────────────────────
  Future<TradeHistoryModel> getTradeHistoryData(int page, int limit, String status) async {
    final cacheKey = _cacheKeyForStatus(status);
    try {
      final response = await _apiService.get(
        ApiConstants.tradesHistory(page, limit, status, sortBy: 'newest'),
      );

      final model = TradeHistoryModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      await _cacheService.put(cacheKey, model.toJson());
      return model;
    } on AppException {
      final cached = getCachedData(status);
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      debugPrint('ERROR: $e');
      throw UnknownException(e.toString());
    }
  }

  Future<TradeHistoryModel> fetchMoreLeaderboardData({
    required int page,
    required int limit,
    required String status,
  }) async {
    final cacheKey = _cacheKeyForStatus(status);
    final current = getCachedData(status) ?? TradeHistoryModel();

    try {
      final response = await _apiService.get(
        ApiConstants.tradesHistory(page, limit, status, sortBy: 'newest'),
      );
      final newData = TradeHistoryModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
      final newTrades = newData.trades ?? [];
      final merged = [...?current.trades, ...newTrades];

      await _cacheService.put(
        cacheKey,
        TradeHistoryModel(
          trades: merged,
          summary: newData.summary,
        ).toJson(),
      );

      // Return only the new page so PaginatedList can append correctly.
      return TradeHistoryModel(
        trades: newTrades,
        summary: newData.summary,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  TradeHistoryModel? getCachedData(String status) {
    try {
      final cacheKey = _cacheKeyForStatus(status);
      final json = _cacheService.get<Map<String, dynamic>>(
        cacheKey,
        defaultValue: null,
      );
      if (json == null) return null;
      return TradeHistoryModel.fromJson(json);
    } catch (e) {
      debugPrint('Error getting cached data: $e');
      return null;
    }
  }
}