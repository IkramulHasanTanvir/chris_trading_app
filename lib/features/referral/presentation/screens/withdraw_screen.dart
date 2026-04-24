import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/referral/presentation/controllers/referral_controller.dart';
import 'package:flutter_task/features/referral/presentation/widgets/payment_method.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_content.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_shimmer_widgets.dart';

import 'package:get/get.dart';

class WithdrawScreen extends StatelessWidget {
  const WithdrawScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReferralController.to;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        //controller: controller.scrollController,
        slivers: [
          // ─── Sliver AppBar ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 80.h,
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
                text: 'Withdraw',
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
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomContainer(
                      width: double.infinity,
                      color: AppColors.navBackground,
                      radiusAll: 16.r,
                      paddingAll: 16.r,
                      child: Column(
                        children: [
                          CustomText(
                            text: 'Available Balance'.toUpperCase(),
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                          Obx(() {
                            final balance =
                                controller.referralData?.totalRewards ?? 0.0;
                            return CustomText(
                              top: 6.h,
                              bottom: 2.h,
                              text: '\$${balance.toStringAsFixed(2)}',
                              fontSize: 32.sp,
                              fontWeight: FontWeight.w600,
                            );
                          }),
                          CustomText(
                            text: 'Referral Earnings',
                            fontSize: 12.sp,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.textSecondary.withValues(alpha: 0.2),
                    ),
                    SizedBox(height: 10.h),

                    CustomText(
                      text: 'Amount',
                      color: AppColors.textSecondary,
                      bottom: 6.h,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomContainer(
                      paddingAll: 12.r,
                      radiusAll: 10.r,
                      color: AppColors.navBackground,
                      bordersColor: AppColors.primary.withValues(alpha: 0.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: 'Enter Amount (USD)'.toUpperCase(),
                            fontWeight: FontWeight.w600,
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                          TextField(
                            cursorColor: AppColors.white,
                            controller: controller.amountController,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                            decoration: const InputDecoration(
                              hintText: '0.00',
                              border: InputBorder.none,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    CustomText(
                      text: 'Payment Details',
                      color: AppColors.textSecondary,
                      bottom: 6.h,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomContainer(
                      paddingAll: 16.r,
                      radiusAll: 10.r,
                      color: AppColors.navBackground,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PaymentMethod(),

                          SizedBox(height: 10.h),
                          CustomTextField(
                            hintText: 'Enter your Phone Number',
                            filColor: AppColors.navBackground,
                            controller: controller.numberController,
                            keyboardType: TextInputType.phone,
                            //borderColor: Colors.transparent,
                          ),

                          CustomTextField(
                            hintText: 'Enter your Email',
                            filColor: AppColors.navBackground,
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            isEmail: true,
                            // borderColor: Colors.transparent,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomContainer(
        paddingAll: 16.r,
        child: SafeArea(
          child: Obx(() {
            return CustomButton(
              backgroundColor: AppColors.navBackground,
              bordersColor: AppColors.textSecondary,
              foregroundColor: AppColors.white,
              radius: 100.r,
              isLoading: controller.requestState.isLoading,
              onPressed: controller.requestWithdrawal,
              label: 'Confirm Withdraw',
            );
          }),
        ),
      ),
    );
  }
}
