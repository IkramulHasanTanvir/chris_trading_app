import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';

class HelperData {

  HelperData._();

  static final List<Map<String, dynamic>> onboardingData = [
    {
      "image": Assets.images.fastOnboarding.image(height: 200.h, width: 185.w),
      "title": "Track your\nProgress",
      "subtitle": "Log trades, view history, and climb the\nleaderboard."
    },
    {
      "image": Assets.images.secondOnboarding.image(height: 200.h, width: 185.w),
      "title": "Fast Optimization",
      "subtitle": "Log trades, view history, and climb the\nleaderboard."
    },
    {
      "image": Assets.images.lastOnboarding.image(height: 200.h, width: 185.w),
      "title": "Unlock Affiliate\nRewards",
      "subtitle": "Earn commissions and access marketing tools."
    },
  ];

}
