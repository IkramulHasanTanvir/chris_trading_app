import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';

class CustomSearchTheme {
  CustomSearchTheme._();

  static final CustomSearchTheme instance = CustomSearchTheme._();

  ThemeData get appBarTheme => _appBarTheme;

  final ThemeData _appBarTheme = ThemeData(
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.background,
      elevation: 0,
      scrolledUnderElevation: 0,
      toolbarHeight: 60,
      titleSpacing: 0,
      iconTheme: IconThemeData(color: AppColors.onSurface),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Color(0xFF2B2B36)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: InputBorder.none,
      hintStyle: TextStyle(
        fontSize: 16.sp,
        color: AppColors.textSecondary,
      ),
      enabledBorder: InputBorder.none,
      focusedBorder: InputBorder.none,
      constraints: BoxConstraints(maxHeight: 44.h),
    ),
    textTheme: TextTheme(
      titleLarge: TextStyle(
        fontSize: 16.sp,
        color: AppColors.white,
      ),
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: AppColors.primary,
    ),
    scaffoldBackgroundColor: AppColors.background,
  );
}
