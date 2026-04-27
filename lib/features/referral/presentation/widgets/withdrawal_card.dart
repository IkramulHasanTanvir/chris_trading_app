import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/helpers/time_format.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/custom_text.dart';
import 'package:flutter_task/features/referral/data/model/withdrawal_model.dart';

class WithdrawalCard extends StatelessWidget {
  final WithdrawalModel data;

  const WithdrawalCard({super.key, required this.data});

  Color _getStatusColor() {
    switch (data.status.toUpperCase()) {
      case 'PENDING':
        return Colors.orange;
      case 'APPROVED':
        return Colors.green;
      case 'REJECTED':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final parts = data.paymentDetails.split(',');

    final phone = parts.length > 1 ? parts.first.trim() : 'xxxxxx';
    final email = parts.isNotEmpty ? parts.last.trim() : 'example@example';
    return Card(
      color: AppColors.navBackground,
      margin:  EdgeInsets.symmetric(vertical: 6.h),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Amount + Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(text:
                  "\$${data.amount}",
                    fontSize: 32.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                ),
                Container(
                  padding:  EdgeInsets.symmetric(
                      horizontal: 12.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: CustomText(text:
                    data.status,
                      color: _getStatusColor(),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

             SizedBox(height: 8.h),

            /// Method
            CustomText(text:
              "Method: ${data.paymentMethod}",
              textAlign: TextAlign.start,
              fontSize: 16.sp,
            ),

             SizedBox(height: 4.h),

            /// Details
            CustomText(text:
              "Email: $email\nPhone: $phone",
              color: AppColors.grey600,
              textAlign: TextAlign.start,

            ),

             SizedBox(height: 6.h),

            /// Admin Note
            if (data.adminNote.isNotEmpty)
              CustomText(text:
                "Note: ${data.adminNote}",
                  fontSize: 13,
                  textAlign: TextAlign.start,
                  color: Colors.blueGrey,

              ),

             Divider(height: 16,color: AppColors.primary.withOpacity(0.2),),

            /// Created Date
            CustomText(text:
              "Date: ${TimeFormatHelper.formatDate(data.createdAt)}",
              fontSize: 12.sp, color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
