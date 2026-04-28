import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter_task/features/home/presentation/widgets/champions_top_three_card.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/presentation/widgets/contributor_card.dart';
import 'package:flutter_task/features/home/presentation/widgets/section_title_widget.dart';
import 'package:flutter_task/features/home/presentation/widgets/shimmer_widgets.dart';
import 'package:flutter_task/features/home/presentation/widgets/trader_card.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.to;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ─── Sliver AppBar ───────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 74.h,
              pinned: false,
              floating: false,
              backgroundColor: AppColors.background,
              elevation: 0,
              actions: [
                IconButton(
                  onPressed: () {
                    Get.toNamed(AppRoutes.settingScreen);
                  },
                  icon: const Icon(
                    Icons.notifications_none,
                    color: AppColors.white,
                  ),
                ),
              ],
              leadingWidth: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 16.w, bottom: 12.h),
                //expandedTitleScale: 2.0,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomNetworkImage(
                      width: 32.w,
                      height: 32.h,
                      boxShape: BoxShape.circle,
                      fit: BoxFit.cover,
                      imageUrl: '',
                    ),
                    Obx(
                       () {

                        return CustomText(
                          left: 6.w,
                          text: 'Hello, ${ProfileController.to.userData?.name ?? ''}',
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        );
                      }
                    ),
                  ],
                ),
              ),
            ),
        
            // ─── Sliver Body ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Obx(() {
                final leaderBoardData = controller.leaderBoard?.topThree ?? [];
                final contributors = controller.contributors;
                final traders = controller.topTraders;
                switch (controller.loadingState) {
                  case LoadingState.initial:
                  case LoadingState.loading:
                    return HomeShimmerWidgets.buildLoadingShimmer();
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
                      SizedBox(height: 16.h),
                      if(leaderBoardData.isNotEmpty)...[
                        ChampionsTopThreeCard(
                          onTap: (){
                            Get.toNamed(AppRoutes.leaderboardScreen);
                          },
                          items: leaderBoardData,
                        ),

                        SizedBox(height: 24.h),
                      ],


                      if(contributors.isNotEmpty)...[
                        SectionTitleWidget(title: 'Top Contributors', onTap: () {
                          Get.toNamed(AppRoutes.contributorScreen,);
                        }),
                        SizedBox(height: 12.h),
                        SizedBox(
                          height: 160.h,
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            scrollDirection: Axis.horizontal,
                            itemCount: contributors.length,
                            separatorBuilder: (_, index) {
                              return SizedBox(width: 12.w);
                            },
                            itemBuilder: (context, index) {
                              final item = contributors[index];

                              return ContributorCard(item: item,isHorizontal: true);
                            },
                          ),
                        ),

                        SizedBox(height: 24.h),
                      ],

                      if(traders.isNotEmpty)...[
                        SectionTitleWidget(title: 'Top traders', onTap: () {
                          Get.toNamed(AppRoutes.topTraderScreen);
                        }),
                        SizedBox(height: 12.h),

                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          itemCount: traders.length,
                          separatorBuilder: (_, index) {
                            return SizedBox(height: 12.w);
                          },
                          itemBuilder: (context, index) {
                            final item = traders[index];

                            return TraderCard(trader: item,);
                          },
                        ),
                      ],


                      SizedBox(height: 100.h),
                    ],
                  );
                }}
                )
            ),
          ],
        ),
      ),
    );
  }
}
