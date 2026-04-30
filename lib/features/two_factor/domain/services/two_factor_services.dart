import 'package:flutter_task/features/two_factor/data/models/two_factor_model.dart';
import 'package:flutter_task/features/two_factor/data/repositories/two_factor_repository.dart';

class TwoFactorService {
  final TwoFactorRepository _repository;

  TwoFactorService({required TwoFactorRepository repository})
      : _repository = repository;



  Future<TwoFactorModel> getTwoFactorSet(String password) async {
    return _repository.getTwoFactorSet(password);
  }

  Future<void> disableTwoFactor(String code) async {
    return _repository.disableTwoFactor(code);
  }

  Future<void> enableTwoFactor(String code) async {
    return _repository.enableTwoFactor(code);
  }

}