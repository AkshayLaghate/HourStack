import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';

class TeamList extends StatelessWidget {
  const TeamList({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TEAM',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkTextMuted,
                  letterSpacing: 1.2,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(
                  Icons.add_rounded,
                  color: AppColors.primaryGlow,
                  size: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildTeamMember(
            name: 'Sarah',
            status: 'Working on API',
            time: '2h 12m',
            isOnline: true,
            initials: 'S',
            avatarColor: AppColors.blueGlow,
          ),
          const SizedBox(height: 14),
          _buildTeamMember(
            name: 'Mike',
            status: 'Offline',
            time: '',
            isOnline: false,
            initials: 'M',
            avatarColor: AppColors.amberGlow,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember({
    required String name,
    required String status,
    required String time,
    required bool isOnline,
    required String initials,
    required Color avatarColor,
  }) {
    return Row(
      children: [
        Stack(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: avatarColor.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(
                  color: avatarColor.withValues(alpha: 0.2),
                ),
              ),
              child: Center(
                child: Text(
                  initials,
                  style: TextStyle(
                    color: avatarColor,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isOnline ? AppColors.greenGlow : AppColors.darkTextMuted,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.darkCard,
                    width: 2,
                  ),
                  boxShadow: isOnline
                      ? [
                          BoxShadow(
                            color: AppColors.greenGlow.withValues(alpha: 0.4),
                            blurRadius: 4,
                          ),
                        ]
                      : null,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTextPrimary,
                ),
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.darkTextMuted,
                ),
              ),
            ],
          ),
        ),
        if (time.isNotEmpty)
          Text(
            time,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.darkTextSecondary,
            ),
          ),
      ],
    );
  }
}
