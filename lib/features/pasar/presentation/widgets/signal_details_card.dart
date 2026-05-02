import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/pasar/data/models/trade_history_model.dart';
import 'package:flutter_task/features/pasar/presentation/controllers/history_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class SignalDetailsCard extends StatelessWidget {
  final Trades item;

  const SignalDetailsCard({super.key, required this.item});

  bool get isLong =>
      (item.signalId?.signalType ?? '').toLowerCase() == 'long';

  String get formattedTime {
    final raw = item.loggedAt ?? item.copiedAt;
    if (raw == null) return '--';
    try {
      final dt = DateTime.parse(raw).toLocal();
      return DateFormat('dd MMM yyyy • hh:mm a').format(dt);
    } catch (_) {
      return raw;
    }
  }

  Color _outcomeColor(String? outcome) {
    switch (outcome?.toLowerCase()) {
      case 'win':
        return Colors.greenAccent;
      case 'loss':
        return Colors.redAccent;
      default:
        return Colors.orangeAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = HistoryController.to;
    final id = item.sId ?? item.sId ?? '';

    return GestureDetector(
      onTap: () {
        controller.toggleExpanded(id);
      },
      child: Obx(() {
        final isExpanded = controller.isExpanded(id);

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: const LinearGradient(
              colors: [Color(0xFF0B0F2A), Color(0xFF050816)],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔥 TOP / IMAGE SWITCH
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 300),
                crossFadeState: isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,

                /// 👉 Compact UI
                firstChild: _topContent(),

                /// 👉 Expanded UI (image)
                secondChild: _expandedImage(),
              ),

              SizedBox(height: 14.h),

              /// 👇 Only show when NOT expanded
            //  if (!isExpanded) ...[
                _priceSection(),
                SizedBox(height: 12.h),
                _extraInfo(),
                SizedBox(height: 14.h),
             // ],

              /// Footer always visible
              _footer(),

              /// Notes
              if (!isExpanded &&
                  item.notes != null &&
                  item.notes!.isNotEmpty) ...[
                SizedBox(height: 10.h),
                CustomText(
                  text: '📝 ${item.notes}',
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                ),
              ],
            ],
          ),
        );
      }),
    );
  }

  /// 🔹 TOP CONTENT (same as before)
  Widget _topContent() {
    return Row(
      children: [
        CustomNetworkImage(
          width: 36.r,
          height: 36.r,
          boxShape: BoxShape.circle,
          imageUrl: item.masterId?.userProfileUrl,

        ),
        SizedBox(width: 10.w),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                text: item.signalId?.symbol ?? '--',
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
              ),
              CustomText(
                text: formattedTime,
                fontSize: 11.sp,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🔹 EXPANDED IMAGE
  Widget _expandedImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.r),
      child: CustomNetworkImage(
        width: double.infinity,
        height: 160.h,
        fit: BoxFit.cover,
        imageUrl: item.screenshotUrl,
        fallbackAsset: Icon(Icons.image_not_supported, size: 160.sp, color: AppColors.textSecondary),
      ),
    );
  }

  /// 🔹 PRICE SECTION
  Widget _priceSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoColumn("Entry", item.entryPrice?.toString() ?? '--'),
        _infoColumn("Exit", item.exitPrice?.toString() ?? '--'),
        _infoColumn("Lot", item.lotSize?.toString() ?? '--'),
      ],
    );
  }

  /// 🔹 EXTRA INFO
  Widget _extraInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _infoColumn(
            "Signal Entry", item.signalId?.entryPrice?.toString() ?? '--'),
        _infoColumn("Asset", item.signalId?.assetType ?? '--'),
        _infoColumn("Platform", item.externalPlatform ?? '--'),
      ],
    );
  }

  /// 🔹 FOOTER
  Widget _footer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: _outcomeColor(item.outcome).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: CustomText(
            text: item.outcome?.toUpperCase() ?? 'PENDING',
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: _outcomeColor(item.outcome),
          ),
        ),
        CustomText(
          text: item.resultPnl != null
              ? '+\$${item.resultPnl}'
              : '--',
          fontSize: 13.sp,
          fontWeight: FontWeight.w700,
          color: Colors.greenAccent,
        ),
      ],
    );
  }

  Widget _infoColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 10.sp,
          color: AppColors.textSecondary,
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: value,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ],
    );
  }
}
