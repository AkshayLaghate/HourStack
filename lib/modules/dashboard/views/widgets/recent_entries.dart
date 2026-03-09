import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../controllers/dashboard_controller.dart';
import '../../../../app/widgets/empty_state_widget.dart';

class RecentEntries extends GetView<DashboardController> {
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
          Obx(() {
            if (controller.isLoading.value &&
                controller.recentSessions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.recentSessions.isEmpty) {
              return const EmptyStateWidget(
                isCompact: true,
                icon: Icons.history_rounded,
                title: 'No Recent Activity',
                description: 'You haven\'t tracked any time recently.',
              );
            }

            return Column(
              children: controller.recentSessions.asMap().entries.map((entry) {
                final session = entry.value;
                final isLast =
                    entry.key == controller.recentSessions.length - 1;
                final project = controller.projectMap[session.projectId];
                final isBillable = project?.isBillable ?? true;

                return Column(
                  children: [
                    _buildEntryItem(
                      icon: IconData(
                        project?.iconCodePoint ?? 0xe232,
                        fontFamily: 'MaterialIcons',
                      ),
                      title: project?.name ?? 'Unknown Project',
                      subtitle: DateFormat(
                        'MMM d, h:mm a',
                      ).format(session.startTime),
                      category: isBillable ? 'Billable' : 'Non-billable',
                      categoryColor: isBillable
                          ? AppColors.success
                          : AppColors.textHint,
                      time: _formatDuration(session.durationMinutes),
                    ),
                    if (!isLast)
                      const Divider(height: 1, color: AppColors.divider),
                  ],
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  String _formatDuration(int minutes) {
    final int h = minutes ~/ 60;
    final int m = minutes % 60;
    return '${h}h ${m}m';
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
              color: categoryColor.withAlpha((0.1 * 255).toInt()),
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
