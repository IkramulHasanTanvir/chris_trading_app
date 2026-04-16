import 'package:flutter/material.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/features/bottom_nav_bar/data/models/nav_item_model.dart';
import 'package:flutter_task/features/bottom_nav_bar/presentation/controller/bottom_nav_bar_controller.dart';
import 'package:flutter_task/features/bottom_nav_bar/presentation/widgets/bottom_nav_bar.dart';
import 'package:get/get.dart';

class BottomNavUserBar extends StatelessWidget {
  const BottomNavUserBar({super.key});




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: GetBuilder<BottomNavBarController>(
        builder: (controller) =>
        IndexedStack(
        index: controller.selectedIndex,
        children:  NavItemModel.userNavItems.map((e) => e.screen).toList(),
      ),
      ),

      bottomNavigationBar: BottomNavBar(),
    );
  }
}