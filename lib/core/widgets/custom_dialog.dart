import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';

class CustomDialog extends StatelessWidget {
  final String title, description;
  final String? leftButtonLabel;
  final String? rightButtonLabel;
  final Color? rightButtonBgColor, rightButtonLabelColor;
  final Color? leftButtonBgColor, leftButtonLabelColor;
  final Color? titleColor;
  final bool isLoading;
  final Widget? content;
  final VoidCallback onTapLeftButton;
  final VoidCallback onTapRightButton;

  const CustomDialog({
    super.key,
    required this.title,
    this.leftButtonLabel = "Cancel",
    this.rightButtonLabel = "Sign Out",
    required this.onTapLeftButton,
    required this.onTapRightButton,
    this.rightButtonBgColor = Colors.transparent,
    this.rightButtonLabelColor,
    this.leftButtonBgColor = Colors.transparent,
    this.leftButtonLabelColor,
    required this.description,
    this.titleColor,
    this.content,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedTitleColor = titleColor ?? AppColors.error;
    final resolvedRightLabel = rightButtonLabelColor ?? AppColors.error;
    final resolvedLeftLabel = leftButtonLabelColor ?? AppColors.textSecondary;
    return Dialog(
      backgroundColor: AppColors.navBackground,
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40.r)),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 40.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title Text
                CustomText(text: title, fontSize: 16.sp, color: resolvedTitleColor),
                SizedBox(height: 20.h),

                Divider(color: AppColors.textSecondary, thickness: 0.5.h),

                SizedBox(height: 20.h),

                // Description Text
                CustomText(
                  left: 10.w,
                  right: 10.w,
                  bottom: 10.w,
                  text: description,
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                  maxline: 2,
                ),
                if (content != null)...[content!] ,
                SizedBox(height: 24.h),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Cancel Button
                    Expanded(
                      child: CustomButton(
                        radius: 100.r,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        bordersColor: resolvedLeftLabel,
                        backgroundColor: leftButtonBgColor,
                        foregroundColor: resolvedLeftLabel,
                        onPressed: onTapLeftButton,
                        label: leftButtonLabel!,
                      ),
                    ),
                    SizedBox(width: 10.w),
                    // Confirm Button
                    Expanded(
                      child: CustomButton(
                        radius: 100.r,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        bordersColor: resolvedRightLabel,
                        backgroundColor: rightButtonBgColor,
                        foregroundColor: resolvedRightLabel,
                        onPressed: onTapRightButton,
                        label: rightButtonLabel!,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          if (isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.navBackground.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(40.r),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primary,
                    strokeWidth: 2.5,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
