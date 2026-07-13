import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/pasar/data/models/trade_history_model.dart';
import 'package:flutter_task/features/pasar/presentation/controllers/history_controller.dart';
import 'package:flutter_task/features/pasar/presentation/widgets/signal_details_card.dart';
import 'package:get/get.dart';

class PasarScreen extends StatelessWidget {
  const PasarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 90.h,
                  pinned: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: AppColors.background,
                  title: CustomText(
                    text: 'Trade History',
                    fontSize: 24.sp,
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
                          Tab(text: 'Copy Trade'),
                          Tab(text: 'Log Trade'),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Obx(() {
              final controller = HistoryController.to;
              return TabBarView(
                children: [
                  NotificationListener<ScrollNotification>(
                    onNotification:
                        controller.pendingList.handleScrollNotification,
                    child: _buildTradeList(
                      trades: controller.pendingTrades,
                      isLoadingMore: controller.isLoadingMorePending,
                      emptyText: 'No Pending Trades',
                    ),
                  ),
                  NotificationListener<ScrollNotification>(
                    onNotification:
                        controller.completedList.handleScrollNotification,
                    child: _buildTradeList(
                      trades: controller.completedTrades,
                      isLoadingMore: controller.isLoadingMoreCompleted,
                      emptyText: 'No Completed Trades',
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildTradeList({
    required List<Trades> trades,
    required bool isLoadingMore,
    required String emptyText,
  }) {
    if (trades.isEmpty) {
      return Center(
        child: CustomText(
          text: emptyText,
          fontSize: 14.sp,
          color: AppColors.textSecondary,
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.navBackground,
      onRefresh: () async {
        await HistoryController.to.refresh();
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(top: 24.h),
        itemCount: trades.length + (isLoadingMore ? 1 : 0) + 1,
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          if (index < trades.length) {
            return SignalDetailsCard(item: trades[index]);
          }
          if (isLoadingMore && index == trades.length) {
            return const PaginationLoader(show: true);
          }
          return SizedBox(height: 100.h);
        },
      ),
    );
  }
}
