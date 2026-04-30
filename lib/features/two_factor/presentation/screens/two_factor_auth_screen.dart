import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/profile/presentation/widgets/active_card.dart';
import 'package:flutter_task/features/profile/presentation/widgets/profile_list_tile.dart';
import 'package:flutter_task/features/referral/presentation/widgets/qr_code_card.dart';
import 'package:flutter_task/features/two_factor/presentation/controllers/two_factor_controller.dart';
import 'package:get/get.dart';

class TwoFactorAuthScreen extends StatelessWidget {
  const TwoFactorAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final verifyLogin = args is String && args == 'login';
    final controller = TwoFactorController.to;
    final authController = AuthController.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          /// ─── AppBar ─────────────────────────
          SliverAppBar(
            expandedHeight: 110.h,
            pinned: true,
            backgroundColor: AppColors.background,
            scrolledUnderElevation: 0,
            leading: IconButton(
              onPressed: () => Get.back(canPop: true),
              icon: const Icon(Icons.arrow_back_ios, color: AppColors.white),
            ),
            flexibleSpace: FlexibleSpaceBar(
              title: CustomText(
                text: 'Two-Factor\nAuthentication',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              centerTitle: true,
            ),
          ),

          /// ─── Body ───────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  /// 🔐 Info Text
                  if (controller.twoFactorData != null) ...[
                    CustomText(
                      text:
                          'Add an extra layer of security to your account by enabling two-factor authentication.',
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),

                    SizedBox(height: 24.h),

                    /// 📱 QR Code Card
                    QrCodeCard(
                      title: 'Scan QR Code',
                      referralLink: controller.twoFactorData?.qrCodeUrl ?? '',
                      body:
                          'Scan this QR code using Google Authenticator or any 2FA app.',
                    ),

                    SizedBox(height: 24.h),
                    CustomContainer(
                      width: double.infinity,
                      paddingAll: 24.r,
                      radiusAll: 20.r,
                      color: AppColors.navBackground,
                      child: Column(
                        children: [
                          CustomText(
                            text: 'Secret Key',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),

                          CustomText(
                            top: 6.h,
                            bottom: 16.h,
                            textAlign: TextAlign.start,
                            text:
                                'To set up 2FA: Open your Authenticator app → Tap "Add account" → Select "Enter a setup key" → Paste this key.',
                            fontSize: 10.sp,
                            color: AppColors.textSecondary,
                          ),
                          CustomContainer(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            width: double.infinity,
                            radiusAll: 12.r,
                            paddingBottom: 10.h,
                            paddingLeft: 10.w,
                            paddingRight: 10.w,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: CustomText(
                                    textAlign: TextAlign.start,
                                    text:
                                        controller.twoFactorData?.secret ?? '',
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Clipboard.setData(
                                      ClipboardData(
                                        text:
                                            controller.twoFactorData?.secret ??
                                            '',
                                      ),
                                    );
                                  },
                                  icon: Icon(
                                    Icons.copy,
                                    color: AppColors.primary,
                                    size: 16.r,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  SizedBox(height: 24.h),

                  /// 🔢 Manual Code Section
                  CustomText(
                    text: 'Enter 6-digit Code',
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),

                  SizedBox(height: 12.h),

                  /// Input Field
                  Form(
                    key: controller.codeGlobalKey,
                    child: CustomPinCodeTextField(
                      textEditingController: verifyLogin
                          ? authController.otpController
                          : controller.codeController,
                    ),
                  ),
                  SizedBox(height: 44.h),

                  Obx(() {
                    final bool twoFactorEnabled =
                        ProfileController.to.userData?.twoFactorEnabled ??
                        false;

                    return CustomButton(
                      backgroundColor: twoFactorEnabled
                          ? AppColors.red
                          : AppColors.primary,
                      isLoading: verifyLogin
                          ? authController.loginState.isLoading
                          : (twoFactorEnabled
                                ? controller.disableState.isLoading
                                : controller.verifyState.isLoading),
                      onPressed: verifyLogin
                          ? authController.login
                          : (twoFactorEnabled
                                ? controller.disableTwoFactor
                                : controller.verifyTwoFactor),
                      label: twoFactorEnabled ? 'Disable 2FA' : 'Enable 2FA',
                    );
                  }),
                  SizedBox(height: 16.h),

                  if (controller.twoFactorData != null)
                    CustomButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: AppColors.navBackground,
                              title: CustomText(
                                text: 'Backup Codes',
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children:
                                    controller.twoFactorData?.backupCodes
                                        ?.map(
                                          (e) => Row(
                                            children: [
                                              Expanded(
                                                child: CustomText(
                                                  textAlign: TextAlign.start,
                                                  // bottom: 6.h,
                                                  text: e,
                                                ),
                                              ),
                                              //const Spacer(),
                                              IconButton(
                                                onPressed: () {
                                                  Clipboard.setData(
                                                    ClipboardData(text: e),
                                                  );
                                                },
                                                icon: Icon(
                                                  Icons.copy,
                                                  color: AppColors.primary,
                                                  size: 16.r,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList() ??
                                    [const Text('No backup codes available')],
                              ),
                            );
                          },
                        );
                      },
                      label: 'View Backup Codes',
                      backgroundColor: AppColors.navBackground,
                      foregroundColor: AppColors.primary,
                    ),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
