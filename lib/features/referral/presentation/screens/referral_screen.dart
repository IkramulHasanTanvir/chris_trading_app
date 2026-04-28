import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/referral/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_content.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_shimmer_widgets.dart';

import 'package:get/get.dart';

class ReferralScreen extends StatelessWidget {
  const ReferralScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReferralController.to;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        controller: controller.scrollController,
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
                Navigator.pop(context);
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

                //  text: 'Referral &\nWithdrawals',
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
              child: Obx(() {
                switch (controller.loadingState) {
                  case LoadingState.initial:
                  case LoadingState.loading:
                    return ReferralShimmerWidgets.buildLoadingShimmer();

                  case LoadingState.offline:
                  case LoadingState.error:
                    return RetryWidget(
                      message: controller.errorMessage,
                      onRetry: controller.retry,
                      isOffline: controller.loadingState.isOffline,
                    );

                  case LoadingState.loaded:
                    return ReferralContent();
                }
              }),
            ),
          ),
        ],
      ),
    );
  }
}
