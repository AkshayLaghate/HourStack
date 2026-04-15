import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle h2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle h3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle h4 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.textPrimary,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.textSecondary,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
  );

  static const TextStyle statValue = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static const TextStyle trend = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );

  // ── Dark Theme Text Styles ──────────────────────────────────────────

  static const TextStyle darkH1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.darkTextPrimary,
    letterSpacing: -0.8,
  );

  static const TextStyle darkH2 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.darkTextPrimary,
    letterSpacing: -0.3,
  );

  static const TextStyle darkH3 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.darkTextPrimary,
  );

  static const TextStyle darkH4 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.darkTextPrimary,
  );

  static const TextStyle darkBodyMedium = TextStyle(
    fontSize: 14,
    color: AppColors.darkTextSecondary,
  );

  static const TextStyle darkBodySmall = TextStyle(
    fontSize: 12,
    color: AppColors.darkTextSecondary,
  );

  static const TextStyle darkLabelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.darkTextSecondary,
  );

  static const TextStyle darkStatValue = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w800,
    color: AppColors.darkTextPrimary,
    letterSpacing: -0.5,
  );

  static const TextStyle darkTrend = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
  );
}
