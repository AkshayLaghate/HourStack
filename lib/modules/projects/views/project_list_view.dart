import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/project_controller.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';

import 'widgets/project_card.dart';
import 'widgets/new_project_card.dart';
import 'widgets/monthly_goal_card.dart';
import 'widgets/create_project_dialog.dart';

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
                    return const Center(child: CircularProgressIndicator());
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
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: 'Search projects...',
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    size: 20,
                    color: AppColors.textHint,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          ElevatedButton.icon(
            onPressed: () =>
                Get.dialog(const CreateProjectDialog()), // Trigger Add Project
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
              Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textSecondary,
              ),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.red,
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
        Text('Projects', style: AppTextStyles.h1),
        SizedBox(height: 8),
        Text(
          'Overview of your active freelance engagements and billable hours.',
          style: AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  void _showAddProjectDialog(BuildContext context) {
    Get.dialog(const CreateProjectDialog());
  }
}
