import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/widgets/empty_state_widget.dart';

import 'widgets/project_card.dart';
import 'widgets/new_project_card.dart';
import 'widgets/monthly_goal_card.dart';
import 'widgets/project_form_dialog.dart';

class ProjectListView extends GetView<ProjectController> {
  const ProjectListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1200;

    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    );
                  }
                  if (controller.projects.isEmpty) {
                    return Column(
                      children: [
                        EmptyStateWidget(
                          icon: Icons.folder_open_rounded,
                          title: 'No Projects Yet',
                          description:
                              'Create your first project to start tracking time and managing your freelance work.',
                          actionLabel: 'Add Project',
                          onActionPressed: () => _showAddProjectDialog(context),
                        ),
                      ],
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isDesktop ? 4 : 2,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: controller.projects.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.projects.length) {
                        return NewProjectCard(
                          onTap: () => _showAddProjectDialog(context),
                        );
                      }
                      final project = controller.projects[index];
                      return ProjectCard(
                        project: project,
                        onTap: () {
                          controller.selectProject(project);
                        },
                      );
                    },
                  );
                }),
                const SizedBox(height: 48),
                Obx(() {
                  if (controller.projects.isEmpty) {
                    return const SizedBox.shrink();
                  }
                  double totalEarnings = 0;
                  for (var p in controller.projects) {
                    totalEarnings += p.monthlyHours * p.hourlyRate;
                  }
                  const goal = 35000.0;
                  final progress = (totalEarnings / goal).clamp(0.0, 1.0);

                  return MonthlyGoalCard(
                    totalEarning: totalEarnings,
                    goal: goal,
                    progress: progress,
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      decoration: const BoxDecoration(
        color: AppColors.darkSurface,
        border: Border(
          bottom: BorderSide(color: AppColors.darkDivider),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.loginDarkInputBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.loginDarkInputBorder),
              ),
              child: const TextField(
                style: TextStyle(
                  color: AppColors.darkTextPrimary,
                  fontSize: 14,
                ),
                cursorColor: AppColors.primaryGlow,
                decoration: InputDecoration(
                  hintText: 'Search projects...',
                  hintStyle: TextStyle(
                    color: AppColors.darkTextMuted,
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColors.darkTextMuted,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          ElevatedButton.icon(
            onPressed: () => Get.dialog(const ProjectFormDialog()),
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Project'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(width: 24),
          Stack(
            children: [
              const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.darkTextSecondary,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 8, minHeight: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Projects',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AppColors.darkTextPrimary,
            letterSpacing: -1,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Overview of your active freelance engagements and billable hours.',
          style: TextStyle(
            fontSize: 15,
            color: AppColors.darkTextSecondary,
          ),
        ),
      ],
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    Get.dialog(const ProjectFormDialog());
  }
}
