import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/widgets/app_simmer.dart';

class HomeShimmerWidgets {
  static Widget buildLoadingShimmer() {
    return AppShimmer.wrap(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 16.h),

          // ─── Champions Top Three Card ──────────────────────────────
          AppShimmer.card(
            radius: 20,
            padding: EdgeInsets.all(20.r),
            child: Column(
              children: [
                // Title row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppShimmer.line(width: 120.w, height: 14),
                    AppShimmer.line(width: 60.w, height: 12),
                  ],
                ),
                SizedBox(height: 20.h),

                // Top 3 avatars
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // 2nd place
                    _buildPodiumItem(size: 60.w, barHeight: 60.h),
                    // 1st place (taller)
                    _buildPodiumItem(size: 72.w, barHeight: 80.h),
                    // 3rd place
                    _buildPodiumItem(size: 60.w, barHeight: 48.h),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24.h),

          // ─── Top Contributors Section Title ────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.line(width: 130.w, height: 16),
                AppShimmer.line(width: 50.w, height: 12),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // ─── Contributors Horizontal List ──────────────────────────
          SizedBox(
            height: 160.h,
            child: ListView.separated(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (_, __) => _buildContributorCard(),
            ),
          ),

          SizedBox(height: 24.h),

          // ─── Top Traders Section Title ─────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppShimmer.line(width: 100.w, height: 16),
                AppShimmer.line(width: 50.w, height: 12),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // ─── Traders Vertical List ─────────────────────────────────
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: 5,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (_, __) => _buildTraderCard(),
          ),

          SizedBox(height: 100.h),
        ],
      ),
    );
  }

  // ─── Podium Item (avatar + name + bar) ──────────────────────────────
  static Widget _buildPodiumItem({
    required double size,
    required double barHeight,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AppShimmer.image(width: size, height: size, radius: size / 2),
        SizedBox(height: 8.h),
        AppShimmer.line(width: size - 8.w, height: 12),
        SizedBox(height: 6.h),
        AppShimmer.box(width: size, height: barHeight, radius: 8),
      ],
    );
  }

  // ─── Contributor Card ────────────────────────────────────────────────
  static Widget _buildContributorCard() {
    return AppShimmer.card(
      radius: 16,
      padding: EdgeInsets.all(12.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppShimmer.image(width: 56.w, height: 56.w, radius: 28.r),
          SizedBox(height: 10.h),
          AppShimmer.line(width: 80.w, height: 13),
          SizedBox(height: 6.h),
          AppShimmer.line(width: 56.w, height: 11),
        ],
      ),
    );
  }

  // ─── Trader Card ─────────────────────────────────────────────────────
  static Widget _buildTraderCard() {
    return AppShimmer.card(
      radius: 14,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          // Rank number
          AppShimmer.line(width: 20.w, height: 14),
          SizedBox(width: 12.w),
          // Avatar
          AppShimmer.image(width: 44.w, height: 44.w, radius: 22.r),
          SizedBox(width: 12.w),
          // Name & subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppShimmer.line(width: 120.w, height: 14),
                SizedBox(height: 6.h),
                AppShimmer.line(width: 80.w, height: 11),
              ],
            ),
          ),
          // Trailing value
          AppShimmer.line(width: 60.w, height: 14),
        ],
      ),
    );
  }
}