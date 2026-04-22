import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';

class ReferralCodeCard extends StatelessWidget {
  const ReferralCodeCard({super.key, required this.referralCode});

  final String referralCode;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      paddingAll: 20.r,
      radiusAll: 20.r,
      color: AppColors.navBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Referral Code',
            color: AppColors.textSecondary,
            fontSize: 12.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: CustomContainer(
                  paddingVertical: 14.h,
                  paddingHorizontal: 16.w,
                  radiusAll: 12.r,
                  color: AppColors.primaryBTN,
                  bordersColor: AppColors.textSecondary,
                  child: CustomText(
                    text: referralCode,
                    color: AppColors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              GestureDetector(
                onTap: () {
                  Clipboard.setData(ClipboardData(text: referralCode));
                },
                behavior: HitTestBehavior.opaque,
                child: CustomContainer(
                  paddingAll: 14.r,
                  radiusAll: 12.r,
                  color: AppColors.primaryBTN,
                  bordersColor: AppColors.textSecondary,
                  child: Icon(
                    Icons.copy_rounded,
                    color: AppColors.white,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
