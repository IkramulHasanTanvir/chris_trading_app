import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:get/get.dart';
import '../widgets/app_logo.dart';

class ForgetScreen extends StatefulWidget {
  const ForgetScreen({super.key});

  @override
  State<ForgetScreen> createState() => _ForgetScreenState();
}

class _ForgetScreenState extends State<ForgetScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 24.w,
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
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
                controller: _emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                isEmail: true,
              ),
              SizedBox(height: 54.h),

              CustomButton(
                label: "Send OTP",
                onPressed: _onGetVerificationCode,
              ),

              SizedBox(height: 18.h),
            ],
          ),
        ),
      ),
    );
  }

  void _onGetVerificationCode() {
    if (_globalKey.currentState!.validate()) return;
    Get.toNamed(AppRoutes.otpScreen, arguments: 'forgot');
  }
}
