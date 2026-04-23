import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/top_up/data/models/plan_model.dart';
import 'package:flutter_task/features/top_up/presentation/widgets/plan_card_widget.dart';

class TopOpScreen extends StatelessWidget {
  const TopOpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ─── Sliver AppBar ───────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 130.h,
            pinned: true,
            floating: false,
            scrolledUnderElevation: 0,
            backgroundColor: AppColors.background,
            elevation: 0,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 2.0,
              title: CustomText(
                text: 'Subscribe To Get\nAccess',
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
              ),
              centerTitle: true,
            ),
          ),

          // ─── Sliver Body ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text:
                        'unlock buy/sell features and enjoy seamless transactions with our subscription plans.',
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 60.h),

                  Row(
                    children: [
                      for (int i = 0; i < PricingPlan.allPlans.length; i++) ...[
                        Expanded(
                          child: PlanCardWidget(
                            plan: PricingPlan.allPlans[i],
                            isSelected:
                                PricingPlan.allPlans[i].id ==
                                PricingPlan.allPlans[0].id,
                            onTap: () {},
                          ),
                        ),
                        if (i < PricingPlan.allPlans.length - 1)
                          SizedBox(width: 16.w),
                      ],
                    ],
                  ),
                  SizedBox(height: 60.h),

                  ...PricingPlan.planPolicy.map(
                    (e) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Row(
                        children: [
                          Icon(Icons.check, color: AppColors.primary),
                          Flexible(
                            child: CustomText(
                              left: 10.w,
                              textAlign: TextAlign.start,
                              text: e,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 32.h),

                  CustomButton(onPressed: () {}, label: 'Subscribe Now'),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
