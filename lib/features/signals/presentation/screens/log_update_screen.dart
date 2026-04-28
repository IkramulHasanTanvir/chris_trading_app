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
            /// ─── AppBar ─────────────────────────────
            SliverAppBar(
              expandedHeight: 80.h,
              leading: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
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

            /// ─── Body ─────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.verticalSpace,

                      /// ─── Entry & Exit ───────────────
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: controller.entryController,
                              hintText: 'Entry Price',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: CustomTextField(
                              controller: controller.exitController,
                              hintText: 'Exit Price',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      16.verticalSpace,

                      /// ─── Lot & PNL ─────────────────
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: controller.lotController,
                              hintText: 'Lot Size',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                          10.horizontalSpace,
                          Expanded(
                            child: CustomTextField(
                              controller: controller.pnlController,
                              hintText: 'Result PnL',
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),

                      /// ─── Outcome Selector ───────────
                      OutcomeButton(),

                      /// ─── Platform Dropdown ─────────
                      CustomText(text: "Platform", fontWeight: FontWeight.w600),
                      10.verticalSpace,

                      Obx(
                        () => Container(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: AppColors.fillColor,
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: DropdownButton<String>(
                            value: controller.platform,
                            dropdownColor: AppColors.fillColor,
                            isExpanded: true,
                            underline: const SizedBox(),
                            items: const [
                              DropdownMenuItem(
                                value: "binance",
                                child: CustomText(text: "Binance"),
                              ),
                              DropdownMenuItem(
                                value: "mt4",
                                child: CustomText(text: "MT4"),
                              ),
                              DropdownMenuItem(
                                value: "mt5",
                                child: CustomText(text: "MT5"),
                              ),
                            ],
                            onChanged: controller.onPlatformChanged,
                          ),
                        ),
                      ),

                      16.verticalSpace,

                      ScreenshotImagePicker(),

                      16.verticalSpace,

                      /// ─── Notes ─────────────────────
                      CustomTextField(
                        controller: controller.notesController,
                        hintText: 'Write notes...',
                        minLines: 4,
                      ),

                      24.verticalSpace,

                      /// ─── Submit Button ─────────────
                      Obx(() {
                        return CustomButton(
                          label: "Submit Log",
                          isLoading: controller.logState.isLoading,
                          onPressed: () {
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
