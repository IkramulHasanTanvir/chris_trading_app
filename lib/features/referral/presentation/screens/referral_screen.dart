import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/referral/data/model/referral_data.dart';
import 'package:flutter_task/features/referral/presentation/widgets/qr_code_card.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_code_card.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referrals_card.dart';
import 'package:get/get.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── Sliver AppBar ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 130.h,
            pinned: true,
            floating: false,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 2.0,
              title: CustomText(
                text: 'Invite a friend\nand Earn Rewards',
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
                children: [
                  QrCodeCard(referralLink: ''),
                  SizedBox(height: 20.h),
                  ReferralCodeCard(referralCode: ''),

                  SizedBox(height: 20.h),

                  _buildStatsRow(null),
                ],

              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ReferralData? data) {
    return Row(
      children: [
        Expanded(
          child: ReferralsCard(
            label: 'Total Referrals',
            value: '${data?.totalReferrals}',
            icon: Icons.people_outline_rounded,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ReferralsCard(
            label: 'Active',
            value: '${data?.activeReferrals}',
            icon: Icons.person_outline_rounded,

          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: ReferralsCard(
            label: 'Rewards',
            value: '\$${data?.totalRewards.toStringAsFixed(0)}',
            icon: Icons.workspace_premium_outlined,
          ),
        ),
      ],
    );
  }

}
