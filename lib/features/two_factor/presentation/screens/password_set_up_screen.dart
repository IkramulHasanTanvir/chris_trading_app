import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/two_factor/presentation/controllers/two_factor_controller.dart';
import 'package:get/get.dart';

class PasswordSetUpScreen extends StatefulWidget {
  const PasswordSetUpScreen({super.key});

  @override
  State<PasswordSetUpScreen> createState() => _PasswordSetUpScreenState();
}

class _PasswordSetUpScreenState extends State<PasswordSetUpScreen> {

  @override
  Widget build(BuildContext context) {
    final controller = TwoFactorController.to;
    return CustomScaffold(
      paddingSide: 24.w,
      appBar: CustomAppBar(title: 'Password'),
      body: SingleChildScrollView(
        child: Form(
          key: controller.globalKey,
          child: Column(
            //spacing: 10.h,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),
              CustomTextField(
                labelText: 'Password',
                controller: controller.passwordController,
                hintText: "Password",
                isPassword: true,
              ),
              CustomTextField(
                labelText: 'Confirm Password',
                controller: controller.confirmPasswordController,
                hintText: "Confirm Password",
                isPassword: true,
              ),

              SizedBox(height: 60.h),
              Obx(() {
                  return CustomButton(
                    isLoading: controller.setUpState.isLoading,
                      label: "Enable 2FA", onPressed: controller.setUpTwoFactor);
                }
              ),
              SizedBox(height: 32.h),
            ],
          ),
        ),
      ),
    );
  }

}
