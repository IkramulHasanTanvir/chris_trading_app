import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/data/models/trader_model.dart';

class UpDownCard extends StatelessWidget {


  const UpDownCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stats = [
      {
        "title": "Up",
        "value": "120903",
        "icon": Icons.arrow_upward_rounded,
        "color": Colors.green,
      },
      {
        "title": "Down",
        "value": "80932",
        "icon": Icons.arrow_downward_rounded,
        "color": Colors.red,
      },
      {
        "title": "Exit",
        "value": "23011",
        "icon": Icons.logout,
        "color": Colors.orange,
      },
    ];

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: stats.map((item) {
        return CustomContainer(
          width: 105.w,
          paddingHorizontal: 8.w,
          paddingVertical: 8.h,
          bordersColor: AppColors.textSecondary.withValues(alpha: 0.15),
          radiusAll: 6.r,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomContainer(
                paddingAll: 4.r,
                color: (item['color'] as Color).withValues(alpha: 0.2),
                radiusAll: 4.r,
                child: Icon(
                  item['icon'],
                  color: item['color'],
                  size: 18,
                ),
              ),
              SizedBox(width: 6.w),

              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomText(
                      text: item['title'],
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    CustomText(
                      text: item['value'],
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      maxline: 1,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
