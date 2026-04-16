import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/features/auth/data/models/login_response_model.dart';
import 'package:flutter_task/features/auth/data/models/user_response_model.dart';

class AuthRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  AuthRepository({
    required ApiService apiService,
    required CacheService cacheService,
  }) : _apiService = apiService,
       _cacheService = cacheService;

  // ─── LOGIN ───────────────────────────────────────
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.loginEndpoint,
        data: {"email": email, "password": password},
      );

      final loginResponse = LoginResponseModel.fromJson(response.data['data']);
      await _cacheService.put(
        AppConstants.cacheAccessToken,
        loginResponse.accessToken,
      );
      await _cacheService.put(
        AppConstants.cacheRefreshToken,
        loginResponse.refreshToken,
      );

      return loginResponse;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  // ─── CACHE GETTERS ───────────────────────────────
  String? getAccessToken() {
    return _cacheService.get<String>(AppConstants.cacheAccessToken);
  }

  String? getRefreshToken() {
    return _cacheService.get<String>(AppConstants.cacheRefreshToken);
  }

  UserResponseModel? getCachedUser() {
    try {
      final json = _cacheService.get<Map>(AppConstants.cacheUser);
      if (json == null) return null;
      return UserResponseModel.fromJson(Map<String, dynamic>.from(json));
    } catch (e) {
      return null;
    }
  }

  bool isLoggedIn() {
    return _cacheService.containsKey(AppConstants.cacheAccessToken);
  }

  // ─── LOGOUT ──────────────────────────────────────
  Future<void> logout() async {
    await _cacheService.delete(AppConstants.cacheAccessToken);
    await _cacheService.delete(AppConstants.cacheRefreshToken);
  }
}
