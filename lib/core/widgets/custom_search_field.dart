import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    this.searchController,
    this.autoFocus = false,
    this.hintText,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
  });

  final TextEditingController? searchController;
  final String? hintText;
  final bool readOnly;
  final bool autoFocus;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: AppColors.primary,
          ),
        ),
        child: SearchBar(
          keyboardType: TextInputType.webSearch,
          onTap: onTap,
          readOnly: readOnly,
          autoFocus: autoFocus,
          controller: searchController,
          hintText: hintText ?? 'Search here . . .',
          leading: Icon(
            Icons.search,
            size: 20.r,
            color: AppColors.textSecondary,
          ),
          constraints: BoxConstraints(minHeight: 44.h, maxHeight: 44.h),
          elevation: WidgetStateProperty.all(0),
          backgroundColor: WidgetStateProperty.all(AppColors.fillColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
              side: BorderSide(
                color: AppColors.textSecondary.withValues(alpha: 0.25),
              ),
            ),
          ),
          padding: WidgetStateProperty.all(EdgeInsets.only(left: 16.w)),
          textStyle: WidgetStateProperty.all(
            TextStyle(fontSize: 12.sp, color: AppColors.white),
          ),
          hintStyle: WidgetStateProperty.all(
            TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
          ),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
