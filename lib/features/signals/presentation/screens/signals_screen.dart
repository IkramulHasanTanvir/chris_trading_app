import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_shimmer_widgets.dart';
import 'package:flutter_task/features/search/model/search_model.dart';
import 'package:flutter_task/features/search/search_screen.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:flutter_task/features/signals/presentation/widgets/signal_card.dart';
import 'package:get/get.dart';

class SignalsScreen extends StatelessWidget {
  const SignalsScreen({super.key});

  void _openSearch(BuildContext context, SignalsController controller) {
    showSearch(
      context: context,
      delegate: SearchScreen(
        hintText: 'Search by symbol...',
        onSearch: (query) async {
          await controller.search.search(query);
          return controller.search.results
              .map(
                (signal) => SearchModel(
                  model: signal,
                  title: signal.symbol?.isNotEmpty == true
                      ? signal.symbol
                      : signal.title,
                  subtitle: [
                    if (signal.signalType != null &&
                        signal.signalType!.isNotEmpty)
                      signal.signalType!.toUpperCase(),
                    if (signal.assetType != null &&
                        signal.assetType!.isNotEmpty)
                      signal.assetType,
                    if (signal.authorId?.name != null &&
                        signal.authorId!.name!.isNotEmpty)
                      signal.authorId!.name,
                  ].join(' · '),
                  image: signal.authorId?.userProfileUrl,
                ),
              )
              .toList();
        },
        onResultTap: (result) {
          controller.search.clear();
          final signal = result.model as SignalsModel?;
          final signalId = signal?.sId;
          Get.back();
          if (signalId == null || signalId.isEmpty) return;
          Get.toNamed(
            AppRoutes.signalsDetailsScreen,
            arguments: signalId,
          );
        },
      ),
    );
  }

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
          edgeOffset: 156.h,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            controller: controller.scrollController,
            slivers: [
              SliverAppBar(
                pinned: true,
                floating: false,
                elevation: 0,
                scrolledUnderElevation: 0,
                backgroundColor: AppColors.background,
                expandedHeight: 150.h,
                title: CustomText(
                  text: 'Signals',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                ),
                centerTitle: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 52.h),
                      child: CustomSearchField(
                        readOnly: true,
                        onTap: () => _openSearch(context, controller),
                        searchController: controller.searchController,
                        hintText: 'Search by symbol...',
                      ),
                    ),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(44.h),
                  child: ColoredBox(
                    color: AppColors.background,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                      child: Obx(() {
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
                    ),
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
