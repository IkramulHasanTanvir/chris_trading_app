import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/data/models/contributor_model.dart';

class ContributorCard extends StatelessWidget {
  const ContributorCard({
    super.key,
    required this.item,
    this.isHorizontal = false,
  });

  final ContributorModel item;
  final bool isHorizontal;

  @override
  Widget build(BuildContext context) {
    return isHorizontal ? _buildHorizontal() : _buildVertical();
  }

  // ─── Vertical = List Tile Style ───────────────────────────────────
  Widget _buildVertical() {
    return CustomContainer(
      color: AppColors.navBackground,
      radiusAll: 16.r,
      paddingHorizontal: 14.w,
      paddingVertical: 12.h,
      bordersColor: AppColors.primary.withValues(alpha: 0.15),
      child: Row(
        children: [
          /// Profile Image
          CustomNetworkImage(
            width: 48.w,
            height: 48.h,
            boxShape: BoxShape.circle,
            imageUrl: item.userProfileUrl ?? '',
          ),

          SizedBox(width: 12.w),

          /// Name + Badge
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Name
                CustomText(
                  text: item.name ?? '',
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp,
                  maxline: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),

                SizedBox(height: 5.h),

                /// Badge
                CustomContainer(
                  paddingHorizontal: 10.w,
                  paddingVertical: 3.h,
                  color: AppColors.primary.withValues(alpha: 0.15),
                  radiusAll: 6.r,
                  child: CustomText(
                    text: item.contributionType ?? '',
                    fontSize: 9.sp,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Horizontal Card ──────────────────────────────────────────────
  Widget _buildHorizontal() {
    return CustomContainer(
      width: 160.w,
      height: 160.h,
      color: AppColors.navBackground,
      radiusAll: 16.r,
      paddingAll: 16.r,
      bordersColor: AppColors.primary.withValues(alpha: 0.15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Profile Image
          CustomNetworkImage(
            width: 60.w,
            height: 60.h,
            boxShape: BoxShape.circle,
            imageUrl: item.userProfileUrl ?? '',
          ),

          SizedBox(height: 10.h),

          /// Name
          CustomText(
            text: item.name ?? '',
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
            maxline: 1,
            textOverflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 6.h),

          /// Badge
          CustomContainer(
            paddingHorizontal: 10.w,
            paddingVertical: 3.h,
            color: AppColors.primary.withValues(alpha: 0.15),
            radiusAll: 6.r,
            child: CustomText(
              text: item.contributionType ?? '',
              fontSize: 9.sp,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}