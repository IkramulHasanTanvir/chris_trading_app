import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/helpers/time_format.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';

class AuthorData extends StatelessWidget {
  final SignalsModel? signal;

  const AuthorData({super.key,  this.signal});

  @override
  Widget build(BuildContext context) {
    final isSell = signal?.signalType?.toLowerCase() == 'sell';
    final isBuy =
        signal?.signalType?.toLowerCase() == 'buy' ||
        signal?.signalType?.toLowerCase() == 'long';

    return Row(
      children: [
        CustomNetworkImage(
          width: 44.r,
          height: 44.r,
          boxShape: BoxShape.circle,
          imageUrl: signal?.authorId?.userProfileUrl ?? '',
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: signal?.authorId?.name ?? '--',
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 2.h),
              CustomText(
                text: signal?.publishedAt != null
                    ? TimeFormatHelper.timeFormat(
                        DateTime.parse(signal?.publishedAt ?? ''),
                      )
                    : '--',
                fontSize: 11.sp,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomText(
              text: signal?.symbol ?? '--',
              fontSize: 18.sp,
              fontWeight: FontWeight.w800,
            ),
            SizedBox(height: 4.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 3.h),
              decoration: BoxDecoration(
                color: isSell ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: CustomText(
                text: (signal?.signalType ?? '').toUpperCase(),
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
