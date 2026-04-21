import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/features/auth/data/models/login_response_model.dart';
import 'package:flutter_task/features/auth/data/models/user_response_model.dart';
import 'package:flutter_task/features/auth/data/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  AuthRepositoryImpl({
    required ApiService apiService,

    required CacheService cacheService,
  }) : _apiService = apiService,
       _cacheService = cacheService;

  @override
  Future<UserResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        data: {
          "name": name,
          "email": email,
          "password": password,
          "confirmPassword": confirmPassword,
        },
      );

      final model = UserResponseModel.fromJson(
        response.data['data']?[0] as Map<String, dynamic>,
      );

      await _cacheService.put(AppConstants.cacheUser, model.toJson());

      return model;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {'email': email, 'password': password},
      );

      final model = LoginResponseModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );

      await _cacheService.put(AppConstants.accessToken, model.accessToken);
      await _cacheService.put(AppConstants.refreshToken, model.refreshToken);

      return model;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> forgotPassword({required String email}) async {
    try {
      final response = _apiService.post(
        ApiConstants.forgot,
        data: {'email': email},
      );
      await response;
      return true;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<bool> otpVerify({required String otp, required String email}) async {
    try {
      await _apiService.post(
        ApiConstants.otpVerify,
        data: {'email': email, 'verificationCode': otp},
      );
      return true;
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  Future<void> resetPassword({
    required String otp,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      await _apiService.post(
        ApiConstants.resetPassword,
        data: {
          "email": email,
          "verificationCode": otp,
          "newPassword": password,
          "confirmPassword": confirmPassword,
        },
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  @override
  String? getAccessToken() {
    return _cacheService.get<String>(AppConstants.accessToken);
  }

  @override
  UserResponseModel? getCachedUser() {
    try {
      final json = _cacheService.get<Map<String, dynamic>>(
        AppConstants.cacheUser,
        defaultValue: null,
      );

      if (json == null) return null;

      return UserResponseModel.fromJson(json);
    } catch (e) {
      return null;
    }
  }

  @override
  String? getRefreshToken() {
    return _cacheService.get<String>(AppConstants.refreshToken);
  }

  @override
  bool isLoggedIn() {
    return _cacheService.containsKey(AppConstants.accessToken);
  }

  @override
  Future<void> logout() {
    return _cacheService.clear();
  }
}
