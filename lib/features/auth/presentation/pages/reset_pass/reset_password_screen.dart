import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter_task/features/auth/presentation/widgets/app_logo.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();
    return CustomScaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: controller.resetFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),

              AppLogo(
                title: 'Reset Password',
                subtitle: 'Enter your new password',
              ),

              SizedBox(height: 40.h),
              CustomTextField(
                controller: controller.passwordController,
                hintText: "New Password",
                isPassword: true,
              ),

              SizedBox(height: 16.h),

              CustomTextField(
                controller: controller.confirmPasswordController,
                hintText: "Confirm Password",
                isPassword: true,
              ),

              SizedBox(height: 36.h),

              GetBuilder<AuthController>(
                builder: (controller) {
                  return CustomButton(
                    label: "Reset",
                    isLoading: controller.resetState.isLoading,
                    onPressed: controller.resetPassword,
                  );
                },
              ),
              SizedBox(height: 44.h),
            ],
          ),
        ),
      ),
    );
  }
}
