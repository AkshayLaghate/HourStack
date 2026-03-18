import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../controllers/dashboard_controller.dart';

class ProjectDistribution extends GetView<DashboardController> {
  const ProjectDistribution({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Project Distribution', style: AppTextStyles.h3),
          const SizedBox(height: 4),
          const Text(
            'Time allocated per project',
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 32),
          Obx(() {
            final pDist = controller.projectDistribution;
            if (pDist.isEmpty) {
              return const SizedBox(
                height: 200,
                child: Center(child: Text('No project data')),
              );
            }

            final sortedEntries = pDist.entries.toList()
              ..sort((a, b) => b.value.compareTo(a.value));
            final totalHours = sortedEntries.fold(
              0.0,
              (sum, item) => sum + item.value,
            );

            final List<PieChartSectionData> sections = [];
            final colors = [
              AppColors.primary,
              const Color(0xFF0EA5E9),
              const Color(0xFFA5B4FC),
              AppColors.border,
            ];

            final legendItems = <Widget>[];
            double othersSum = 0;

            for (var i = 0; i < sortedEntries.length; i++) {
              final entry = sortedEntries[i];
              if (i < 3) {
                final pct = totalHours > 0
                    ? (entry.value / totalHours * 100).round()
                    : 0;
                sections.add(
                  PieChartSectionData(
                    color: colors[i],
                    value: totalHours > 0
                        ? entry.value
                        : 1, // Draw equal slices if no hours
                    title: '',
                    radius: 25,
                  ),
                );
                legendItems.add(
                  _buildLegendItem(entry.key.name, '$pct%', colors[i]),
                );
                legendItems.add(const SizedBox(height: 12));
              } else {
                othersSum += entry.value;
              }
            }

            if (othersSum > 0 || sortedEntries.length > 3) {
              final pct = totalHours > 0
                  ? (othersSum / totalHours * 100).round()
                  : 0;
              sections.add(
                PieChartSectionData(
                  color: colors[3],
                  value: totalHours > 0
                      ? othersSum
                      : 1, // Draw others slice if no hours
                  title: '',
                  radius: 25,
                ),
              );
              legendItems.add(_buildLegendItem('Others', '$pct%', colors[3]));
            } else if (legendItems.isNotEmpty) {
              legendItems.removeLast(); // remove last SizedBox
            }

            return Column(
              children: [
                SizedBox(
                  height: 200,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 60,
                          startDegreeOffset: -90,
                          sections: sections,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${controller.activeProjectsCount}',
                            style: AppTextStyles.h2.copyWith(fontSize: 24),
                          ),
                          const Text(
                            'Active Projects',
                            style: AppTextStyles.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                ...legendItems,
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String title, String percentage, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          percentage,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
