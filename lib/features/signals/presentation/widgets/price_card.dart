import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/custom_text.dart';

class PriceCard extends StatelessWidget {
  final String label;
  final double? value;
  final Color color;

  const PriceCard({super.key,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        borderRadius: BorderRadius.circular(10.r),
        border: Border(left: BorderSide(color: color, width: 3.w)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: label,
            fontSize: 11.sp,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 4.h),
          CustomText(
            text: value?.toString() ?? '--',
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ],
      ),
    );
  }
}
