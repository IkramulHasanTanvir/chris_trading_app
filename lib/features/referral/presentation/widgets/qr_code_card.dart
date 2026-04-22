import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrCodeCard extends StatelessWidget {
  const QrCodeCard({super.key, required this.referralLink});

  final String referralLink;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: double.infinity,
      paddingAll: 24.r,
      radiusAll: 20.r,
      color: AppColors.navBackground,
      child: Column(
        children: [
          // Header
          Row(
            children: [
              CustomContainer(
                radiusAll: 20.r,
                paddingHorizontal: 10.w,
                paddingVertical: 4.h,
                color: AppColors.primaryBTN,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.qr_code_rounded,
                      size: 13.sp,
                      color: AppColors.white,
                    ),
                    SizedBox(width: 4.w),
                    CustomText(
                      text: 'Your QR Code',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 20.h),

          // QR Code
          CustomContainer(
            color: AppColors.white,
            paddingAll: 16.r,
            radiusAll: 12.r,
            child: QrImageView(
              data: referralLink,
              version: QrVersions.auto,
              size: 180.r,
              backgroundColor: AppColors.white,
              eyeStyle: const QrEyeStyle(
                eyeShape: QrEyeShape.square,
                color: AppColors.background,
              ),
              dataModuleStyle: const QrDataModuleStyle(
                dataModuleShape: QrDataModuleShape.square,
                color: AppColors.background,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          CustomText(
            text: 'Scan to sign up with your referral',
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
