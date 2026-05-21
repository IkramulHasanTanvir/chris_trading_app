import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/referral/presentation/widgets/referral_shimmer_widgets.dart';
import 'package:flutter_task/features/signals/presentation/controllers/signal_controller.dart';
import 'package:flutter_task/features/signals/presentation/widgets/signal_card.dart';
import 'package:get/get.dart';


class SignalsDetailsScreen extends StatelessWidget {
  const SignalsDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String signalId = Get.arguments;
    final controller = SignalsController.to;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await controller.getSignalDetails(signalId);
          },
          edgeOffset: 60.h,
          color: AppColors.primary,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // ─── Sliver AppBar ───────────────────────────────────────────
              SliverAppBar(
                expandedHeight: 70.h,
               // pinned: true,
                floating: false,
                scrolledUnderElevation: 0,
                backgroundColor: AppColors.background,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  expandedTitleScale: 2.0,
                  title: CustomText(
                    text: 'Signals Details',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  centerTitle: true,
                ),
              ),

              // ─── Sliver Body ─────────────────────────────────────────────
              SliverToBoxAdapter(
                child: Column(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
