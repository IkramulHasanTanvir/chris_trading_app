import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter_task/features/auth/presentation/widgets/app_logo.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = AuthController.to;

    return CustomScaffold(
      paddingSide: 24.w,
      body: SingleChildScrollView(
        child: Form(
          key: controller.registerFormKey,
          child: Column(
            spacing: 4.h,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 70.h),
              Center(
                child: AppLogo(
                  icon: Assets.lotties.tradingAnimLine.lottie(
                    height: 100.h,
                    width: 200.w,
                  ),
                  title: "Create Account",
                ),
              ),
              SizedBox(height: 10.h),
              CustomTextField(
                controller: controller.nameController,
                hintText: "Name",
              ),
              CustomTextField(
                controller: controller.emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),

              CustomTextField(
                controller: controller.passwordController,
                hintText: "Password",
                isPassword: true,
              ),
              CustomTextField(
                controller: controller.confirmPasswordController,
                hintText: "Confirm Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != controller.passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              SizedBox(height: 44.h),

              Obx(() {
                return CustomButton(
                  isLoading: controller.registerState.isLoading,
                  label: "Sign Up",
                  onPressed: controller.register,
                );
              }),

              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: 'Already have an account? ',
                    fontSize: 14.sp,
                    color: AppColors.grey600,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.back(canPop: true);
                    },
                    child: CustomText(
                      text: "Sign In",
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
      ),
    );
  }
}
