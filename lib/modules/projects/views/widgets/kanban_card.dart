import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
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
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isRecording
              ? AppColors.primary.withValues(alpha: 0.5)
              : AppColors.darkBorder.withValues(alpha: 0.4),
          width: isRecording ? 2 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isRecording
                ? AppColors.primary.withValues(alpha: 0.1)
                : Colors.black.withValues(alpha: isDragging ? 0.2 : 0.1),
            blurRadius: isDragging ? 15 : 10,
            offset: Offset(0, isDragging ? 8 : 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
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
                          color: AppColors.darkTextMuted,
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
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkTextPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  task.description,
                  style: const TextStyle(
                    color: AppColors.darkTextSecondary,
                    height: 1.5,
                    fontSize: 13,
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
                          color: AppColors.primaryGlow,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(task.trackedMinutes / 60).toStringAsFixed(1)}h / ${task.estimatedHours}h',
                          style: const TextStyle(
                            color: AppColors.darkTextPrimary,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
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
    Color bgColor;
    Color textColor;

    if (task.status == TaskStatus.done) {
      bgColor = AppColors.success.withValues(alpha: 0.12);
      textColor = AppColors.greenGlow;
    } else if (task.priority == TaskPriority.high) {
      bgColor = AppColors.error.withValues(alpha: 0.12);
      textColor = AppColors.roseGlow;
    } else if (task.priority == TaskPriority.medium) {
      bgColor = AppColors.primary.withValues(alpha: 0.12);
      textColor = AppColors.primaryGlow;
    } else {
      bgColor = AppColors.darkBorder.withValues(alpha: 0.3);
      textColor = AppColors.darkTextSecondary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
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
        const Text(
          'RECORDING',
          style: TextStyle(
            color: AppColors.primaryGlow,
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
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.darkBorder.withValues(alpha: 0.3),
      ),
      child: const Icon(
        Icons.person_outline,
        size: 14,
        color: AppColors.darkTextMuted,
      ),
    );
  }
}
