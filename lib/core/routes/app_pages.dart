import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/features/auth/presentation/pages/forget/forget_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/login/log_in_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/otp/otp_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/reset_pass/reset_password_screen.dart';
import 'package:flutter_task/features/auth/presentation/pages/sign_up/sign_up_screen.dart';
import 'package:flutter_task/features/home/presentation/home_page.dart';
import 'package:flutter_task/features/onboarding/onboarding_screen.dart';
import 'package:flutter_task/features/splash/splash_screen.dart';
import 'package:get/get.dart';



abstract class AppPages {
  AppPages._();

  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.initial,
      page: () => const SplashScreen(),
      //binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.onboardingScreen,
      page: () => const OnboardingScreen(),
      //  binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const LoginScreen(),
     //  binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.signUpScreen,
      page: () => const SignUpScreen(),
    //  binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.forgetScreen,
      page: () => const ForgetScreen(),
      //binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.otpScreen,
      page: () => const OtpScreen(),
      //binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.resetScreen,
      page: () => const ResetPasswordScreen(),
    //  binding: AuthBinding(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

  ];
}




class HomeBinding extends Bindings {
  @override
  void dependencies() {
    // HomeController and all home-feature dependencies are registered
    // globally in DependencyInjection.init(). Nothing extra needed here.
    //
    // Example of route-scoped registration (auto-disposes on route leave):
    // Get.lazyPut<HomeController>(
    //   () => HomeController(
    //     homeService: Get.find<HomeService>(),
    //     repository: Get.find<HomeRepository>(),
    //     connectivityService: Get.find<ConnectivityService>(),
    //   ),
    // );
  }
}
