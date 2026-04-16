import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:get/get.dart';
import '../widgets/app_logo.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final String role = Get.arguments as String;

  final TextEditingController _otpController = TextEditingController();




  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //SizedBox(height: 44.h),
            AppLogo(
              title: 'Tow-Factor Authentication',
              subtitle: 'Enter the verification code sent to your email',
            ),
            SizedBox(height: 40.h),

            ///==============Pin code Field============<>>>>
            Form(
              key: _globalKey,
              child: CustomPinCodeTextField(
                textEditingController: _otpController,
              ),
            ),

            SizedBox(height: 56.h),

                  CustomButton(
                      label: "Verify",
                      onPressed: _onTapNextScreen,
                    ),
            SizedBox(height: 18.h),
          ],
        ),
      ),
    );
  }

  void _onTapNextScreen() async {
    if (!_globalKey.currentState!.validate()) return;
    if(role == 'forgot'){
      Get.toNamed(AppRoutes.resetScreen);
    }else{
      Get.toNamed(AppRoutes.bottomNavUserBar);
    }
  }


}
