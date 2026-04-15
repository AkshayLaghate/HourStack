import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import 'dashed_container.dart';

class NewProjectCard extends StatelessWidget {
  final VoidCallback onTap;

  const NewProjectCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DashedContainer(
      borderRadius: 20,
      dashPattern: const [8, 8],
      color: AppColors.darkBorder,
      strokeWidth: 2,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.darkBorder.withValues(alpha: 0.3),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.darkTextMuted,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'New Project',
                style: TextStyle(
                  color: AppColors.darkTextSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
