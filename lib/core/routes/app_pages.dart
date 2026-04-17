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

/// All application routes mapped to their pages and bindings.
///
/// [AppPages.routes] is passed to `GetMaterialApp(getPages: ...)` to enable
/// GetX named routing. Each [GetPage] entry ties a URL-like route name to a
/// page widget and an optional [Bindings] class that supplies dependencies.
///
/// **Activating named routing in `app.dart`:**
/// ```dart
/// // 1. Import the routes
/// import 'core/routes/app_routes.dart';
/// import 'core/routes/app_pages.dart';
///
/// // 2. Update GetMaterialApp inside MyApp
/// GetMaterialApp(
///   initialRoute: AppRoutes.home,   // replaces: home: child
///   getPages: AppPages.routes,      // register all pages
///   // Remove the `home:` parameter once initialRoute is set
/// )
/// ```
///
/// **Adding a new page:**
/// ```dart
/// GetPage(
///   name: AppRoutes.profile,
///   page: () => const ProfilePage(),
///   binding: ProfileBinding(),
/// ),
/// ```
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
      //  binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.signUpScreen,
      page: () => const SignUpScreen(),
      //  binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.forgetScreen,
      page: () => const ForgetScreen(),
      //  binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.otpScreen,
      page: () => const OtpScreen(),
      //  binding: HomeBinding(),
    ),
    GetPage(
      name: AppRoutes.resetScreen,
      page: () => const ResetPasswordScreen(),
      //  binding: HomeBinding(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),

    // ─── Add your pages below ──────────────────────────────────────────────
    // GetPage(
    //   name: AppRoutes.splash,
    //   page: () => const SplashPage(),
    //   binding: SplashBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.login,
    //   page: () => const LoginPage(),
    //   binding: LoginBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.profile,
    //   page: () => const ProfilePage(),
    //   binding: ProfileBinding(),
    // ),
  ];
}

/// Bindings for [HomePage].
///
/// Dependencies for the home feature are already registered as global
/// singletons in [DependencyInjection.init()], so no additional registration
/// is needed here.
///
/// If you prefer **route-scoped lifecycle** (controller auto-disposed when
/// leaving the route), move [HomeController] registration from
/// [DependencyInjection] to here using `Get.lazyPut`.
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

// ─── Binding Templates ──────────────────────────────────────────────────────
// Copy this template when adding a new feature binding:
//
// class ProfileBinding extends Bindings {
//   @override
//   void dependencies() {
//     Get.lazyPut<ProfileRepository>(
//       () => ProfileRepository(
//         apiService: Get.find<ApiService>(),
//         cacheService: Get.find<CacheService>(),
//       ),
//     );
//     Get.lazyPut<ProfileService>(
//       () => ProfileService(repository: Get.find<ProfileRepository>()),
//     );
//     Get.lazyPut<ProfileController>(
//       () => ProfileController(service: Get.find<ProfileService>()),
//     );
//   }
// }
