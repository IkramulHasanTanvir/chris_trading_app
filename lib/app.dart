import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/routes/app_pages.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/services/theme_controller.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFFEEF2F6),
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.primaryDark,
        surface: Colors.white,
        onSurface: const Color(0xFF0F172A),
        onPrimary: Colors.white,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFEEF2F6),
        foregroundColor: Color(0xFF0F172A),
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: Color(0xFFD8DEE6)),
        ),
      ),
      dividerColor: const Color(0xFFE2E8F0),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? Colors.white
              : const Color(0xFFF1F5F9),
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary
              : const Color(0xFFCBD5E1),
        ),
      ),
    );
  }

  ThemeData _darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: const Color(0xFF191932),
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: const Color(0xFF191826),
        onSurface: Colors.white,
        onPrimary: Colors.white,
        error: AppColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF191932),
        foregroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
      ),
      dividerColor: const Color(0xFF2B2B36),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary
              : const Color(0xFF3A3A50),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return Obx(() {
          final isDark = Get.isRegistered<ThemeController>()
              ? ThemeController.to.isDarkMode
              : true;

          return GetMaterialApp(
            title: 'Trading',
            debugShowCheckedModeBanner: false,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            theme: _lightTheme(),
            darkTheme: _darkTheme(),
            getPages: AppPages.routes,
            initialRoute: AppRoutes.initial,
            defaultTransition: Transition.cupertino,
            transitionDuration: const Duration(milliseconds: 180),
          );
        });
      },
    );
  }
}
