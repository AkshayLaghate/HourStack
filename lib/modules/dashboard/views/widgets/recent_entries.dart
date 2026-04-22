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
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderSubtle(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Entries',
                style: AppTextStyles.sectionTitle(context),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View All',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.isLoading.value &&
                controller.recentSessions.isEmpty) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              );
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
                      context: context,
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
                          ? AppColors.greenGlow
                          : AppColors.textMutedColor(context),
                      time: _formatDuration(session.durationMinutes),
                    ),
                    if (!isLast)
                      Divider(
                        height: 1,
                        color: AppColors.dividerColor(context),
                      ),
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
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required String category,
    required Color categoryColor,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
            child: Icon(icon, color: AppColors.primaryGlow, size: 18),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor(context),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMutedColor(context),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: categoryColor.withValues(alpha: 0.08),
              ),
            ),
            child: Text(
              category,
              style: TextStyle(
                color: categoryColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            time,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor(context),
              letterSpacing: -0.3,
            ),
          ),
        ],
      ),
    );
  }
}
