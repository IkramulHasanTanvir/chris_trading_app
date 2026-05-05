import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:get/get.dart';

class ReferralCodeCard extends StatefulWidget {
  const ReferralCodeCard({super.key});

  @override
  State<ReferralCodeCard> createState() => _ReferralCodeCardState();
}

class _ReferralCodeCardState extends State<ReferralCodeCard> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = ProfileController.to;

    return CustomContainer(
      paddingHorizontal: 20.w,
      radiusAll: 20.r,
      color: AppColors.navBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: CustomText(
                  textAlign: TextAlign.start,
                  text: 'Referral Code',
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),

              Obx(() {
                if (controller.codeChanged) {
                  return Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 16.h,
                    ),
                    child: CustomText(
                      text: 'Code Changed',
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }

                return IconButton(
                  onPressed: () {
                    if (controller.isEditingReferral.value) {
                      controller.saveReferral(_focusNode);
                    } else {
                      controller.startEditingReferral(_focusNode);
                    }
                  },
                  icon: CustomText(
                    text: controller.isEditingReferral.value
                        ? 'Save Code'
                        : 'Customize Code',
                    color: AppColors.primary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                  ),
                );
              }),
            ],
          ),

          Obx(() {
            final bool editing =
                !controller.codeChanged && controller.isEditingReferral.value;

            return Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: AppColors.primaryBTN,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: editing
                            ? AppColors.primary
                            : AppColors.textSecondary,
                        width: editing ? 1.5 : 1.0,
                      ),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: 4.h,
                      horizontal: 16.w,
                    ),
                    child: TextField(
                      controller: controller.referralController,
                      focusNode: _focusNode,
                      readOnly: !editing,
                      style: TextStyle(
                        color: AppColors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration:  InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onTapOutside: (_) {
                        if (controller.isEditingReferral.value) {
                          controller.cancelEditingReferral(_focusNode);
                        }
                      },
                    ),
                  ),
                ),
                SizedBox(width: 10.w),

                GestureDetector(
                  onTap: () {
                    Clipboard.setData(
                      ClipboardData(
                        text: controller.userData?.referralCode ?? '',
                      ),
                    );
                  },
                  behavior: HitTestBehavior.opaque,
                  child: CustomContainer(
                    paddingAll: 14.r,
                    radiusAll: 12.r,
                    color: AppColors.primaryBTN,
                    bordersColor: AppColors.textSecondary,
                    child: Icon(
                      Icons.copy_rounded,
                      color: AppColors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            );
          }),

          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}