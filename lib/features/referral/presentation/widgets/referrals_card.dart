import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';

class ReferralsCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const ReferralsCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,

  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      paddingAll: 14.r,
      radiusAll: 16.r,
      color: AppColors.navBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomContainer(
            paddingAll: 6.r,
            radiusAll: 8.r,
            color: AppColors.primary.withOpacity(0.2),
            child: Icon(icon, color: AppColors.primary, size: 14.sp),
          ),
          SizedBox(height: 10.h),
          CustomText(
            text: value,
            color: AppColors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
          SizedBox(height: 2.h),
          CustomText(
            text: label,
            color: AppColors.textSecondary,
            fontSize: 10.sp,
          ),
        ],
      ),
    );
  }
}
