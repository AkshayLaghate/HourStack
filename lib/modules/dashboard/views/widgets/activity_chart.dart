import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../../app/widgets/empty_state_widget.dart';

class ActivityChart extends GetView<DashboardController> {
  const ActivityChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(controller.rangeLabel, style: AppTextStyles.darkH2)),
              Row(
                children: [
                  _buildLegendItem('Billable', AppColors.primaryGlow),
                  const SizedBox(width: 16),
                  _buildLegendItem('Non-billable', AppColors.darkTextMuted),
                ],
              ),
            ],
          ),
          const SizedBox(height: 32),
          Obx(() {
            if (controller.isLoading.value) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGlow,
                    strokeWidth: 2,
                  ),
                ),
              );
            }

            final hasData =
                controller.billableData.any((v) => v > 0) ||
                controller.nonBillableData.any((v) => v > 0);

            if (!hasData) {
              return const SizedBox(
                height: 200,
                child: EmptyStateWidget(
                  isCompact: true,
                  icon: Icons.show_chart_rounded,
                  title: 'No Activity Yet',
                  description:
                      'Activities will be displayed here once you start tracking time.',
                ),
              );
            }

            return SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  minY: 0,
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => AppColors.darkCardHover,
                      tooltipBorderRadius: BorderRadius.circular(8),
                      tooltipBorder: BorderSide(
                        color: AppColors.darkBorder.withValues(alpha: 0.5),
                      ),
                      getTooltipItems: (List<LineBarSpot> touchedSpots) {
                        return touchedSpots.map((LineBarSpot touchedSpot) {
                          return LineTooltipItem(
                            '${touchedSpot.y.toStringAsFixed(1)}h',
                            TextStyle(
                              color: touchedSpot.bar.color ?? AppColors.primaryGlow,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          );
                        }).toList();
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 2,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: AppColors.darkBorderSubtle.withValues(alpha: 0.4),
                      strokeWidth: 0.5,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          final total = controller.chartLabels.length;

                          int interval = 1;
                          if (total > 12) {
                            interval = (total / 6).ceil();
                          }

                          if (index >= 0 &&
                              index < total &&
                              index % interval == 0) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                controller.chartLabels[index],
                                style: TextStyle(
                                  fontSize: 11,
                                  color: AppColors.darkTextMuted,
                                ),
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.billableData
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      preventCurveOverShooting: true,
                      color: AppColors.primaryGlow,
                      barWidth: 2.5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.15),
                            AppColors.primary.withValues(alpha: 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                    LineChartBarData(
                      spots: controller.nonBillableData
                          .asMap()
                          .entries
                          .map((e) => FlSpot(e.key.toDouble(), e.value))
                          .toList(),
                      isCurved: true,
                      preventCurveOverShooting: true,
                      color: AppColors.darkTextMuted.withValues(alpha: 0.4),
                      barWidth: 1.5,
                      isStrokeCapRound: true,
                      dotData: const FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.3),
                blurRadius: 4,
              ),
            ],
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}
