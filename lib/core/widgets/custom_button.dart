import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/utils/assets_path/fonts.gen.dart';
import 'package:flutter_task/core/widgets/widgets.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    this.suffixIcon,
    this.child,
    this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.height,
    this.width,
    this.fontWeight,
    this.fontSize,
    this.fontName,
    required this.onPressed,
    this.radius,
    this.prefixIcon,
    this.bordersColor,
    this.suffixIconShow = false,
    this.prefixIconShow = false,
    this.title,
    this.iconHeight,
    this.iconWidth,
    this.elevation = false,
    this.isLoading = false,
    this.loadingIndicatorColor,
  });

  final Widget? suffixIcon;
  final IconData? prefixIcon;
  final Widget? child;
  final String? label;
  final Widget? title;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? height;
  final double? width;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? radius;
  final String? fontName;
  final VoidCallback? onPressed;
  final Color? bordersColor;
  final bool suffixIconShow;
  final bool prefixIconShow;
  final double? iconHeight;
  final double? iconWidth;
  final bool elevation;
  final bool isLoading;
  final Color? loadingIndicatorColor;

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      elevation: elevation,
      onTap: isLoading ? null : onPressed,
      color: backgroundColor ?? AppColors.primary,
      height: height ?? 48.h,
      width: width ?? double.infinity,
      radiusAll: radius ?? 5.r,
      bordersColor: bordersColor,
      child: child ??
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            switchInCurve: Curves.easeIn,
            switchOutCurve: Curves.easeOut,
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(
                  scale: animation,
                  child: child,
                ),
              );
            },
            child: isLoading
                ? SizedBox(
              key: const ValueKey('loading'),
              height: 20.h,
              width: 20.h,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(
                  loadingIndicatorColor ??
                      foregroundColor ??
                      Colors.white,
                ),
              ),
            )
                : Row(
              key: const ValueKey('content'),
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Prefix Icon
                if (prefixIcon != null || prefixIconShow == true) ...[
                  Icon(
                    size: 18.r,
                    prefixIcon ?? Icons.arrow_back,
                    color: foregroundColor ?? AppColors.white,
                  ),
                  SizedBox(width: 8.w),
                ],

                if (title != null) title!,

                /// Label Text
                if (label != null)
                  Flexible(
                    child: CustomText(
                      text: label ?? '',
                      color: foregroundColor ?? Colors.white,
                      fontName: fontName ?? FontFamily.poppins,
                      fontWeight: fontWeight ?? FontWeight.w600,
                      fontSize: fontSize ?? 15.sp,
                    ),
                  ),

                /// Suffix Icon
                if (suffixIcon != null || suffixIconShow == true) ...[
                  SizedBox(width: 8.w),
                  suffixIcon != null
                      ? suffixIcon!
                      : Icon(Icons.arrow_forward_ios),
                ],
              ],
            ),
          ),
    );
  }
}