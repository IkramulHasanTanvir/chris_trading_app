import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_shimmer_widgets.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:flutter_task/features/signals/presentation/widgets/signal_card.dart';
import 'package:flutter_task/features/signals/presentation/widgets/up_down_card.dart';
import 'package:get/get.dart';


class SignalsScreen extends StatelessWidget {
  const SignalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignalsController.to;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.scrollController,
          slivers: [
            // ─── Sliver AppBar ───────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 70.h,
             // pinned: true,
              floating: false,
              scrolledUnderElevation: 0,
              backgroundColor: AppColors.background,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 2.0,
                title: CustomText(
                  text: 'Signals',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
                centerTitle: true,
              ),
            ),
        
            // ─── Sliver Body ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Obx(
                 () {
                   final signals = controller.signals;
                   switch (controller.loadingState) {
                     case LoadingState.initial:
                     case LoadingState.loading:
                       return ReferralShimmerWidgets.buildLoadingShimmer();

                     case LoadingState.offline:
                     case LoadingState.error:
                       return RetryWidget(
                         message: controller.errorMessage,
                         onRetry: controller.retry,
                         isOffline: controller.loadingState.isOffline,
                       );

                     case LoadingState.loaded:
                  return Column(
                    children: [
                      SizedBox(height: 10.h),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: signals.length,
                        separatorBuilder: (_, index) {
                          return SizedBox(height: 12.w);
                        },
                        itemBuilder: (context, index) {
                          final item = signals[index] ;

                          return SignalCard(item: item);
                        },
                      ),
                      SizedBox(height: 100.h),
                    ],
                  );
                }}
              ),
            ),
          ],
        ),
      ),
    );
  }
}
