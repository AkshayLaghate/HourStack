import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppThemePreference { light, dark, system }

class ThemeService extends GetxService {
  static const _themePreferenceKey = 'theme_preference';

  final Rx<AppThemePreference> _preference = AppThemePreference.system.obs;

  AppThemePreference get preference => _preference.value;

  ThemeMode get themeMode {
    switch (_preference.value) {
      case AppThemePreference.light:
        return ThemeMode.light;
      case AppThemePreference.dark:
        return ThemeMode.dark;
      case AppThemePreference.system:
        return ThemeMode.system;
    }
  }

  String get preferenceLabel {
    switch (_preference.value) {
      case AppThemePreference.light:
        return 'Light';
      case AppThemePreference.dark:
        return 'Dark';
      case AppThemePreference.system:
        return 'System';
    }
  }

  Future<ThemeService> init() async {
    final prefs = await SharedPreferences.getInstance();
    final storedPreference = prefs.getString(_themePreferenceKey);

    _preference.value = AppThemePreference.values.firstWhere(
      (value) => value.name == storedPreference,
      orElse: () => AppThemePreference.system,
    );

    return this;
  }

  Future<void> setPreference(AppThemePreference preference) async {
    _preference.value = preference;
    Get.changeThemeMode(themeMode);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themePreferenceKey, preference.name);
  }

  Future<void> toggleLightDark() async {
    final nextPreference = Get.isDarkMode
        ? AppThemePreference.light
        : AppThemePreference.dark;

    await setPreference(nextPreference);
  }
}
