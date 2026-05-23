import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_shimmer_widgets.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:flutter_task/features/signals/presentation/widgets/signal_card.dart';
import 'package:get/get.dart';


class BadgeScreen extends StatelessWidget {
  const BadgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = ProfileController.to;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.loadData();
          },
          edgeOffset: 60.h,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // ─── Sliver AppBar ───────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 70.h,
               // pinned: true,
                floating: false,
                scrolledUnderElevation: 0,
                backgroundColor: AppColors.background,
                elevation: 0,
                leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.white,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 2.0,
                  title: CustomText(
                    text: 'Badges',
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
                     final signals = controller.badge?.badges;
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
                          itemCount: signals?.length ?? 0,
                          separatorBuilder: (_, index) {
                            return SizedBox(height: 12.w);
                          },
                          itemBuilder: (context, index) {
                            final item = signals?[index] ;
                            return CustomContainer(
                              paddingHorizontal: 16.w,
                              paddingVertical: 14.h,
                              color: AppColors.backgroundDark,
                              radiusAll: 14.r,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomNetworkImage(
                                    boxShape: BoxShape.circle,
                                    height: 32.r,
                                    width: 32.r,
                                    imageUrl: item?.iconUrl ?? '',
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        CustomText(
                                          textAlign: TextAlign.start,
                                          text: item?.name ?? '',
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.w700,
                                          color: AppColors.white,
                                        ),
                                        CustomText(
                                          textAlign: TextAlign.start,
                                          text: item?.description ?? '',
                                          fontSize: 12.sp,
                                          color: AppColors.textSecondary,
                                          top: 4.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  if(item?.earned == true)
                                    CustomContainer(
                                      paddingHorizontal: 12.w,
                                      paddingVertical: 4.h,
                                      color: AppColors.navBackground,
                                      radiusAll: 100.r,
                                      child: CustomText(
                                        text: 'Achieved',
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.primary,
                                      ),
                                    )

                               ]
                              ),
                            );
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
      ),
    );
  }
}
