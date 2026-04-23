import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/widgets/app_simmer.dart';

class ReferralShimmerWidgets {
  // ─── Referral Screen Shimmer ─────────────────────────────────────────
  static Widget buildLoadingShimmer() {
    return AppShimmer.wrap(
      child: Column(
        children: [
          SizedBox(height: 16.h),

          // QR Code Card
          AppShimmer.card(
            radius: 20,
            padding: EdgeInsets.all(24.r),
            child: Column(
              children: [
                Center(child: AppShimmer.image(width: 160.w, height: 160.w, radius: 16)),
                SizedBox(height: 16.h),
                Center(child: AppShimmer.line(width: 180.w, height: 14)),
                SizedBox(height: 8.h),
                Center(child: AppShimmer.line(width: 120.w, height: 12)),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Referral Code Card
          AppShimmer.card(
            radius: 16,
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppShimmer.line(width: 80.w, height: 12),
                    SizedBox(height: 8.h),
                    AppShimmer.line(width: 140.w, height: 20),
                  ],
                ),
                AppShimmer.box(width: 40.w, height: 40.h, radius: 10),
              ],
            ),
          ),

          SizedBox(height: 20.h),

          // Stats Row
          Row(
            children: List.generate(3, (i) {
              final isLast = i == 2;
              return Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: AppShimmer.card(
                        radius: 14,
                        padding: EdgeInsets.all(14.r),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppShimmer.box(width: 28.w, height: 28.h, radius: 8),
                            SizedBox(height: 10.h),
                            AppShimmer.line(height: 18),
                            SizedBox(height: 6.h),
                            AppShimmer.line(width: 50.w, height: 12),
                          ],
                        ),
                      ),
                    ),
                    if (!isLast) SizedBox(width: 12.w),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}