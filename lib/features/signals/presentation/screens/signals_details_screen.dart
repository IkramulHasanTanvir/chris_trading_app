import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/image_url_helper.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/presentation/widgets/shimmer_widgets.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:flutter_task/features/signals/presentation/widgets/author_data.dart';
import 'package:flutter_task/features/signals/presentation/widgets/chart_section.dart';
import 'package:flutter_task/features/signals/presentation/widgets/comment_section.dart';
import 'package:flutter_task/features/signals/presentation/widgets/price_card.dart';
import 'package:flutter_task/features/signals/presentation/widgets/signal_details_section.dart';
import 'package:flutter_task/features/signals/presentation/widgets/stats_section.dart';
import 'package:flutter_task/features/signals/presentation/widgets/take_profit_section.dart';
import 'package:get/get.dart';

class SignalsDetailsScreen extends StatefulWidget {
  const SignalsDetailsScreen({super.key});

  @override
  State<SignalsDetailsScreen> createState() => _SignalsDetailsScreenState();
}

class _SignalsDetailsScreenState extends State<SignalsDetailsScreen> {
  final _commentsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    final String signalId = Get.arguments;
    SignalsController.to.getSignalDetails(signalId);
    SignalsController.to.loadComments(signalId);
  }

  void _scrollToComments() {
    final ctx = _commentsKey.currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
    SignalsController.to.focusCommentReply();
  }

  @override
  Widget build(BuildContext context) {
    final String signalId = Get.arguments;
    final controller = SignalsController.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child:  RefreshIndicator(
          edgeOffset: 60.h,
            onRefresh: () async {
              await controller.getSignalDetails(signalId, showLoader: false);
              await controller.loadComments(signalId, refresh: true);
            },
            color: AppColors.primary,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                // ─── Sliver AppBar ──────────────────────────────
                SliverAppBar(
                  expandedHeight: 60.h,
                  floating: false,
                  pinned: false,
                  scrolledUnderElevation: 0,
                  backgroundColor: AppColors.background,
                  elevation: 0,
                  leading: GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.white,
                      size: 20.r,
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    title: CustomText(
                      text: 'Signal Details',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                    centerTitle: true,
                  ),
                ),
                  SliverToBoxAdapter(
                    child: Obx(() {
                      final signal = controller.signalDetail;
                      switch (controller.detailsState) {
                        case LoadingState.initial:
                        case LoadingState.loading:
                          return HomeShimmerWidgets.buildLoadingShimmer();
                        case LoadingState.offline:
                        case LoadingState.error:
                          return RetryWidget(
                            message: controller.errorMessage,
                            onRetry: () => controller.getSignalDetails(signalId),
                            isOffline: controller.detailsState.isOffline,
                          );
                        case LoadingState.loaded:
                      return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),

                              // ── Author + Symbol Row ──────────────
                              AuthorData(signal: signal),

                              SizedBox(height: 16.h),

                              // ── Chart / Video ─────────────────────
                              if ((signal?.videoUrl ?? '').trim().isNotEmpty)
                                ChartSection(signal: signal)
                              else if (ImageUrlHelper.isLoadableImageUrl(
                                signal?.externalChartUrl,
                              ))
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16.r),
                                  child: CustomNetworkImage(
                                    width: double.infinity,
                                    height: 220.h,
                                    fit: BoxFit.cover,
                                    imageUrl: signal?.externalChartUrl,
                                    fallbackAsset: Icon(
                                      Icons.show_chart_rounded,
                                      size: 48.r,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                )
                              else if ((signal?.externalChartUrl ?? '')
                                  .trim()
                                  .isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  height: 120.h,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: AppColors.navBackground,
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.show_chart_rounded,
                                        size: 36.r,
                                        color: AppColors.textSecondary,
                                      ),
                                      SizedBox(height: 8.h),
                                      CustomText(
                                        text: 'Chart preview unavailable',
                                        fontSize: 12.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ],
                                  ),
                                ),

                              SizedBox(height: 16.h),

                              // ── Price Info Cards ─────────────────
                              Row(
                                children: [
                                  Expanded(
                                    child: PriceCard(
                                      label: 'Entry',
                                      value: signal?.entryPrice,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                    child: PriceCard(
                                      label: 'Stop',
                                      value: signal?.stopLoss,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),

                              // ── Target Levels ───────────────
                              TakeProfitSection(signal: signal),

                              SizedBox(height: 16.h),

                              // ── Signal Details ───────────────────
                              SignalDetailsSection(signal: signal),

                              SizedBox(height: 16.h),

                              // ── Description ──────────────────────
                              if ((signal?.description ?? '').isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.navBackground,
                                    borderRadius: BorderRadius.circular(12.r),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CustomText(
                                        text: 'Description',
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textSecondary,
                                      ),
                                      SizedBox(height: 8.h),
                                      CustomText(
                                        text: signal?.description ?? '',
                                        fontSize: 13.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 16.h),

                              // ── Entry Notes ──────────────────────
                              if ((signal?.entryNotes ?? '').isNotEmpty)
                                Container(
                                  width: double.infinity,
                                  padding: EdgeInsets.all(16.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.navBackground,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border(
                                      left: BorderSide(
                                        color: AppColors.primary,
                                        width: 3.w,
                                      ),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.notes_rounded,
                                            size: 16.r,
                                            color: AppColors.primary,
                                          ),
                                          SizedBox(width: 6.w),
                                          CustomText(
                                            text: 'Entry Notes',
                                            fontSize: 13.sp,
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.primary,
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8.h),
                                      CustomText(
                                        text: signal?.entryNotes ?? '',
                                        fontSize: 13.sp,
                                        color: AppColors.textSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 16.h),

                              // ── Stats Row ────────────────────────
                              StatsSection(
                                signal: signal,
                                onReplyTap: _scrollToComments,
                              ),

                              SizedBox(height: 16.h),

                              // ── Tags ─────────────────────────────
                              if ((signal?.tags ?? []).isNotEmpty)
                                Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  children: (signal?.tags ?? [])
                                      .map(
                                        (tag) => Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 6.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withOpacity(
                                              0.12,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              20.r,
                                            ),
                                          ),
                                          child: CustomText(
                                            text: '#$tag',
                                            fontSize: 12.sp,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              SizedBox(height: 24.h),
                              // ── Comments ─────────────────────────────
                              KeyedSubtree(
                                key: _commentsKey,
                                child: CommentsSection(signalId: signalId),
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ),
                        ); }
                      })
                  ),
              ],
            ),
          )
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Obx(() {
            final signalId = controller.signalDetail?.sId ?? '';
            final isCopied = controller.signalDetail?.isCopied == true ||
                controller.isSignalTracked(signalId);
            return Row(
              children: [
                Expanded(
                  child: Opacity(
                    opacity: isCopied ? 0.45 : 1,
                    child: IgnorePointer(
                      ignoring: isCopied,
                      child: CustomButton(
                        fontSize: 14.sp,
                        height: 36.h,
                        backgroundColor: isCopied
                            ? AppColors.textSecondary
                            : AppColors.primaryBTN,
                        onPressed: isCopied
                            ? null
                            : () {
                                _showCopyDialog(context, controller);
                              },
                        label: isCopied ? 'Tracked' : 'Tracking',
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: CustomButton(
                    fontSize: 14.sp,
                    height: 36.h,
                    onPressed: () {
                      Get.toNamed(
                        AppRoutes.logUpdateScreen,
                        arguments: controller.signalDetail?.sId,
                      );
                    },
                    label: 'Log Trade',
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void _showCopyDialog(BuildContext context, SignalsController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.navBackground,
          title: CustomText(
            text: 'Track Trading Signal',
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          content: CustomText(
            text: 'Are you sure you want to track this signal?',
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const CustomText(
                text: 'Cancel',
                color: AppColors.textSecondary,
              ),
            ),
            TextButton(
              onPressed: () {
                controller.copyTradingSignal(
                  signalId: controller.signalDetail?.sId ?? '',
                );
                Get.back();
              },
              child: const CustomText(
                text: 'Tracking',
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );
      },
    );
  }
}
