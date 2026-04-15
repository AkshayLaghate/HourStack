import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class WeeklyComparisonCard extends StatelessWidget {
  final double thisWeekHours;
  final double lastWeekHours;
  final double weeklyGoal;

  const WeeklyComparisonCard({
    super.key,
    required this.thisWeekHours,
    required this.lastWeekHours,
    required this.weeklyGoal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Weekly Comparison',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.darkTextPrimary,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 16),
        _buildWeekCard(
          title: 'THIS WEEK',
          hours: thisWeekHours,
          goal: weeklyGoal,
          progressColor: AppColors.primary,
          icon: Icons.bar_chart_rounded,
          isActive: true,
        ),
        const SizedBox(height: 16),
        _buildWeekCard(
          title: 'LAST WEEK',
          hours: lastWeekHours,
          goal: weeklyGoal,
          progressColor: AppColors.darkTextMuted,
          icon: Icons.history_rounded,
          isActive: false,
        ),
      ],
    );
  }

  Widget _buildWeekCard({
    required String title,
    required double hours,
    required double goal,
    required Color progressColor,
    required IconData icon,
    required bool isActive,
  }) {
    final progress = (hours / goal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.primary.withValues(alpha: 0.08)
            : AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? AppColors.primary.withValues(alpha: 0.2)
              : AppColors.darkBorder.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: isActive
                      ? AppColors.primaryGlow
                      : AppColors.darkTextMuted,
                ),
              ),
              Icon(
                icon,
                color: isActive ? AppColors.primaryGlow : AppColors.darkTextMuted,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                hours.toStringAsFixed(1),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: isActive
                      ? AppColors.darkTextPrimary
                      : AppColors.darkTextSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'hrs',
                style: TextStyle(
                  color: isActive
                      ? AppColors.primaryGlow.withValues(alpha: 0.7)
                      : AppColors.darkTextMuted,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.darkBorder.withValues(alpha: 0.4),
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              minHeight: 10,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'GOAL:',
                style: TextStyle(
                  color: isActive
                      ? AppColors.primaryGlow.withValues(alpha: 0.7)
                      : AppColors.darkTextMuted,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  fontSize: 11,
                ),
              ),
              Text(
                '${goal.toInt()} hrs',
                style: TextStyle(
                  color: isActive
                      ? AppColors.primaryGlow
                      : AppColors.darkTextSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
