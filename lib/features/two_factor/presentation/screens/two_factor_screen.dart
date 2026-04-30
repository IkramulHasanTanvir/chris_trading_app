import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/two_factor/presentation/controllers/two_factor_controller.dart';
import 'package:flutter_task/features/two_factor/presentation/widgets/step_tile.dart';
import 'package:get/get.dart';

class TwoFactorScreen extends StatelessWidget {
  const TwoFactorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── Sliver AppBar ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 90.h,
            pinned: true,
            floating: false,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(canPop: true),
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 2.0,
              title: CustomText(
                text: 'Two-factor',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              centerTitle: true,
            ),
          ),

          // ─── Sliver Body ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text:
                        'Add an extra layer of security to your account by enabling two-factor authentication.',
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    textAlign: TextAlign.center,
                  ),

                  SizedBox(height: 24.h),

                  // ─── Big Shield Icon ─────────────────────────
                  Center(
                    child: CustomContainer(
                      paddingAll: 24.r,
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.1),
                      bordersColor: AppColors.primary.withValues(alpha: 0.4),
                      child: Icon(
                        Icons.shield_outlined,
                        color: AppColors.primary,
                        size: 54.r,
                      ),
                    ),
                  ),

                  SizedBox(height: 12.h),

                  Center(
                    child: CustomText(
                      text: '2FA Not Enabled',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.white,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // ─── How it works title ──────────────────────
                  CustomText(
                    text: 'How it works',
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),

                  SizedBox(height: 16.h),

                  // ─── Steps ───────────────────────────────────
                  StepTile(
                    step: '01',
                    icon: Icons.lock_outline,
                    title: 'Sign in as usual',
                    subtitle: 'Enter your email and password like normal.',
                  ),

                  StepTile(
                    step: '02',
                    icon: Icons.phone_android_outlined,
                    title: 'Open your authenticator',
                    subtitle: 'Get a 6-digit code from your authenticator app.',
                  ),

                  StepTile(
                    step: '03',
                    icon: Icons.verified_outlined,
                    title: 'Enter the code',
                    subtitle: 'Submit the code to complete your secure login.',
                    isLast: true,
                  ),

                  SizedBox(height: 24.h),

                  // ─── Bottom Note ─────────────────────────────
                  CustomContainer(
                    width: double.infinity,
                    paddingAll: 14.r,
                    color: AppColors.primary.withValues(alpha: 0.12),
                    radiusAll: 12.r,
                    bordersColor: AppColors.primary,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppColors.primary,
                          size: 16.r,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: CustomText(
                            text:
                                'Even if your password is stolen, your account stays protected.',
                            fontSize: 11.sp,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Obx(
            () {
              final isTwoFactorEnabled = ProfileController.to.userData?.twoFactorEnabled ?? false;
              return CustomButton(
                backgroundColor: isTwoFactorEnabled
                    ? AppColors.red
                    : AppColors.primary,
                onPressed: () {
                  if (!isTwoFactorEnabled) {
                    Get.toNamed(AppRoutes.passwordSetUpScreen);
                  } else {
                    Get.toNamed(AppRoutes.twoFactorAuthScreen);
                  }
                },
                label: isTwoFactorEnabled ? "Disable 2FA" : "Enable 2FA",
              );
            }
          ),
        ),
      ),
    );
  }
}
