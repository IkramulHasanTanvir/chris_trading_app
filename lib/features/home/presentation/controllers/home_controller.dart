import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
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

  // ─── Data ─────────────────────────────────────────────────────────
  final _leaderBoard = Rxn<LeaderBoardModel>();
  final _topTraders = <TraderModel>[].obs;
  final _contributors = <ContributorModel>[].obs;

  LeaderBoardModel? get leaderBoard => _leaderBoard.value;
  List<TraderModel> get topTraders => _topTraders;
  List<ContributorModel> get contributors => _contributors;

  // ─── Pagination ───────────────────────────────────────────────────
  static const int _pageSize = 10;

  int _leaderboardPage = 1;
  int _tradersPage = 1;
  int _contributorsPage = 1;

  final _isLoadingMoreLeaderboard = false.obs;
  final _isLoadingMoreTraders = false.obs;
  final _isLoadingMoreContributors = false.obs;

  final _hasMoreLeaderboard = true.obs;
  final _hasMoreTraders = true.obs;
  final _hasMoreContributors = true.obs;

  bool get isLoadingMoreLeaderboard => _isLoadingMoreLeaderboard.value;
  bool get isLoadingMoreTraders => _isLoadingMoreTraders.value;
  bool get isLoadingMoreContributors => _isLoadingMoreContributors.value;

  bool get hasMoreLeaderboard => _hasMoreLeaderboard.value;
  bool get hasMoreTraders => _hasMoreTraders.value;
  bool get hasMoreContributors => _hasMoreContributors.value;

  // ─── Scroll Controllers ───────────────────────────────────────────
  ScrollController? leaderboardScrollController;
  ScrollController? tradersScrollController;
  ScrollController? contributorsScrollController;

  @override
  void onInit() {
    super.onInit();
    leaderboardScrollController = ScrollController()
      ..addListener(_onLeaderboardScroll);
    tradersScrollController = ScrollController()
      ..addListener(_onTradersScroll);
    contributorsScrollController = ScrollController()
      ..addListener(_onContributorsScroll);
    loadData();
  }

  // ─── Scroll Listeners ─────────────────────────────────────────────
  void _onLeaderboardScroll() {
    if (leaderboardScrollController == null) return;
    final position = leaderboardScrollController!.position;
    if (position.pixels >= position.maxScrollExtent - 200 &&
        !isLoadingMoreLeaderboard &&
        hasMoreLeaderboard) {
      loadMoreLeaderboard();
    }
  }

  void _onTradersScroll() {
    if (tradersScrollController == null) return;
    final position = tradersScrollController!.position;
    if (position.pixels >= position.maxScrollExtent - 200 &&
        !isLoadingMoreTraders &&
        hasMoreTraders) {
      loadMoreTraders();
    }
  }

  void _onContributorsScroll() {
    if (contributorsScrollController == null) return;
    final position = contributorsScrollController!.position;
    if (position.pixels >= position.maxScrollExtent - 200 &&
        !isLoadingMoreContributors &&
        hasMoreContributors) {
      loadMoreContributors();
    }
  }

  // ─── Load All ─────────────────────────────────────────────────────
  Future<void> loadData() async {
    try {
      _errorMessage.value = '';

      final hasCache = _service.hasCache();
      if (hasCache) {
        final cached = _service.getCachedData();
        _leaderBoard.value = cached.leaderBoard;
        _topTraders.assignAll(cached.topTraders);
        _contributors.assignAll(cached.contributors);
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.loading;
      }

      await _service.fetchAllHomeData();

      final fresh = _service.getCachedData();
      _leaderBoard.value = fresh.leaderBoard;
      _topTraders.assignAll(fresh.topTraders);
      _contributors.assignAll(fresh.contributors);

      _hasMoreLeaderboard.value =
          (fresh.leaderBoard?.leaderBoardItems?.length ?? 0) >= _pageSize;
      _hasMoreTraders.value = fresh.topTraders.length >= _pageSize;
      _hasMoreContributors.value = fresh.contributors.length >= _pageSize;

      _loadingState.value = LoadingState.loaded;
    } catch (e) {
      if (!_service.hasCache()) {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = e.errorMessage;
      }
    }
  }

  // ─── Pagination ───────────────────────────────────────────────────
  Future<void> loadMoreLeaderboard() async {
    if (isLoadingMoreLeaderboard || !hasMoreLeaderboard) return;
    try {
      _isLoadingMoreLeaderboard.value = true;
      _leaderboardPage++;

      final data = await _service.fetchMoreLeaderboard(
        page: _leaderboardPage,
        limit: _pageSize,
      );

      final newItems = data.leaderBoardItems ?? [];
      if (newItems.length < _pageSize) _hasMoreLeaderboard.value = false;

      // Repository already merged into cache; just reflect the updated model
      _leaderBoard.value = data;
    } catch (e) {
      _leaderboardPage--;
      ToastMessageHelper.show(e.errorMessage);
    } finally {
      _isLoadingMoreLeaderboard.value = false;
    }
  }

  Future<void> loadMoreTraders() async {
    if (isLoadingMoreTraders || !hasMoreTraders) return;
    try {
      _isLoadingMoreTraders.value = true;
      _tradersPage++;

      final data = await _service.fetchMoreTopTraders(
        page: _tradersPage,
        limit: _pageSize,
      );
      _topTraders.addAll(data);

      if (data.length < _pageSize) _hasMoreTraders.value = false;
    } catch (e) {
      _tradersPage--;
      ToastMessageHelper.show(e.errorMessage);
    } finally {
      _isLoadingMoreTraders.value = false;
    }
  }

  Future<void> loadMoreContributors() async {
    if (isLoadingMoreContributors || !hasMoreContributors) return;
    try {
      _isLoadingMoreContributors.value = true;
      _contributorsPage++;

      final data = await _service.fetchMoreContributors(
        page: _contributorsPage,
        limit: _pageSize,
      );
      _contributors.addAll(data);

      if (data.length < _pageSize) _hasMoreContributors.value = false;
    } catch (e) {
      _contributorsPage--;
      ToastMessageHelper.show(e.errorMessage);
    } finally {
      _isLoadingMoreContributors.value = false;
    }
  }

  Future<void> retry() async => await loadData();

  // ─── Dispose ──────────────────────────────────────────────────────
  @override
  void onClose() {
    leaderboardScrollController?.removeListener(_onLeaderboardScroll);
    leaderboardScrollController?.dispose();
    leaderboardScrollController = null;

    tradersScrollController?.removeListener(_onTradersScroll);
    tradersScrollController?.dispose();
    tradersScrollController = null;

    contributorsScrollController?.removeListener(_onContributorsScroll);
    contributorsScrollController?.dispose();
    contributorsScrollController = null;

    super.onClose();
  }
}