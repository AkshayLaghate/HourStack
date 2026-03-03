import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../data/models/task_model.dart';
import 'kanban_column.dart';

class KanbanBoardView extends StatefulWidget {
  const KanbanBoardView({super.key});

  @override
  State<KanbanBoardView> createState() => _KanbanBoardViewState();
}

class _KanbanBoardViewState extends State<KanbanBoardView> {
  int _activeSubTabIndex = 0;
  final String _activeTaskId = 'task-2'; // Mock active task ID

  @override
  Widget build(BuildContext context) {
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
                  tasks: _getMockTasks(TaskStatus.backlog),
                  onAddPressed: () {},
                ),
                KanbanColumn(
                  title: 'In Progress',
                  status: TaskStatus.inProgress,
                  tasks: _getMockTasks(TaskStatus.inProgress),
                  activeTaskId: _activeTaskId,
                  onAddPressed: () {},
                ),
                KanbanColumn(
                  title: 'Review',
                  status: TaskStatus.review,
                  tasks: _getMockTasks(TaskStatus.review),
                  onAddPressed: () {},
                ),
                KanbanColumn(
                  title: 'Done',
                  status: TaskStatus.done,
                  tasks: _getMockTasks(TaskStatus.done),
                  onAddPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubNavigation() {
    return Row(
      children: [
        _buildSubTab(0, Icons.dashboard_customize_outlined, 'Board View'),
        const SizedBox(width: 32),
        _buildSubTab(1, Icons.table_chart_outlined, 'Table View'),
        const SizedBox(width: 32),
        _buildSubTab(2, Icons.timeline_outlined, 'Timeline'),
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

  List<TaskModel> _getMockTasks(TaskStatus status) {
    switch (status) {
      case TaskStatus.backlog:
        return [
          TaskModel(
            id: 'task-1',
            title: 'Mobile Wireframes V2',
            description:
                'Complete the remaining screens for the onboarding flow and user profile...',
            status: TaskStatus.backlog,
            priority: TaskPriority.medium,
            estimatedHours: 8,
            trackedMinutes: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          TaskModel(
            id: 'task-5',
            title: 'Client API Integration',
            description:
                'Connect the dashboard cards to the real-time analytics API for live metrics.',
            status: TaskStatus.backlog,
            priority: TaskPriority.high,
            estimatedHours: 5,
            trackedMinutes: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
      case TaskStatus.inProgress:
        return [
          TaskModel(
            id: 'task-2',
            title: 'Dark Mode Implementation',
            description:
                'Applying the dark theme palette across all major UI components and testing...',
            status: TaskStatus.inProgress,
            priority: TaskPriority.high,
            estimatedHours: 4,
            trackedMinutes: 150, // 2.5h
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          TaskModel(
            id: 'task-6',
            title: 'Project Icon Set',
            description:
                'Export and organize the custom Material Symbol based icons for the developer...',
            status: TaskStatus.inProgress,
            priority: TaskPriority.medium,
            estimatedHours: 3,
            trackedMinutes: 60, // 1h
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
      case TaskStatus.review:
        return [
          TaskModel(
            id: 'task-3',
            title: 'User Persona Docs',
            description:
                'Final polish on user interview transcripts and synthesized personas.',
            status: TaskStatus.review,
            priority: TaskPriority.medium,
            estimatedHours: 12,
            trackedMinutes: 720, // 12h
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
      case TaskStatus.done:
        return [
          TaskModel(
            id: 'task-4',
            title: 'Style Guide V1',
            description:
                'Initial draft of the core typography and color variables for the app.',
            status: TaskStatus.done,
            priority: TaskPriority.low,
            estimatedHours: 6,
            trackedMinutes: 360, // 6h
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
    }
  }
}
