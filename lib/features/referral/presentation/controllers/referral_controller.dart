import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/features/referral/data/model/referral_data.dart';
import 'package:flutter_task/features/referral/data/model/withdrawal_model.dart';
import 'package:flutter_task/features/referral/domain/services/referral_service.dart';
import 'package:get/get.dart';

class ReferralController extends GetxController {
  final ReferralService _service;

  static ReferralController get to => Get.find();

  ReferralController({required ReferralService service}) : _service = service;

  // ─── State ────────────────────────────────────────────────────────
  LoadingState _loadingState = LoadingState.initial;

  LoadingState get loadingState => _loadingState;

  String _errorMessage = '';

  String get errorMessage => _errorMessage;

  // ─── Data ─────────────────────────────────────────────────────────
  ReferralData? _referralData;

  ReferralData? get referralData => _referralData;

  List<WithdrawalModel> _withdrawals = [];

  List<WithdrawalModel> get withdrawals => _withdrawals;

  // ─── Pagination ───────────────────────────────────────────────────
  int _currentPage = 1;
  static const int _pageSize = 10;

  bool _isLoadingMore = false;

  bool get isLoadingMore => _isLoadingMore;

  bool _hasMore = true;

  bool get hasMore => _hasMore;

  // ─── Scroll ───────────────────────────────────────────────────────
  ScrollController? scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController()..addListener(_onScroll);
    loadData();
  }

  void _onScroll() {
    if (scrollController == null) return;
    final position = scrollController!.position;

    if (position.pixels >= position.maxScrollExtent - 200 &&
        !_isLoadingMore &&
        _hasMore) {
      loadMore();
    }
  }

  // ─── Load All ─────────────────────────────────────────────────────
  Future<void> loadData() async {
    try {
      _errorMessage = '';

      final hasCache = _service.hasCache();
      if (hasCache) {
        final cached = _service.getCachedData();
        _referralData = cached.referralData;
        _withdrawals = cached.withdrawals;
        _loadingState = LoadingState.loaded;
      } else {
        _loadingState = LoadingState.loading;
      }
      update();

      await _service.fetchAllReferralData();

      final fresh = _service.getCachedData();
      _referralData = fresh.referralData;
      _withdrawals = fresh.withdrawals;
      _hasMore = _withdrawals.length >= _pageSize;
      _loadingState = LoadingState.loaded;
      update();
    } catch (e) {
      if (!_service.hasCache()) {
        _loadingState = LoadingState.error;
        _errorMessage = e.errorMessage;
        update();
      }
    }
  }

  // ─── Pagination ───────────────────────────────────────────────────
  Future<void> loadMore() async {
    if (_isLoadingMore || !_hasMore) return;

    try {
      _isLoadingMore = true;
      _currentPage++;
      update();

      final data = await _service.fetchMoreWithdrawals(page: _currentPage);
      _withdrawals = [..._withdrawals, ...data];

      if (data.length < _pageSize) _hasMore = false;
    } catch (e) {
      _currentPage--;
      ToastMessageHelper.show(e.errorMessage);
    } finally {
      _isLoadingMore = false;
      update();
    }
  }

  Future<void> retry() async => await loadData();

  @override
  void onClose() {
    scrollController?.removeListener(_onScroll);
    scrollController?.dispose();
    scrollController = null;
    super.onClose();
  }
}
