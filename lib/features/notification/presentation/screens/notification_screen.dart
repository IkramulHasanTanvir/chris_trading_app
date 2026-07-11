import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/time_format.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/presentation/widgets/shimmer_widgets.dart';
import 'package:flutter_task/features/notification/presentation/controllers/notification_controller.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = NotificationController.to;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.refresh();
        },
        edgeOffset: 100.h,
        color: AppColors.primary,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          controller: controller.scrollController,
          slivers: [
            // ─── Sliver AppBar ───────────────────────────────────────
            SliverAppBar(
              expandedHeight: 70.h,
              pinned: true,
              floating: false,
              scrolledUnderElevation: 0,
              backgroundColor: AppColors.background,
              elevation: 0,
              leading: IconButton(
                onPressed: () => Get.back(canPop: true),
                icon: const Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: AppColors.white,
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 2.0,
                title: CustomText(
                  text: 'Notification',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
                centerTitle: true,
              ),
            ),

            // ─── Notification List ───────────────────────────────────
            Obx(() {
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
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                            (context, index) {
                          final data = controller.notification[index];
                          return CustomContainer(
                            paddingHorizontal: 16.w,
                            paddingVertical: 10.h,
                            marginBottom: 10.h,
                            color: AppColors.navBackground,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.notifications_active_outlined,
                                  color: data.isRead == true
                                      ? AppColors.textSecondary
                                      : AppColors.primary,
                                ),
                                SizedBox(width: 12.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: CustomText(
                                              bottom: 6.h,
                                              textAlign: TextAlign.start,
                                              maxline: 1,
                                              textOverflow:
                                              TextOverflow.ellipsis,
                                              text: data.title ?? '',
                                              fontWeight: FontWeight.w700,
                                              color: data.isRead == true
                                                  ? AppColors.textGray
                                                  : AppColors.white,
                                            ),
                                          ),
                                          CustomText(
                                            bottom: 6.h,
                                            left: 6.w,
                                            textAlign: TextAlign.start,
                                            fontSize: 12.sp,
                                            text: TimeFormatHelper.timeFormat(
                                              DateTime.parse(
                                                data.createdAt.toString(),
                                              ),
                                            ),
                                            color: AppColors.textSecondary,
                                          ),
                                        ],
                                      ),
                                      CustomText(
                                        textAlign: TextAlign.start,
                                        text: data.message ?? '',
                                        color: AppColors.textSecondary,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: controller.notification.length,
                      ),
                    ),
                  );
              }
            }),

            // ─── Load More Indicator ─────────────────────────────────
            PaginationLoaderSliver(controller: controller),
            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),
      ),
    );
  }
}