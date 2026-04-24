import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/referral/data/model/payment_method_model.dart';
import 'package:flutter_task/features/referral/presentation/controllers/referral_controller.dart';
import 'package:get/get.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ReferralController.to;

    return Obx(
          () => Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: List.generate(
          PaymentMethodModel.paymentMethods.length,
              (index) {
            final item = PaymentMethodModel.paymentMethods[index];
            final isSelected =
                controller.selectedIndex == index;

            return GestureDetector(
              onTap: () => controller.selectMethod(index),
              child: CustomContainer(
                bordersColor: isSelected
                    ? AppColors.primary
                    : AppColors.textSecondary,
                color: isSelected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : Colors.transparent,
                radiusAll: 8.r,
                paddingHorizontal: 16.r,
                paddingVertical: 6.h,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SvgPicture.asset(
                      item.iconPath,
                      height: 24.r,
                      width: 24.r,
                    ),
                    CustomText(
                      left: 6.w,
                      text: item.name,
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.textSecondary,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
