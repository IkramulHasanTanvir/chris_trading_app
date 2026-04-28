import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/profile/presentation/widgets/active_card.dart';
import 'package:flutter_task/features/profile/presentation/widgets/profile_list_tile.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProfileController.to;
    return Scaffold(

      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── Sliver AppBar ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 90.h,
            pinned: true,
            floating: false,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 2.0,
              title: CustomText(
                text: 'User Profile',
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
              child: Obx(
                () {
                  final data = controller.userData;
                  return Column(
                    children: [
                      SizedBox(height: 24.h),
                      CustomNetworkImage(
                        boxShape: BoxShape.circle,
                        height: 128.r,
                        width: 128.r,
                        imageUrl: data?.userProfileUrl ?? '',
                      ),
                      CustomText(
                        text: data?.name ?? '',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        top: 12.h,
                        color: AppColors.white,
                      ),
                      CustomText(
                        text: data?.email ?? '',
                        fontSize: 10.sp,
                        top: 4.h,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: 24.h),

                      // Active Cards Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ActiveCard(
                              isActive: data?.subscriptionStatus == 'active',
                              title: data?.subscriptionStatus, subtitle: "subscription"),
                          SizedBox(width: 12.w),
                          ActiveCard(
                              isActive: data?.subscriptionTier == 'pro',
                              title: "Pro"),
                          SizedBox(width: 12.w),
                          ActiveCard(
                            isActive: data?.twoFactorEnabled ?? false,
                            title: "Two-factor",
                            subtitle: "authentication",
                          ),
                        ],
                      ),

                      SizedBox(height: 16.h),

                      // List Tiles
                      ProfileListTile(
                        icon: Icons.person_outline,
                        title: "Edit Profile",
                        onTap: () {
                           Get.toNamed(AppRoutes.editProfileScreen);
                        },
                      ),
                      ProfileListTile(
                        icon: Icons.lock_outline,
                        title: "Change Password",
                        onTap: () {
                          Get.toNamed(AppRoutes.settingChangePassword);
                        },
                      ),
                      ProfileListTile(
                        icon: Icons.share_outlined,
                        title: "Referral Program",
                        onTap: () {
                           Get.toNamed(AppRoutes.referralScreen);
                        },
                      ),
                      ProfileListTile(
                        icon: Icons.settings_outlined,
                        title: "Settings",
                        onTap: () {
                           Get.toNamed(AppRoutes.settingScreen);
                        },
                      ),

                      // Sign Out
                      ProfileListTile(
                        icon: Icons.logout_outlined,
                        title: "Sign Out",
                        trailing: const SizedBox.shrink(),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => CustomDialog(
                              title: "Sign Out",
                              description: 'Are you sure want to sign out?',
                              onTapLeftButton: () => Navigator.pop(context),
                              onTapRightButton: AuthController.to.logout,
                            ),
                          );
                        },
                      ),

                      SizedBox(height: 100.h),
                    ],
                  );
                }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
