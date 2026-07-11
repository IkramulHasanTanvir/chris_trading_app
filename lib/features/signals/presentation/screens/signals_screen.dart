import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_shimmer_widgets.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:flutter_task/features/signals/presentation/widgets/signal_card.dart';
import 'package:get/get.dart';

class SignalsScreen extends StatelessWidget {
  const SignalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = SignalsController.to;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.refresh();
          },
          edgeOffset: 60.h,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            controller: controller.scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 70.h,
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
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      CustomTextField(
                        controller: controller.searchController,
                        hintText: 'Search by symbol...',
                        validator: (_) => null,
                        prefixIcon: Icon(
                          Icons.search,
                          color: AppColors.textSecondary,
                          size: 20.r,
                        ),
                        textInputAction: TextInputAction.search,
                        onFieldSubmitted: (_) => controller.applyFilters(),
                        suffixIcon: IconButton(
                          onPressed: controller.applyFilters,
                          icon: Icon(
                            Icons.arrow_forward_rounded,
                            color: AppColors.primary,
                            size: 20.r,
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Obx(() {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _AssetChip(
                                label: 'All',
                                selected: controller.selectedAssetType.isEmpty,
                                onTap: () => controller.onAssetTypeChanged(''),
                              ),
                              ...controller.assetTypeOptions.map(
                                (type) => _AssetChip(
                                  label: type.toUpperCase(),
                                  selected:
                                      controller.selectedAssetType == type,
                                  onTap: () =>
                                      controller.onAssetTypeChanged(type),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                      SizedBox(height: 8.h),
                    ],
                  ),
                ),
              ),
              Obx(() {
                final signals = controller.signals;
                switch (controller.loadingState) {
                  case LoadingState.initial:
                  case LoadingState.loading:
                    return SliverToBoxAdapter(
                      child: ReferralShimmerWidgets.buildLoadingShimmer(),
                    );
                  case LoadingState.offline:
                  case LoadingState.error:
                    return SliverToBoxAdapter(
                      child: RetryWidget(
                        message: controller.errorMessage,
                        onRetry: controller.retry,
                        isOffline: controller.loadingState.isOffline,
                      ),
                    );
                  case LoadingState.loaded:
                    if (signals.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.only(top: 48.h),
                          child: Center(
                            child: CustomText(
                              text: 'No signals found',
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(bottom: 12.h),
                              child: SignalCard(item: signals[index]),
                            );
                          },
                          childCount: signals.length,
                        ),
                      ),
                    );
                }
              }),
              PaginationLoaderSliver(controller: controller),
              SliverToBoxAdapter(child: SizedBox(height: 100.h)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssetChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _AssetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: selected ? AppColors.primary : AppColors.navBackground,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: selected
                  ? AppColors.primary
                  : AppColors.textSecondary.withValues(alpha: 0.3),
            ),
          ),
          child: CustomText(
            text: label,
            fontSize: 11.sp,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
