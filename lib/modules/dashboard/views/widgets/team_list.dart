import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';

class TeamList extends StatelessWidget {
  const TeamList({super.key});

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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('TEAM', style: AppTextStyles.labelLarge),
              const Icon(Icons.add_rounded, color: AppColors.primary, size: 20),
            ],
          ),
          const SizedBox(height: 20),
          _buildTeamMember(
            name: 'Sarah',
            status: 'Working on API',
            time: '2h 12m',
            isOnline: true,
            imageUrl: 'https://i.pravatar.cc/150?u=sarah',
          ),
          const SizedBox(height: 16),
          _buildTeamMember(
            name: 'Mike',
            status: 'Offline',
            time: '',
            isOnline: false,
            imageUrl: 'https://i.pravatar.cc/150?u=mike',
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
    required String imageUrl,
  }) {
    return Row(
      children: [
        Stack(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(imageUrl),
              onBackgroundImageError: (exception, stackTrace) {},
              child: const Icon(Icons.person_outline, size: 20),
            ),

            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: isOnline ? AppColors.success : AppColors.textHint,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
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
              Text(name, style: AppTextStyles.h3.copyWith(fontSize: 14)),
              Text(status, style: AppTextStyles.bodySmall),
            ],
          ),
        ),
        if (time.isNotEmpty)
          Text(time, style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
      ],
    );
  }
}
