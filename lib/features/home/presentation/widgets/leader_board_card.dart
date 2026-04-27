import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/data/models/leader_board_model.dart';
import 'package:flutter_task/features/home/data/models/trader_model.dart';

class LeaderBoardCard extends StatelessWidget {
  final LeaderBoardItem item;

  const LeaderBoardCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      paddingAll: 12.r,
      color: AppColors.navBackground,
      radiusAll: 12.r,
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 3)),
      ],

      child: Row(
        children: [
          // Profile Image
          CircleAvatar(
            radius: 24.r,
            backgroundImage: NetworkImage(item.accountId?.userProfileUrl ?? ""),
          ),

          SizedBox(width: 12.w),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomText(
                  text: item.accountId?.name ?? "Unknown",
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 4.h),
                CustomText(
                  text: "Win Rate: ${item.winRate ?? 0}%",
                  fontSize: 12.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
