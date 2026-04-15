import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class RecentSessionsList extends StatelessWidget {
  final List<SessionItem> sessions;

  const RecentSessionsList({super.key, required this.sessions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Sessions',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.darkTextPrimary,
                letterSpacing: -0.5,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text(
                'View all',
                style: TextStyle(
                  color: AppColors.primaryGlow,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ...sessions.map((session) => _buildSessionItem(session)),
      ],
    );
  }

  Widget _buildSessionItem(SessionItem session) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(session.icon, color: AppColors.primaryGlow, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  session.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextPrimary,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      session.date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.darkTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: AppColors.darkBorder,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      session.timeRange,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.darkTextSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '${session.duration} hrs',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.darkTextPrimary,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 16),
          const Icon(
            Icons.more_vert_rounded,
            color: AppColors.darkTextMuted,
            size: 20,
          ),
        ],
      ),
    );
  }
}

class SessionItem {
  final String title;
  final String date;
  final String timeRange;
  final double duration;
  final IconData icon;

  SessionItem({
    required this.title,
    required this.date,
    required this.timeRange,
    required this.duration,
    required this.icon,
  });
}
