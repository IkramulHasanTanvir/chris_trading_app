import 'package:flutter/material.dart';
import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/features/home/data/models/contributor_model.dart';
import 'package:flutter_task/features/home/data/models/leader_board_model.dart';
import 'package:flutter_task/features/home/data/models/trader_model.dart';

class HomeRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  HomeRepository({
    required ApiService apiService,
    required CacheService cacheService,
  }) : _apiService = apiService,
       _cacheService = cacheService;

  // ─── Leaderboard Data ───────────────────────────────────────────────
  Future<LeaderBoardModel> getLeaderboardData(int page, int limit) async {
    try {
      final response = await _apiService.get(
        ApiConstants.leaderboard(page, limit),
      );

      // ✅ এই lines গুলো add করুন
      debugPrint('======= LEADERBOARD DEBUG =======');
      debugPrint('response.data type: ${response.data.runtimeType}');
      debugPrint('response.data: ${response.data}');
      debugPrint('data key type: ${response.data['data'].runtimeType}');
      debugPrint('topThree: ${response.data['data']?['topThree']}');
      debugPrint('=================================');

      final model = LeaderBoardModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      debugPrint('model.topThree: ${model.topThree}');
      debugPrint('model.topThree length: ${model.topThree?.length}');

      await _cacheService.put(AppConstants.cacheLeaderBoard, model.toJson());
      return model;
    } on AppException {
      final cached = getCachedLeaderBoardData();
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      debugPrint('ERROR: $e');
      throw UnknownException(e.toString());
    }
  }


  Future<LeaderBoardModel> fetchMoreLeaderboardData({
    required int page,
    required int limit,
  }) async {
    final newData = await getLeaderboardData(page, limit);

    if (newData.leaderBoardItems != null) {
      final current = getCachedLeaderBoardData() ?? LeaderBoardModel();
      final merged = [
        ...current.leaderBoardItems!,
        ...newData.leaderBoardItems!,
      ];
      await _cacheService.put(AppConstants.cacheLeaderBoard, {
        "leaderBoardItems": merged,
        "topThree": current.topThree,
        "stats": current.stats,
      });
      return LeaderBoardModel(
        leaderBoardItems: merged,
        topThree: current.topThree,
        stats: current.stats,
      );
    } else {
      return LeaderBoardModel(leaderBoardItems: [], topThree: [], stats: null);
    }
  }

  LeaderBoardModel? getCachedLeaderBoardData() {
    try {
      final json = _cacheService.get<Map<String, dynamic>>(
        AppConstants.cacheLeaderBoard,
        defaultValue: null,
      );
      if (json == null) return null;
      return LeaderBoardModel.fromJson(json);
    } catch (e) {
      debugPrint('Error getting cached referral data: $e');
      return null;
    }
  }

  // top signals data ────────────────────────────────────────────────────────

  Future<List<TraderModel>> getTopTraderData(int page, int limit) async {
    try {
      final response = await _apiService.get(
        ApiConstants.topTrader(page, limit),
      );
      final list = response.data['data']?['data'] as List? ?? [];
      final model = list.map((e) => TraderModel.fromJson(e)).toList();
      await _cacheService.put(
        AppConstants.cacheTrader,
        model.map((e) => e.toJson()).toList(),
      );
      return model;
    } on AppException {
      final cached = getCachedTopTraderData();
      if (cached != null) return cached;
      rethrow;
    }
  }

  Future<List<TraderModel>> fetchMoreTopTraderData({
    required int page,
    required int limit,
  }) async {
    final newData = await getTopTraderData(page, limit);
    if (newData.isNotEmpty) {
      final current = getCachedTopTraderData() ?? [];
      final merged = [...current, ...newData];
      await _cacheService.put(
        AppConstants.cacheTrader,
        merged.map((e) => e.toJson()).toList(),
      );
    }
    return newData;
  }

  List<TraderModel>? getCachedTopTraderData() {
    try {
      final jsonList = _cacheService.get<List>(
        AppConstants.cacheTrader,
        defaultValue: null,
      );
      if (jsonList == null) return null;
      return jsonList
          .map((json) => TraderModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting cached referral data: $e');
      return null;
    }
  }

  // Contributor Data ───────────────────────────────────────────────

  Future<List<ContributorModel>> getContributorData(int page, int limit) async {
    try {
      final response = await _apiService.get(
        ApiConstants.contributions(page, limit),
      );
      final list = response.data['data']?['data'] as List? ?? [];
      final model = list.map((e) => ContributorModel.fromJson(e)).toList();

      await _cacheService.put(
        AppConstants.cacheContributor,
        model.map((e) => e.toJson()).toList(),
      );
      return model;
    } on AppException {
      final cached = getCachedContributorData();
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<ContributorModel>> fetchMoreContributorData({
    required int page,
    required int limit,
  }) async {
    final newData = await getContributorData(page, limit);
    if (newData.isNotEmpty) {
      final current = getCachedContributorData() ?? [];
      final merged = [...current, ...newData];
      await _cacheService.put(
        AppConstants.cacheContributor,
        merged.map((e) => e.toJson()).toList(),
      );
    }
    return newData;
  }

  List<ContributorModel>? getCachedContributorData() {
    try {
      final jsonList = _cacheService.get<List>(
        AppConstants.cacheContributor,
        defaultValue: null,
      );
      if (jsonList == null) return null;
      return jsonList
          .map(
            (json) => ContributorModel.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      debugPrint('Error getting cached referral data: $e');
      return null;
    }
  }
}
