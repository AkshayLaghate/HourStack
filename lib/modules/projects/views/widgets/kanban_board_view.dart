import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../data/models/task_model.dart';
import '../../../../data/models/project_model.dart';
import '../../../kanban/controllers/kanban_controller.dart';
import '../../../tasks/widgets/task_form_dialog.dart';
import 'kanban_column.dart';

class KanbanBoardView extends StatefulWidget {
  final ProjectModel project;
  const KanbanBoardView({super.key, required this.project});

  @override
  State<KanbanBoardView> createState() => _KanbanBoardViewState();
}

class _KanbanBoardViewState extends State<KanbanBoardView> {
  late final KanbanController controller;
  int _activeSubTabIndex = 0;
  final String _activeTaskId =
      'task-2'; // This should ideally come from a timer controller

  @override
  void initState() {
    super.initState();
    controller = Get.find<KanbanController>();
    // Use addPostFrameCallback to avoid setState during build if setProject
    // triggers an immediate update that Obx might react to while building.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        controller.setProject(widget.project);
      }
    });
  }

  @override
  void didUpdateWidget(KanbanBoardView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.project.id != widget.project.id) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          controller.setProject(widget.project);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSubNavigation(),
          const SizedBox(height: 8),
          const Divider(color: AppColors.divider),
          const SizedBox(height: 32),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  KanbanColumn(
                    title: 'Backlog',
                    status: TaskStatus.backlog,
                    tasks: controller.getTasksForStatus(TaskStatus.backlog),
                    onAddPressed: () => Get.dialog(
                      const TaskFormDialog(initialStatus: TaskStatus.backlog),
                    ),
                    onTaskTap: (task) => Get.dialog(TaskFormDialog(task: task)),
                  ),
                  KanbanColumn(
                    title: 'In Progress',
                    status: TaskStatus.inProgress,
                    tasks: controller.getTasksForStatus(TaskStatus.inProgress),
                    activeTaskId: _activeTaskId,
                    onAddPressed: () => Get.dialog(
                      const TaskFormDialog(
                        initialStatus: TaskStatus.inProgress,
                      ),
                    ),
                    onTaskTap: (task) => Get.dialog(TaskFormDialog(task: task)),
                  ),
                  KanbanColumn(
                    title: 'Review',
                    status: TaskStatus.review,
                    tasks: controller.getTasksForStatus(TaskStatus.review),
                    onAddPressed: () => Get.dialog(
                      const TaskFormDialog(initialStatus: TaskStatus.review),
                    ),
                    onTaskTap: (task) => Get.dialog(TaskFormDialog(task: task)),
                  ),
                  KanbanColumn(
                    title: 'Done',
                    status: TaskStatus.done,
                    tasks: controller.getTasksForStatus(TaskStatus.done),
                    onAddPressed: () => Get.dialog(
                      const TaskFormDialog(initialStatus: TaskStatus.done),
                    ),
                    onTaskTap: (task) => Get.dialog(TaskFormDialog(task: task)),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSubNavigation() {
    return Row(
      children: [
        _buildSubTab(0, Icons.dashboard_customize_outlined, 'Board View'),
        const SizedBox(width: 32),
        _buildSubTab(1, Icons.table_chart_outlined, 'Table View'),
        const SizedBox(width: 32),
        _buildSubTab(2, Icons.timeline_outlined, 'Timeline'),
        const Spacer(),
        TextButton.icon(
          onPressed: () => controller.seedMockTasks(),
          icon: const Icon(Icons.auto_awesome, size: 18),
          label: const Text('Seed Tasks'),
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: AppColors.primary.withOpacity(0.2)),
            ),
          ),
        ),
        const SizedBox(width: 40),
      ],
    );
  }

  Widget _buildSubTab(int index, IconData icon, String label) {
    bool isActive = _activeSubTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _activeSubTabIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.primary : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isActive ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isActive ? AppColors.primary : AppColors.textSecondary,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
