/// Route name constants for the entire application.
///
/// All route names are defined here as static constants. Use these constants
/// everywhere instead of string literals to prevent typos and to get
/// compile-time safety when navigating.
///
/// **Usage:**
/// ```dart
/// // Navigate to a named route
/// Get.toNamed(AppRoutes.home_demo);
///
/// // Navigate and remove all previous routes
/// Get.offAllNamed(AppRoutes.login);
///
/// // Navigate with arguments
/// Get.toNamed(AppRoutes.profile, arguments: {'userId': '123'});
/// ```
///
/// **Adding a new route:**
/// 1. Add the constant here: `static const String profile = '/profile';`
/// 2. Add a [GetPage] entry in [AppPages.routes].
/// 3. Optionally create a [Bindings] class for that page.
abstract class AppRoutes {
  AppRoutes._();

  static const String initial = '/';
  static const String onboardingScreen = '/onboarding';
  static const String loginScreen = '/auth/login';
  static const String signUpScreen = '/auth/register';
  static const String forgetScreen = '/auth/forget';
  static const String otpScreen = '/auth/otp';
  static const String resetScreen = '/auth/reset';
  static const String bottomNavUserBar = '/bottomNavUserBar';
  static const String settingScreen = '/profile/setting';
  static const String supportScreen = '/setting/support';
  static const String settingChangePassword = '/setting/change_password';
  static const String referralScreen = '/profile/referral';
  static const String withdrawScreen = '/referral/withdraw';
  static const String topTraderScreen = '/home/signals';
  static const String leaderboardScreen = '/home/leaderboard';
  static const String contributorScreen = '/home/contributor';
  static const String editProfileScreen = '/profile/edit';
  static const String logUpdateScreen = '/signal/log-update';
  static const String twoFactorScreen = '/profile/two-factor';
  static const String passwordSetUpScreen = '/profile/two-factor/password';
  static const String twoFactorAuthScreen = '/profile/two-factor-auth';
  static const String notificationScreen = '/home/notification';
  static const String home = '/home_demo';

  // ─── Add your routes below ───────────────────────────────────────────────
  // static const String splash   = '/splash';
  // static const String login    = '/login';
  // static const String register = '/register';
  // static const String profile  = '/profile';
  // static const String settings = '/settings';
  // static const String cart     = '/cart';
  // static const String checkout = '/checkout';
  // static const String orderDetail = '/order-detail';
}
