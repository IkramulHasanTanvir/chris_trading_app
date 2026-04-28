import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';

class UpDownCard extends StatelessWidget {
  final int? entry;
  final int? exit;
  final int? stopLoss;

  const UpDownCard({
    super.key,
    this.entry,
    this.exit,
    this.stopLoss,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> stats = [
      {
        "title": "Entry",
        "value": entry?.toString() ?? "--",
        "icon": Icons.login,
        "color": Colors.blue,
      },
      {
        "title": "Exit",
        "value": exit?.toString() ?? "--",
        "icon": Icons.logout,
        "color": Colors.green,
      },
      {
        "title": "Stop",
        "value": stopLoss?.toString() ?? "--",
        "icon": Icons.warning_amber_rounded,
        "color": Colors.red,
      },
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: stats.map((item) {
        return Expanded(
          child: CustomContainer(
            marginRight: 6.w,
            paddingHorizontal: 8.w,
            paddingVertical: 6.h,
            bordersColor: AppColors.textSecondary.withValues(alpha: 0.15),
            radiusAll: 6.r,
            child: Row(
              children: [
                CustomContainer(
                  paddingAll: 4.r,
                  color: (item['color'] as Color).withValues(alpha: 0.2),
                  radiusAll: 4.r,
                  child: Icon(
                    item['icon'],
                    color: item['color'],
                    size: 14.r,
                  ),
                ),
                SizedBox(width: 8.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: item['title'],
                        fontSize: 9.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      CustomText(
                        text: item['value'],
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                        maxline: 1,
                        textOverflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
