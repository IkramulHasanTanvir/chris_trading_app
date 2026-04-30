import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/features/pasar/data/models/trade_history_model.dart';
import 'package:flutter_task/features/pasar/data/repositories/history_repository.dart';

class HistoryService {
  final HistoryRepository _repository;

  HistoryService({required HistoryRepository repository})
      : _repository = repository;

  // ─── Fetch All ────────────────────────────────────────────────────
  Future<void> fetchAllHistoryData() async {
    try {
      await Future.wait([
        _repository.getTradeHistoryData(1, 10, "pending"),
        _repository.getTradeHistoryData(1, 10, "completed"),
      ]);
    } on AppException {
      if (!hasCache()) {
        rethrow;
      }
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ─── Fetch More ───────────────────────────────────────────────────
  Future<TradeHistoryModel> fetchMoreHistory({
    required int page,
    required int limit,
    required String status,
  }) async {
    try {
      return await _repository.fetchMoreLeaderboardData(
        page: page,
        limit: limit,
        status: status,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ─── Cache ────────────────────────────────────────────────────────
  bool hasCache() {
    return _repository.getCachedData('pending') != null ||
        _repository.getCachedData('completed') != null;
  }

  TradeHistoryModel? getCachedData(String status) {
    return _repository.getCachedData(status);
  }

  HistoryScreenData getCachedAllData() {
    return HistoryScreenData(
      pending: _repository.getCachedData('pending'),
      completed: _repository.getCachedData('completed'),
    );
  }
}

// ─── Screen Data Wrapper ──────────────────────────────────────────────
class HistoryScreenData {
  final TradeHistoryModel? pending;
  final TradeHistoryModel? completed;

  HistoryScreenData({
    required this.pending,
    required this.completed,
  });
}