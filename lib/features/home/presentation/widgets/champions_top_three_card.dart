import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/data/models/leader_board_model.dart';

class ChampionsTopThreeCard extends StatelessWidget {
  const ChampionsTopThreeCard({super.key, required this.items, this.onTap});

  final List<LeaderBoardItem> items;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final sortedItems = List<LeaderBoardItem>.from(items)
      ..sort((a, b) =>
          (b.leaderboardScore ?? 0).compareTo(a.leaderboardScore ?? 0));

    final topThree = sortedItems.take(3).toList();

    final arranged = [
      if (topThree.length > 1) topThree[1],
      if (topThree.isNotEmpty) topThree[0],
      if (topThree.length > 2) topThree[2],
    ];

    return CustomContainer(
      onTap: onTap,
      horizontalMargin: 16.w,
      width: double.infinity,
      color: AppColors.navBackground,
      radiusAll: 16.r,
      //paddingAll: 16.r,
      paddingHorizontal: 16.w,
      paddingVertical: 16.h,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if(onTap != null)
          CustomText(text: 'leaderboard'.toUpperCase(), fontWeight: FontWeight.w700, fontSize: 16.sp,
            bottom: 10.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(arranged.length, (index) {
              final isCenter = index == 1;
              return _buildCard(arranged[index], index, isCenter: isCenter);
            }),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }


  Widget _buildCard(LeaderBoardItem data, int index, {bool isCenter = false}) {
    final positions = ['2nd', '1st', '3rd'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Stack(
          children: [
            CustomNetworkImage(
              border: Border.all(color: isCenter ? Colors.amber : AppColors.primary, width: isCenter ? 4 : 3),
              width: isCenter ? 90.w : 70.w,
              // 👈 center bigger
              height: isCenter ? 90.h : 70.h,
              boxShape: BoxShape.circle,
              fit: BoxFit.cover,
              imageUrl: data.accountId?.userProfileUrl ?? '',
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: CustomContainer(
                width: 22.w,
                height: 22.h,
                color: isCenter ? Colors.amber : AppColors.primary,
                radiusAll: 12.r,
                child: Center(
                  child: CustomText(
                    text: positions[index],
                    fontSize: 10.sp,
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),

        CustomText(
          top: 6.h,
          text: data.accountId?.name ?? '',
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),

        CustomText(
          text: '+${data.leaderboardScore ?? 0}%',
          color: AppColors.primary,
          fontWeight: FontWeight.w700,
        ),
        if(isCenter)
          SizedBox(height: 20.h),
      ],
    );
  }
}
