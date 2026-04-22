import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/widgets/widgets.dart';


class SettingChangePassword extends StatefulWidget {
  const SettingChangePassword({super.key});

  @override
  State<SettingChangePassword> createState() => _SettingChangePasswordState();
}

class _SettingChangePasswordState extends State<SettingChangePassword> {


  final TextEditingController _oldPassTEController = TextEditingController();
  final TextEditingController _passTEController = TextEditingController();
  final TextEditingController _rePassTEController = TextEditingController();
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      paddingSide: 24.w,
      appBar: CustomAppBar(
        title: 'Change Password',
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _globalKey,
          child: Column(
            //spacing: 10.h,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 24.h,
              ),
              CustomTextField(
                labelText: 'Old Password',
                controller: _oldPassTEController,
                hintText: "Old Password",
                isPassword: true,
              ),
              CustomTextField(
                labelText: 'New Password',
                controller: _passTEController,
                hintText: "New Password",
                isPassword: true,
              ),
              CustomTextField(
                labelText: 'Confirm Password',
                controller: _rePassTEController,
                hintText: "Confirm Password",
                isPassword: true,
              ),

        SizedBox(height: 60.h,),
              CustomButton(
                  label: "Update",
                  onPressed: _onChangePassword,
                  ),
              SizedBox(
                height:32.h,
              ),
            ],
          ),
        ),
      ),
    );
  }


  void _onChangePassword(){
    if(!_globalKey.currentState!.validate()) return;
   // Get.offAllNamed(AppRoutes.resetPasswordSuccess);
  }


  @override
  void dispose() {
    _oldPassTEController.dispose();
    _passTEController.dispose();
    _rePassTEController.dispose();
    super.dispose();
  }
}
