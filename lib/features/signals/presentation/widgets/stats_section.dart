import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/custom_text.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';

class StatsSection extends StatelessWidget {
  final SignalsModel? signal;

  const StatsSection({super.key,  this.signal});

  @override
  Widget build(BuildContext context) {
    final stats = [
      (Icons.visibility_outlined, 'Views', signal?.viewCount ?? 0),
      (Icons.favorite_border_rounded, 'Likes', signal?.likeCount ?? 0),
      (Icons.bookmark_border_rounded, 'Saved', signal?.bookmarkCount ?? 0),
      (Icons.comment_outlined, 'Comments', signal?.commentCount ?? 0),
      (Icons.copy_outlined, 'Copiers', signal?.copierCount ?? 0),
    ];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Stats',
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: stats
                .map(
                  (s) => _buildStatItem(icon: s.$1, label: s.$2, count: s.$3),
                )
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required int count,
  }) {
    return Column(
      children: [
        Icon(icon, size: 20.r, color: AppColors.primary),
        SizedBox(height: 4.h),
        CustomText(
          text: count.toString(),
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
        CustomText(
          text: label,
          fontSize: 10.sp,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}
