import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/features/referral/data/model/referral_data.dart';
import 'package:flutter_task/features/referral/data/model/withdrawal_model.dart';
import 'package:flutter_task/features/referral/data/repositories/referral_repository.dart';

class ReferralService {
  final ReferralRepository _repository;

  ReferralService({required ReferralRepository repository})
    : _repository = repository;

  Future<void> fetchAllReferralData() async {
    try {
      await Future.wait([
        _repository.getReferralData(),
        _repository.getWithdrawalData(page: 1),
      ]);
    } on AppException {
      if (!hasCache()) {
        rethrow;
      }
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<WithdrawalModel>> fetchMoreWithdrawals({
    required int page,
  }) async {
    return await _repository.fetchMoreWithdrawals(page: page);
  }

  bool hasCache() {
    return _repository.hasCache();
  }

  ReferralScreenData getCachedData() {
    return ReferralScreenData(
      referralData: _repository.getCachedReferralData(),
      withdrawals: _repository.getCachedWithdrawalData() ?? [],
    );
  }
}

class ReferralScreenData {
  final ReferralData? referralData;
  final List<WithdrawalModel> withdrawals;

  ReferralScreenData({required this.referralData, required this.withdrawals});
}
