import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/settings_controller.dart';
import '../../../app/theme/app_colors.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(48.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildProfileSection(),
            const SizedBox(height: 24),
            _buildBillingSection(),
            const SizedBox(height: 24),
            _buildTimeTrackingSection(),
            const SizedBox(height: 24),
            _buildAppearanceSection(),
            const SizedBox(height: 24),
            _buildAccountSection(),
            const SizedBox(height: 48),
            _buildFooterButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.darkTextPrimary,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Manage your account, preferences, and tracking behavior.',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return _buildSectionCard(
      title: 'Profile',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Obx(
                () => CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                  backgroundImage: controller.photoUrl.value != null
                      ? NetworkImage(controller.photoUrl.value!)
                      : const NetworkImage('https://i.pravatar.cc/150?u=a'),
                  child: controller.photoUrl.value == null
                      ? Text(
                          (controller.fullName.value.isNotEmpty)
                              ? controller.fullName.value[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGlow,
                          ),
                        )
                      : null,
                  onBackgroundImageError: (_, __) {},
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.camera_alt,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      label: 'Full Name',
                      initialValue: controller.fullName.value,
                      onChanged: (v) => controller.fullName.value = v,
                      enabled: false,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTextField(
                      label: 'Email Address',
                      initialValue: controller.emailAddress.value,
                      onChanged: (v) => controller.emailAddress.value = v,
                      enabled: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingSection() {
    return _buildSectionCard(
      title: 'Billing Preferences',
      child: Row(
        children: [
          Expanded(
            child: _buildDropdownField(
              label: 'Currency',
              value: controller.selectedCurrency,
              items: [
                'USD - US Dollar',
                'EUR - Euro',
                'GBP - British Pound',
                'INR - Indian Rupee',
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildDropdownField(
              label: 'Billing Type',
              value: controller.selectedBillingType,
              items: ['Hourly Rate', 'Fixed Price'],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeTrackingSection() {
    return _buildSectionCard(
      title: 'Time Tracking',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 350,
            child: _buildDropdownField(
              label: 'Rounding Rule',
              value: controller.selectedRoundingRule,
              items: [
                'Round to nearest 15 minutes',
                'Round to nearest 30 minutes',
                'No rounding',
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Auto-stop timers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  Text(
                    'Automatically stop active timers at the end of the workday.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
              Obx(
                () => Switch(
                  value: controller.autoStopTimers.value,
                  onChanged: (v) => controller.autoStopTimers.value = v,
                  activeTrackColor: AppColors.primary,
                  activeThumbColor: Colors.white,
                  inactiveThumbColor: AppColors.darkTextSecondary,
                  inactiveTrackColor: AppColors.darkBorder,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppearanceSection() {
    return _buildSectionCard(
      title: 'Appearance',
      child: SizedBox(
        width: 350,
        child: _buildDropdownField(
          label: 'Theme',
          value: controller.selectedTheme,
          items: ['Light', 'Dark', 'System'],
        ),
      ),
    );
  }

  Widget _buildAccountSection() {
    return _buildSectionCard(
      title: 'Account',
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        children: [
          _buildActionButton(
            label: 'Change Password',
            icon: Icons.lock_outline,
            onPressed: controller.changePassword,
          ),
          _buildActionButton(
            label: 'Sign Out',
            icon: Icons.logout,
            onPressed: controller.signOut,
          ),
          _buildActionButton(
            label: 'Delete Account',
            icon: Icons.delete_outline,
            color: AppColors.roseGlow,
            backgroundColor: AppColors.error.withValues(alpha: 0.1),
            onPressed: controller.deleteAccount,
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: AppColors.darkTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 24),
        ElevatedButton(
          onPressed: controller.saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Save Changes',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required String initialValue,
    required Function(String) onChanged,
    bool enabled = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.darkTextSecondary,
              ),
            ),
            if (!enabled)
              const Icon(
                Icons.lock_outline,
                size: 14,
                color: AppColors.darkTextMuted,
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          enabled: enabled,
          style: const TextStyle(
            color: AppColors.darkTextPrimary,
            fontSize: 14,
          ),
          cursorColor: AppColors.primaryGlow,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled
                ? AppColors.loginDarkInputBg
                : AppColors.loginDarkInputBg.withValues(alpha: 0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.loginDarkInputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.loginDarkInputBorder),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: AppColors.loginDarkInputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField({
    required String label,
    required RxString value,
    required List<String> items,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: AppColors.darkTextSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.loginDarkInputBg,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.loginDarkInputBorder),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: value.value,
                isExpanded: true,
                dropdownColor: AppColors.darkCard,
                style: const TextStyle(
                  color: AppColors.darkTextPrimary,
                  fontSize: 14,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.darkTextSecondary,
                ),
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) value.value = v;
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    Color color = AppColors.darkTextPrimary,
    Color backgroundColor = AppColors.darkSurface,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18, color: color),
      label: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: AppColors.darkBorder.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}
