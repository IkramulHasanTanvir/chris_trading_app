import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/photo_picker_helper.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:get/get.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

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
            leading: IconButton(onPressed: () => Get.back(canPop: true), icon: const Icon(Icons.arrow_back_ios, color: AppColors.white,)),
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 2.0,
              title: CustomText(
                text: 'Update Profile',
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
                    return Form(
                      key: controller.formKey,
                      child: Column(
                        children: [
                          SizedBox(height: 24.h),
                          Stack(
                            children: [
                              CustomNetworkImage(
                                boxShape: BoxShape.circle,
                                height: 128.r,
                                width: 128.r,
                                imageFile: controller.selectedImage,
                                imageUrl: data?.userProfileUrl,
                              ),
                              Positioned(
                                bottom: 10.h,
                                right: 0,
                                child: GestureDetector(
                                  onTap: () {
                                    PhotoPickerHelper.showPicker(context: context, onImagePicked: controller.onImagePicked);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(alpha: 0.5),
                                      shape: BoxShape.circle,
                                    ),
                                    child:  Icon(Icons.camera_alt, color: AppColors.white,size: 18.r,),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 44.h),

                          CustomTextField(
                            labelText: 'Name',
                            controller: controller.nameController,
                            hintText: 'Name',
                          ),
                          CustomTextField(
                            labelText: 'Email',
                            hintText: 'Email',
                            readOnly: true,
                            hintextColor: AppColors.textSecondary,
                            controller: controller.emailController,
                          ),


                          SizedBox(height: 30.h),
                          Obx(() {
                              return CustomButton(
                                isLoading: controller.updateState.isLoading,
                                onPressed: controller.updateProfile,
                                label: 'Update Profile',
                              );
                            }
                          ),
                          SizedBox(height: 100.h),
                        ],
                      ),
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
