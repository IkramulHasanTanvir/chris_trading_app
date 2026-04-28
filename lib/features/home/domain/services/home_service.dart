import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/features/home/data/models/contributor_model.dart';
import 'package:flutter_task/features/home/data/models/leader_board_model.dart';
import 'package:flutter_task/features/home/data/models/trader_model.dart';
import 'package:flutter_task/features/home/data/repositories/home_repository.dart';

class HomeService {
  final HomeRepository _repository;

  HomeService({required HomeRepository repository}) : _repository = repository;

  // ─── Leaderboard ────────────────────────────────────────────────────

  Future<void> fetchAllHomeData() async {
    try {
      await Future.wait([
        _repository.getLeaderboardData(1, 10),
        _repository.getTopTraderData(1, 10),
        _repository.getContributorData(1, 10),
      ]);
    } on AppException {
      if (!hasCache()) {
        rethrow;
      }
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<LeaderBoardModel> fetchMoreLeaderboard({
    required int page,
    required int limit,
  }) async {
    try {
      return await _repository.fetchMoreLeaderboardData(
        page: page,
        limit: limit,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<TraderModel>> fetchMoreTopTraders({
    required int page,
    required int limit,
  }) async {
    try {
      return await _repository.fetchMoreTopTraderData(page: page, limit: limit);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<ContributorModel>> fetchMoreContributors({
    required int page,
    required int limit,
  }) async {
    try {
      return await _repository.fetchMoreContributorData(
        page: page,
        limit: limit,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<String> followTrader ({required String traderId}) async {
    try {
      return await _repository.followTrader(traderId: traderId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  bool hasCache() {
    return _repository.getCachedLeaderBoardData() != null ||
        _repository.getCachedTopTraderData() != null ||
        _repository.getCachedContributorData() != null;
  }

  HomeScreenData getCachedData() {
    return HomeScreenData(
      leaderBoard: _repository.getCachedLeaderBoardData(),
      topTraders: _repository.getCachedTopTraderData() ?? [],
      contributors: _repository.getCachedContributorData() ?? [],
    );
  }
}

class HomeScreenData {
  final LeaderBoardModel? leaderBoard;
  final List<TraderModel> topTraders;
  final List<ContributorModel> contributors;

  HomeScreenData({
    required this.leaderBoard,
    required this.topTraders,
    required this.contributors,
  });
}
