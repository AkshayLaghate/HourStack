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
import 'widgets/budget_status.dart';
import 'widgets/team_list.dart';
import '../../../app/utils/number_extensions.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1200;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 40),
          _buildStatsGrid(isDesktop),
          const SizedBox(height: 32),
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column
                const Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      ActivityChart(),
                      SizedBox(height: 32),
                      RecentEntries(),
                    ],
                  ),
                ),
                const SizedBox(width: 32),
                // Right Column (Sidebar)
                const SizedBox(
                  width: 340,
                  child: Column(
                    children: [
                      TimerCard(),
                      SizedBox(height: 32),
                      BudgetStatus(),
                      SizedBox(height: 32),
                      TeamList(),
                    ],
                  ),
                ),
              ],
            )
          else
            // Mobile Layout
            const Column(
              children: [
                TimerCard(),
                SizedBox(height: 32),
                ActivityChart(),
                SizedBox(height: 32),
                RecentEntries(),
                SizedBox(height: 32),
                BudgetStatus(),
                SizedBox(height: 32),
                TeamList(),
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
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashboard', style: AppTextStyles.h1),
                SizedBox(height: 4),
                Text(
                  'Welcome back, Alex. Here\'s your productivity overview.',
                  style: AppTextStyles.bodyMedium,
                ),
              ],
            ),
            Obx(
              () => InkWell(
                onTap: () => controller.selectDateRange(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_rounded,
                        size: 16,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatDateRange(),
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.w600,
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
          () => SegmentedButton<DateRangeType>(
            segments: const [
              ButtonSegment(
                value: DateRangeType.day,
                label: Text('Day'),
                icon: Icon(Icons.today),
              ),
              ButtonSegment(
                value: DateRangeType.week,
                label: Text('Week'),
                icon: Icon(Icons.date_range),
              ),
              ButtonSegment(
                value: DateRangeType.month,
                label: Text('Month'),
                icon: Icon(Icons.calendar_month),
              ),
              ButtonSegment(
                value: DateRangeType.custom,
                label: Text('Custom'),
                icon: Icon(Icons.more_horiz),
              ),
            ],
            selected: {controller.rangeType.value},
            onSelectionChanged: (Set<DateRangeType> newSelection) {
              controller.setRange(newSelection.first);
            },
            style: SegmentedButton.styleFrom(
              backgroundColor: Colors.white,
              selectedBackgroundColor: AppColors.primary,
              selectedForegroundColor: Colors.white,
              side: const BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
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
          trend:
              '+5.2%', // Trend could be calculated if we had yesterday's data
          isPositive: true,
          icon: Icons.timer_rounded,
          iconColor: Colors.blue,
          iconBgColor: const Color(0xFFEFF6FF),
        ),
        StatCard(
          title: 'Period Revenue',
          value: controller.periodTotalRevenue.value.toCurrency(
            symbol: AppConstants.defaultCurrencySymbol,
          ),
          trend: '+12%',
          isPositive: true,
          icon: Icons.attach_money_rounded,
          iconColor: Colors.green,
          iconBgColor: const Color(0xFFF0FDF4),
        ),
        StatCard(
          title: 'Active Projects',
          value: '8', // This could also be fetched from projectRepo
          trend: '2 nearing deadline',
          isPositive: false,
          icon: Icons.folder_rounded,
          iconColor: Colors.blueAccent,
          iconBgColor: const Color(0xFFEEF2FF),
        ),
        StatCard(
          title: 'Monthly Hours',
          value: _formatHours(controller.monthlyHours.value),
          trend: 'Updated just now',
          isPositive: true,
          icon: Icons.analytics_rounded,
          iconColor: Colors.orange,
          iconBgColor: const Color(0xFFFFFBEB),
        ),
      ];

      if (isDesktop) {
        return Row(
          children: stats
              .map(
                (s) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: s == stats.last ? 0 : 24),
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
