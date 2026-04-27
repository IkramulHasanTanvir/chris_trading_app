import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';

class SignalCard extends StatefulWidget {
  final SignalsModel item;

  const SignalCard({super.key, required this.item});

  @override
  State<SignalCard> createState() => _SignalCardState();
}

class _SignalCardState extends State<SignalCard> {
  bool isExpanded = false;
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isSell = item.signalType?.toLowerCase() == "sell";

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(color: AppColors.navBackground),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 ONLY TOP SECTION CLICKABLE
          GestureDetector(
            onTap: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 300),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: _topRow(item, isSell),
              secondChild: _chartImage(item),
            ),
          ),

          SizedBox(height: 12.h),

          /// ENTRY / EXIT / SL
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem("Entry", item.entryPrice),
              _infoItem("Exit", item.takeProfit1),
              _infoItem("Stop loss", item.stopLoss),
            ],
          ),

          SizedBox(height: 14.h),

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: CustomButton(
                  fontSize: 14.sp,
                  height: 36.h,
                  backgroundColor: AppColors.primaryBTN,
                  onPressed: () {},
                  label: 'Copy Trade',
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: CustomButton(
                  fontSize: 14.sp,
                  height: 36.h,
                  onPressed: () {},
                  label: 'Log Trade',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 🔹 Top Row (with Like button)
  Widget _topRow(SignalsModel item, bool isSell) {
    return Row(
      key: const ValueKey("top"),
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
              CustomText(
                text: item.symbol ?? '',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              SizedBox(width: 6.w),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: isSell ? Colors.red : Colors.green,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: CustomText(
                  text: item.signalType ?? '',
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),

        /// TIME
        CustomContainer(
          paddingVertical: 2.h,
          paddingHorizontal: 10.w,
          bordersColor: AppColors.white,
          radiusAll: 20.r,
          child: CustomText(text: "9:45 AM", fontSize: 10.sp),
        ),

        SizedBox(width: 6.w),

        /// ❤️ LIKE BUTTON (No conflict now)
        Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20.r),
            onTap: () {
              setState(() {
                isLiked = !isLiked;
              });
            },
            child: Padding(
              padding: EdgeInsets.all(6.r),
              child: AnimatedScale(
                scale: isLiked ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : AppColors.textSecondary,
                  size: 20.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 Chart Image
  Widget _chartImage(SignalsModel item) {
    return ClipRRect(
      key: const ValueKey("image"),
      borderRadius: BorderRadius.circular(4.r),
      child: CustomNetworkImage(
        width: double.infinity,
        height: 140.h,
        fit: BoxFit.cover,
        imageUrl: item.externalChartUrl ?? "https://i.pravatar.cc/150?img=1",
      ),
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
