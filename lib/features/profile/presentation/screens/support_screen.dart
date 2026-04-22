import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:url_launcher/url_launcher.dart';


class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBar: const CustomAppBar(title: 'support'),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            height: 345.h,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(Assets.images.supportBg.path),
              ),
            ),
          ),
          //  Spacer(),
          CustomContainer(
            paddingAll: 24.r,
            radiusAll: 32.r,
            bordersColor: AppColors.primary,
            //linearColors: AppColors.dialogLinearColors,
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            child: Column(
              children: [
                CustomText(
                  text: 'Support',
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.sp,
                  bottom: 6.h,
                ),
                CustomText(
                  text:
                      "If you have any questions, need assistance,"
                      " or want to discuss your progress, feel free to "
                      "reach out to your coach. We're here to help you "
                      "achieve your fitness goals!",
                  fontSize: 12.sp,
                  color: AppColors.primary,
                ),
              ],
            ),
          ),

          CustomContainer(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 4),
              )
            ],
            paddingHorizontal: 18.w,
            bottomLeft: 16.r,
            bottomRight: 16.r,
            color: AppColors.primary,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () async {
                    final Uri url = Uri.parse('tel:(609)327-7992');
                    if (await launchUrl(url)) {
                      await launchUrl(url);
                    } else {
                      debugPrint('Could not launch phone dialer');
                    }
                  },
                  label: CustomText(text: '(609)327-7992',color: Colors.white,fontWeight: FontWeight.w600),
                  icon: Icon(Icons.phone_outlined,color: Colors.white,size: 16.r),
                ),
                TextButton.icon(
                  onPressed: () async {
                    final Uri emailUrl = Uri(
                      scheme: 'mailto',
                      path: 'bta2bigma@gmail.com',
                      query:
                          'subject=Support Inquiry&body=Hello, I need assistance with...',
                    );
                    if (await launchUrl(emailUrl)) {
                      await launchUrl(emailUrl);
                    } else {
                      debugPrint('Could not launch email client');
                    }
                  },
                  label: CustomText(text: 'bta2bigma@gmail.com',color: Colors.white,fontWeight: FontWeight.w600,),
                  icon: Icon(Icons.email_outlined,color: Colors.white,size: 16.r),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
        ],
      ),
    );
  }
}
