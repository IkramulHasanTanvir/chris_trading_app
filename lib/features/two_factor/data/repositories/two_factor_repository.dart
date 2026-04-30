import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/features/two_factor/data/models/two_factor_model.dart';

class TwoFactorRepository {
  final ApiService _apiService;

  TwoFactorRepository({required ApiService apiService})
    : _apiService = apiService;

  // ─── two-factor Data ───────────────────────────────────────────────
  Future<TwoFactorModel> getTwoFactorSet(String password) async {
    try {
      final response = await _apiService.post(
        ApiConstants.twoFactorSetUp,
        data: {'password': password},
      );
      final model = TwoFactorModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
      return model;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> disableTwoFactor(String code) async {
    try {
      await _apiService.post(
        ApiConstants.twoFactorDisable,
        data: {'twoFactorCode': code},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> enableTwoFactor(String code) async {
    try {
      await _apiService.post(
        ApiConstants.twoFactorOtp,
        data: {'twoFactorCode': code},
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }
}
