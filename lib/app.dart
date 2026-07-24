import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/routes/app_pages.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/services/theme_controller.dart';
import 'package:get/get.dart';
import 'core/utils/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
            theme: ThemeData(
              brightness: Brightness.light,
              primarySwatch: Colors.green,
              scaffoldBackgroundColor: Colors.white,
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              primarySwatch: Colors.green,
              scaffoldBackgroundColor: AppColors.background,
            ),
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
