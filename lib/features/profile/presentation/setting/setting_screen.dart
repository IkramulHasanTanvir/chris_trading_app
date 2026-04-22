import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter_task/features/profile/presentation/widgets/profile_list_tile.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const NeverScrollableScrollPhysics(),
        slivers: [
          // ─── Sliver AppBar ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 90.h,
            pinned: true,
            floating: false,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.background,
            elevation: 0,
            leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.white,
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 2.0,
              title: CustomText(
                text: 'Settings',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              centerTitle: true,
            ),
          ),

          // ─── Sliver Body ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 16.h),

                  CustomText(
                    text: 'legal & support'.toUpperCase(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),

                  SizedBox(height: 6.h),

                  // List Tiles
                  // List Tiles
                  ProfileListTile(
                    title: 'Terms & Conditions',
                    onTap: () {
                      // Get.toNamed(AppRoutes.profileInformationScreen);
                    },
                  ),
                  ProfileListTile(
                    title: 'Privacy Policy',
                    onTap: () {
                      // Get.toNamed(AppRoutes.settingChangePassword);
                    },
                  ),
                  ProfileListTile(
                    title: 'About Us',
                    onTap: () {
                      // Get.toNamed(AppRoutes.settingChangePassword);
                    },
                  ),
                  ProfileListTile(
                    title: 'Contact Us',
                    onTap: () {
                      Get.toNamed(AppRoutes.supportScreen);
                    },
                  ),

                  // Sign Out
                  ProfileListTile(
                    title: "Delete Account",
                    trailing: const SizedBox.shrink(),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          title: "Delete Account",
                          description: 'Are you sure want to delete account?',
                          onTapLeftButton: () => Get.back(),
                          onTapRightButton: AuthController.to.logout,
                          rightButtonLabel: 'Yes, Delete',
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
