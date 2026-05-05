import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/referral/data/model/referral_data.dart';
import 'package:flutter_task/features/referral/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/referral/presentation/widgets/qr_code_card.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_code_card.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referrals_card.dart';
import 'package:flutter_task/features/referral/presentation/widgets/withdrawal_card.dart';
import 'package:get/get.dart';

class ReferralContent extends StatelessWidget {
  const ReferralContent({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReferralController.to;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() {
          final data = controller.referralData;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              QrCodeCard(referralLink: data?.referralLink ?? ''),
              SizedBox(height: 20.h),
              ReferralCodeCard(),
              SizedBox(height: 20.h),
              _buildStatsRow(data),
              if ((data?.totalRewards ?? 0) > 0) ...[
                SizedBox(height: 20.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomButton(
                    width: 120.w,
                    height: 35.h,
                    backgroundColor: AppColors.navBackground,
                    foregroundColor: AppColors.primary,
                    fontSize: 14.sp,
                    onPressed: () {
                      Get.toNamed(AppRoutes.withdrawScreen);
                    },
                    label: 'Withdraw',
                  ),
                ),
              ],
            ],
          );
        }),

        Divider(
          height: 40.h,
          thickness: 1,
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
        Obx(() {
          if (controller.withdrawals.isEmpty) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h),
              child: Center(child: CustomText(text: 'No withdrawals yet')),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: 'Withdrawals',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(height: 10.h),
              ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.withdrawals.length,
                itemBuilder: (_, i) =>
                    WithdrawalCard(data: controller.withdrawals[i]),
              ),
            ],
          );
        }),

        Obx(
          () => controller.isLoadingMore
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  child: const Center(child: CustomLoader()),
                )
              : const SizedBox.shrink(),
        ),

        SizedBox(height: 100.h),
      ],
    );
  }

  Widget _buildStatsRow(ReferralData? data) {
    return Row(
      children: [
        Expanded(
          child: ReferralsCard(
            label: 'Total Referrals',
            value: '${data?.totalReferrals ?? '0'}',
            icon: Icons.people_outline_rounded,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ReferralsCard(
            label: 'Active',
            value: '${data?.activeReferrals ?? '0'}',
            icon: Icons.person_outline_rounded,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ReferralsCard(
            label: 'Rewards',
            value: '\$${data?.totalRewards.toStringAsFixed(0) ?? '0'}',
            icon: Icons.workspace_premium_outlined,
          ),
        ),
      ],
    );
  }
}
