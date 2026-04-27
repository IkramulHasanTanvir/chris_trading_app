import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/data/models/trader_model.dart';

class TraderCard extends StatelessWidget {
  final TraderModel trader;
  final VoidCallback? onFollow;

  const TraderCard({
    super.key,
    required this.trader,
    this.onFollow,
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

          CustomButton(onPressed: (){},
            label: "Follow",
            width: 70.w,
            height: 26.h,
            fontSize: 10.sp,
          ),
        ],
      ),
    );
  }
}
