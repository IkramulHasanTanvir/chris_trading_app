import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';

class TakeProfitSection extends StatelessWidget {
  final SignalsModel? signal;
  const TakeProfitSection({super.key,  this.signal});

  @override
  Widget build(BuildContext context) {
    final tps = [
      ('Target 1', signal?.takeProfit1),
      ('Target 2', signal?.takeProfit2),
      ('Target 3', signal?.takeProfit3),
    ].where((e) => e.$2 != null).toList();

    if (tps.isEmpty) return const SizedBox.shrink();

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
            text: 'Targets',
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 12.h),
          ...tps.asMap().entries.map((entry) {
            final idx = entry.key;
            final tp = entry.value;
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 28.r,
                          height: 28.r,
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: CustomText(
                              text: '${idx + 1}',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.green,
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        CustomText(
                          text: tp.$1,
                          fontSize: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                    CustomText(
                      text: tp.$2?.toString() ?? '--',
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                    ),
                  ],
                ),
                if (idx < tps.length - 1) ...[
                  SizedBox(height: 4.h),
                  Divider(
                    color: AppColors.textSecondary.withValues(alpha: 0.15),
                    height: 16.h,
                  ),
                ],
              ],
            );
          }),
        ],
      ),
    );
  }
}
