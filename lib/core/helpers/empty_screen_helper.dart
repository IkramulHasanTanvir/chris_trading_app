import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/core/widgets/widgets.dart';

class EmptyScreenHelper {
  EmptyScreenHelper._();

  static EmptyScreenHelper get instance => EmptyScreenHelper._();


  Widget emptyData ({required RefreshCallback onRefresh,String? title}){
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Assets.lotties.emptyData.lottie(height: 200.h),
          CustomText(
            text: title ?? 'No Data Found',
            color: AppColors.white,
            fontSize: 16.sp,
          ),
          SizedBox(height: 16.h),

          /// 🔄 Refresh Button
          CustomButton(
            label: 'Refresh',
            onPressed: onRefresh,
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            fontSize: 14.sp,
            height: 34.h,
            width: 100.w,
          ),
        ],
      ),
    );

  }

}