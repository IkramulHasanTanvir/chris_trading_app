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



  void _goNextScreen()async {
    Future.delayed(const Duration(seconds: 2), () async {
      if (AuthController.to.isLoggedIn()){
        Get.offAllNamed(AppRoutes.bottomNavUserBar);
      }else{
        Get.offNamed(AppRoutes.onboardingScreen);
      }

    });
  }

  @override
  void initState() {
   _goNextScreen();
    super.initState();
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
