import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/data/models/trader_model.dart';
import 'package:flutter_task/features/home/presentation/controllers/home_controller.dart';
import 'package:get/get.dart';

class TraderCard extends StatelessWidget {
  final TraderModel trader;

  const TraderCard({
    super.key,
    required this.trader,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      paddingAll: 12.r,
        color: AppColors.navBackground,
        radiusAll: 12.r,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 3),
          )
        ],

      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 24.r,
            backgroundImage: NetworkImage(
              trader.userProfileUrl ?? "",
            ),
          ),

          SizedBox(width: 12.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(text:
                  trader.name ?? "Unknown",
                    fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 4.h),
                CustomText(text:
                  "Win Rate: ${trader.winRate ?? 0}%",
                    fontSize: 12.sp,
                    color: AppColors.primary,
                ),
              ],
            ),
          ),

          // Follow Button

          Obx(() {
            final isFollowing = HomeController.to.isFollowing(trader.accountId?.sId ?? '');
            return CustomButton(
              backgroundColor: !isFollowing ? AppColors.primary : AppColors.background,
              onPressed: () {
                if(isFollowing){
                  _showCopyDialog(context);
                }else{
                  HomeController.to.followTrader(traderId: trader.accountId?.sId ?? '');

                }
              } ,
              label: isFollowing ? "Following" : "Follow",
              width: 80.w,
              height: 26.h,
              fontSize: 10.sp,
            );
          }),
        ],
      ),
    );
  }


  void _showCopyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.navBackground,
          title: CustomText(
            text: 'Unfollow Trader',
            fontSize: 16.sp,
            color: Colors.red,
            fontWeight: FontWeight.w600,
          ),
          content: CustomText(
            text: 'Are you sure you want to unfollow this trader?',
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const CustomText(
                text: 'Cancel',
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                HomeController.to.followTrader(traderId: trader.accountId?.sId ?? '');
                Get.back();
              },
              child: const CustomText(
                text: 'Unfollow',
                color: AppColors.red,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );
      },
    );
  }

}
