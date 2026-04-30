import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/features/auth/domain/services/auth_services.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService;

  static AuthController get to => Get.find();

  AuthController({required AuthService authService})
      : _authService = authService;

  /// ─── STATE ─────────────────────────────
  final _loginState = LoadingState.initial.obs;
  final _registerState = LoadingState.initial.obs;
  final _otpState = LoadingState.initial.obs;
  final _forgotState = LoadingState.initial.obs;
  final _resetState = LoadingState.initial.obs;

  LoadingState get loginState => _loginState.value;
  LoadingState get registerState => _registerState.value;
  LoadingState get otpState => _otpState.value;
  LoadingState get forgotState => _forgotState.value;
  LoadingState get resetState => _resetState.value;

  /// ─── FORM ──────────────────────────────
  final nameController = TextEditingController();
  final emailController = TextEditingController(text: kDebugMode ? 'pemafet963@ryzid.com' : '');
  final passwordController = TextEditingController(text: kDebugMode ? 'SecurePass123!' : '');
  final confirmPasswordController = TextEditingController();
  final otpController = TextEditingController();

  /// Separate keys for login and register forms
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  final forgotFormKey = GlobalKey<FormState>();
  final resetFormKey = GlobalKey<FormState>();

  /// ─── LOGIN ─────────────────────────────
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) return;

    _loginState.value = LoadingState.loading;

    try {
      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
        twoFactorCode: otpController.text.isEmpty ? null : otpController.text.trim(),
      );
      _loginState.value = LoadingState.loaded;
      await ProfileController.to.loadData();
      Get.offAllNamed(AppRoutes.bottomNavUserBar);
      otpController.clear();
    } catch (e) {
      _loginState.value = LoadingState.error;
      if (e.errorMessage == 'Two-factor authentication code required') {
        Get.toNamed(AppRoutes.twoFactorAuthScreen, arguments: 'login');
        return;
      }
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  /// ─── REGISTER ──────────────────────────
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    _registerState.value = LoadingState.loading;

    try {
      await _authService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      _registerState.value = LoadingState.loaded;
      Get.toNamed(AppRoutes.otpScreen, arguments: 'signup');
    } catch (e) {
      _registerState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  /// ─── VERIFY EMAIL ──────────────────────
  Future<bool> otp() async {
    if (!otpFormKey.currentState!.validate()) return false;

    _otpState.value = LoadingState.loading;

    try {
      await _authService.otpVerify(
        email: emailController.text.trim(),
        otp: otpController.text.trim(),
      );
      _otpState.value = LoadingState.loaded;
      return true;
    } catch (e) {
      _otpState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
      return false;
    }
  }

  /// ─── FORGOT PASSWORD ───────────────────
  Future<void> forgot() async {
    if (!forgotFormKey.currentState!.validate()) return;

    _forgotState.value = LoadingState.loading;

    try {
      await _authService.forgotPassword(emailController.text.trim());
      _forgotState.value = LoadingState.loaded;
      Get.toNamed(AppRoutes.otpScreen, arguments: 'forgot');
    } catch (e) {
      _forgotState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  /// ─── RESET PASSWORD ────────────────────
  Future<void> resetPassword() async {
    if (!resetFormKey.currentState!.validate()) return;

    _resetState.value = LoadingState.loading;

    try {
      await _authService.resetPassword(
        email: emailController.text.trim(),
        otp: otpController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      _resetState.value = LoadingState.loaded;
      Get.offAllNamed(AppRoutes.loginScreen);
    } catch (e) {
      _resetState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  /// ─── LOGOUT ────────────────────────────
  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.loginScreen);
  }

  /// ─── IS LOGGED IN ──────────────────────
  bool isLoggedIn() => _authService.isLoggedIn();

  /// ─── DISPOSE ───────────────────────────
  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    otpController.dispose();
    super.onClose();
  }
}