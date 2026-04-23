import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/features/referral/data/model/referral_data.dart';
import 'package:flutter_task/features/referral/domain/services/referral_service.dart';
import 'package:get/get.dart';

class ReferralController extends GetxController {
  final ReferralService _referralService;

  ReferralController({required ReferralService referralService})
    : _referralService = referralService;

  // State
  LoadingState _loadingState = LoadingState.initial;

  LoadingState get loadingState => _loadingState;

  String  _errorMessage = '';

  String get errorMessage => _errorMessage;


  // Data
  ReferralData? _referralData;

  ReferralData? get referralData => _referralData;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final cached = _referralService.getCachedReferralData();

      if (cached != null) {
        _referralData = cached;
        _loadingState = LoadingState.loaded;
      } else {
        _loadingState = LoadingState.loading;
      }
      _errorMessage = '';
      update();

      final fresh = await _referralService.getReferralData();
      _referralData = fresh;
      _loadingState = LoadingState.loaded;
      update();
    } catch (e) {
      if (_referralData == null) {
        _loadingState = LoadingState.error;
        _errorMessage = e.errorMessage;
        update();
      }
    }
  }

  Future<void> retry() async => await loadData();
}
