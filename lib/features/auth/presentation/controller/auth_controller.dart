import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/features/auth/domain/services/auth_services.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final AuthService _authService;

  AuthController({required AuthService authService})
    : _authService = authService;

  /// ─── STATE ─────────────────────────────
  LoadingState _loginState = LoadingState.initial;
  LoadingState _registerState = LoadingState.initial;
  LoadingState _otpState = LoadingState.initial;
  LoadingState _forgotState = LoadingState.initial;
  LoadingState _resetState = LoadingState.initial;

  LoadingState get loginState => _loginState;

  LoadingState get registerState => _registerState;

  LoadingState get otpState => _otpState;

  LoadingState get forgotState => _forgotState;

  LoadingState get resetState => _resetState;

  /// ─── FORM ──────────────────────────────
  final nameController = TextEditingController();
  final emailController = TextEditingController(text: kDebugMode ? 'ikramulhasantanvir@gmail.com' : '');
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

    _loginState = LoadingState.loading;
    update();

    try {
      await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      _loginState = LoadingState.loaded;
      update();
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      _loginState = LoadingState.error;
      update();
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  /// ─── REGISTER ──────────────────────────
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) return;

    _registerState = LoadingState.loading;
    update();
    try {
      await _authService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      _registerState = LoadingState.loaded;
      update();
      Get.toNamed(AppRoutes.otpScreen, arguments: 'signup');
    } catch (e) {
      _registerState = LoadingState.error;
      update();
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  /// ─── verify email ──────────────────────────
  Future<bool> otp() async {
    if (!otpFormKey.currentState!.validate()) return false;

    _otpState = LoadingState.loading;
    update();
    try {
      await _authService.otpVerify(
        email: emailController.text.trim(),
        otp: otpController.text.trim(),
      );
      _otpState = LoadingState.loaded;
      update();
      return true;
    } catch (e) {
      _otpState = LoadingState.error;
      update();
      ToastMessageHelper.show(e.errorMessage);
      return false;
    }
  }

  /// ─── forgot email ──────────────────────────
  Future<void> forgot() async {
    if (!forgotFormKey.currentState!.validate()) return;

    _forgotState = LoadingState.loading;
    update();
    try {
      await _authService.forgotPassword(emailController.text.trim());
      _forgotState = LoadingState.loaded;
      update();
      Get.toNamed(AppRoutes.otpScreen, arguments: 'forgot');
    } catch (e) {
      _forgotState = LoadingState.error;
      update();
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  /// ─── verify email ──────────────────────────
  Future<void> resetPassword() async {
    if (!resetFormKey.currentState!.validate()) return;

    _resetState = LoadingState.loading;
    update();
    try {
      await _authService.resetPassword(
        email: emailController.text.trim(),
        otp: otpController.text,
        password: passwordController.text,
        confirmPassword: confirmPasswordController.text,
      );
      _resetState = LoadingState.loaded;
      update();
      Get.offAllNamed(AppRoutes.loginScreen);
    } catch (e) {
      _resetState = LoadingState.error;
      update();
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  /// ─── LOGOUT ────────────────────────────
  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.loginScreen);
  }

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
