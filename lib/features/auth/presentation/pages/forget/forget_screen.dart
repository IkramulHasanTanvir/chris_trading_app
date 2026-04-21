import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter_task/features/auth/presentation/widgets/app_logo.dart';
import 'package:get/get.dart';

class ForgetScreen extends StatelessWidget {
  const ForgetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController controller = Get.find<AuthController>();

    return CustomScaffold(
      paddingSide: 24.w,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: controller.forgotFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 24.h),

              AppLogo(
                title: 'Forgot Password',
                subtitle: 'Enter your email to receive a verification code',
              ),
              SizedBox(height: 40.h),
              CustomTextField(
                controller: controller.emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),
              SizedBox(height: 54.h),

              GetBuilder<AuthController>(
                builder: (controller) {
                  return CustomButton(
                    label: "Send OTP",
                    isLoading: controller.forgotState.isLoading,
                    onPressed: controller.forgot,
                  );
                },
              ),

              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }
}
