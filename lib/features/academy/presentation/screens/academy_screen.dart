import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/academy/data/models/academy_video_model.dart';
import 'package:flutter_task/features/academy/presentation/controllers/academy_controller.dart';
import 'package:flutter_task/features/home/presentation/widgets/shimmer_widgets.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AcademyScreen extends StatelessWidget {
  const AcademyScreen({super.key});

  Future<void> _openVideo(AcademyVideo video) async {
    final uri = Uri.tryParse(video.youtubeUrl);
    if (uri == null) return;
    final launched = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!launched) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = AcademyController.to;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () => controller.loadData(showLoader: false),
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverAppBar(
                expandedHeight: 70.h,
                pinned: true,
                floating: false,
                backgroundColor: AppColors.background,
                elevation: 0,
                scrolledUnderElevation: 0,
                automaticallyImplyLeading: false,
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: CustomText(
                    text: 'Academy',
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Obx(() {
                  switch (controller.loadingState) {
                    case LoadingState.initial:
                    case LoadingState.loading:
                      return HomeShimmerWidgets.buildLoadingShimmer();
                    case LoadingState.offline:
                    case LoadingState.error:
                      return RetryWidget(
                        message: controller.errorMessage,
                        onRetry: controller.loadData,
                        isOffline: controller.loadingState.isOffline,
                      );
                    case LoadingState.loaded:
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 16.h),
                            SizedBox(
                              height: 36.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.categories.length,
                                separatorBuilder: (_, __) =>
                                    SizedBox(width: 8.w),
                                itemBuilder: (context, index) {
                                  final category =
                                      controller.categories[index];
                                  final selected =
                                      controller.selectedCategoryId ==
                                      category.id;
                                  return GestureDetector(
                                    onTap: () =>
                                        controller.selectCategory(category.id),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 14.w,
                                        vertical: 8.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? AppColors.primary
                                            : AppColors.navBackground,
                                        borderRadius:
                                            BorderRadius.circular(20.r),
                                      ),
                                      child: CustomText(
                                        text: category.name,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600,
                                        color: selected
                                            ? AppColors.white
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: 20.h),
                            if (controller.videos.isEmpty)
                              Padding(
                                padding: EdgeInsets.only(top: 48.h),
                                child: Center(
                                  child: CustomText(
                                    text: 'No videos in this category yet',
                                    fontSize: 14.sp,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              )
                            else
                              ...controller.videos.map(
                                (video) => Padding(
                                  padding: EdgeInsets.only(bottom: 14.h),
                                  child: _AcademyVideoCard(
                                    video: video,
                                    onTap: () => _openVideo(video),
                                  ),
                                ),
                              ),
                            SizedBox(height: 100.h),
                          ],
                        ),
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
}

class _AcademyVideoCard extends StatelessWidget {
  final AcademyVideo video;
  final VoidCallback onTap;

  const _AcademyVideoCard({
    required this.video,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.navBackground,
          borderRadius: BorderRadius.circular(14.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (video.resolvedThumbnail.isNotEmpty)
                    CustomNetworkImage(
                      imageUrl: video.resolvedThumbnail,
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: AppColors.background,
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.play_circle_outline,
                        size: 48.r,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  Container(
                    color: Colors.black.withValues(alpha: 0.25),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.play_circle_filled_rounded,
                      size: 52.r,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: video.title,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                    maxline: 2,
                    textOverflow: TextOverflow.ellipsis,
                  ),
                  if (video.description.isNotEmpty) ...[
                    SizedBox(height: 6.h),
                    CustomText(
                      text: video.description,
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                      maxline: 2,
                      textOverflow: TextOverflow.ellipsis,
                    ),
                  ],
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.ondemand_video_rounded,
                        size: 14.r,
                        color: AppColors.primary,
                      ),
                      SizedBox(width: 4.w),
                      CustomText(
                        text: 'Watch on YouTube',
                        fontSize: 11.sp,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
