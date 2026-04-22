import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:flutter_task/core/widgets/widgets.dart';

class PrivacyPolicyAllScreen extends StatefulWidget {
  const PrivacyPolicyAllScreen({super.key});

  @override
  State<PrivacyPolicyAllScreen> createState() => _PrivacyPolicyAllScreenState();
}

class _PrivacyPolicyAllScreenState extends State<PrivacyPolicyAllScreen> {
  late final String title;
  // late final ContentType contentType;
  // final TermsAndConditionController controller =
  //     Get.find<TermsAndConditionController>();

  @override
  void initState() {
    super.initState();
    final args = Get.arguments as Map<String, dynamic>?;
    title = args?['title'] ?? 'Terms and Conditions';
    // contentType = _getContentTypeFromTitle(title);
    // controller.fetchContent(contentType);
  }

  @override
  Widget build(BuildContext context) {
    final sizeH = MediaQuery.sizeOf(context).height;
    return Scaffold(
      backgroundColor: Color(0xffF6F5F1),
      appBar: CustomAppBar(title: title),
      body: Obx(() {
        // if (controller.isLoading.value) {
        //   return const Center(child: CustomLoader());
        // }
        //
        // if (controller.content.isEmpty) {
        //   return Center(child: CustomText(text: 'Not found'));
        // }

        return ListView(
          padding: EdgeInsets.all(sizeH * .02),
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: sizeH * .01),
            HtmlWidget(
              '',
             // controller.content.value ?? '',
              textStyle: TextStyle(fontSize: 14.sp),
            ),
          ],
        );
      }),
    );
  }

  // ContentType _getContentTypeFromTitle(String title) {
  //   switch (title.toLowerCase()) {
  //     case 'privacy policy':
  //       return ContentType.privacyPolicy;
  //     case 'about us':
  //       return ContentType.aboutUs;
  //     case 'terms of service':
  //       return ContentType.termsAndCondition;
  //     default:
  //       return ContentType.termsAndCondition;
  //   }
  // }
}
