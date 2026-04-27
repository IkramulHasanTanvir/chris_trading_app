import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/pasar/presentation/widgets/signal_details_card.dart';
import 'package:flutter_task/features/trader/data/models/signal_model.dart';

class PasarScreen extends StatelessWidget {
  const PasarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 90.h,
                  pinned: true,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  backgroundColor: AppColors.background,

                  title: CustomText(
                    text: 'Signals',
                    fontSize: 28.sp,
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
                          Tab(text: "Copy"),
                          Tab(text: "Log"),
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
                /// ───── Copy Tab ─────
                _buildSignalList(),

                /// ───── Log Tab ─────
                Center(
                  child: CustomText(
                    text: "No Logs Found",
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔥 Signal List (Reusable)
  Widget _buildSignalList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 24.h),

          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: SignalsModel.demoSignals.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final item = SignalsModel.demoSignals[index];
              return SignalDetailsCard(item: item);
            },
          ),

          SizedBox(height: 100.h),
        ],
      ),
    );
  }
}
