import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/custom_text.dart';
import 'package:flutter_task/features/bottom_nav_bar/data/models/nav_item_model.dart';
import 'package:flutter_task/features/bottom_nav_bar/presentation/controller/bottom_nav_bar_controller.dart';
import 'package:get/get.dart';

class BottomNavItem extends StatelessWidget {
  final NavItemModel navItem;
  final int index;

  const BottomNavItem({
    super.key,
    required this.navItem,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavBarController>(builder: (controller) {
      final isSelected = controller.selectedIndex == index;

      return GestureDetector(
        onTap: () => controller.onChange(index),
        behavior: HitTestBehavior.opaque,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ✅ Smooth indicator animation
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              height: 4.h,
              width: isSelected ? 14.w : 0,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),

            SizedBox(height: 10.h),

            // ✅ Smooth icon color transition
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: SvgPicture.asset(
                navItem.icon,
                key: ValueKey(isSelected),
                width: 24.r,
                height: 24.r,
                colorFilter: ColorFilter.mode(
                  isSelected ? AppColors.white : AppColors.textSecondary,
                  BlendMode.srcIn,
                ),
              ),
            ),
            SizedBox(height: 4.h),
            CustomText(text:
              navItem.label ?? '',
                color: isSelected ? AppColors.white : AppColors.textSecondary,
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,

            ),
          ],
        ),
      );
    });
  }
}