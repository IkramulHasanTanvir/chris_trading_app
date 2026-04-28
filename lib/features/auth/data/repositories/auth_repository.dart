import 'package:flutter_task/features/auth/data/models/login_response_model.dart';
import 'package:flutter_task/features/profile/data/models/user_response_model.dart';

abstract class AuthRepository {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<UserResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<void> forgotPassword({required String email});

  Future<bool> otpVerify({required String otp, required String email});

  Future<void> resetPassword({
    required String otp,
    required String email,
    required String password,
    required String confirmPassword,
  });

  /// ─── CACHE GETTERS ───────────────────────────────
  bool isLoggedIn();

  String? getAccessToken();

  String? getRefreshToken();

  UserResponseModel? getCachedUser();

  /// ─── LOGOUT ──────────────────────────────────────
  Future<void> logout();
}
