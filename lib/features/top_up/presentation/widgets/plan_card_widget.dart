import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/custom_container.dart';
import 'package:flutter_task/core/widgets/custom_text.dart';
import 'package:flutter_task/features/top_up/data/models/plan_model.dart';

class PlanCardWidget extends StatefulWidget {
  final PricingPlan plan;
  final bool isSelected;
  final VoidCallback onTap;

  const PlanCardWidget({
    super.key,
    required this.plan,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<PlanCardWidget> createState() => _PlanCardWidgetState();
}

class _PlanCardWidgetState extends State<PlanCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 1.03,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHover(bool hovering) {
    hovering ? _controller.forward() : _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final plan = widget.plan;

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: _scaleAnim,
          builder: (context, child) =>
              Transform.scale(scale: _scaleAnim.value, child: child),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeOut,
           // width: 166.w,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: widget.isSelected ? AppColors.primary : Colors.white,
                width: 2,
              ),
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Label
                    CustomText(
                      text: plan.id.toUpperCase(),
                      color: widget.isSelected
                          ? AppColors.primary
                          : Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 10.h),
                    // Price
                    CustomText(
                      text: plan.formatedPrice,
                      color: widget.isSelected
                          ? AppColors.primary
                          : Colors.white,
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    SizedBox(height: 14.h),


                    if(plan.discount != null)
                    CustomContainer(
                      marginBottom: 2.h,
                      paddingHorizontal: 16.w,
                      paddingVertical: 2.h,
                      radiusAll: 100.r,
                      color: AppColors.white.withOpacity(0.1),
                      child: CustomText(
                        text: plan.formatedDiscount,
                        color: widget.isSelected
                            ? AppColors.primary
                            : Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    // Sub text
                    CustomText(
                      textAlign: TextAlign.start,
                      text: '${plan.badgeText ?? ''}${plan.subText}',
                      color: widget.isSelected
                          ? AppColors.primary
                          : Colors.white,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ],
                ),
                // Check badge
                if (widget.isSelected)
                  Positioned(
                    top: -22,
                    right: -22,
                    child: CustomContainer(
                      paddingAll: 4.r,
                      shape: BoxShape.circle,
                      color: AppColors.primary,
                        child: Icon(Icons.check, color: AppColors.white,size: 16.r,)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
