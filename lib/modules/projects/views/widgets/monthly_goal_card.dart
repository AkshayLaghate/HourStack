import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/utils/constants.dart';
import '../../../../app/utils/number_extensions.dart';

class MonthlyGoalCard extends StatelessWidget {
  final double totalEarning;
  final double goal;
  final double progress;

  const MonthlyGoalCard({
    super.key,
    required this.totalEarning,
    required this.goal,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = goal - totalEarning;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.15),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TOTAL MONTHLY GOAL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryGlow,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      '${AppConstants.defaultCurrencySymbol}${totalEarning.toThousandSeparator(2)}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        color: AppColors.darkTextPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: AppColors.success.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Text(
                        '${(progress * 100).toInt()}% Achieved',
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.greenGlow,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 40),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: AppColors.darkBorder.withValues(alpha: 0.4),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                    minHeight: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'You are ${AppConstants.defaultCurrencySymbol}${remaining.toThousandSeparator(2)} away from your monthly target. Keep it up!',
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.darkTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
