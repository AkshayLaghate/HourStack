import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class BudgetStatus extends StatelessWidget {
  const BudgetStatus({super.key});

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
          const Text('BUDGET STATUS', style: AppTextStyles.labelLarge),
          const SizedBox(height: 20),
          _buildBudgetItem('Website Redesign', 0.75, AppColors.primary),
          const SizedBox(height: 16),
          _buildBudgetItem('Marketing Campaign', 0.42, AppColors.success),
          const SizedBox(height: 16),
          _buildBudgetItem('Consultation', 0.92, AppColors.error),
        ],
      ),
    );
  }

  Widget _buildBudgetItem(String title, double progress, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: AppTextStyles.h3.copyWith(fontSize: 14)),
            Text(
              '${(progress * 100).toInt()}%',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.divider,
            color: color,
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}
