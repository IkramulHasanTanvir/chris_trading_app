import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/features/referral/data/model/payment_method_model.dart';
import 'package:flutter_task/features/referral/data/model/referral_data.dart';
import 'package:flutter_task/features/referral/data/model/withdrawal_model.dart';
import 'package:flutter_task/features/referral/domain/services/referral_service.dart';
import 'package:get/get.dart';

class ReferralController extends GetxController {
  final ReferralService _service;

  static ReferralController get to => Get.find();

  ReferralController({required ReferralService service}) : _service = service;

  // ─── Controller ──────────────────────────────────────────────────
  final amountController = TextEditingController();
  final emailController = TextEditingController();
  final numberController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> get formKey => _formKey;

  final RxInt _selectedIndex = 0.obs;

  int get selectedIndex => _selectedIndex.value;

  // ─── State ────────────────────────────────────────────────────────
  final _loadingState = LoadingState.initial.obs;
  final _requestState = LoadingState.initial.obs;
  final _errorMessage = ''.obs;

  LoadingState get loadingState => _loadingState.value;

  LoadingState get requestState => _requestState.value;

  String get errorMessage => _errorMessage.value;

  // ─── Data ─────────────────────────────────────────────────────────
  final _referralData = Rxn<ReferralData>();
  final _withdrawals = <WithdrawalModel>[].obs;

  ReferralData? get referralData => _referralData.value;

  List<WithdrawalModel> get withdrawals => _withdrawals;

  // ─── Pagination ───────────────────────────────────────────────────
  int _currentPage = 1;
  static const int _pageSize = 10;

  final _isLoadingMore = false.obs;
  final _hasMore = true.obs;

  bool get isLoadingMore => _isLoadingMore.value;

  bool get hasMore => _hasMore.value;

  // ─── Scroll ───────────────────────────────────────────────────────
  ScrollController? scrollController;

  // ─── Helper Method ───────────────────────────────────────────────────
  void selectMethod(int index) {
    _selectedIndex.value = index;
  }

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
        !isLoadingMore &&
        hasMore) {
      loadMore();
    }
  }

  // ─── Load All ─────────────────────────────────────────────────────
  Future<void> loadData() async {
    try {
      _errorMessage.value = '';

      final hasCache = _service.hasCache();
      if (hasCache) {
        final cached = _service.getCachedData();
        _referralData.value = cached.referralData;
        _withdrawals.assignAll(cached.withdrawals);
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.loading;
      }

      await _service.fetchAllReferralData();

      final fresh = _service.getCachedData();
      _referralData.value = fresh.referralData;
      _withdrawals.assignAll(fresh.withdrawals);
      _hasMore.value = _withdrawals.length >= _pageSize;
      _loadingState.value = LoadingState.loaded;
    } catch (e) {
      if (!_service.hasCache()) {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = e.errorMessage;
      }
    }
  }

  // ─── Pagination ───────────────────────────────────────────────────
  Future<void> loadMore() async {
    if (isLoadingMore || !hasMore) return;

    try {
      _isLoadingMore.value = true;
      _currentPage++;

      final data = await _service.fetchMoreWithdrawals(page: _currentPage);
      _withdrawals.addAll(data);

      if (data.length < _pageSize) _hasMore.value = false;
    } catch (e) {
      _currentPage--;
      ToastMessageHelper.show(e.errorMessage);
    } finally {
      _isLoadingMore.value = false;
    }
  }

  Future<void> retry() async => await loadData();

  // ─── Request Withdrawal ───────────────────────────────────────────────────

  Future<void> requestWithdrawal() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      _requestState.value = LoadingState.loading;
      final amount = double.tryParse(amountController.text);
      if (amount == null) {
        _requestState.value = LoadingState.error;
        return;
      }
      await _service.withdrawRequest(
        amount: amount,
        paymentMethod: PaymentMethodModel.paymentMethods[selectedIndex].name,
        phoneNumber: numberController.text,
        email: emailController.text,
      );
      _requestState.value = LoadingState.loaded;
      ToastMessageHelper.show('Withdrawal request sent successfully');

      await loadData();
      Get.back(canPop: true);
      _selectedIndex.value = 0;
      amountController.clear();
      numberController.clear();
      emailController.clear();
    } catch (e) {
      _requestState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  @override
  void onClose() {
    scrollController?.removeListener(_onScroll);
    scrollController?.dispose();
    scrollController = null;
    super.onClose();
  }
}
