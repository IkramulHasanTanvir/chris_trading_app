import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/core/services/connectivity_service.dart';
import 'package:flutter_task/features/auth/presentation/pages/forget/forget_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/login/log_in_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/otp/otp_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/reset_pass/reset_password_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/sign_up/sign_up_screen.dart';
import 'package:flutter_task/features/bottom_nav_bar/presentation/bottom_nav_user.dart';
import 'package:flutter_task/features/bottom_nav_bar/presentation/controller/bottom_nav_bar_controller.dart';
import 'package:flutter_task/features/home_demo/presentation/home_page.dart';
import 'package:flutter_task/features/onboarding/onboarding_screen.dart';
import 'package:flutter_task/features/profile/presentation/screens/setting_change_password.dart';
import 'package:flutter_task/features/profile/presentation/screens/support_screen.dart';
import 'package:flutter_task/features/profile/presentation/setting/setting_screen.dart';
import 'package:flutter_task/features/referral/data/repositories/referral_repository.dart';
import 'package:flutter_task/features/referral/domain/services/referral_service.dart';
import 'package:flutter_task/features/referral/presentation/controllers/referral_controller.dart';
import 'package:flutter_task/features/referral/presentation/screens/referral_screen.dart';
import 'package:flutter_task/features/splash/splash_screen.dart';
import 'package:get/get.dart';

abstract class AppPages {
  AppPages._();

  static final List<GetPage> routes = [
    GetPage(name: AppRoutes.initial, page: () => const SplashScreen()),

    GetPage(
      name: AppRoutes.onboardingScreen,
      page: () => const OnboardingScreen(),
    ),
    GetPage(name: AppRoutes.loginScreen, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.signUpScreen, page: () => const SignUpScreen()),
    GetPage(name: AppRoutes.forgetScreen, page: () => const ForgetScreen()),
    GetPage(name: AppRoutes.otpScreen, page: () => const OtpScreen()),
    GetPage(name: AppRoutes.settingScreen, page: () => const SettingScreen()),
    GetPage(name: AppRoutes.supportScreen, page: () => const SupportScreen()),
    GetPage(
      name: AppRoutes.settingChangePassword,
      page: () => const SettingChangePassword(),
    ),
    GetPage(
      name: AppRoutes.resetScreen,
      page: () => const ResetPasswordScreen(),
    ),

    GetPage(
      name: AppRoutes.bottomNavUserBar,
      page: () => const BottomNavUserBar(),
      binding: BottomNavBinding(),
    ),

    GetPage(name: AppRoutes.home, page: () => const HomePage()),

    GetPage(
      name: AppRoutes.referralScreen,
      page: () => const ReferralScreen(),
      binding: ReferralBinding(),
    ),
  ];
}

class BottomNavBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BottomNavBarController>(
      () => BottomNavBarController(),
      fenix: true,
    );
  }
}

class ReferralBinding extends Bindings {
  @override
  void dependencies() {
    // ✅ আগে Repository
    Get.lazyPut<ReferralRepository>(
          () => ReferralRepository(
        apiService: Get.find<ApiService>(),
        cacheService: Get.find<CacheService>(),
      ),
      fenix: true,
    );

    // ✅ তারপর Service
    Get.lazyPut<ReferralService>(
          () => ReferralService(
        repository: Get.find<ReferralRepository>(),
        connectivityService: Get.find<ConnectivityService>(),
      ),
      fenix: true,
    );

    // ✅ সবশেষে Controller
    Get.lazyPut<ReferralController>(
          () => ReferralController(referralService: Get.find<ReferralService>()),
      fenix: true,
    );
  }
}