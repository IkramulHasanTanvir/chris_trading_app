import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerHelper {
  ShimmerHelper._();

  static ShimmerHelper get instance => ShimmerHelper._();

  ///─── Public: Full Feed Shimmer ─────────────────────────────────────────────
  Widget showFeedShimmer() {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStoryShimmer(),
          _buildSectionShimmer(),   // Trending
          _buildSectionShimmer(),   // Discount
          SizedBox(height: 16.h),
        ],
      ),
    );
  }

  Widget showProductShimmer() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 10.w,
        childAspectRatio: 164.w / 207.h,
      ),
      itemBuilder: (context, index) {
        return _buildProductCardShimmer();
      },
    );
  }

  Widget showShopDetailsShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header: Avatar + Info + Heart icon ──
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar circle
                Container(
                  width: 72.r,
                  height: 72.r,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
                SizedBox(width: 8.w),

                // Info column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Shop name
                      _shimmerBox(width: 140.w, height: 20.h, borderRadius: 4),
                      SizedBox(height: 8.h),

                      // Location row
                      Row(
                        children: [
                          _shimmerBox(width: 12.r, height: 12.r, borderRadius: 6),
                          SizedBox(width: 4.w),
                          _shimmerBox(width: 110.w, height: 10.h, borderRadius: 4),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Time row
                      Row(
                        children: [
                          _shimmerBox(width: 12.r, height: 12.r, borderRadius: 6),
                          SizedBox(width: 4.w),
                          _shimmerBox(width: 130.w, height: 10.h, borderRadius: 4),
                        ],
                      ),
                      SizedBox(height: 10.h),

                      // Social buttons row
                      Row(
                        children: List.generate(3, (i) => Padding(
                          padding: EdgeInsets.only(right: 8.w),
                          child: _shimmerBox(width: 32.r, height: 32.r, borderRadius: 8),
                        )),
                      ),
                    ],
                  ),
                ),

                // Heart icon placeholder
                _shimmerBox(width: 24.r, height: 24.r, borderRadius: 12),
              ],
            ),
          ),

          // ── TabBar placeholder ──
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              children: [
                _shimmerBox(width: 80.w, height: 14.h, borderRadius: 4),
                SizedBox(width: 32.w),
                _shimmerBox(width: 80.w, height: 14.h, borderRadius: 4),
              ],
            ),
          ),

          Divider(height: 1, color: Colors.grey.shade200),
          SizedBox(height: 12.h),

          // ── Products Grid placeholder ──
          Expanded(
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              itemCount: 6,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.h,
                crossAxisSpacing: 10.w,
                childAspectRatio: 164.w / 207.h,
              ),
              itemBuilder: (_, __) => _buildProductCardShimmer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget showShopShimmer() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 154.w / 208.h,
      ),
      itemBuilder: (context, index) {
        return _buildShopCardShimmer();
      },
    );
  }

  Widget _buildShopCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.10),
              offset: const Offset(0, 2),
              blurRadius: 6,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image placeholder
            Container(
              height: 144.h,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 6.h),

                  // Title placeholder
                  Container(
                    width: 100.w,
                    height: 14.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // "Shop" label placeholder
                  Container(
                    width: 40.w,
                    height: 11.h,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  SizedBox(height: 6.h),

                  // Location row placeholder
                  Row(
                    children: [
                      // Location icon placeholder
                      Container(
                        width: 12.r,
                        height: 12.r,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      // Location text placeholder
                      Container(
                        width: 80.w,
                        height: 10.h,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showReelsShimmer() {
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16.r),
      itemCount: 6,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16.h,
        crossAxisSpacing: 16.w,
        childAspectRatio: 158.w / 218.h,
      ),
      itemBuilder: (context, index) {
        return _buildReelsCardShimmer();
      },
    );
  }

  Widget _buildReelsCardShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(14.r),
          gradient: LinearGradient(
            colors: [Colors.grey.shade300, Colors.grey.shade200],
          ),
        ),
        child: Stack(
          children: [
            // Thumbnail placeholder (full card)
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),

            // Top-right: views badge placeholder
            Positioned(
              right: 0,
              top: 8.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Container(
                  width: 45.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),

            // Bottom-left: avatar + name placeholder
            Positioned(
              left: 0,
              bottom: 8.h,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar circle
                    Container(
                      width: 28.r,
                      height: 28.r,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    // Name bar
                    Container(
                      width: 80.w,
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: Colors.grey[400],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── Core shimmer animation wrapper ───────────────────────────────────────
  Widget _shimmerBox({
    required double width,
    required double height,
    double borderRadius = 8,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(borderRadius.r),
        ),
      ),
    );
  }

  // ─── Story Section Shimmer ─────────────────────────────────────────────────
  Widget _buildStoryShimmer() {
    return Padding(
      padding: EdgeInsets.only(left: 16.h),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.only(right: 14.w),
              child: Column(
                children: [
                  _shimmerBox(
                    width: 62.w,
                    height: 62.h,
                    borderRadius: 16.r,
                  ),
                  SizedBox(height: 6.h),
                  _shimmerBox(width: 50.w, height: 10.h, borderRadius: 4),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  // ─── Horizontal Product Section Shimmer ───────────────────────────────────
  Widget _buildSectionShimmer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 16.h),

        // Title row
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _shimmerBox(width: 130.w, height: 16.h, borderRadius: 4),
              _shimmerBox(width: 60.w, height: 14.h, borderRadius: 4),
            ],
          ),
        ),

        SizedBox(height: 10.h),

        // Horizontal product cards
        SizedBox(
          height: 210.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(4, (index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: index == 0 ? 16.w : 10.w,
                    right: index == 3 ? 16.w : 0,
                  ),
                  child: _buildProductCardShimmer(),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  // ─── Single Product Card Shimmer ───────────────────────────────────────────
  Widget _buildProductCardShimmer() {
    return Container(
      width: 150.w,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product image
          Padding(
              padding: EdgeInsets.all(6.r),
              child: _shimmerBox(width: double.infinity, height: 109.h, borderRadius: 12)),
          Padding(
            padding: EdgeInsets.all(8.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _shimmerBox(width: 110.w, height: 12.h, borderRadius: 4),
                SizedBox(height: 6.h),
                _shimmerBox(width: 80.w, height: 10.h, borderRadius: 4),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _shimmerBox(width: 20.w, height: 20.h, borderRadius: 10),
                    SizedBox(width: 6.w),
                    _shimmerBox(width: 70.w, height: 10.h, borderRadius: 4),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}