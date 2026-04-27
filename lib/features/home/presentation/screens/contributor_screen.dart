import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/features/home/data/models/trader_model.dart';
import 'package:flutter_task/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter_task/features/home/presentation/widgets/champions_top_three_card.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/data/models/contributor_model.dart';
import 'package:flutter_task/features/home/data/models/leader_board_model.dart';
import 'package:flutter_task/features/home/presentation/widgets/contributor_card.dart';
import 'package:flutter_task/features/home/presentation/widgets/section_title_widget.dart';
import 'package:flutter_task/features/home/presentation/widgets/trader_card.dart';
import 'package:flutter_task/features/trader/data/models/signal_model.dart';
import 'package:flutter_task/features/trader/presentation/widgets/signal_card.dart';
import 'package:flutter_task/features/trader/presentation/widgets/up_down_card.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/utils/assets_path/assets.gen.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter_task/features/profile/presentation/widgets/active_card.dart';
import 'package:flutter_task/features/profile/presentation/widgets/profile_list_tile.dart';
import 'package:get/get.dart';

class ContributorScreen extends StatelessWidget {
  const ContributorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.to;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
          controller: controller.contributorsScrollController,
          slivers: [
            // ─── Sliver AppBar ───────────────────────────────────────────
            SliverAppBar(
              expandedHeight: 70.h,
              // pinned: true,
              floating: false,
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.white,
                ),
              ),
              scrolledUnderElevation: 0,
              backgroundColor: AppColors.background,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                expandedTitleScale: 2.0,
                title: CustomText(
                  text: 'Contributors',
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                ),
                centerTitle: true,
              ),
            ),

            // ─── Sliver Body ─────────────────────────────────────────────
            SliverToBoxAdapter(
              child: Column(
                children: [
                  SizedBox(height: 10.h),
                  Obx(() {
                    final data = controller.contributors;
                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      itemCount: data.length,
                      separatorBuilder: (_, index) {
                        return SizedBox(height: 12.w);
                      },
                      itemBuilder: (context, index) {
                        final item = data[index];

                        return ContributorCard(item: item);
                      },
                    );
                  }),
                  Obx(
                    () => controller.isLoadingMoreContributors
                        ? Padding(
                            padding: EdgeInsets.all(16.w),
                            child: const Center(child: CustomLoader()),
                          )
                        : const SizedBox.shrink(),
                  ),

                  SizedBox(height: 100.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
