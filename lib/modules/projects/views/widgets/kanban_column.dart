import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../data/models/task_model.dart';
import '../../../kanban/controllers/kanban_controller.dart';
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
    return DragTarget<TaskModel>(
      onWillAcceptWithDetails: (details) => details.data.status != status,
      onAcceptWithDetails: (details) {
        final task = details.data;
        try {
          final controller = Get.find<KanbanController>();
          controller.updateTaskStatus(task, status);
        } catch (e) {
          debugPrint('Error updating task status: $e');
        }
      },
      builder: (context, candidateData, rejectedData) {
        bool isHovering = candidateData.isNotEmpty;

        return Container(
          width: 320,
          margin: const EdgeInsets.only(right: 24),
          decoration: BoxDecoration(
            color: isHovering
                ? AppColors.primary.withValues(alpha: 0.06)
                : AppColors.darkSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isHovering
                  ? AppColors.primary.withValues(alpha: 0.3)
                  : AppColors.darkBorder.withValues(alpha: 0.3),
              width: isHovering ? 2 : 1,
            ),
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
      },
    );
  }

  Widget _buildHeader() {
    bool isStatusActive = status == TaskStatus.inProgress;
    Color countBgColor = isStatusActive
        ? AppColors.primary
        : AppColors.darkTextMuted.withValues(alpha: 0.2);
    Color countTextColor = isStatusActive
        ? Colors.white
        : AppColors.darkTextSecondary;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                  color: AppColors.darkTextSecondary,
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
                  style: TextStyle(
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
              color: AppColors.darkTextMuted,
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
