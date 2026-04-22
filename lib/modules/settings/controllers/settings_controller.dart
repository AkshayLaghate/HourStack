import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/services/theme_service.dart';

class SettingsController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _themeService = Get.find<ThemeService>();

  late final RxString fullName;
  late final RxString emailAddress;
  final photoUrl = RxnString();

  final selectedCurrency = 'INR - Indian Rupee'.obs;
  final selectedBillingType = 'Hourly Rate'.obs;

  final selectedRoundingRule = 'Round to nearest 15 minutes'.obs;
  final autoStopTimers = true.obs;

  final selectedTheme = 'System'.obs;

  @override
  void onInit() {
    super.onInit();
    final user = _authService.currentUser.value;
    fullName = (user?.name ?? '').obs;
    emailAddress = (user?.email ?? '').obs;
    photoUrl.value = user?.photoUrl;

    // Optional: Keep them in sync if the service user updates
    ever(_authService.currentUser, (user) {
      if (user != null) {
        fullName.value = user.name;
        emailAddress.value = user.email;
        photoUrl.value = user.photoUrl;
      }
    });

    selectedTheme.value = _themeService.preferenceLabel;
  }

  void saveChanges() {
    Get.snackbar('Success', 'Settings saved successfully');
  }

  Future<void> updateTheme(String value) async {
    selectedTheme.value = value;

    switch (value) {
      case 'Light':
        await _themeService.setPreference(AppThemePreference.light);
        break;
      case 'Dark':
        await _themeService.setPreference(AppThemePreference.dark);
        break;
      default:
        await _themeService.setPreference(AppThemePreference.system);
    }
  }

  void signOut() {
    _authService.logout();
  }

  void changePassword() {
    Get.snackbar('Info', 'Change password dialog');
  }

  void deleteAccount() {
    Get.snackbar('Warning', 'Delete account dialog');
  }
}
