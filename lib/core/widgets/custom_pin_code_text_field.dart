import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:pinput/pinput.dart';

class CustomPinCodeTextField extends StatelessWidget {
  const CustomPinCodeTextField(
      {super.key, this.textEditingController, this.validator, this.focusNode,this.autoFocus=false});

  final TextEditingController? textEditingController;
  final FormFieldValidator? validator;
  final FocusNode? focusNode;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return Pinput(
        validator: validator ??
            (value) {
              if (value == null || value.isEmpty) {
                return "The code seems invalid. Please try again";
              } else if (value.length != 6 ||
                  !RegExp(r'^\d{6}$').hasMatch(value)) {
                return "Enter a valid 6-digit Code";
              }
              return null;
            },
        focusNode: focusNode,

        controller: textEditingController,
        length: 6,
        separatorBuilder: (index) => SizedBox(width: 14.w),
        defaultPinTheme: PinTheme(
          width: 47.w,
          height: 47.h,
          textStyle: TextStyle(color: AppColors.white, fontSize: 16.sp),
          decoration: BoxDecoration(
            //shape: BoxShape.circle,
          //  color: AppColors.bgColor,
            borderRadius: BorderRadius.circular(12.r),
           border: Border.all(color: AppColors.white),
          ),
        ),
        focusedPinTheme: PinTheme(
          width: 47.w,
          height: 47.h,
          textStyle:  TextStyle(color: AppColors.white, fontSize: 20),
          decoration: BoxDecoration(
            //shape: BoxShape.circle,
           // color: AppColors.bgColor,
           borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary),
          ),
        ),
        cursor: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 2.w,
              height: 20.h,
              color: AppColors.white,
            ),
          ],
        ),
        keyboardType: TextInputType.number,
        //obscureText: true,
        autofocus: false,
        onChanged: (value) {},
        obscuringCharacter: '-');
  }
}
