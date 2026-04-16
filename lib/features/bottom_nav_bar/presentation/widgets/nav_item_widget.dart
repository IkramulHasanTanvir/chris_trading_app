import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/bottom_nav_bar/data/models/nav_item_model.dart';
import 'package:flutter_task/features/bottom_nav_bar/presentation/controller/bottom_nav_bar_controller.dart';
import 'package:get/get.dart';

class BottomNavItem extends StatelessWidget {
  final NavItemModel navItem;
  final int index;

  const BottomNavItem({
    super.key,
    required this.navItem, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BottomNavBarController>(builder: (controller) {
      final isSelected = controller.selectedIndex == index;

      return GestureDetector(
        onTap: () => controller.onChange(index),
        child: CustomContainer(
          color: isSelected ? Colors.black26 : Colors.transparent,
          paddingAll: 9.r,
          shape: BoxShape.circle,
          child: SvgPicture.asset(
            navItem.icon,
            width: 24.w,
            height: 24.h,
          ),
        ),
      );
    });
  }
}
