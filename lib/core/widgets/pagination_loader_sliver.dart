import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/services/paginated_list.dart';
import 'package:flutter_task/core/services/paginated_loader_ui.dart';
import 'package:flutter_task/core/widgets/custom_loader.dart';
import 'package:get/get.dart';

class PaginationLoaderSliver extends StatelessWidget {
  const PaginationLoaderSliver({super.key, required this.controller})
      : list = null,
        contentState = null;

  const PaginationLoaderSliver.list({
    super.key,
    required this.list,
    this.contentState,
  }) : controller = null;

  final PaginatedLoaderUi? controller;
  final PaginatedList<dynamic>? list;
  final LoadingState? contentState;

  bool get _show {
    if (controller != null) return controller!.showPaginationLoader;
    final paginated = list;
    if (paginated == null) return false;
    if (contentState != null && contentState != LoadingState.loaded) {
      return false;
    }
    return paginated.showLoadMoreLoader;
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Touch Rx so Obx tracks load-more / refresh flags.
      if (controller != null) {
        controller!.paginatedList.isLoadingMore.value;
        controller!.paginatedList.isRefreshing.value;
      } else {
        list?.isLoadingMore.value;
        list?.isRefreshing.value;
      }

      if (!_show) {
        return const SliverToBoxAdapter(child: SizedBox.shrink());
      }

      return SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          child: const Center(child: CustomLoader()),
        ),
      );
    });
  }
}

/// Non-sliver footer loader for [ListView] / column layouts.
class PaginationLoader extends StatelessWidget {
  const PaginationLoader({super.key, required this.show});

  final bool show;

  @override
  Widget build(BuildContext context) {
    if (!show) return const SizedBox.shrink();
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: const Center(child: CustomLoader()),
    );
  }
}
