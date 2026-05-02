import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/helpers/time_format.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/pasar/presentation/widgets/up_down_card.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:get/get.dart';

class SignalCard extends StatelessWidget {
  final SignalsModel item;

  const SignalCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final controller = SignalsController.to;

    final isSell = item.signalType?.toLowerCase() == "sell";

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        controller.toggleExpanded(item.sId ?? '');
      },
      child: Obx(() {
        final isExpanded = controller.isExpanded(item.sId ?? '');

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.all(isExpanded ? 0 : 14.r),
          decoration: BoxDecoration(
            color: isExpanded
                ? AppColors.background
                : AppColors.navBackground,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// 🔥 TOP / IMAGE SWITCH
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                sizeCurve: Curves.easeInOut,
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                firstChild: _topRow(item, isSell),
                secondChild: _chartImage(item),
              ),

              SizedBox(height: 12.h),

              /// 🔥 ENTRY / EXIT / SL
              if (!isExpanded)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoItem("Entry", item.entryPrice),
                    _infoItem("Exit", item.takeProfit1),
                    _infoItem("Stop loss", item.stopLoss),
                  ],
                ),

              SizedBox(height: 14.h),

              /// 🔥 BUTTONS
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      fontSize: 14.sp,
                      height: 36.h,
                      backgroundColor: AppColors.primaryBTN,
                      onPressed: () {
                        _showCopyDialog(context, controller);
                      },
                      label: 'Copy Trade',
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: CustomButton(
                      fontSize: 14.sp,
                      height: 36.h,
                      onPressed: () {
                        Get.toNamed(
                          AppRoutes.logUpdateScreen,
                          arguments: item.sId,
                        );
                      },
                      label: 'Log Trade',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  /// 🔹 Dialog
  void _showCopyDialog(BuildContext context, SignalsController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.navBackground,
          title: CustomText(
            text: 'Copy Trading Signal',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          content: CustomText(
            text: 'Are you sure you want to copy this signal?',
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const CustomText(
                text: 'Cancel',
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                controller.copyTradingSignal(signalId: item.sId ?? '');
                Get.back();
              },
              child: const CustomText(
                text: 'Copy Trade',
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );
      },
    );
  }

  /// 🔹 Top Row
  Widget _topRow(SignalsModel item, bool isSell) {
    return Row(
      children: [
        CustomNetworkImage(
          width: 34.r,
          height: 34.r,
          boxShape: BoxShape.circle,
          imageUrl: item.authorId?.userProfileUrl ?? '',
        ),
        SizedBox(width: 8.w),

        Expanded(
          child: Row(
            children: [
              Flexible(
                child: CustomText(
                  text: item.symbol ?? '',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  maxline: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 6.w),

              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.w,
                  vertical: 2.h,
                ),
                decoration: BoxDecoration(
                  color: isSell ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: CustomText(
                  text: item.signalType ?? '',
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: 6.w),

        CustomContainer(
          paddingVertical: 1.h,
          paddingHorizontal: 6.w,
          bordersColor: AppColors.white,
          radiusAll: 20.r,
          child: CustomText(
            text: TimeFormatHelper.timeFormat(
              DateTime.parse(item.publishedAt.toString()),
            ),
            fontSize: 8.sp,
          ),
        ),
      ],
    );
  }

  /// 🔹 Chart Image
  Widget _chartImage(SignalsModel item) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UpDownCard(
          entry: item.entryPrice,
          exit: item.takeProfit1,
          stopLoss: item.stopLoss,
        ),
        SizedBox(height: 12.h),
        ClipRRect(
          borderRadius: BorderRadius.circular(4.r),
          child: CustomNetworkImage(
            width: double.infinity,
            height: 140.h,
            fit: BoxFit.cover,
            imageUrl: item.externalChartUrl,
            fallbackAsset: Icon(Icons.image_not_supported, size: 140.sp, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  /// 🔹 Info Item
  Widget _infoItem(String title, int? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: title,
          fontSize: 12.sp,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: 2.h),
        CustomText(
          text: value?.toString() ?? '--',
          fontSize: 12.sp,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
