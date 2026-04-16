import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/features/auth/domain/services/auth_services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService;

  AuthController({required AuthService authService})
    : _authService = authService;

  // State management
  LoadingState _loginState = LoadingState.initial;
  LoadingState get loginState => _loginState;


  String _loginError = '';
  String get loginError => _loginError;

  // ─── Form Controllers ─────────────────────────────
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final globalKey = GlobalKey<FormState>();


  bool obscurePassword = true;

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    update();
  }

  Future<void> login() async {
    _loginState = LoadingState.loading;
    update();

    try {
      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      Get.toNamed(AppRoutes.otpScreen, arguments: 'signup');
    } catch (e) {
      _loginError = e.toString();
      _loginState = LoadingState.error;
      update();
    }
  }

  void logout() async {
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
