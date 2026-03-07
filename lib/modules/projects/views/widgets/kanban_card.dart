import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../data/models/task_model.dart';

class KanbanCard extends StatelessWidget {
  final TaskModel task;
  final bool isRecording;
  final VoidCallback? onTap;
  final VoidCallback? onPlayPressed;

  const KanbanCard({
    super.key,
    required this.task,
    this.isRecording = false,
    this.onTap,
    this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Draggable<TaskModel>(
      data: task,
      feedback: Material(
        color: Colors.transparent,
        child: SizedBox(width: 300, child: _buildCardContent(isDragging: true)),
      ),
      childWhenDragging: Opacity(opacity: 0.3, child: _buildCardContent()),
      child: _buildCardContent(),
    );
  }

  Widget _buildCardContent({bool isDragging = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isRecording ? AppColors.primary : AppColors.border,
          width: isRecording ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDragging ? 0.08 : 0.04),
            blurRadius: isDragging ? 15 : 10,
            offset: Offset(0, isDragging ? 8 : 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildPriorityLabel(),
                    if (isRecording)
                      _buildRecordingIndicator()
                    else
                      IconButton(
                        onPressed: onPlayPressed,
                        icon: const Icon(
                          Icons.play_circle_outline_rounded,
                          color: AppColors.textHint,
                          size: 24,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  task.title,
                  style: AppTextStyles.h3.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          size: 16,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(task.trackedMinutes / 60).toStringAsFixed(1)}h / ${task.estimatedHours}h',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    _buildUserAvatar(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPriorityLabel() {
    String label = task.status == TaskStatus.done
        ? 'COMPLETED'
        : task.priority.name.toUpperCase();
    Color bgColor = _getPriorityColor(task);
    Color textColor = bgColor.withOpacity(0.8);

    if (task.status == TaskStatus.done) {
      bgColor = const Color(0xFFE8F5E9);
      textColor = const Color(0xFF2E7D32);
    } else if (task.priority == TaskPriority.high) {
      bgColor = const Color(0xFFFFF1F0);
      textColor = const Color(0xFFF5222D);
    } else if (task.priority == TaskPriority.medium) {
      bgColor = const Color(0xFFF0F5FF);
      textColor = const Color(0xFF2F54EB);
    } else {
      bgColor = AppColors.background;
      textColor = AppColors.textSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: AppTextStyles.bodySmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w700,
          fontSize: 10,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return Row(
      children: [
        Text(
          'RECORDING',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w800,
            fontSize: 10,
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.pause_circle_filled_rounded,
          color: AppColors.primary,
          size: 28,
        ),
      ],
    );
  }

  Widget _buildUserAvatar() {
    return Container(
      width: 24,
      height: 24,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.background,
      ),
      child: const Icon(
        Icons.person_outline,
        size: 14,
        color: AppColors.textSecondary,
      ),
    );
  }

  Color _getPriorityColor(TaskModel task) {
    switch (task.priority) {
      case TaskPriority.high:
        return const Color(0xFFF5222D);
      case TaskPriority.medium:
        return const Color(0xFF2F54EB);
      case TaskPriority.low:
        return const Color(0xFF52C41A);
    }
  }
}
