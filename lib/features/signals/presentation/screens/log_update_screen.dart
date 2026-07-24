import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:flutter_task/features/signals/presentation/widgets/outcome_button.dart';
import 'package:flutter_task/features/signals/presentation/widgets/screenshot_image_piker.dart';
import 'package:get/get.dart';

class LogUpdateScreen extends StatelessWidget {
  const LogUpdateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String signalId = Get.arguments as String;
    final controller = SignalsController.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 80.h,
              leading: IconButton(
                onPressed: () => Get.back(canPop: true),
                icon: Icon(Icons.arrow_back_ios, color: AppColors.onSurface),
              ),
              backgroundColor: AppColors.background,
              elevation: 0,
              centerTitle: true,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 2.0,
                title: CustomText(
                  text: 'Log Update',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
                centerTitle: true,
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: controller.entryController,
                              hintText: 'Entry',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: CustomTextField(
                              controller: controller.stopController,
                              hintText: 'Stop',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: controller.exitController,
                              hintText: 'Target',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: CustomTextField(
                              controller: controller.lotController,
                              hintText: 'Lot Size',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      16.verticalSpace,
                      CustomTextField(
                        controller: controller.pnlController,
                        hintText: 'Result PnL',
                        keyboardType: TextInputType.number,
                      ),
                      12.verticalSpace,
                      CustomText(
                        text: 'PnL Unit',
                        fontWeight: FontWeight.w600,
                      ),
                      8.verticalSpace,
                      Obx(() {
                        return Row(
                          children: [
                            _UnitChip(
                              label: 'USD (\$)',
                              selected: controller.pnlUnit == 'usd',
                              onTap: () => controller.onPnlUnitChanged('usd'),
                            ),
                            SizedBox(width: 8.w),
                            _UnitChip(
                              label: 'Percent (%)',
                              selected: controller.pnlUnit == 'percent',
                              onTap: () =>
                                  controller.onPnlUnitChanged('percent'),
                            ),
                          ],
                        );
                      }),
                      OutcomeButton(),
                      CustomText(
                        text: 'Platform',
                        fontWeight: FontWeight.w600,
                      ),
                      10.verticalSpace,
                      Obx(() {
                        final platforms = controller.platforms;
                        final values = platforms.map((e) => e.value).toList();
                        final current = values.contains(controller.platform)
                            ? controller.platform
                            : (values.isNotEmpty ? values.first : null);
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: AppColors.fillColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: DropdownButton<String>(
                            value: current,
                            hint: const CustomText(text: 'Select platform'),
                            dropdownColor: AppColors.fillColor,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: platforms
                                .map(
                                  (p) => DropdownMenuItem(
                                    value: p.value,
                                    child: CustomText(text: p.label),
                                  ),
                                )
                                .toList(),
                            onChanged: controller.onPlatformChanged,
                          ),
                        );
                      }),
                      16.verticalSpace,
                      ScreenshotImagePicker(),
                      Obx(() {
                        if (controller.imageState.isLoading) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: CustomText(
                              text: 'Uploading screenshot...',
                              fontSize: 12.sp,
                              color: AppColors.textSecondary,
                            ),
                          );
                        }
                        if (controller.imageUrl.isNotEmpty) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8.h),
                            child: CustomText(
                              text: 'Screenshot uploaded',
                              fontSize: 12.sp,
                              color: Colors.greenAccent,
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      }),
                      16.verticalSpace,
                      CustomTextField(
                        controller: controller.notesController,
                        hintText: 'Write notes...',
                        minLines: 4,
                        validator: (_) => null,
                      ),
                      24.verticalSpace,
                      Obx(() {
                        final uploading = controller.imageState.isLoading;
                        return CustomButton(
                          label: uploading ? 'Uploading...' : 'Submit Log',
                          isLoading: controller.logState.isLoading,
                          onPressed: uploading
                              ? () {}
                              : () {
                                  controller.logTradingSignal(signalId);
                                },
                        );
                      }),
                      30.verticalSpace,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnitChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _UnitChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.navBackground,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: selected
                ? AppColors.primary
                : AppColors.textSecondary.withValues(alpha: 0.3),
          ),
        ),
        child: CustomText(
          text: label,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
          color: selected ? AppColors.white : AppColors.textSecondary,
        ),
      ),
    );
  }
}
