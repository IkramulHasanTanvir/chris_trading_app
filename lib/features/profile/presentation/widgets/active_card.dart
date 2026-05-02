import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';

class ActiveCard extends StatelessWidget {
  const ActiveCard({
    super.key,
    this.title,
    this.subtitle,
    this.isActive = true, this.onTap,
  });

  final bool isActive;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomContainer(
        onTap: onTap,
        height: 48.h,
        paddingVertical: 6.h,
        radiusAll: 10.r,
        bordersColor: AppColors.primaryBTN,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 48.h,
              child: Center(
                child: Icon(
                  Icons.check_circle,
                  color: isActive ? AppColors.primary : AppColors.textSecondary,
                ),
              ),
            ),
            SizedBox(width: 2.w),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerLeft,
                child: subtitle != null
                    ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomText(
                      textAlign: TextAlign.start,
                      text: title ?? "",
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: !isActive
                          ? AppColors.textSecondary
                          : AppColors.white,
                    ),
                    CustomText(
                      textAlign: TextAlign.start,
                      text: subtitle!,
                      fontSize: 10.sp,
                      color: !isActive
                          ? AppColors.textSecondary
                          : AppColors.white,
                    ),
                  ],
                )
                    : CustomText(
                  textAlign: TextAlign.start,
                  text: title ?? "",
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: !isActive
                      ? AppColors.textSecondary
                      : AppColors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}