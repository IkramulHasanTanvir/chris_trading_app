import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/home/data/models/trader_model.dart';
import 'package:flutter_task/features/home/presentation/controllers/home_controller.dart';
import 'package:flutter_task/features/home/presentation/widgets/trader_card.dart';
import 'package:flutter_task/features/pasar/presentation/widgets/signal_details_card.dart';
import 'package:flutter_task/features/trader/data/models/signal_model.dart';
import 'package:get/get.dart';

class TopTraderScreen extends StatelessWidget {
  const TopTraderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = HomeController.to;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 100.h,
                  pinned: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: AppColors.background,
                  foregroundColor: AppColors.white,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.white,
                    ),
                  ),

                  title: CustomText(
                    text: 'Top Traders',
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                  ),
                  centerTitle: true,

                  /// 🔥 TabBar
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(30.h),
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: TabBar(
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorColor: AppColors.primary,
                          indicatorWeight: 2.5,
                          labelColor: AppColors.primary,
                          unselectedLabelColor: AppColors.white,
                          dividerColor: AppColors.textSecondary,
                          tabs: const [
                            Tab(text: "Explore"),
                            Tab(text: "Following"),
                          ],
                        )
                    ),
                  ),
                ),
              ];
            },

            /// 🔥 Tab Views
            body: TabBarView(
              children: [
                /// ───── All Tab ─────
                _buildSignalList(controller.topTraders),

                /// ───── Follow Tab ─────
                _buildSignalList(controller.topTraders),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 Signal List (Reusable)
  Widget _buildSignalList(List<TraderModel> data) {
    return Column(
      children: [
        SizedBox(height: 24.h),

        Obx(
           () {
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

                return TraderCard(trader: item,);
              },
            );
          }
        ),
        SizedBox(height: 100.h),
      ],
    );
  }
}
