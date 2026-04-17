import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/features/auth/domain/services/auth_services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService;

  AuthController({required AuthService authService})
      : _authService = authService;

  /// ─── STATE ─────────────────────────────
  LoadingState _loginState = LoadingState.initial;
  LoadingState get loginState => _loginState;

  String _loginError = '';
  String get loginError => _loginError;

  /// ─── FORM ──────────────────────────────
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final globalKey = GlobalKey<FormState>();

  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    update();
  }

  /// ─── LOGIN FUNCTION ────────────────────
  Future<void> login() async {
    if (!globalKey.currentState!.validate()) return;

    _loginState = LoadingState.loading;
    _loginError = '';
    update();

    try {
      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      _loginState = LoadingState.loaded;
      update();

      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      _loginState = LoadingState.error;
      _loginError = e.toString();
      update();
    }
  }


  /// ─── LOGOUT ───────────────────────────
  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.loginScreen);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
