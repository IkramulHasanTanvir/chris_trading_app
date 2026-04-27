import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/trader/data/models/signal_model.dart';

class SignalDetailsCard extends StatelessWidget {
  final SignalsModel item;

  const SignalDetailsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final isCall = item.signalType?.toLowerCase() == "call";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF0B0F2A),
            Color(0xFF050816),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ─── TOP ROW ─────────────────────
          Row(
            children: [
              /// Avatar
              CustomNetworkImage(
                width: 36.r,
                height: 36.r,
                boxShape: BoxShape.circle,
                imageUrl: item.authorId?.userProfileUrl ?? '',
              ),

              SizedBox(width: 10.w),

              /// Name + Time
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: item.symbol ?? '',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  SizedBox(height: 2.h),
                  CustomText(
                    text: "Today • 10:45 AM", // dynamic করতে পারো
                    fontSize: 11.sp,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),

              const Spacer(),

              /// CALL / PUT + Active
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: isCall ? Colors.green : Colors.red,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: CustomText(
                      text: item.signalType ?? '',
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: "Active",
                    fontSize: 11.sp,
                    color: Colors.green,
                  ),
                ],
              )
            ],
          ),

          SizedBox(height: 16.h),

          /// ─── ENTRY / TARGETS ─────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _leftColumn("Entry 1", item.entryPrice),
              _rightColumn("Entry", item.entryPrice),

              _leftColumn("Target 2", item.takeProfit1),
              _rightColumn("Target", item.takeProfit2),

              _leftColumn("Target 3", item.takeProfit3),
              _rightColumn("Target", item.stopLoss),
            ],
          ),
        ],
      ),
    );
  }

  /// Left label (Entry 1, Target 2...)
  Widget _leftColumn(String title, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 11.sp,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: value?.toString() ?? '--',
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }

  /// Right label (Entry, Target...)
  Widget _rightColumn(String title, dynamic value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 11.sp,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: value?.toString() ?? '--',
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}

