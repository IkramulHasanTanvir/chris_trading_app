import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/auth/presentation/widgets/app_logo.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final TextEditingController _fastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 24.w,
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
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
                controller: _fastNameController,
                hintText: "Name",
              ),
              CustomTextField(
                controller: _emailController,
                hintText: "Email",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),

              CustomTextField(
                controller: _passwordController,
                hintText: "Password",
                isPassword: true,
              ),
              CustomTextField(
                controller: _confirmPassController,
                hintText: "Confirm Password",
                isPassword: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirm password is required';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              SizedBox(height: 44.h),

              CustomButton(label: "Sign Up", onPressed: _onSignUp),

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
                      Get.back();
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

  void _onSignUp() {
    if (_globalKey.currentState!.validate()) return;
    Get.toNamed(AppRoutes.otpScreen, arguments: 'signup');
  }
}
