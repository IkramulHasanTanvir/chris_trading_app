import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';

class AppShimmer {
  // ─── Colors ──────────────────────────────────────────────────────────
  static const Color _baseColor = Color(0xFF2A2A3A);
  static const Color _highlightColor = Color(0xFF3E3E52);

  // ─── Shimmer wrapper ─────────────────────────────────────────────────
  static Widget wrap({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: _baseColor,
      highlightColor: _highlightColor,
      child: child,
    );
  }

  // ─── Primitive building blocks ───────────────────────────────────────

  /// সাধারণ box — text, image, button placeholder এর জন্য
  static Widget box({
    double? width,
    double? height,
    double radius = 12,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  /// Circle — avatar, icon placeholder এর জন্য
  static Widget circle({double size = 40}) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
      ),
    );
  }

  /// Card wrapper — যেকোনো shimmer card এর জন্য
  static Widget card({
    required Widget child,
    EdgeInsetsGeometry? padding,
    double radius = 16,
    double? width,
    double? height,
  }) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      padding: padding ?? EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }

  /// Text line placeholder
  static Widget line({double? width, double height = 14, double radius = 6}) {
    return box(width: width, height: height.h, radius: radius);
  }

  /// একাধিক text line — paragraph placeholder এর জন্য
  static Widget lines({
    int count = 3,
    double spacing = 8,
    double? lastLineWidth,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(count, (i) {
        final isLast = i == count - 1;
        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : spacing.h),
          child: line(width: isLast ? lastLineWidth : double.infinity),
        );
      }),
    );
  }

  /// Image / Banner placeholder
  static Widget image({
    double? width,
    double? height,
    double radius = 12,
  }) {
    return box(width: width, height: height, radius: radius);
  }

  /// List tile — leading + title + subtitle
  static Widget listTile({bool hasLeading = true, bool hasTrailing = false}) {
    return Row(
      children: [
        if (hasLeading) ...[circle(size: 44.r), SizedBox(width: 12.w)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              line(width: 160.w, height: 14),
              SizedBox(height: 6.h),
              line(width: 100.w, height: 12),
            ],
          ),
        ),
        if (hasTrailing) ...[SizedBox(width: 12.w), box(width: 32.w, height: 32.h, radius: 8)],
      ],
    );
  }

  /// Button placeholder
  static Widget button({double? width, double height = 48}) {
    return box(width: width ?? double.infinity, height: height.h, radius: 12);
  }

  /// Grid — product/card grid এর জন্য
  static Widget grid({
    int crossAxisCount = 2,
    int itemCount = 4,
    double childAspectRatio = 1,
    double spacing = 12,
    double itemRadius = 12,
  }) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing.w,
        mainAxisSpacing: spacing.h,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (_, __) => box(radius: itemRadius),
    );
  }

  /// List — multiple list tiles এর জন্য
  static Widget list({
    int itemCount = 5,
    double spacing = 12,
    bool hasLeading = true,
    bool hasTrailing = false,
  }) {
    return wrap(
      child: Column(
        children: List.generate(itemCount, (i) {
          final isLast = i == itemCount - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : spacing.h),
            child: listTile(hasLeading: hasLeading, hasTrailing: hasTrailing),
          );
        }),
      ),
    );
  }
}