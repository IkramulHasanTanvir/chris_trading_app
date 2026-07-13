import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/search/controller/search_history_controller.dart';
import 'package:get/get.dart';

class SearchItemEmpty extends StatelessWidget {
  const SearchItemEmpty({super.key, required this.onItemTap});

  final void Function(String query) onItemTap;

  SearchHistoryController get _ctrl => SearchHistoryController.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final history = _ctrl.history;
      if (history.isEmpty) return _buildEmpty();

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          Expanded(child: _buildList(history)),
        ],
      );
    });
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 48.r, color: AppColors.textSecondary),
          SizedBox(height: 10.h),
          CustomText(
            text: 'No recent searches',
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CustomText(
            text: 'Recent Searches',
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
          TextButton(
            onPressed: _ctrl.clearAll,
            child: CustomText(
              text: 'Clear All',
              fontSize: 12.sp,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(List<String> history) {
    return ListView.separated(
      itemCount: history.length,
      separatorBuilder: (_, __) => Divider(
        height: 1,
        indent: 16.w,
        endIndent: 16.w,
        thickness: 0.1,
        color: AppColors.fillColor,
      ),
      itemBuilder: (context, index) {
        final item = history[index];
        return ListTile(
          minTileHeight: 30.h,
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16.w),
          leading: Icon(
            Icons.history,
            size: 20.r,
            color: AppColors.textSecondary,
          ),
          title: Text(
            item,
            style: TextStyle(fontSize: 14.sp, color: AppColors.white),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.close,
              size: 18.r,
              color: AppColors.textSecondary,
            ),
            onPressed: () => _ctrl.removeQuery(item),
          ),
          onTap: () => onItemTap(item),
        );
      },
    );
  }
}
