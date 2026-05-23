import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';

class SignalDetailsSection extends StatelessWidget {
  final SignalsModel? signal;

  const SignalDetailsSection({super.key, required this.signal});

  @override
  Widget build(BuildContext context) {
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
            text: 'Signal Info',
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
          SizedBox(height: 12.h),
          _buildDetailRow(
            label: 'Asset Type',
            value: signal?.assetType?.toUpperCase() ?? '',
          ),
          _buildDetailRow(
            label: 'Timeframe',
            value: signal?.timeframe?.toUpperCase() ?? '',
          ),
          _buildDetailRow(
            label: 'Status',
            value: signal?.status?.toUpperCase() ?? '',
            isStatus: true,
          ),
          _buildDetailRow(
            label: 'Publish Type',
            value: signal?.publishType ?? '',
          ),
          if (signal?.resultPnl != null)
            _buildDetailRow(
              label: 'Result PnL',
              value: '${(signal?.resultPnl ?? 0) >= 0 ? '+' : ''}${signal?.resultPnl}%',
              isPnl: true,
              pnlPositive: (signal?.resultPnl ?? 0) >= 0,
            ),
          _buildDetailRow(
            label: 'Featured',
            value: (signal?.isFeatured ?? false) ? 'Yes' : 'No',
          ),
          _buildDetailRow(
            label: 'Premium',
            value: (signal?.isPremium ?? false) ? 'Yes' : 'No',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    bool isLast = false,
    bool isStatus = false,
    bool isPnl = false,
    bool pnlPositive = true,
  }) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: label,
                fontSize: 13.sp,
                color: AppColors.textSecondary,
              ),
              if (isStatus)
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 3.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(
                    text: value,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.green,
                  ),
                )
              else if (isPnl)
                CustomText(
                  text: value ,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w700,
                  color: pnlPositive ? Colors.green : Colors.red,
                )
              else
                CustomText(
                  text: value,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                ),
            ],
          ),
        ),
        if (!isLast)
          Divider(color: AppColors.textSecondary.withValues(alpha: 0.15), height: 0),
      ],
    );
  }
}
