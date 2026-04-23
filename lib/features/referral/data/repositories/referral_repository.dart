import 'package:flutter/material.dart';
import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/features/referral/data/model/referral_data.dart';

class ReferralRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  ReferralRepository({
    required ApiService apiService,
    required CacheService cacheService,
  }) : _apiService = apiService,
       _cacheService = cacheService;

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
      debugPrint('💾 getCachedReferralData: $json');
      return ReferralData.fromJson(json);
    } catch (e) {
      debugPrint('Error getting cached referral data: $e');
      return null;
    }
  }
}
