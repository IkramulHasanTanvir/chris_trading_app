import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/data/models/leader_board_model.dart';
import 'package:flutter_task/features/home/data/models/trader_model.dart';
import 'package:flutter_task/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter_task/features/home/presentation/widgets/champions_top_three_card.dart';
import 'package:flutter_task/features/home/presentation/widgets/leader_board_card.dart';
import 'package:flutter_task/features/home/presentation/widgets/trader_card.dart';
import 'package:get/get.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final  controller = HomeController.to;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.leaderboardScrollController,
          slivers: [
            // ─── Sliver AppBar ───────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 280.h,
              pinned: true,
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
                centerTitle: true,
                collapseMode: CollapseMode.pin,
                title: CustomText(
                  text: 'Leaderboard',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),

                background: Padding(
                  padding: EdgeInsets.only(top: kToolbarHeight),
                  child: Obx(
                     () {
                      return ChampionsTopThreeCard(
                        items: controller.leaderBoard?.topThree ?? [],
                      );
                    }
                  ),
                ),
              ),
            ),

            // ─── Sliver Body ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 10.h),

                  SizedBox(height: 24.h),
                  Obx(
                     () {
                       final data = controller.leaderBoard?.leaderBoardItems ?? [];

                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        itemCount: data.length,
                        separatorBuilder: (_, index) {
                          return SizedBox(height: 12.w);
                        },
                        itemBuilder: (context, index) {
                          final item = data[index];

                          return LeaderBoardCard(item: item);
                        },
                      );
                    }
                  ),
                  Obx(() => controller.isLoadingMoreLeaderboard
                      ? Padding(
                    padding: EdgeInsets.all(16.w),
                    child: const Center(child: CustomLoader()),
                  )
                      : const SizedBox.shrink()),
                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
