import 'package:flutter/material.dart';
import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/features/referral/data/model/referral_data.dart';
import 'package:flutter_task/features/referral/data/model/withdrawal_model.dart';

class ReferralRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  ReferralRepository({
    required ApiService apiService,
    required CacheService cacheService,
  }) : _apiService = apiService,
       _cacheService = cacheService;

  // ─── Referral Data ───────────────────────────────────────────────
  Future<ReferralData> getReferralData() async {
    try {
      final response = await _apiService.get(ApiConstants.referral);
      final model = ReferralData.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
      await _cacheService.put(AppConstants.cacheReferralData, model.toJson());
      return model;
    } on AppException {
      final cached = getCachedReferralData();
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  ReferralData? getCachedReferralData() {
    try {
      final json = _cacheService.get<Map<String, dynamic>>(
        AppConstants.cacheReferralData,
        defaultValue: null,
      );
      if (json == null) return null;
      return ReferralData.fromJson(json);
    } catch (e) {
      debugPrint('Error getting cached referral data: $e');
      return null;
    }
  }

  // ─── Withdrawal Data (with Pagination) ───────────────────────────

  Future<void> withdrawRequest({
    required double amount,
    required String paymentMethod,
    required String phoneNumber,
    required String email,
  }) async {
    try {
      await _apiService.post(
        ApiConstants.withdrawalRequest,
        data: {
          "amount": amount,
          "paymentMethod": paymentMethod,
          "paymentDetails": "$phoneNumber, $email",
        },
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<WithdrawalModel>> getWithdrawalData({int page = 1}) async {
    try {
      final response = await _apiService.get(ApiConstants.myWithdrawals(page));
      final list = response.data['data'] as List? ?? [];

      final data = list.map((e) => WithdrawalModel.fromJson(e)).toList();
      if (page == 1) {
        await _cacheService.put(
          AppConstants.cacheWithdrawalData,
          data.map((e) => e.toJson()).toList(),
        );
      }

      return data;
    } on AppException {
      if (page == 1) {
        return getCachedWithdrawalData() ?? [];
      }
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<List<WithdrawalModel>> fetchMoreWithdrawals({
    required int page,
  }) async {
    final newData = await getWithdrawalData(page: page);
    if (newData.isNotEmpty) {
      final current = getCachedWithdrawalData() ?? [];
      final merged = [...current, ...newData];

      await _cacheService.put(
        AppConstants.cacheWithdrawalData,
        merged.map((e) => e.toJson()).toList(),
      );
    }

    return newData;
  }

  List<WithdrawalModel>? getCachedWithdrawalData() {
    try {
      final jsonList =
          _cacheService.get<List>(
            AppConstants.cacheWithdrawalData,
            defaultValue: [],
          ) ??
          [];
      return jsonList
          .map((json) => WithdrawalModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Error getting cached withdrawal data: $e');
      return null;
    }
  }

  bool hasCache() {
    return _cacheService.containsKey(AppConstants.cacheReferralData);
  }
}
