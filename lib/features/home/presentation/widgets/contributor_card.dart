import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/helpers/time_format.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/data/models/contributor_model.dart';
class ContributorCard extends StatelessWidget {
  const ContributorCard({super.key, required this.item,});

  final ContributorModel item;



  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      width: 160.w,
        height: 160.h,
        color: AppColors.navBackground,
        radiusAll: 16.r,
        paddingAll: 16.r,
        bordersColor: AppColors.primary.withValues(alpha: 0.15),
      child: Column(
        children: [
          /// Profile Image
          CustomNetworkImage(
            width: 80.w,
            height: 80.h,
            boxShape: BoxShape.circle,
            imageUrl: item.userProfileUrl ?? '',
          ),

          SizedBox(width: 10.w),

          /// Name
          CustomText(
            text: item.name ?? '',
            fontWeight: FontWeight.w700,
            fontSize: 16.sp,
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
