import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/services/theme_controller.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/profile/presentation/widgets/profile_list_tile.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProfileController.to;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
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
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.onSurface,
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
                    text: 'Appearance'.toUpperCase(),
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                  SizedBox(height: 6.h),
                  Obx(() {
                    // Rebuild settings tile when theme flips
                    final theme = ThemeController.to;
                    final isDark = theme.isDarkMode;
                    return ProfileListTile(
                      title: isDark ? 'Dark Mode' : 'Light Mode',
                      trailing: Switch(
                        value: isDark,
                        activeTrackColor: AppColors.primary,
                        onChanged: (value) {
                          theme.setDarkMode(value);
                        },
                      ),
                      onTap: () => theme.toggle(),
                    );
                  }),

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
                        builder: (context) => Obx(() {
                            return CustomDialog(
                              isLoading: controller.deleteState.isLoading,
                              title: "Delete Account?",
                              description: 'This action is permanent and cannot be undone. Please type DELETE below to confirm account deletion.',
                              content: CustomTextField(
                                hintText: 'Type...',
                                  controller: controller.deleteController),
                              onTapLeftButton: () => Navigator.pop(context),
                              onTapRightButton: () async {
                                if (controller.deleteController.text != 'DELETE') {
                                  return;
                                }
                                await controller.deleteUser();
                              },
                              rightButtonLabel: 'Yes, Delete',
                            );
                          }
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
