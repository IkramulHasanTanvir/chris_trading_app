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

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final  controller = AuthController.to;

    return CustomScaffold(
      paddingSide: 24.w,
      body: SingleChildScrollView(
        child: Form(
          key: controller.loginFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 70.h),
              Center(
                child: AppLogo(
                  icon: Assets.lotties.tradingAnimLine.lottie(
                    height: 100.h,
                    width: 200.w,
                  ),
                  title: "Login",
                  subtitle: "Enter your email and password to log in",
                ),
              ),
              SizedBox(height: 20.h),
              CustomTextField(
                controller: controller.emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),

              SizedBox(height: 10.h),
              CustomTextField(
                controller: controller.passwordController,
                hintText: "Password",
                isPassword: true,
              ),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () => Get.toNamed(AppRoutes.forgetScreen),
                child: CustomText(
                  fontSize: 12.sp,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,

                  text: "Forgot Password?",
                ),
              ),

              SizedBox(height: 24.h),




              Obx(() {
                  return CustomButton(
                    isLoading: controller.loginState.isLoading,
                      label: "Log in", onPressed: controller.login);
                }
              ),

              SizedBox(height: 18.h),





              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Expanded(child: Divider(color: AppColors.grey600)),
              //     CustomText(
              //       text: 'Or log in with',
              //       fontSize: 12.sp,
              //       fontWeight: FontWeight.w600,
              //       color: AppColors.grey600,
              //       left: 9.w,
              //       right: 9.w,
              //     ),
              //     Expanded(child: Divider(color: AppColors.grey600)),
              //   ],
              // ),
              //
              // SizedBox(height: 20.h),
              //
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Flexible(
              //       child: GestureDetector(
              //         onTap: () async {
              //           //  await AuthService().signInWithGoogle();
              //         },
              //         child: CustomContainer(
              //           paddingAll: 14.r,
              //           color: Colors.white,
              //           width: 98.w,
              //           height: 48.h,
              //           radiusAll: 10.r,
              //           child: Assets.icons.google.svg(),
              //         ),
              //       ),
              //     ),
              //     SizedBox(width: 16.w),
              //     Flexible(
              //       child: GestureDetector(
              //         onTap: () async {
              //           // await AuthService().signInWithApple();
              //         },
              //         child: CustomContainer(
              //           paddingAll: 14.r,
              //           color: Colors.white,
              //           width: 98.w,
              //           height: 48.h,
              //           radiusAll: 10.r,
              //           child: Assets.icons.apple.svg(),
              //         ),
              //       ),
              //     ),
              //   ],
              // ),
              SizedBox(height: 20.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: "Don’t have an account? ",
                    color: AppColors.grey600,
                  ),
                  GestureDetector(
                    onTap: () => Get.toNamed(AppRoutes.signUpScreen),
                    child: CustomText(
                      fontWeight: FontWeight.w600,
                      text: "Sign up",
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
