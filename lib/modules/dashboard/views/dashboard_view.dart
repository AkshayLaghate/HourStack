import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../app/utils/constants.dart';
import 'widgets/stat_card.dart';
import 'widgets/activity_chart.dart';
import 'widgets/recent_entries.dart';
import 'widgets/timer_card.dart';
import 'widgets/budget_status.dart';
import 'widgets/team_list.dart';

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
          _buildHeader(),
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

  Widget _buildHeader() {
    return Row(
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                'Oct 24, 2023',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsGrid(bool isDesktop) {
    final stats = [
      const StatCard(
        title: 'Total Hours',
        value: '32h 45m',
        trend: '+5.2%',
        isPositive: true,
        icon: Icons.timer_rounded,
        iconColor: Colors.blue,
        iconBgColor: Color(0xFFEFF6FF),
      ),
      const StatCard(
        title: 'Billable Amount',
        value: '${AppConstants.defaultCurrencySymbol}2,450',
        trend: '+12%',
        isPositive: true,
        icon: Icons.attach_money_rounded,
        iconColor: Colors.green,
        iconBgColor: Color(0xFFF0FDF4),
      ),
      const StatCard(
        title: 'Active Projects',
        value: '8',
        trend: '2 nearing deadline',
        isPositive: false,
        icon: Icons.folder_rounded,
        iconColor: Colors.blueAccent,
        iconBgColor: Color(0xFFEEF2FF),
      ),
      const StatCard(
        title: 'Pending Invoices',
        value: '${AppConstants.defaultCurrencySymbol}850',
        trend: 'Due in 3 days',
        isPositive: true,
        icon: Icons.chat_bubble_rounded,
        iconColor: Colors.orange,
        iconBgColor: Color(0xFFFFFBEB),
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
  }
}
