import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
class SectionTitleWidget extends StatelessWidget {
  const SectionTitleWidget({super.key, this.onTap, required this.title,  this.fontWeight = FontWeight.w400});

  final VoidCallback? onTap;
  final String title;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            fontSize: 16.sp,
            text: title,
            color: AppColors.textSecondary,
            fontWeight: fontWeight,
          ),
          if (onTap != null)
            GestureDetector(
              onTap: onTap,
              behavior: HitTestBehavior.opaque,
              child: CustomText(
                fontSize: 14.sp,
                text: 'View All',
                color: AppColors.primary,
                fontWeight: fontWeight,
              ),
            ),
        ],
      ),
    );
  }
}
