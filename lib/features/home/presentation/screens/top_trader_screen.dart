import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/data/models/trader_model.dart';
import 'package:flutter_task/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter_task/features/home/presentation/widgets/trader_card.dart';
import 'package:get/get.dart';

class TopTraderScreen extends StatelessWidget {
  const TopTraderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.to;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 100.h,
                  pinned: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.white,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.onSurface,
                ),
                  ),
                  title: CustomText(
                    text: 'Top Traders',
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  centerTitle: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(30.h),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: TabBar(
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: AppColors.primary,
                        indicatorWeight: 2.5,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.white,
                        dividerColor: AppColors.textSecondary,
                        tabs: const [
                          Tab(text: 'Explore'),
                          Tab(text: 'Following'),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              children: [
                NotificationListener<ScrollNotification>(
                  onNotification:
                      controller.tradersList.handleScrollNotification,
                  child: Obx(
                    () => _buildTraderList(
                      data: controller.topTraders,
                      isLoadingMore: controller.isLoadingMoreTraders,
                    ),
                  ),
                ),
                NotificationListener<ScrollNotification>(
                  onNotification:
                      controller.followTradersList.handleScrollNotification,
                  child: Obx(
                    () => _buildTraderList(
                      data: controller.followTraders,
                      isLoadingMore: controller.isLoadingMoreFollowTraders,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTraderList({
    required List<TraderModel> data,
    required bool isLoadingMore,
  }) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(
        parent: BouncingScrollPhysics(),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      itemCount: data.length + (isLoadingMore ? 1 : 0) + 1,
      separatorBuilder: (_, __) => SizedBox(height: 12.h),
      itemBuilder: (context, index) {
        if (index < data.length) {
          return TraderCard(trader: data[index]);
        }
        if (isLoadingMore && index == data.length) {
          return const PaginationLoader(show: true);
        }
        return SizedBox(height: 100.h);
      },
    );
  }
}
