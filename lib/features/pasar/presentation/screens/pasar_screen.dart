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
                    fontSize: 28.sp,
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
                          Tab(text: "Copy Trade"),
                          Tab(text: "Log Trade"),
                        ],
                      ),
                    ),
                  ),
                ),
              ];
            },
            body: Obx(() {
              final controller = HistoryController.to;
              // ─── Tab Views ────────────────────────────────────────
              return TabBarView(
                children: [
                  /// ───── Pending Tab ─────
                  _buildTradeList(
                    trades: controller.pendingTrades,
                    scrollController: controller.pendingScrollController,
                    isLoadingMore: controller.isLoadingMorePending,
                    hasMore: controller.hasMorePending,
                    emptyText: 'No Pending Trades',
                  ),

                  /// ───── Completed Tab ─────
                  _buildTradeList(
                    trades: controller.completedTrades,
                    scrollController: controller.completedScrollController,
                    isLoadingMore: controller.isLoadingMoreCompleted,
                    hasMore: controller.hasMoreCompleted,
                    emptyText: 'No Completed Trades',
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  // ─── Trade List Builder ───────────────────────────────────────────
  Widget _buildTradeList({
    required List<Trades> trades,
    required ScrollController? scrollController,
    required bool isLoadingMore,
    required bool hasMore,
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
        await HistoryController.to.retry();
      },
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        controller: scrollController,
        padding: EdgeInsets.symmetric(horizontal: 16.w).copyWith(
          top: 24.h,
          bottom: 100.h,
        ),
        itemCount: trades.length + (isLoadingMore ? 1 : 0),
        separatorBuilder: (_, __) => SizedBox(height: 12.h),
        itemBuilder: (context, index) {
          // ─── Load More Indicator ───────────────────────────────
          if (index == trades.length) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          final item = trades[index];
          return SignalDetailsCard(item: item);
        },
      ),
    );
  }
}