import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/core/services/paginated_list.dart';
import 'package:flutter_task/features/home/data/models/contributor_model.dart';
import 'package:flutter_task/features/home/data/models/leader_board_model.dart';
import 'package:flutter_task/features/home/data/models/trader_model.dart';
import 'package:flutter_task/features/home/domain/services/home_service.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final HomeService _service;

  static HomeController get to => Get.find();

  HomeController({required HomeService service}) : _service = service;

  // ─── State ────────────────────────────────────────────────────────
  final _loadingState = LoadingState.initial.obs;
  final _errorMessage = ''.obs;

  LoadingState get loadingState => _loadingState.value;
  String get errorMessage => _errorMessage.value;

  // ─── Leaderboard meta (topThree / stats) ──────────────────────────
  final _leaderBoard = Rxn<LeaderBoardModel>();
  LeaderBoardModel? get leaderBoard => _leaderBoard.value;

  // ─── Paginated lists ──────────────────────────────────────────────
  late final PaginatedList<LeaderBoardItem> leaderboardList;
  late final PaginatedList<TraderModel> tradersList;
  late final PaginatedList<ContributorModel> contributorsList;
  late final PaginatedList<TraderModel> followTradersList;

  List<TraderModel> get topTraders => tradersList.items;
  List<ContributorModel> get contributors => contributorsList.items;
  List<TraderModel> get followTraders => followTradersList.items;
  List<LeaderBoardItem> get leaderboardItems => leaderboardList.items;

  ScrollController? get leaderboardScrollController =>
      leaderboardList.scrollController;
  ScrollController? get tradersScrollController => tradersList.scrollController;
  ScrollController? get contributorsScrollController =>
      contributorsList.scrollController;
  ScrollController? get followTradersScrollController =>
      followTradersList.scrollController;

  bool get isLoadingMoreLeaderboard => leaderboardList.showLoadMoreLoader;
  bool get isLoadingMoreTraders => tradersList.showLoadMoreLoader;
  bool get isLoadingMoreContributors => contributorsList.showLoadMoreLoader;
  bool get isLoadingMoreFollowTraders => followTradersList.showLoadMoreLoader;

  @override
  void onInit() {
    super.onInit();
    void onError(Object e) => ToastMessageHelper.show(e.errorMessage);

    leaderboardList = PaginatedList<LeaderBoardItem>(
      limit: 10,
      fetchPage: _fetchLeaderboardPage,
      onError: onError,
    );
    tradersList = PaginatedList<TraderModel>(
      limit: 10,
      fetchPage: _fetchTradersPage,
      onError: onError,
    );
    contributorsList = PaginatedList<ContributorModel>(
      limit: 10,
      fetchPage: _fetchContributorsPage,
      onError: onError,
    );
    followTradersList = PaginatedList<TraderModel>(
      limit: 10,
      fetchPage: _fetchFollowTradersPage,
      onError: onError,
    );

    leaderboardList.initScroll();
    contributorsList.initScroll();
    // Top traders / following use NestedScrollView + scroll notifications.
    loadData();
  }

  Future<List<LeaderBoardItem>> _fetchLeaderboardPage(
    int page,
    int limit,
  ) async {
    if (page == 1) {
      final cached = _service.getCachedData().leaderBoard;
      _leaderBoard.value = cached;
      return cached?.leaderBoardItems ?? [];
    }
    final data = await _service.fetchMoreLeaderboard(page: page, limit: limit);
    _leaderBoard.value = LeaderBoardModel(
      leaderBoardItems: [
        ...leaderboardList.items,
        ...?data.leaderBoardItems,
      ],
      topThree: data.topThree ?? _leaderBoard.value?.topThree,
      stats: data.stats ?? _leaderBoard.value?.stats,
    );
    return data.leaderBoardItems ?? [];
  }

  Future<List<TraderModel>> _fetchTradersPage(int page, int limit) async {
    if (page == 1) return _service.getCachedData().topTraders;
    return _service.fetchMoreTopTraders(page: page, limit: limit);
  }

  Future<List<ContributorModel>> _fetchContributorsPage(
    int page,
    int limit,
  ) async {
    if (page == 1) return _service.getCachedData().contributors;
    return _service.fetchMoreContributors(page: page, limit: limit);
  }

  Future<List<TraderModel>> _fetchFollowTradersPage(
    int page,
    int limit,
  ) async {
    if (page == 1) {
      final traders = _service.getCachedData().followTraders;
      setInitialFollowState(traders);
      return traders;
    }
    final data = await _service.fetchMoreFollowTraders(
      page: page,
      limit: limit,
    );
    appendFollowState(data);
    return data;
  }

  Future<void> loadData() async {
    try {
      _errorMessage.value = '';

      final hasCache = _service.hasCache();
      if (hasCache) {
        final cached = _service.getCachedData();
        _leaderBoard.value = cached.leaderBoard;
        leaderboardList.items.assignAll(cached.leaderBoard?.leaderBoardItems ?? []);
        tradersList.items.assignAll(cached.topTraders);
        contributorsList.items.assignAll(cached.contributors);
        followTradersList.items.assignAll(cached.followTraders);
        setInitialFollowState(cached.followTraders);
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.loading;
      }

      await _service.fetchAllHomeData();
      await Future.wait([
        leaderboardList.loadFirst(),
        tradersList.loadFirst(),
        contributorsList.loadFirst(),
        followTradersList.loadFirst(),
      ]);

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
  Future<void> refresh() async {
    await tradersList.refreshWith(loadData);
  }

  // ─── Follow State ─────────────────────────────────────────────────
  final RxSet<String> _followingIds = <String>{}.obs;

  bool isFollowing(String traderId) {
    if (traderId.isEmpty) return false;
    return _followingIds.contains(traderId);
  }

  void setInitialFollowState(List<TraderModel> traders) {
    _followingIds.clear();
    _followingIds.addAll(
      traders
          .where((e) => e.isFollow == true)
          .map((e) => e.accountId?.sId ?? '')
          .where((id) => id.isNotEmpty),
    );
  }

  void appendFollowState(List<TraderModel> traders) {
    _followingIds.addAll(
      traders
          .where((e) => e.isFollow == true)
          .map((e) => e.accountId?.sId ?? '')
          .where((id) => id.isNotEmpty),
    );
  }

  Future<void> followTrader({required String traderId}) async {
    if (traderId.isEmpty) return;

    final wasFollowing = _followingIds.contains(traderId);
    wasFollowing ? _followingIds.remove(traderId) : _followingIds.add(traderId);

    try {
      final action = await _service.followTrader(traderId: traderId);

      if (action == 'followed') {
        _followingIds.add(traderId);
      } else if (action == 'unfollowed') {
        _followingIds.remove(traderId);
      }
      _service.fetchMoreFollowTraders(page: 1, limit: 10).then((fresh) {
        followTradersList.items.assignAll(fresh);
        setInitialFollowState(fresh);
      });
    } catch (e) {
      wasFollowing
          ? _followingIds.add(traderId)
          : _followingIds.remove(traderId);
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  @override
  void onClose() {
    leaderboardList.dispose();
    tradersList.dispose();
    contributorsList.dispose();
    followTradersList.dispose();
    super.onClose();
  }
}
