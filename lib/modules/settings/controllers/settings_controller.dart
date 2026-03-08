import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class SettingsController extends GetxController {
  final _authService = Get.find<AuthService>();

  late final RxString fullName;
  late final RxString emailAddress;
  final photoUrl = RxnString();

  final selectedCurrency = 'INR - Indian Rupee'.obs;
  final selectedBillingType = 'Hourly Rate'.obs;

  final selectedRoundingRule = 'Round to nearest 15 minutes'.obs;
  final autoStopTimers = true.obs;

  final selectedTheme = 'Light'.obs;

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
  }

  void saveChanges() {
    Get.snackbar('Success', 'Settings saved successfully');
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
