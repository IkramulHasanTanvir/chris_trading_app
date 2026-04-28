import 'package:flutter_task/features/auth/data/models/login_response_model.dart';
import 'package:flutter_task/features/profile/data/models/user_response_model.dart';
import 'package:flutter_task/features/auth/data/repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _repository;

  AuthService({required AuthRepository repository}) : _repository = repository;

  /// ─── LOGIN ─────────────────────────────
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _repository.login(email: email, password: password);

    return response;
  }

  /// ─── REGISTER ──────────────────────────
  Future<UserResponseModel> register({
    required String name,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await _repository.register(
      name: name,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  /// ─── FORGOT PASSWORD ───────────────────
  Future<void> forgotPassword(String email) async {
    return await _repository.forgotPassword(email: email);
  }

  /// ─── OTP VERIFY ───────────────────
  Future<bool> otpVerify({required String email, required String otp}) async {
    return await _repository.otpVerify(email: email, otp: otp);
  }

  /// ─── OTP VERIFY ───────────────────
  Future<void> resetPassword({
    required String otp,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    return await _repository.resetPassword(
      email: email,
      otp: otp,
      password: password,
      confirmPassword: confirmPassword,
    );
  }

  /// ─── SESSION ───────────────────────────
  bool isLoggedIn() => _repository.isLoggedIn();

  String? getToken() => _repository.getAccessToken();

  Future<void> logout() => _repository.logout();
}
