import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class RecentEntries extends StatelessWidget {
  const RecentEntries({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent Entries', style: AppTextStyles.h2),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'View All',
                  style: TextStyle(color: AppColors.primary),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildEntryItem(
            icon: Icons.web_rounded,
            title: 'Website Redesign',
            subtitle: 'Homepage Layout',
            category: 'Billable',
            categoryColor: AppColors.success,
            time: '2h 15m',
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildEntryItem(
            icon: Icons.brush_rounded,
            title: 'Brand Identity',
            subtitle: 'Logo Concepts',
            category: 'Billable',
            categoryColor: AppColors.success,
            time: '1h 45m',
          ),
          const Divider(height: 1, color: AppColors.divider),
          _buildEntryItem(
            icon: Icons.email_rounded,
            title: 'Email Correspondence',
            subtitle: 'Client catch-up',
            category: 'Non-billable',
            categoryColor: AppColors.textHint,
            time: '0h 30m',
          ),
        ],
      ),
    );
  }

  Widget _buildEntryItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String category,
    required Color categoryColor,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.h3),
                Text(subtitle, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: categoryColor,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(time, style: AppTextStyles.h3.copyWith(fontSize: 14)),
        ],
      ),
    );
  }
}
