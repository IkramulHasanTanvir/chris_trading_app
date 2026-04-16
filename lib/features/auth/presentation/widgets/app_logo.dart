import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.title,
    this.subtitle,  this.icon,
  });

  final String? title, subtitle;
  final Widget? icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ?icon,
        if (icon != null) SizedBox(height: 32.h),
        if (title != null) ...[
          CustomText(
            text: title ?? '',
            fontSize: 32.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.white,
          ),
          SizedBox(height: 10.h),
        ],

        if (subtitle != null)
          CustomText(
            text: subtitle ?? '',
            fontSize: 12.sp,
           fontWeight: FontWeight.w500,
           color: AppColors.grey600,
          ),
      ],
    );
  }
}
