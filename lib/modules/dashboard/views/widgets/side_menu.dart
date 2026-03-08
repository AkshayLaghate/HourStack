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
      width: 280,
      color: AppColors.sidebar,
      child: Column(
        children: [
          const SizedBox(height: 32),
          _buildLogo(),
          const SizedBox(height: 48),
          Expanded(
            child: Obx(
              () => ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _MenuItem(
                    icon: Icons.dashboard_rounded,
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
                    icon: Icons.view_kanban_rounded,
                    title: 'Kanban',
                    isActive: controller.selectedIndex == 2,
                    onTap: () => controller.changeIndex(2),
                  ),
                  _MenuItem(
                    icon: Icons.calendar_month_rounded,
                    title: 'Calendar',
                    isActive: controller.selectedIndex == 3,
                    onTap: () => controller.changeIndex(3),
                  ),
                  _MenuItem(
                    icon: Icons.bar_chart_rounded,
                    title: 'Reports',
                    isActive: controller.selectedIndex == 4,
                    onTap: () => controller.changeIndex(4),
                  ),
                  _MenuItem(
                    icon: Icons.workspaces_outline,
                    title: 'Projects',
                    isActive: false,
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.people_outline_rounded,
                    title: 'Team',
                    isActive: false,
                    onTap: () {},
                  ),
                  _MenuItem(
                    icon: Icons.settings_rounded,
                    title: 'Settings',
                    isActive: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          _buildNewEntryButton(),
          const SizedBox(height: 24),
          _buildUserProfile(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.timer_rounded,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HourStack',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Freelance Tracker',
                style: TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewEntryButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(12),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text(
                  'New Time Entry',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundImage: const NetworkImage(
              'https://i.pravatar.cc/150?u=alex',
            ),
            onBackgroundImageError: (exception, stackTrace) {},
            child: const Icon(Icons.person_outline, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Alex Morgan',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Pro Plan',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.more_vert_rounded, color: AppColors.textHint, size: 20),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Icon(
          icon,
          color: isActive ? AppColors.primary : AppColors.textSecondary,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.primary : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
