import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';

class ProfileListTile extends StatelessWidget {
  const ProfileListTile({
    super.key,
    this.color,
    this.textColor,
    this.trailing,
    required this.title,
    required this.onTap,
     this.icon,
  });

  final Color? color;
  final Color? textColor;
  final Widget? trailing;
  final String title;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      onTap: onTap,
      verticalMargin: 4.h,
      paddingHorizontal: 16.w,
      paddingVertical: 14.h,
      radiusAll: 10.r,
      color: AppColors.primaryBTN,
      boxShadow: [
        BoxShadow(
          color: Color(0xffE4E5E7).withOpacity(0.16),
          blurRadius: 2,
          offset: Offset(0, 1),
        )
      ],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)...[Icon(icon,color: AppColors.white,size: 20.r,),
            SizedBox(width: 12.w),],

          Expanded(
            child: CustomText(
              text: title,
              textAlign: TextAlign.start,
              fontWeight: FontWeight.w600,
              color: textColor ?? AppColors.white,
            ),
          ),
          if (trailing == null)
            Icon(
              Icons.arrow_forward_ios_outlined,
              color: AppColors.white,
              size: 16.r,
            )
          else
            trailing!,
        ],
      ),
    );
  }
}
