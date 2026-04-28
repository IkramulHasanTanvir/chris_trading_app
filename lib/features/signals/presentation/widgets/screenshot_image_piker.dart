import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/helpers/photo_picker_helper.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:get/get.dart';

class ScreenshotImagePicker extends StatelessWidget {
  const ScreenshotImagePicker({super.key});

  void _pickImage(BuildContext context) {
    PhotoPickerHelper.showPicker(
      context: context,
      onImagePicked: (file) =>  SignalsController.to.onImagePicked(file),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final File? image = SignalsController.to.selectedImage;

      return GestureDetector(
        onTap: image == null ? () => _pickImage(context) : null,
        child: Container(
          width: double.infinity,
          height: 180.h,
          decoration: BoxDecoration(
            color: AppColors.fillColor,
            borderRadius: BorderRadius.circular(10.r),
            border: image == null
                ? Border.all(
              color: Colors.white24,
              width: 1.5,
              strokeAlign: BorderSide.strokeAlignInside,
            )
                : null,
          ),
          child: image == null
              ?  emptyState()
              : previewState(
            image: image,
            onRemove: SignalsController.to.onImageRemoved,
            onReplace: () => _pickImage(context),
          ),
        ),
      );
    });
  }



Widget emptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 44.w,
          height: 44.w,
          decoration: const BoxDecoration(
            color: Colors.white12,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.upload_rounded, color: Colors.white54, size: 22.sp),
        ),
        8.verticalSpace,
        CustomText(
          text: 'Tap to select image',
          fontSize: 12.sp,
          color: Colors.white38,
        ),
      ],
    );
  }

  Widget previewState({
    required File image,
    required VoidCallback onRemove,
    required VoidCallback onReplace,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          /// ─── Image ─────────────────────────────
          Image.file(image, fit: BoxFit.cover),

          /// ─── Change button (bottom right) ──────
          Positioned(
            bottom: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: onReplace,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: CustomText(
                  text: 'Change',
                  fontSize: 11.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          /// ─── Remove button (top right) ─────────
          Positioned(
            top: 8.h,
            right: 8.w,
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                width: 26.w,
                height: 26.w,
                decoration: const BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.close, size: 14.sp, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
