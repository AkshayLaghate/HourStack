import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../data/services/theme_service.dart';
import '../../../main/controllers/main_controller.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();
    final themeService = Get.find<ThemeService>();
    final isDark = AppColors.isDark(context);

    return Container(
      width: 272,
      decoration: BoxDecoration(
        color: AppColors.sidebarBackground(context),
        border: Border(
          right: BorderSide(
            color: AppColors.borderSubtle(context).withValues(alpha: 0.9),
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
          _buildLogo(context),
          const SizedBox(height: 36),
          Expanded(
            child: Obx(
              () => ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  _buildSectionLabel(context, 'MAIN'),
                  const SizedBox(height: 8),
                  _MenuItem(
                    icon: Icons.grid_view_rounded,
                    title: 'Dashboard',
                    isActive: controller.selectedIndex == 0,
                    onTap: () => controller.changeIndex(0),
                  ),
                  _MenuItem(
                    icon: Icons.folder_rounded,
                    title: 'Projects',
                    isActive: controller.selectedIndex == 1,
                    onTap: () => controller.changeIndex(1),
                  ),
                  _MenuItem(
                    icon: Icons.calendar_month_rounded,
                    title: 'Calendar',
                    isActive: controller.selectedIndex == 2,
                    onTap: () => controller.changeIndex(2),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionLabel(context, 'ANALYTICS'),
                  const SizedBox(height: 8),
                  _MenuItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Reports',
                    isActive: controller.selectedIndex == 3,
                    onTap: () => controller.changeIndex(3),
                  ),
                  _MenuItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    isActive: controller.selectedIndex == 4,
                    onTap: () => controller.changeIndex(4),
                  ),
                ],
              ),
            ),
          ),
          _buildNewEntryButton(),
          const SizedBox(height: 16),
          Obx(
            () => _buildThemeToggle(
              context,
              isDark: themeService.themeMode == ThemeMode.dark ||
                  (themeService.themeMode == ThemeMode.system && isDark),
              onTap: themeService.toggleLightDark,
            ),
          ),
          const SizedBox(height: 16),
          _buildUserProfile(context),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(BuildContext context, String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, bottom: 2),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.textMutedColor(context).withValues(alpha: 0.7),
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(9),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryGlow],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(11),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.timer_outlined,
              color: Colors.white,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HourStack',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor(context),
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Freelance Tracker',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMutedColor(context),
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewEntryButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        width: double.infinity,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          gradient: const LinearGradient(
            colors: [AppColors.primary, Color(0xFF4F46E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.3),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(11),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'New Time Entry',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildThemeToggle(
    BuildContext context, {
    required bool isDark,
    required Future<void> Function() onTap,
  }) {
    final label = isDark ? 'Switch to Light' : 'Switch to Dark';
    final icon = isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            onTap();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.cardBackground(context),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderSubtle(context)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Theme',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor(context),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        label,
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondaryColor(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.swap_horiz_rounded,
                  size: 18,
                  color: AppColors.textMutedColor(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserProfile(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context).withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderSubtle(context).withValues(alpha: 0.8),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.7),
                  AppColors.primaryGlow.withValues(alpha: 0.5),
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text(
                'A',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Alex Morgan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor(context),
                  ),
                ),
                Text(
                  'Pro Plan',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.textMutedColor(context),
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_horiz_rounded,
            color: AppColors.textMutedColor(context),
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatefulWidget {
  final IconData icon;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<_MenuItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final isHighlighted = widget.isActive || _hovering;
    final activeTextColor = AppColors.isDark(context)
        ? AppColors.primaryGlow
        : AppColors.primary;
    final defaultTextColor = isHighlighted
        ? AppColors.textPrimaryColor(context)
        : AppColors.textSecondaryColor(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: widget.isActive
                ? AppColors.sidebarActive(context)
                : (_hovering
                    ? AppColors.cardBackground(context).withValues(alpha: 0.7)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            border: widget.isActive
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.16),
                  )
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      widget.icon,
                      color: widget.isActive
                          ? activeTextColor
                          : defaultTextColor,
                      size: 19,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.isActive
                            ? activeTextColor
                            : defaultTextColor,
                        fontSize: 13,
                        fontWeight: widget.isActive
                            ? FontWeight.w600
                            : FontWeight.w500,
                        letterSpacing: 0.1,
                      ),
                    ),
                    if (widget.isActive) ...[
                      const Spacer(),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: activeTextColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: activeTextColor.withValues(alpha: 0.35),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
