import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/core/helpers/image_url_helper.dart';
import 'package:shimmer/shimmer.dart';

class CustomNetworkImage extends StatelessWidget {
  final String? imageUrl;
  final File? imageFile;
  final Widget? fallbackAsset;
  final double? height;
  final double? width;
  final Border? border;
  final double? borderRadius;
  final BoxShape boxShape;
  final Color? backgroundColor;
  final Widget? child;
  final ColorFilter? colorFilter;
  final List<BoxShadow>? boxShadow;
  final bool elevation;
  final BoxFit? fit;

  const CustomNetworkImage({
    super.key,
    this.child,
    this.colorFilter,
    this.imageUrl,
    this.imageFile,
    this.fallbackAsset,
    this.backgroundColor,
    this.height,
    this.width,
    this.border,
    this.borderRadius,
    this.boxShape = BoxShape.rectangle,
    this.boxShadow,
    this.elevation = false,
    this.fit,
  });

  @override
  Widget build(BuildContext context) {
    /// ✅ 1. File Image — exist check করে তারপর load
    if (imageFile != null) {
      if (imageFile!.existsSync()) {
        return _buildContainer(FileImage(imageFile!));
      }
      return _buildFallback();
    }

    /// ✅ 2. Network Image — empty / non-image URL হলে সরাসরি fallback
    if ((imageUrl ?? '').trim().isNotEmpty) {
      final trimmedUrl = imageUrl!.trim();

      if (!ImageUrlHelper.isLoadableImageUrl(trimmedUrl)) {
        return _buildFallback();
      }

      return CachedNetworkImage(
        imageUrl: trimmedUrl,
        imageBuilder: (context, imageProvider) =>
            _buildContainer(imageProvider),
        placeholder: (context, url) => Shimmer.fromColors(
          baseColor: Colors.grey.shade200,
          highlightColor: Colors.grey.shade50,
          child: _buildContainer(null, shimmer: true),
        ),
        errorWidget: (context, url, error) => _buildFallback(),
        errorListener: (error) {
          if (kDebugMode) {
            debugPrint('CustomNetworkImage load failed: $error');
          }
        },
      );
    }

    /// ✅ 3. null বা empty string — fallback
    return _buildFallback();
  }

  /// 🔹 Reusable Container Builder
  Widget _buildContainer(ImageProvider? imageProvider,
      {bool shimmer = false}) {
    return Container(
      height: height,
      width: width,
      decoration: _buildDecoration(
        imageProvider: imageProvider,
        shimmer: shimmer,
      ),
      child: child,
    );
  }

  /// 🔹 Decoration Builder
  BoxDecoration _buildDecoration({
    ImageProvider? imageProvider,
    bool shimmer = false,
  }) {
    return BoxDecoration(
      color: shimmer
          ? Colors.grey.withValues(alpha: 0.4)
          : (backgroundColor ?? Colors.grey.shade300),
      boxShadow: boxShadow ??
          (elevation
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 20,
                    spreadRadius: 6,
                  ),
                ]
              : null),
      border: border,
      borderRadius:
          borderRadius != null ? BorderRadius.circular(borderRadius!) : null,
      shape: boxShape,
      image: imageProvider != null
          ? DecorationImage(
              image: imageProvider,
              fit: fit ?? BoxFit.cover,
              colorFilter: colorFilter,
            )
          : null,
    );
  }

  /// 🔹 Fallback UI
  Widget _buildFallback() {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      decoration: _buildDecoration(
        imageProvider: null,
        shimmer: false,
      ),
      child: fallbackAsset ??
          Icon(
            Icons.person,
            color: Colors.grey.shade500,
            size: (height != null && height! > 0)
                ? (height! * 0.45).clamp(16.0, 48.0)
                : 24,
          ),
    );
  }
}
