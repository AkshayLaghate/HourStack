import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../controllers/dashboard_controller.dart';

class ActivityHeatmap extends GetView<DashboardController> {
  const ActivityHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Activity Heatmap', style: AppTextStyles.h3),
                  const SizedBox(height: 4),
                  const Text(
                    'Daily work intensity over the last year',
                    style: AppTextStyles.bodyMedium,
                  ),
                ],
              ),
              _buildLegendRow(),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Obx(() {
                final datasets = Map<DateTime, int>.from(
                  controller.heatmapDatasets,
                );
                return HeatMap(
                  datasets: datasets,
                  colorMode: ColorMode.opacity,
                  showText: false,
                  scrollable: false,
                  size: 14,
                  colorsets: const {1: AppColors.primary},
                  startDate: now.subtract(const Duration(days: 365)),
                  endDate: now,
                  onClick: (value) {},
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendRow() {
    return Row(
      children: [
        Text(
          'Less',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(width: 8),
        _buildLegendBox(AppColors.primary.withAlpha(50)),
        const SizedBox(width: 4),
        _buildLegendBox(AppColors.primary.withAlpha(100)),
        const SizedBox(width: 4),
        _buildLegendBox(AppColors.primary.withAlpha(150)),
        const SizedBox(width: 4),
        _buildLegendBox(AppColors.primary.withAlpha(200)),
        const SizedBox(width: 4),
        _buildLegendBox(AppColors.primary),
        const SizedBox(width: 8),
        Text(
          'More',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendBox(Color color) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
