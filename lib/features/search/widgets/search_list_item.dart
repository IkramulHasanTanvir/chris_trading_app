import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/search/model/search_model.dart';
import 'package:flutter_task/features/search/widgets/search_item.dart';

class SearchListItem extends StatelessWidget {
  const SearchListItem({
    super.key,
    required this.query,
    required this.onSearch,
    this.onResultTap,
  });

  final String query;
  final Future<List<SearchModel>> Function(String query) onSearch;
  final void Function(SearchModel selectedItem)? onResultTap;

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return FutureBuilder<List<SearchModel>>(
      future: onSearch(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CustomText(
              text: 'Searching...',
              color: AppColors.textSecondary,
            ),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 56.r,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 12.h),
                CustomText(
                  text: snapshot.error.toString(),
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          );
        }

        final results = snapshot.data ?? [];
        if (results.isEmpty) return _buildNoResult();
        return SearchItem(
          results: results,
          onTap: onResultTap,
        );
      },
    );
  }

  Widget _buildNoResult() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 56.r, color: AppColors.textSecondary),
          SizedBox(height: 12.h),
          CustomText(
            text: 'No result for "$query"',
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }
}
