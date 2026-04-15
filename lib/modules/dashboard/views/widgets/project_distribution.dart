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
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Project Distribution', style: AppTextStyles.darkH3),
          const SizedBox(height: 4),
          Text(
            'Time allocated per project',
            style: TextStyle(
              fontSize: 13,
              color: AppColors.darkTextMuted,
            ),
          ),
          const SizedBox(height: 28),
          Obx(() {
            final pDist = controller.projectDistribution;
            if (pDist.isEmpty) {
              return SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'No project data',
                    style: TextStyle(
                      color: AppColors.darkTextMuted,
                      fontSize: 13,
                    ),
                  ),
                ),
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
              AppColors.primaryGlow,
              AppColors.blueGlow,
              const Color(0xFFA78BFA),
              AppColors.darkBorder,
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
                    value: totalHours > 0 ? entry.value : 1,
                    title: '',
                    radius: 22,
                  ),
                );
                legendItems.add(
                  _buildLegendItem(entry.key.name, '$pct%', colors[i]),
                );
                legendItems.add(const SizedBox(height: 10));
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
                  value: totalHours > 0 ? othersSum : 1,
                  title: '',
                  radius: 22,
                ),
              );
              legendItems.add(_buildLegendItem('Others', '$pct%', colors[3]));
            } else if (legendItems.isNotEmpty) {
              legendItems.removeLast();
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
                          sectionsSpace: 2,
                          centerSpaceRadius: 55,
                          startDegreeOffset: -90,
                          sections: sections,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${controller.activeProjectsCount}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: AppColors.darkTextPrimary,
                              letterSpacing: -0.5,
                            ),
                          ),
                          Text(
                            'Active',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.darkTextMuted,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
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
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.darkTextPrimary,
            ),
          ),
        ),
        Text(
          percentage,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }
}
