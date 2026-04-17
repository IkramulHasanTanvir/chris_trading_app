import 'package:flutter/material.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/features/auth/domain/services/auth_services.dart';
import 'package:get/get.dart';

class SplashMiddleware extends GetMiddleware {
  final AuthService _authService = Get.find<AuthService>();

  @override
  RouteSettings? redirect(String? route) {
    if (_authService.isLoggedIn()) {
      return const RouteSettings(name: AppRoutes.home);
    } else {
      return const RouteSettings(name: AppRoutes.loginScreen);
    }
  }
}
