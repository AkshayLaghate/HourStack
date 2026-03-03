import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

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
        const Text('Weekly Comparison', style: AppTextStyles.h2),
        const SizedBox(height: 16),
        _buildWeekCard(
          title: 'THIS WEEK',
          hours: thisWeekHours,
          goal: weeklyGoal,
          progressColor: AppColors.primary,
          icon: Icons.bar_chart_rounded,
        ),
        const SizedBox(height: 16),
        _buildWeekCard(
          title: 'LAST WEEK',
          hours: lastWeekHours,
          goal: weeklyGoal,
          progressColor: AppColors.textHint,
          icon: Icons.history_rounded,
          isDashed: true,
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
    bool isDashed = false,
  }) {
    final progress = (hours / goal).clamp(0.0, 1.0);
    final isIndigo = !isDashed;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isIndigo ? const Color(0xFFF1F3FF) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isIndigo ? const Color(0xFFE0E7FF) : const Color(0xFFF1F5F9),
        ),
        boxShadow: isIndigo
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.01),
                  blurRadius: 30,
                  offset: const Offset(0, 8),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: isIndigo
                      ? const Color(0xFF6366F1)
                      : const Color(0xFF818CF8),
                ),
              ),
              Icon(
                icon,
                color: isIndigo
                    ? const Color(0xFF6366F1)
                    : const Color(0xFF94A3B8),
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
                style: AppTextStyles.h1.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1,
                  color: isIndigo
                      ? const Color(0xFF1E1B4B)
                      : AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'hrs',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isIndigo
                      ? const Color(0xFF6366F1).withOpacity(0.7)
                      : AppColors.textHint,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: isIndigo
                  ? Colors.white
                  : const Color(0xFFF1F5F9),
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
                style: AppTextStyles.bodySmall.copyWith(
                  color: isIndigo
                      ? const Color(0xFF6366F1).withOpacity(0.7)
                      : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                  fontSize: 11,
                ),
              ),
              Text(
                '${goal.toInt()} hrs',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isIndigo
                      ? const Color(0xFF4F46E5)
                      : AppColors.textPrimary,
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
