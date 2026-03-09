import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
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
        color: const Color(0xFFF0F2FF),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'TOTAL MONTHLY GOAL',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF6366F1),
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
                      style: AppTextStyles.h1.copyWith(fontSize: 40),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '${(progress * 100).toInt()}% Achieved',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: const Color(0xFF10B981),
                        fontWeight: FontWeight.bold,
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
                    backgroundColor: Colors.white,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Color(0xFF6366F1),
                    ),
                    minHeight: 12,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'You are ${AppConstants.defaultCurrencySymbol}${remaining.toThousandSeparator(2)} away from your monthly target. Keep it up!',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
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
