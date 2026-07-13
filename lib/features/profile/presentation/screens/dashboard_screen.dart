import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/pnl_format_helper.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/profile/data/models/dashboard_model.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/profile/presentation/screens/dashboard_chart.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_shimmer_widgets.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

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
                  expandedTitleScale: 2.0,
                  centerTitle: true,
                ),
              ),

              // ─── Sliver Body ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Obx(() {
                  final dashboard = controller.dashboard;
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
                          Wrap(
                            spacing: 10.w,
                            runSpacing: 16.h,
                            children: [
                              _buildStatusCard(
                                color: AppColors.primary,
                                'Win',
                                '${dashboard?.winsLosses?.wins?.percentage ?? 0} %',
                              ),
                              _buildStatusCard(
                                'Total Trades',
                                '${dashboard?.summary?.totalTrades ?? 0}',
                              ),
                              _buildStatusCard(
                                'P/L (USD)',
                                PnlFormatHelper.format(
                                  dashboard?.summary?.profitLossUsd,
                                  unit: 'usd',
                                ),
                              ),
                              _buildStatusCard(
                                'P/L (%)',
                                PnlFormatHelper.format(
                                  dashboard?.summary?.profitLossPercent,
                                  unit: 'percent',
                                ),
                              ),
                              _buildStatusCard(
                                'Top Traded Asset',
                                dashboard?.summary?.topTradedAsset?.assetType ??
                                    'N/A',
                              ),
                            ],
                          ),

                          SizedBox(height: 24.h),

                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: WinsLossesPieChart(
                              winsPercent:
                                  (dashboard?.winsLosses?.wins?.percentage ?? 0)
                                      .toDouble(),
                              lossesPercent:
                                  (dashboard?.winsLosses?.losses?.percentage ??
                                          0)
                                      .toDouble(),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: TradesByAssetBarChart(
                              tradesByAsset: dashboard?.tradesByAsset ?? [],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          if ((dashboard?.tradeBars ?? []).isNotEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.w),
                              child: _TradeBarsSection(
                                tradeBars: dashboard!.tradeBars!,
                              ),
                            ),
                          SizedBox(height: 100.h),
                        ],
                      );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(String label, String value, {Color? color}) {
    return CustomContainer(
      width: 161.w,
      height: 114.h,
      bordersColor: color ?? AppColors.white,
      radiusAll: 14.r,
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            color: color ?? AppColors.white,
            text: label,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          SizedBox(height: 6.h),
          CustomText(
            color: color ?? AppColors.white,
            text: value.toString(),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }
}

class _TradeBarsSection extends StatelessWidget {
  final List<TradeBars> tradeBars;

  const _TradeBarsSection({required this.tradeBars});

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      radiusAll: 14.r,
      color: AppColors.navBackground,
      paddingAll: 16.r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Recent Trade Results',
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
          SizedBox(height: 12.h),
          ...tradeBars.take(8).map((bar) {
            final positive = (bar.profitLoss ?? 0) >= 0;
            return Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomText(
                          text: bar.symbol ?? '--',
                          fontWeight: FontWeight.w600,
                          fontSize: 13.sp,
                        ),
                        CustomText(
                          text: (bar.outcome ?? '').toUpperCase(),
                          fontSize: 11.sp,
                          color: AppColors.textSecondary,
                        ),
                      ],
                    ),
                  ),
                  CustomText(
                    text: PnlFormatHelper.format(
                      bar.profitLoss,
                      unit: bar.pnlUnit,
                    ),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: positive ? Colors.greenAccent : Colors.redAccent,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
