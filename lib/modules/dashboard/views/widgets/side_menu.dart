import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../main/controllers/main_controller.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<MainController>();

    return Container(
      width: 272,
      decoration: BoxDecoration(
        color: AppColors.darkSidebar,
        border: Border(
          right: BorderSide(
            color: AppColors.darkBorderSubtle.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 28),
          _buildLogo(),
          const SizedBox(height: 36),
          Expanded(
            child: Obx(
              () => ListView(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                children: [
                  _buildSectionLabel('MAIN'),
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
                  _buildSectionLabel('ANALYTICS'),
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
          _buildUserProfile(),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 14, bottom: 2),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.darkTextMuted.withValues(alpha: 0.7),
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  Widget _buildLogo() {
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
              const Text(
                'HourStack',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkTextPrimary,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Freelance Tracker',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.darkTextMuted,
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

  Widget _buildUserProfile() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.darkCard.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.darkBorderSubtle.withValues(alpha: 0.4),
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
                const Text(
                  'Alex Morgan',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
                Text(
                  'Pro Plan',
                  style: TextStyle(
                    fontSize: 11,
                    color: AppColors.darkTextMuted,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.more_horiz_rounded,
            color: AppColors.darkTextMuted,
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
                ? AppColors.darkSidebarActive
                : (_hovering
                    ? AppColors.darkCard.withValues(alpha: 0.4)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(10),
            border: widget.isActive
                ? Border.all(
                    color: AppColors.primary.withValues(alpha: 0.2),
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
                          ? AppColors.primaryGlow
                          : (isHighlighted
                              ? AppColors.darkTextPrimary
                              : AppColors.darkTextSecondary),
                      size: 19,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      widget.title,
                      style: TextStyle(
                        color: widget.isActive
                            ? AppColors.primaryGlow
                            : (isHighlighted
                                ? AppColors.darkTextPrimary
                                : AppColors.darkTextSecondary),
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
                          color: AppColors.primaryGlow,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primaryGlow.withValues(alpha: 0.5),
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
