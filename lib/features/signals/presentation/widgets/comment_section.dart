import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/helpers/time_format.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/signals/data/models/comment_model.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:get/get.dart';

class CommentsSection extends StatelessWidget {
  final String signalId;

  const CommentsSection({super.key, required this.signalId});

  @override
  Widget build(BuildContext context) {
    final controller = SignalsController.to;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── Header ──────────────────────────────────────────
        CustomText(
          text: 'Comments',
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: 12.h),

        // ─── Comment Input ────────────────────────────────────
        _buildCommentInput(signalId),

        SizedBox(height: 16.h),

        // ─── Comment List ─────────────────────────────────────
        Obx(() {
          if(controller.comments.isEmpty) {
            return CustomText(
              text: 'No comments yet',
              fontSize: 13.sp,
              color: AppColors.textSecondary,
            );
          }
         return Column(
           children: [
             ...controller.comments.map(
                   (c) => _CommentTile(comment: c),
             ),
             if (controller.hasMoreComments)
               Padding(
                 padding: EdgeInsets.symmetric(vertical: 8.h),
                 child: controller.isLoadingMoreComments
                     ? const CustomLoader()
                     : TextButton(
                   onPressed: () =>
                       controller.loadMoreComments(signalId),
                   child: CustomText(
                     text: 'Load more comments',
                     color: AppColors.primary,
                     fontSize: 13.sp,
                   ),
                 ),
               ),
           ],
         );
        }
        ),
      ],
    );
  }

  Widget _buildCommentInput(String signalId) {
    final controller = SignalsController.to;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: CustomTextField(
            validator: (_) => null,
            filColor: AppColors.navBackground,
            hintText: 'Write a comment...',
              controller: controller.commentController,
            suffixIcon: CustomContainer(
              marginAll: 4.r,
              onTap: () => controller.submitComment(signalId),
              color: AppColors.primary,
              radiusAll: 10.r,
              child: Icon(
                Icons.send_rounded,
                color: AppColors.white,
                size: 18.r,
              ),
            ),
          ),
        ),

      ],
    );

  }
}

// ─── Single Comment Tile ──────────────────────────────────────────────
class _CommentTile extends StatelessWidget {
  final CommentModel comment;
  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomNetworkImage(
            imageUrl: comment.userId?.userProfileUrl ?? '',
            height: 40.h,
            width: 40.w,
            boxShape: BoxShape.circle,
          ),
          SizedBox(width: 6.w),
          // Content
          Expanded(
            child: Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: AppColors.navBackground,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomText(
                        text: comment.userId?.name ?? 'Anonymous',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                      CustomText(
                        text: comment.createdAt != null
                            ? TimeFormatHelper.timeFormat(
                                DateTime.tryParse(comment.createdAt!) ??
                                    DateTime.now(),
                              )
                            : '--',
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  CustomText(
                    text: comment.message ?? '',
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(height: 6.h),
                  GestureDetector(
                    onTap: () {
                      SignalsController.to.focusCommentReply(
                        username: comment.userId?.name,
                      );
                    },
                    child: CustomText(
                      text: 'Reply',
                      fontSize: 11.sp,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}