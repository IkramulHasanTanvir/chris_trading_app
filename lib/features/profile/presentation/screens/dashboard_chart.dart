import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_task/core/utils/app_colors.dart';
import 'package:flutter_task/features/profile/data/models/dashboard_model.dart';



// ─── Wins / Losses Pie Chart ────────────────────────────────────
class WinsLossesPieChart extends StatefulWidget {
  final double winsPercent;
  final double lossesPercent;

  const WinsLossesPieChart({
    super.key,
    required this.winsPercent,
    required this.lossesPercent,
  });

  @override
  State<WinsLossesPieChart> createState() => _WinsLossesPieChartState();
}

class _WinsLossesPieChartState extends State<WinsLossesPieChart> {
  int _touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.navBackground,
       // border: Border.all(color: AppColors.navBackground),
        //borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Wins / Losses',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 180.h,
            child: Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      pieTouchData: PieTouchData(
                        touchCallback: (event, response) {
                          setState(() {
                            if (!event.isInterestedForInteractions ||
                                response == null ||
                                response.touchedSection == null) {
                              _touchedIndex = -1;
                              return;
                            }
                            _touchedIndex =
                                response.touchedSection!.touchedSectionIndex;
                          });
                        },
                      ),
                      startDegreeOffset: -90,
                      centerSpaceRadius: 45.r,
                      sectionsSpace: 3,
                      sections: [
                        PieChartSectionData(
                          value: widget.winsPercent,
                          color: AppColors.winBlue,
                          radius: _touchedIndex == 0 ? 65.r : 56.r,
                          title: '${widget.winsPercent.toInt()}%',
                          titleStyle: TextStyle(
                            fontSize: _touchedIndex == 0 ? 14.sp : 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                        PieChartSectionData(
                          value: widget.lossesPercent,
                          color: AppColors.lossRed,
                          radius: _touchedIndex == 1 ? 65.r : 56.r,
                          title: '${widget.lossesPercent.toInt()}%',
                          titleStyle: TextStyle(
                            fontSize: _touchedIndex == 1 ? 14.sp : 12.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                      color: AppColors.winBlue,
                      label: 'Wins',
                      value: '${widget.winsPercent.toInt()}%',
                    ),
                    SizedBox(height: 12.h),
                    _buildLegendItem(
                      color: AppColors.lossRed,
                      label: 'Losses',
                      value: '${widget.lossesPercent.toInt()}%',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        SizedBox(width: 6.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: AppColors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ─── Trades By Asset Bar Chart ──────────────────────────────────
class TradesByAssetBarChart extends StatefulWidget {
  final List<TradesByAsset> tradesByAsset;

  const TradesByAssetBarChart({super.key, required this.tradesByAsset});

  @override
  State<TradesByAssetBarChart> createState() => _TradesByAssetBarChartState();
}

class _TradesByAssetBarChartState extends State<TradesByAssetBarChart> {
  int _touchedGroupIndex = -1;

  @override
  Widget build(BuildContext context) {
    final maxY = widget.tradesByAsset
        .map((e) => (e.wins ?? 0) + (e.losses ?? 0))
        .fold<double>(0, (a, b) => a > b ? a : b.toDouble());

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.navBackground,
        //border: Border.all(color: AppColors.navBackground),
        //borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Trades By Asset',
            style: TextStyle(
              color: AppColors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          // Legend
          Row(
            children: [
              _legendDot(AppColors.barGreen, 'Wins'),
              SizedBox(width: 16.w),
              _legendDot(AppColors.barRed, 'Losses'),
            ],
          ),
          SizedBox(height: 12.h),
          SizedBox(
            height: 200.h,
            child: BarChart(
              BarChartData(
                maxY: maxY * 1.3,
                minY: -(maxY * 0.6),
                barTouchData: BarTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          response == null ||
                          response.spot == null) {
                        _touchedGroupIndex = -1;
                        return;
                      }
                      _touchedGroupIndex =
                          response.spot!.touchedBarGroupIndex;
                    });
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF1E2235),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final asset = widget.tradesByAsset[groupIndex];
                      final label = rodIndex == 0 ? 'Wins' : 'Losses';
                      final val = rodIndex == 0
                          ? asset.wins ?? 0
                          : asset.losses ?? 0;
                      return BarTooltipItem(
                        '${asset.symbol}\n$label: $val',
                        TextStyle(
                          color: AppColors.white,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: maxY / 4,
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: AppColors.navBackground,
                    strokeWidth: 0.8,
                  ),
                ),
                borderData: FlBorderData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28.w,
                      interval: maxY / 4,
                      getTitlesWidget: (value, meta) {
                        if (value == 0) return const SizedBox();
                        return Text(
                          value.abs().toInt().toString(),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 9.sp,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 22.h,
                      getTitlesWidget: (value, meta) {
                        final idx = value.toInt();
                        if (idx < 0 || idx >= widget.tradesByAsset.length) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: EdgeInsets.only(top: 4.h),
                          child: Text(
                            widget.tradesByAsset[idx].symbol ?? '',
                            style: TextStyle(
                              color: _touchedGroupIndex == idx
                                  ? AppColors.white
                                  : AppColors.textSecondary,
                              fontSize: 9.sp,
                              fontWeight: _touchedGroupIndex == idx
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(widget.tradesByAsset.length, (i) {
                  final asset = widget.tradesByAsset[i];
                  final isTouched = _touchedGroupIndex == i;
                  return BarChartGroupData(
                    x: i,
                    groupVertically: false,
                    barRods: [
                      // Wins bar (positive)
                      BarChartRodData(
                        toY: (asset.wins ?? 0).toDouble(),
                        fromY: 0,
                        color: isTouched
                            ? AppColors.barGreen.withOpacity(1)
                            : AppColors.barGreen.withOpacity(0.85),
                        width: 5.w,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(3.r),
                        ),
                      ),
                      // Losses bar (negative, going down)
                      BarChartRodData(
                        toY: -((asset.losses ?? 0).toDouble()),
                        fromY: 0,
                        color: isTouched
                            ? AppColors.barRed.withOpacity(1)
                            : AppColors.barRed.withOpacity(0.85),
                        width: 5.w,
                        borderRadius: BorderRadius.vertical(
                          bottom: Radius.circular(3.r),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.r),
          ),
        ),
        SizedBox(width: 5.w),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}

// ─── Usage Example in DashboardScreen ──────────────────────────
//
// Inside your LoadingState.loaded case, add these two widgets:
//
// WinsLossesPieChart(
//   winsPercent: (dashboard?.winsLosses?.wins?.percentage ?? 0).toDouble(),
//   lossesPercent: (dashboard?.winsLosses?.losses?.percentage ?? 0).toDouble(),
// ),
// SizedBox(height: 16.h),
// TradesByAssetBarChart(
//   tradesByAsset: dashboard?.tradesByAsset ?? [],
// ),