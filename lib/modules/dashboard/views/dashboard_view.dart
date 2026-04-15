import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/utils/constants.dart';
import 'widgets/stat_card.dart';
import 'widgets/activity_chart.dart';
import 'widgets/recent_entries.dart';
import 'widgets/timer_card.dart';
import 'widgets/project_distribution.dart';
import 'widgets/activity_heatmap.dart';
import '../../../app/utils/number_extensions.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1200;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 36),
          _buildStatsGrid(isDesktop),
          const SizedBox(height: 28),
          if (isDesktop)
            Column(
              children: [
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: ActivityChart(),
                      ),
                      const SizedBox(width: 28),
                      const SizedBox(
                        width: 340,
                        child: TimerCard(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Expanded(
                        flex: 3,
                        child: RecentEntries(),
                      ),
                      const SizedBox(width: 28),
                      const SizedBox(
                        width: 340,
                        child: ProjectDistribution(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const ActivityHeatmap(),
              ],
            )
          else
            const Column(
              children: [
                TimerCard(),
                SizedBox(height: 28),
                ActivityChart(),
                SizedBox(height: 28),
                ProjectDistribution(),
                SizedBox(height: 28),
                ActivityHeatmap(),
                SizedBox(height: 28),
                RecentEntries(),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Dashboard', style: AppTextStyles.darkH1),
                const SizedBox(height: 6),
                Text(
                  'Welcome back, Alex. Here\'s your productivity overview.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.darkTextSecondary,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
            Obx(
              () => InkWell(
                onTap: () => controller.selectDateRange(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.darkBorderSubtle,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.calendar_today_rounded,
                        size: 14,
                        color: AppColors.darkTextMuted,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDateRange(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Obx(
          () => _buildDarkSegmentedControl(),
        ),
      ],
    );
  }

  Widget _buildDarkSegmentedControl() {
    final items = [
      (DateRangeType.day, 'Day', Icons.today),
      (DateRangeType.week, 'Week', Icons.date_range),
      (DateRangeType.month, 'Month', Icons.calendar_month),
      (DateRangeType.custom, 'Custom', Icons.more_horiz),
    ];

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: items.map((item) {
          final isSelected = controller.rangeType.value == item.$1;
          return GestureDetector(
            onTap: () => controller.setRange(item.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.$3,
                    size: 14,
                    color: isSelected
                        ? Colors.white
                        : AppColors.darkTextMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.$2,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : AppColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  String _formatDateRange() {
    final type = controller.rangeType.value;
    final start = controller.startDate.value;
    final end = controller.endDate.value;

    if (type == DateRangeType.day) {
      return DateFormat('MMM dd, yyyy').format(start);
    } else if (type == DateRangeType.week) {
      return '${DateFormat('MMM dd').format(start)} - ${DateFormat('MMM dd, yyyy').format(end)}';
    } else if (type == DateRangeType.month) {
      return DateFormat('MMMM yyyy').format(start);
    } else {
      return '${DateFormat('MMM dd').format(start)} - ${DateFormat('MMM dd').format(end)}';
    }
  }

  Widget _buildStatsGrid(bool isDesktop) {
    return Obx(() {
      final stats = [
        StatCard(
          title: 'Period Hours',
          value: _formatHours(controller.periodTotalHours.value),
          trend: controller.periodHoursTrend.value,
          trendDescription: controller.trendDescription,
          isPositive: controller.isPeriodHoursPositive.value,
          icon: Icons.timer_rounded,
          accentColor: AppColors.blueGlow,
        ),
        StatCard(
          title: 'Period Revenue',
          value: controller.periodTotalRevenue.value.toCurrency(
            symbol: AppConstants.defaultCurrencySymbol,
          ),
          trend: controller.periodRevenueTrend.value,
          trendDescription: controller.trendDescription,
          isPositive: controller.isPeriodRevenuePositive.value,
          icon: Icons.attach_money_rounded,
          accentColor: AppColors.greenGlow,
        ),
        StatCard(
          title: 'Active Projects',
          value: controller.activeProjectsCount.value.toString(),
          trend: controller.activeProjectsTrend.value,
          trendDescription: controller.trendDescription,
          isPositive: controller.isActiveProjectsPositive.value,
          icon: Icons.folder_rounded,
          accentColor: AppColors.primaryGlow,
        ),
        StatCard(
          title: 'Monthly Hours',
          value: _formatHours(controller.monthlyHours.value),
          trend: controller.monthlyHoursTrend.value,
          trendDescription: 'vs last month',
          isPositive: controller.isMonthlyHoursPositive.value,
          icon: Icons.analytics_rounded,
          accentColor: AppColors.amberGlow,
        ),
      ];

      if (isDesktop) {
        return Row(
          children: stats
              .map(
                (s) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: s == stats.last ? 0 : 20),
                    child: s,
                  ),
                ),
              )
              .toList(),
        );
      }

      return Wrap(
        spacing: 16,
        runSpacing: 16,
        children: stats.map((s) => SizedBox(width: 180, child: s)).toList(),
      );
    });
  }

  String _formatHours(double hours) {
    final int h = hours.toInt();
    final int m = ((hours - h) * 60).round();
    if (h > 0) {
      return '${h}h ${m}m';
    }
    return '${m}m';
  }
}
