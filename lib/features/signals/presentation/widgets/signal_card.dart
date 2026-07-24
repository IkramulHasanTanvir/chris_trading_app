import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/helpers/image_url_helper.dart';
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
        // isCopied == true => Tracked + disabled
        final isTracked =
            item.isCopied == true || controller.isSignalTracked(item.sId ?? '');

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
              /// Trade name always stays on top
              Padding(
                padding: EdgeInsets.all(isExpanded ? 14.r : 0),
                child: _topRow(item, isSell),
              ),

              SizedBox(height: 12.h),

              /// Optional chart image when expanded
              if (isExpanded) ...[
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 14.w),
                  child: _chartImage(item),
                ),
                SizedBox(height: 12.h),
              ],

              /// ENTRY / STOP / TARGET
              if (!isExpanded)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _infoItem("Entry", item.entryPrice),
                    _infoItem("Stop", item.stopLoss),
                    _infoItem("Target", item.takeProfit1),
                  ],
                ),

              SizedBox(height: 14.h),

              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isExpanded ? 14.w : 0,
                ).copyWith(bottom: isExpanded ? 14.h : 0),
                child: Row(
                  children: [
                    Expanded(
                      child: Opacity(
                        opacity: isTracked ? 0.45 : 1,
                        child: IgnorePointer(
                          ignoring: isTracked,
                          child: CustomButton(
                            fontSize: 14.sp,
                            height: 36.h,
                            backgroundColor: isTracked
                                ? AppColors.textSecondary
                                : AppColors.primaryBTN,
                            onPressed: isTracked
                                ? null
                                : () {
                                    _showCopyDialog(context, controller);
                                  },
                            label: isTracked ? 'Tracked' : 'Tracking',
                          ),
                        ),
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
                    SizedBox(width: 10.w),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(
                          AppRoutes.signalsDetailsScreen,
                          arguments: item.sId,
                        );
                      },
                      child: CustomContainer(
                        radiusAll: 4.r,
                        color: AppColors.primaryBTN,
                        paddingAll: 8.r,
                        child: Icon(
                          Icons.info_outline,
                          color: AppColors.white,
                          size: 22.r,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  void _showCopyDialog(BuildContext context, SignalsController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.navBackground,
          title: CustomText(
            text: 'Track Trading Signal',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          content: CustomText(
            text: 'Are you sure you want to track this signal?',
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
                if (controller.isSignalTracked(item.sId ?? '')) {
                  Get.back();
                  return;
                }
                controller.copyTradingSignal(signalId: item.sId ?? '');
                Get.back();
              },
              child: CustomText(
                text: controller.isSignalTracked(item.sId ?? '')
                    ? 'Already Tracked'
                    : 'Tracking',
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );
      },
    );
  }

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
                  text: item.symbol ?? item.title ?? '',
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
            text: _formatSignalTime(item),
            fontSize: 8.sp,
          ),
        ),
      ],
    );
  }

  String _formatSignalTime(SignalsModel item) {
    final raw = item.publishedAt ?? item.createdAt;
    if (raw == null || raw.isEmpty || raw == 'null') return '--';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return '--';
    return TimeFormatHelper.timeFormat(parsed);
  }

  Widget _chartImage(SignalsModel item) {
    final chartUrl = item.externalChartUrl;
    final canShowImage = ImageUrlHelper.isLoadableImageUrl(chartUrl);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        UpDownCard(
          entry: item.entryPrice,
          exit: item.takeProfit1,
          stopLoss: item.stopLoss,
        ),
        if (canShowImage) ...[
          SizedBox(height: 12.h),
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: CustomNetworkImage(
              width: double.infinity,
              height: 140.h,
              fit: BoxFit.cover,
              imageUrl: chartUrl,
              fallbackAsset: Icon(
                Icons.show_chart_rounded,
                size: 48.r,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _infoItem(String title, double? value) {
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
