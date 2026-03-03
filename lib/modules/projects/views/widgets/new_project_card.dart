import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import 'dashed_container.dart';

class NewProjectCard extends StatelessWidget {
  final VoidCallback onTap;

  const NewProjectCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return DashedContainer(
      borderRadius: 24,
      dashPattern: const [8, 8],
      color: AppColors.border,
      strokeWidth: 2,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(24)),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: AppColors.textHint,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'New Project',
                style: AppTextStyles.h3.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
