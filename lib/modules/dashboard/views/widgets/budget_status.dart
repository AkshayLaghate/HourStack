import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class BudgetStatus extends StatelessWidget {
  const BudgetStatus({super.key});

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
          Text(
            'BUDGET STATUS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.darkTextMuted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 20),
          _buildBudgetItem('Website Redesign', 0.75, AppColors.primaryGlow),
          const SizedBox(height: 16),
          _buildBudgetItem('Marketing Campaign', 0.42, AppColors.greenGlow),
          const SizedBox(height: 16),
          _buildBudgetItem('Consultation', 0.92, AppColors.roseGlow),
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
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkTextPrimary,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.darkBorderSubtle,
            color: color,
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
