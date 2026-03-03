import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../data/models/task_model.dart';
import 'kanban_card.dart';

class KanbanColumn extends StatelessWidget {
  final String title;
  final List<TaskModel> tasks;
  final TaskStatus status;
  final String? activeTaskId;
  final VoidCallback? onAddPressed;
  final Function(TaskModel)? onTaskTap;
  final Function(TaskModel)? onTaskPlay;

  const KanbanColumn({
    super.key,
    required this.title,
    required this.tasks,
    required this.status,
    this.activeTaskId,
    this.onAddPressed,
    this.onTaskTap,
    this.onTaskPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      margin: const EdgeInsets.only(right: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return KanbanCard(
                  task: task,
                  isRecording: task.id == activeTaskId,
                  onTap: () => onTaskTap?.call(task),
                  onPlayPressed: () => onTaskPlay?.call(task),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    bool isStatusActive = status == TaskStatus.inProgress;
    Color countBgColor = isStatusActive
        ? AppColors.primary
        : AppColors.textHint.withOpacity(0.2);
    Color countTextColor = isStatusActive
        ? Colors.white
        : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title.toUpperCase(),
                style: AppTextStyles.h3.copyWith(
                  fontSize: 14,
                  letterSpacing: 1.2,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: countBgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${tasks.length}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: countTextColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: onAddPressed,
            icon: const Icon(
              Icons.add_circle_outline_rounded,
              color: AppColors.textHint,
              size: 24,
            ),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
