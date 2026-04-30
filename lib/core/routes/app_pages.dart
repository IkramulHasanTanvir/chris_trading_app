import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/features/auth/presentation/pages/forget/forget_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/login/log_in_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/otp/otp_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/reset_pass/reset_password_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/sign_up/sign_up_screen.dart';
import 'package:flutter_task/features/bottom_nav_bar/presentation/bottom_nav_user.dart';
import 'package:flutter_task/features/bottom_nav_bar/presentation/controller/bottom_nav_bar_controller.dart';
import 'package:flutter_task/features/home/data/repositories/home_repository.dart';
import 'package:flutter_task/features/home/domain/services/home_service.dart';
import 'package:flutter_task/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter_task/features/home/presentation/screens/contributor_screen.dart';
import 'package:flutter_task/features/home/presentation/screens/leaderboard_screen.dart';
import 'package:flutter_task/features/home/presentation/screens/top_trader_screen.dart';
import 'package:flutter_task/features/notification/presentation/screens/notification_screen.dart';
import 'package:flutter_task/features/onboarding/onboarding_screen.dart';
import 'package:flutter_task/features/pasar/data/repositories/history_repository.dart';
import 'package:flutter_task/features/pasar/domain/services/history_service.dart';
import 'package:flutter_task/features/pasar/presentation/controllers/history_controller.dart';
import 'package:flutter_task/features/profile/presentation/screens/edit_profile_screen.dart';
import 'package:flutter_task/features/profile/presentation/screens/setting_change_password.dart';
import 'package:flutter_task/features/profile/presentation/screens/support_screen.dart';
import 'package:flutter_task/features/profile/presentation/setting/setting_screen.dart';
import 'package:flutter_task/features/referral/data/repositories/referral_repository.dart';
import 'package:flutter_task/features/referral/domain/services/referral_service.dart';
import 'package:flutter_task/features/referral/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/referral/presentation/screens/referral_screen.dart';
import 'package:flutter_task/features/referral/presentation/screens/withdraw_screen.dart';
import 'package:flutter_task/features/signals/data/repositories/signals_repository.dart';
import 'package:flutter_task/features/signals/domain/services/signal_service.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:flutter_task/features/signals/presentation/screens/log_update_screen.dart';
import 'package:flutter_task/features/splash/splash_screen.dart';
import 'package:flutter_task/features/two_factor/data/repositories/two_factor_repository.dart';
import 'package:flutter_task/features/two_factor/domain/services/two_factor_services.dart';
import 'package:flutter_task/features/two_factor/presentation/controllers/two_factor_controller.dart';
import 'package:flutter_task/features/two_factor/presentation/screens/password_set_up_screen.dart';
import 'package:flutter_task/features/two_factor/presentation/screens/two_factor_auth_screen.dart';
import 'package:flutter_task/features/two_factor/presentation/screens/two_factor_screen.dart';
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

    GetPage(
      name: AppRoutes.referralScreen,
      page: () => const ReferralScreen(),
      binding: ReferralBinding(),
    ),
    GetPage(
      name: AppRoutes.withdrawScreen,
      page: () => const WithdrawScreen(),
      binding: ReferralBinding(),
    ),

    GetPage(
      name: AppRoutes.topTraderScreen,
      page: () => const TopTraderScreen(),
      // binding: ReferralBinding(),
    ),

    GetPage(
      name: AppRoutes.leaderboardScreen,
      page: () => const LeaderboardScreen(),
      // binding: ReferralBinding(),
    ),

    GetPage(
      name: AppRoutes.contributorScreen,
      page: () => const ContributorScreen(),
      // binding: ReferralBinding(),
    ),

    GetPage(
      name: AppRoutes.editProfileScreen,
      page: () => const EditProfileScreen(),
      // binding: ReferralBinding(),
    ),


    GetPage(
      name: AppRoutes.logUpdateScreen,
      page: () => const LogUpdateScreen(),
      // binding: ReferralBinding(),
    ),


    GetPage(
      name: AppRoutes.twoFactorScreen,
      page: () => const TwoFactorScreen(),
       binding: TwoFactorBinding(),
    ),


    GetPage(
      name: AppRoutes.passwordSetUpScreen,
      page: () => const PasswordSetUpScreen(),
       binding: TwoFactorBinding(),
    ),

    GetPage(
      name: AppRoutes.twoFactorAuthScreen,
      page: () => const TwoFactorAuthScreen(),
      binding: TwoFactorBinding(),
    ),


    GetPage(
      name: AppRoutes.notificationScreen,
      page: () => const NotificationScreen(),
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

    Get.lazyPut<HomeRepository>(
      () => HomeRepository(
        apiService: Get.find<ApiService>(),
        cacheService: Get.find<CacheService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<HomeService>(
      () => HomeService(repository: Get.find<HomeRepository>()),
      fenix: true,
    );

    Get.lazyPut<HomeController>(
      () => HomeController(service: Get.find<HomeService>()),
      fenix: true,
    );


    Get.lazyPut<SignalsRepository>(
      () => SignalsRepository(
        apiService: Get.find<ApiService>(),
        cacheService: Get.find<CacheService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<SignalsService>(
      () => SignalsService(repository: Get.find<SignalsRepository>()),
      fenix: true,
    );

    Get.lazyPut<SignalsController>(
      () => SignalsController(service: Get.find<SignalsService>()),
      fenix: true,
    );
    Get.lazyPut<HistoryRepository>(
      () => HistoryRepository(
        apiService: Get.find<ApiService>(),
        cacheService: Get.find<CacheService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<HistoryService>(
      () => HistoryService(repository: Get.find<HistoryRepository>()),
      fenix: true,
    );

    Get.lazyPut<HistoryController>(
      () => HistoryController(service: Get.find<HistoryService>()),
      fenix: true,
    );

  }
}

class ReferralBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReferralRepository>(
      () => ReferralRepository(
        apiService: Get.find<ApiService>(),
        cacheService: Get.find<CacheService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ReferralService>(
      () => ReferralService(repository: Get.find<ReferralRepository>()),
      fenix: true,
    );

    Get.lazyPut<ReferralController>(
      () => ReferralController(service: Get.find<ReferralService>()),
      fenix: true,
    );
  }
}


class TwoFactorBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TwoFactorRepository>(
          () => TwoFactorRepository(
        apiService: Get.find<ApiService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<TwoFactorService>(
          () => TwoFactorService(repository: Get.find<TwoFactorRepository>()),
      fenix: true,
    );

    Get.lazyPut<TwoFactorController>(
          () => TwoFactorController(service: Get.find<TwoFactorService>()),
      fenix: true,
    );
  }
}
