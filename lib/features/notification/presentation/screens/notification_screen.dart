import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/time_format.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/presentation/widgets/shimmer_widgets.dart';
import 'package:flutter_task/features/notification/data/models/notification_model.dart';
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
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: AppColors.onSurface,
                ),
              ),
              actions: [
                Obx(() {
                  final hasUnread = controller.notificationCount > 0 ||
                      controller.notification.any((e) => e.isRead != true);
                  if (!hasUnread) return const SizedBox.shrink();
                  return TextButton(
                    onPressed: controller.markAllAsRead,
                    child: CustomText(
                      text: 'Mark all',
                      fontSize: 12.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }),
              ],
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 1.5,
                title: CustomText(
                  text: 'Notifications',
                  fontSize: 18.sp,
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
                          return GestureDetector(
                            onTap: () => controller.onNotificationTap(data),
                            child: Container(
                              margin: EdgeInsets.only(bottom: 10.h),
                              padding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 14.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.navBackground,
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  _buildNotificationIcon(data),
                                  SizedBox(width: 14.w),
                                  Expanded(
                                    child: _buildNotificationContent(data),
                                  ),
                                  if (data.data?.signalId != null && (data.data?.signalId ?? '').isNotEmpty) ...[
                                    SizedBox(width: 8.w),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: AppColors.textSecondary,
                                      size: 14.r,
                                    ),
                                  ],
                                ],
                              ),
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

  Widget _buildNotificationIcon(NotificationModel data) {
    final title = (data.title ?? '').toLowerCase();
    final type = (data.type ?? '').toLowerCase();

    final Color iconColor;
    final Color bgColor;
    final IconData icon;

    if (type.contains('signal') ||
        title.contains('signal') ||
        title.contains('buy') ||
        title.contains('sell')) {
      icon = Icons.trending_up_rounded;
      iconColor = AppColors.primary;
      bgColor = AppColors.primary.withValues(alpha: 0.15);
    } else if (type.contains('commission') ||
        title.contains('commission') ||
        title.contains('\$') ||
        title.contains('earn')) {
      icon = Icons.attach_money_rounded;
      iconColor = AppColors.winBlue;
      bgColor = AppColors.winBlue.withValues(alpha: 0.15);
    } else if (type.contains('streak') ||
        title.contains('streak') ||
        title.contains('badge') ||
        title.contains('reward')) {
      icon = Icons.local_fire_department_rounded;
      iconColor = AppColors.rating;
      bgColor = AppColors.rating.withValues(alpha: 0.15);
    } else {
      icon = Icons.notifications_active_outlined;
      iconColor = AppColors.primary;
      bgColor = AppColors.primary.withValues(alpha: 0.15);
    }

    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: bgColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: 20.r),
    );
  }

  Widget _buildNotificationContent(NotificationModel data) {
    final isRead = data.isRead == true;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: CustomText(
                text: data.title ?? '',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
                color: isRead ? AppColors.textGray : AppColors.white,
                maxline: 1,
                textOverflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
              ),
            ),
            SizedBox(width: 8.w),
            CustomText(
              text: _safeTime(data.createdAt),
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ],
        ),
        SizedBox(height: 4.h),
        CustomText(
          text: data.message ?? '',
          fontSize: 13.sp,
          color: AppColors.textSecondary,
          maxline: 2,
          textOverflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
        ),
      ],
    );
  }

  String _safeTime(String? raw) {
    if (raw == null || raw.isEmpty) return '--';
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) return '--';
    return TimeFormatHelper.timeFormat(parsed);
  }
}
