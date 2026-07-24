import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/custom_text.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';

class StatsSection extends StatelessWidget {
  final SignalsModel? signal;
  final VoidCallback? onReplyTap;

  const StatsSection({
    super.key,
    this.signal,
    this.onReplyTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignalsController.to;
    final signalId = signal?.sId ?? '';

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
            children: [
              _buildStatItem(
                icon: Icons.visibility_outlined,
                label: 'Views',
                count: signal?.viewCount ?? 0,
              ),
              _buildStatItem(
                icon: (signal?.isLiked ?? false)
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                label: 'Likes',
                count: signal?.likeCount ?? 0,
                active: signal?.isLiked ?? false,
                onTap: signalId.isEmpty
                    ? null
                    : () => controller.toggleLike(signalId),
              ),
              _buildStatItem(
                icon: (signal?.isBookmarked ?? false)
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                label: 'Saved',
                count: signal?.bookmarkCount ?? 0,
                active: signal?.isBookmarked ?? false,
                onTap: signalId.isEmpty
                    ? null
                    : () => controller.toggleBookmark(signalId),
              ),
              _buildStatItem(
                icon: Icons.comment_outlined,
                label: 'Comments',
                count: signal?.commentCount ?? 0,
                onTap: onReplyTap,
              ),
              _buildStatItem(
                icon: Icons.copy_outlined,
                label: 'Copiers',
                count: signal?.copierCount ?? 0,
              ),
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            children: [
              Expanded(
                child: _ActionChip(
                  icon: (signal?.isLiked ?? false)
                      ? Icons.favorite_rounded
                      : Icons.favorite_border_rounded,
                  label: (signal?.isLiked ?? false) ? 'Liked' : 'Like',
                  active: signal?.isLiked ?? false,
                  onTap: signalId.isEmpty
                      ? null
                      : () => controller.toggleLike(signalId),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _ActionChip(
                  icon: (signal?.isBookmarked ?? false)
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  label: (signal?.isBookmarked ?? false) ? 'Saved' : 'Save',
                  active: signal?.isBookmarked ?? false,
                  onTap: signalId.isEmpty
                      ? null
                      : () => controller.toggleBookmark(signalId),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _ActionChip(
                  icon: Icons.reply_rounded,
                  label: 'Reply',
                  onTap: onReplyTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required int count,
    bool active = false,
    VoidCallback? onTap,
  }) {
    final content = Column(
      children: [
        Icon(
          icon,
          size: 20.r,
          color: active ? Colors.redAccent : AppColors.primary,
        ),
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

    if (onTap == null) return content;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}

class _ActionChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _ActionChip({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: active
              ? AppColors.primary.withValues(alpha: 0.18)
              : AppColors.background,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: active
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.2),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16.r,
              color: active ? AppColors.primary : AppColors.white,
            ),
            SizedBox(width: 6.w),
            CustomText(
              text: label,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: active ? AppColors.primary : AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}
