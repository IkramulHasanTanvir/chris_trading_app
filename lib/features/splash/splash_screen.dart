import 'package:flutter/material.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/features/auth/presentation/controller/auth_controller.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goNextScreen();
  }

  Future<void> _goNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;

    try {
      final loggedIn =
          Get.isRegistered<AuthController>() && AuthController.to.isLoggedIn();
      if (loggedIn) {
        Get.offAllNamed(AppRoutes.bottomNavUserBar);
      } else {
        Get.offNamed(AppRoutes.onboardingScreen);
      }
    } catch (_) {
      // Offline / cache issues: fall back to onboarding safely.
      Get.offNamed(AppRoutes.onboardingScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Assets.lotties.tradingAnimLine.lottie(),
      ),
    );
  }
}
