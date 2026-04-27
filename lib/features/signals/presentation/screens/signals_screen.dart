import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/core/widgets/widgets.dart';
import 'package:flutter_task/features/signals/data/models/signal_model.dart';
import 'package:flutter_task/features/signals/presentation/widgets/signal_card.dart';
import 'package:flutter_task/features/signals/presentation/widgets/up_down_card.dart';


class SignalsScreen extends StatelessWidget {
  const SignalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: CustomScrollView(
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
                  text: 'Signals',
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
                  UpDownCard()     ,
        
                  SizedBox(height: 24.h),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    itemCount: SignalsModel.demoSignals.length,
                    separatorBuilder: (_, index) {
                      return SizedBox(height: 12.w);
                    },
                    itemBuilder: (context, index) {
                      final item = SignalsModel.demoSignals[index];
        
                      return SignalCard(item: item);
                    },
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
