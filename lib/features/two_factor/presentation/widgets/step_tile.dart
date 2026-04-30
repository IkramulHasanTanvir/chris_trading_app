import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';

class StepTile extends StatelessWidget {
  final String step;
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isLast;

   const StepTile({super.key,
    required this.step,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Left: number + line ─────────────────
          Column(
            children: [
              CustomContainer(
                width: 36.r,
                height: 36.r,
                  color: AppColors.primary.withValues(alpha: 0.12),
                  radiusAll: 10.r,
                  bordersColor: AppColors.primary.withValues(alpha: 0.35),

                child: Center(
                  child: CustomText(
                    text: step,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    color: AppColors.primary.withValues(alpha: 0.2),
                  ),
                ),
            ],
          ),

          SizedBox(width: 14.w),

          // ─── Right: content ──────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 20.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, color: AppColors.white, size: 18.r),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          textAlign: TextAlign.start,
                          text: title,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.white,
                        ),
                        SizedBox(height: 3.h),
                        CustomText(
                          textAlign: TextAlign.start,
                          text: subtitle,
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}