import 'package:flutter_task/core/services/connectivity_service.dart';
import 'package:flutter_task/features/referral/data/model/referral_data.dart';
import 'package:flutter_task/features/referral/data/repositories/referral_repository.dart';

class ReferralService {
  final ReferralRepository _repository;
  final ConnectivityService _connectivityService;

  ReferralService({
    required ReferralRepository repository,
    required ConnectivityService connectivityService,
  }) : _repository = repository,
       _connectivityService = connectivityService;

  Future<ReferralData> getReferralData() async {
    return await _repository.getReferralData();
  }

  ReferralData? getCachedReferralData() {
    return _repository.getCachedReferralData();
  }

}
