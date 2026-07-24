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
    final controller = AuthController.to;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isSmall = screenHeight < 700;
    final topGap = isSmall ? 24.h : 70.h;
    final logoHeight = isSmall ? 72.h : 100.h;

    return CustomScaffold(
      paddingSide: 24.w,
      resizeToAvoidBottomInset: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: topGap),
                      Center(
                        child: AppLogo(
                          icon: Assets.lotties.tradingAnimLine.lottie(
                            height: logoHeight,
                            width: 200.w,
                          ),
                          title: "Login",
                          subtitle: "Enter your email and password to log in",
                        ),
                      ),
                      SizedBox(height: isSmall ? 12.h : 20.h),
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
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Get.toNamed(AppRoutes.forgetScreen),
                          child: CustomText(
                            fontSize: 12.sp,
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                            text: "Forgot Password?",
                          ),
                        ),
                      ),
                      SizedBox(height: isSmall ? 16.h : 24.h),
                      Obx(() {
                        return CustomButton(
                          isLoading: controller.loginState.isLoading,
                          label: "Log in",
                          onPressed: controller.login,
                        );
                      }),
                      const Spacer(),
                      SizedBox(height: 16.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: CustomText(
                              text: "Don’t have an account? ",
                              color: AppColors.grey600,
                            ),
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
            ),
          );
        },
      ),
    );
  }
}
