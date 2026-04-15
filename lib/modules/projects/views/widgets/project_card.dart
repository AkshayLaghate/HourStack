import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../data/models/project_model.dart';
import '../../../../app/utils/constants.dart';
import '../../../../app/utils/number_extensions.dart';

class ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;

  const ProjectCard({super.key, required this.project, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final revenue = project.monthlyHours * project.hourlyRate;
    final currencySymbol = _getCurrencySymbol(project.currency);
    final projectColor = Color(project.colorValue);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: projectColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                IconData(project.iconCodePoint, fontFamily: 'MaterialIcons'),
                color: projectColor,
                size: 24,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              project.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.darkTextPrimary,
                letterSpacing: -0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              '$currencySymbol${project.hourlyRate.toStringAsFixed(2)} / hr',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.darkTextSecondary,
              ),
            ),
            Text(
              '${project.monthlyHours.toInt()}h this month',
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.darkTextMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Revenue: ${revenue.toCurrency(symbol: currencySymbol)}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                color: AppColors.darkTextPrimary,
              ),
            ),
            const Spacer(),
            _buildProgressBar(projectColor),
          ],
        ),
      ),
    );
  }

  String _getCurrencySymbol(String currency) {
    if (currency == 'INR') return AppConstants.defaultCurrencySymbol;
    if (currency == 'USD') return '\$';
    return currency;
  }

  Widget _buildProgressBar(Color projectColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'MONTHLY PROGRESS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: AppColors.darkTextMuted,
              ),
            ),
            Text(
              '${(project.monthlyProgress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: AppColors.darkTextSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: project.monthlyProgress,
            backgroundColor: AppColors.darkBorder.withValues(alpha: 0.4),
            valueColor: AlwaysStoppedAnimation<Color>(projectColor),
            minHeight: 6,
          ),
        ),
      ],
    );
  }
}
