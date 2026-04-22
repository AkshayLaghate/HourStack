import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF6366F1);
  static const Color primaryLight = Color(0xFFEEF2FF);

  static const Color background = Color(0xFFF8FAFC);
  static const Color sidebar = Color(0xFFFFFFFF);
  static const Color card = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64728B);
  static const Color textHint = Color(0xFF94A3B8);

  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFF0FDF4);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFFBEB);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFFEFF6FF);

  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Login Redesign Colors
  static const Color loginGradientStart = Color(0xFFE0E7FF);
  static const Color loginGradientEnd = Color(0xFFF5F3FF);
  static const Color loginCardSurface = Color(0xFFF1F5F9);

  // Dark Login Theme
  static const Color loginDarkBg = Color(0xFF0B0F1A);
  static const Color loginDarkSurface = Color(0xFF131825);
  static const Color loginDarkCard = Color(0xFF1A1F2E);
  static const Color loginDarkBorder = Color(0xFF252B3B);
  static const Color loginDarkTextPrimary = Color(0xFFF1F5F9);
  static const Color loginDarkTextSecondary = Color(0xFF8B95A9);
  static const Color loginDarkInputBg = Color(0xFF0F1320);
  static const Color loginDarkInputBorder = Color(0xFF1E2433);
  static const Color primaryGlow = Color(0xFF818CF8);

  // Dark Dashboard Theme — extends login dark palette
  static const Color darkBg = Color(0xFF0B0F1A);
  static const Color darkSurface = Color(0xFF111627);
  static const Color darkCard = Color(0xFF161B2E);
  static const Color darkCardHover = Color(0xFF1C2238);
  static const Color darkBorder = Color(0xFF232942);
  static const Color darkBorderSubtle = Color(0xFF1C2137);
  static const Color darkTextPrimary = Color(0xFFF1F5F9);
  static const Color darkTextSecondary = Color(0xFF7E8BA4);
  static const Color darkTextMuted = Color(0xFF535F78);
  static const Color darkSidebar = Color(0xFF0E1222);
  static const Color darkSidebarActive = Color(0xFF161D33);
  static const Color darkDivider = Color(0xFF1A2035);

  // Light dashboard palette derived from the provided reference
  static const Color lightAppBackground = Color(0xFFF5F7FB);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSidebar = Color(0xFFFFFFFF);
  static const Color lightSidebarActive = Color(0xFFE6E7FF);
  static const Color lightCardHover = Color(0xFFF8FAFF);
  static const Color lightBorderSubtle = Color(0xFFE6ECF5);
  static const Color lightTextPrimary = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF5F7393);
  static const Color lightTextMuted = Color(0xFF94A3B8);
  static const Color lightInputBackground = Color(0xFFFFFFFF);
  static const Color lightTimerStart = Color(0xFFEEF2FF);
  static const Color lightTimerEnd = Color(0xFFE0E7FF);

  // Accent glows for dark theme
  static const Color blueGlow = Color(0xFF60A5FA);
  static const Color greenGlow = Color(0xFF4ADE80);
  static const Color amberGlow = Color(0xFFFBBF24);
  static const Color roseGlow = Color(0xFFFB7185);

  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color appBackground(BuildContext context) =>
      isDark(context) ? darkBg : lightAppBackground;

  static Color surface(BuildContext context) =>
      isDark(context) ? darkSurface : lightSurface;

  static Color sidebarBackground(BuildContext context) =>
      isDark(context) ? darkSidebar : lightSidebar;

  static Color sidebarActive(BuildContext context) =>
      isDark(context) ? darkSidebarActive : lightSidebarActive;

  static Color cardBackground(BuildContext context) =>
      isDark(context) ? darkCard : lightSurface;

  static Color cardHover(BuildContext context) =>
      isDark(context) ? darkCardHover : lightCardHover;

  static Color borderColor(BuildContext context) =>
      isDark(context) ? darkBorder : border;

  static Color borderSubtle(BuildContext context) =>
      isDark(context) ? darkBorderSubtle : lightBorderSubtle;

  static Color dividerColor(BuildContext context) =>
      isDark(context) ? darkDivider : divider;

  static Color textPrimaryColor(BuildContext context) =>
      isDark(context) ? darkTextPrimary : lightTextPrimary;

  static Color textSecondaryColor(BuildContext context) =>
      isDark(context) ? darkTextSecondary : lightTextSecondary;

  static Color textMutedColor(BuildContext context) =>
      isDark(context) ? darkTextMuted : lightTextMuted;

  static Color inputBackground(BuildContext context) =>
      isDark(context) ? loginDarkInputBg : lightInputBackground;

  static Color inputBorder(BuildContext context) =>
      isDark(context) ? loginDarkInputBorder : lightBorderSubtle;

  static List<Color> timerGradient(BuildContext context) => isDark(context)
      ? const [Color(0xFF1A1545), Color(0xFF161040)]
      : const [lightTimerStart, lightTimerEnd];

  static Color timerTextColor(BuildContext context) =>
      isDark(context) ? darkTextPrimary : lightTextPrimary;

  static Color timerSecondaryTextColor(BuildContext context) =>
      isDark(context)
          ? Colors.white.withValues(alpha: 0.7)
          : lightTextSecondary;

  static Color timerOutlineColor(BuildContext context) =>
      isDark(context)
          ? Colors.white.withValues(alpha: 0.06)
          : primary.withValues(alpha: 0.12);
}
