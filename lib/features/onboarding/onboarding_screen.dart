import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/helpers/helper_data.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        actions: [
          if(currentIndex > 0)
          Padding(
            padding: EdgeInsets.only(right: 16.0.w),
            child: CustomButton(
              width: 56.w,
              height: 21.h,
              onPressed: _handleNext,
              label: 'Skip',
              fontSize: 10.sp,
              fontWeight: FontWeight.w500,
              backgroundColor: Colors.transparent,
              bordersColor: AppColors.white,
            ),
          ),
        ],
      ),
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        itemCount: HelperData.onboardingData.length,
        onPageChanged: (index) => setState(() => currentIndex = index),
        itemBuilder: (context, index) {
          final data = HelperData.onboardingData[index];
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 44.h),
                CustomContainer(
                  height: 218.h,
                  width: double.infinity,
                  child: data['image'] as Widget,
                ),
                CustomText(
                  top: 60.h,
                  text: data['title'],
                  fontSize: 28.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.white,
                ),
                SizedBox(height: 44.h),
                CustomText(
                  text: data['subtitle'],
                  fontSize: 12.sp,
                  color: AppColors.white.withOpacity(0.6),
                ),
                SizedBox(height: 24.h),

                if(currentIndex <= 0)
                CustomButton(onPressed: _handleNext, label: 'Get started'),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Handle Next Button
  void _handleNext() {
    if (currentIndex < HelperData.onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Get.offAllNamed(AppRoutes.loginScreen);
    }
  }
}
