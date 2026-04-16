import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:get/get.dart';
import '../widgets/app_logo.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});


  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final TextEditingController _resetPasswordController = TextEditingController();
  final TextEditingController _newResetPasswordController = TextEditingController();





  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar:  CustomAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
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
                controller: _resetPasswordController,
                hintText: "New Password",
                isPassword: true,

              ),
        
        
        
              SizedBox(height: 16.h),
        
              CustomTextField(
                controller: _newResetPasswordController,
                hintText: "Confirm Password",
                isPassword: true,
        
              ),
        
        
              SizedBox(height: 36.h),

              CustomButton(
                label: "Reset",
                onPressed: _onResetPassword,
              ),
              SizedBox(height: 44.h),
        
            ],
          ),
        ),
      ),
    );
  }



  void _onResetPassword(){
    if(_globalKey.currentState!.validate()) return;
  }

}
