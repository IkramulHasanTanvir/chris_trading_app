import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/core/services/paginated_list.dart';
import 'package:flutter_task/core/services/paginated_loader_ui.dart';
import 'package:flutter_task/features/referral/data/model/payment_method_model.dart';
import 'package:flutter_task/features/referral/data/model/referral_data.dart';
import 'package:flutter_task/features/referral/data/model/withdrawal_model.dart';
import 'package:flutter_task/features/referral/domain/services/referral_service.dart';
import 'package:get/get.dart';

class ReferralController extends GetxController with PaginatedLoaderUi {
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
  ReferralData? get referralData => _referralData.value;

  late final PaginatedList<WithdrawalModel> withdrawalsList;

  List<WithdrawalModel> get withdrawals => withdrawalsList.items;
  ScrollController? get scrollController => withdrawalsList.scrollController;
  bool get isLoadingMore => withdrawalsList.showLoadMoreLoader;

  @override
  LoadingState get paginationContentState => loadingState;

  @override
  PaginatedList<dynamic> get paginatedList => withdrawalsList;

  void selectMethod(int index) {
    _selectedIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    withdrawalsList = PaginatedList<WithdrawalModel>(
      limit: 10,
      fetchPage: _fetchWithdrawalsPage,
      onError: (e) => ToastMessageHelper.show(e.errorMessage),
    );
    withdrawalsList.initScroll();
    loadData();
  }

  Future<List<WithdrawalModel>> _fetchWithdrawalsPage(
    int page,
    int limit,
  ) async {
    if (page == 1) {
      await _service.fetchAllReferralData();
      final fresh = _service.getCachedData();
      _referralData.value = fresh.referralData;
      return fresh.withdrawals;
    }
    return _service.fetchMoreWithdrawals(page: page, limit: limit);
  }

  Future<void> loadData() async {
    try {
      _errorMessage.value = '';

      final hasCache = _service.hasCache();
      if (hasCache) {
        final cached = _service.getCachedData();
        _referralData.value = cached.referralData;
        withdrawalsList.items.assignAll(cached.withdrawals);
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.loading;
      }

      await withdrawalsList.loadFirst();
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
  Future<void> refresh() => withdrawalsList.refreshWith(loadData);

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
    withdrawalsList.dispose();
    amountController.dispose();
    emailController.dispose();
    numberController.dispose();
    super.onClose();
  }
}
