import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/custom_text.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:get/get.dart';

class OutcomeButton extends StatelessWidget {
  const OutcomeButton({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignalsController.to;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        16.verticalSpace,
        CustomText(
          text: "Outcome",
          fontWeight: FontWeight.w600,
        ),
        10.verticalSpace,
        Obx(
              () => Row(
            children: [
              _buildOutcomeButton("win", controller),
              10.horizontalSpace,
              _buildOutcomeButton("loss", controller),
            ],
          ),
        ),
        16.verticalSpace,
      ],
    );
  }

  Widget _buildOutcomeButton(String value, SignalsController controller) {
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.onOutcomeChanged(value),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: controller.outcome == value
                ? (value == "win" ? Colors.green : Colors.red)
                : AppColors.textSecondary,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: CustomText(
            text: value.toUpperCase(),
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}