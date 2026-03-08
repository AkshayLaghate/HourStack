import 'package:flutter/material.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/routes/app_pages.dart';
import '../../../projects/controllers/project_controller.dart';
import '../../../timer/controllers/timer_controller.dart';
import 'package:get/get.dart';

class TimerCard extends StatelessWidget {
  const TimerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final timerController = Get.find<TimerController>();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: timerController.isTimerRunning.value
                              ? (timerController.isPaused.value
                                    ? Colors.amberAccent
                                    : Colors.greenAccent)
                              : Colors.white54,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timerController.isTimerRunning.value
                            ? (timerController.isPaused.value
                                  ? 'PAUSED'
                                  : 'TRACKING')
                            : 'IDLE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.more_horiz_rounded,
                color: Colors.white.withOpacity(0.8),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(
            () => timerController.isTimerRunning.value
                ? Text(
                    'Project: ${timerController.selectedProject.value?.name ?? "None"}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  )
                : _SelectionTrigger(
                    label:
                        timerController.selectedProject.value?.name ??
                        'Select Project',
                    icon: Icons.folder_open_rounded,
                    onTap: () => _showProjectSelectionSheet(context),
                    isLabelBold: true,
                    fontSize: 18,
                  ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => timerController.isTimerRunning.value
                ? Text(
                    timerController.selectedTask.value?.title ??
                        'No Task Active',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : _SelectionTrigger(
                    label:
                        timerController.selectedTask.value?.title ??
                        'Select Task',
                    icon: Icons.assignment_outlined,
                    onTap: () {
                      if (timerController.selectedProject.value == null) {
                        Get.snackbar(
                          'Select Project',
                          'Please select a project first to see available tasks.',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.white.withOpacity(0.9),
                          colorText: AppColors.textPrimary,
                        );
                      } else {
                        _showTaskSelectionSheet(context);
                      }
                    },
                    isLabelBold: true,
                    fontSize: 18,
                  ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Obx(
              () => Text(
                timerController.formattedTime,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Obx(
                  () => GestureDetector(
                    onTap: () async {
                      if (timerController.isTimerRunning.value) {
                        await timerController.stopTimer();
                      } else {
                        if (timerController.selectedProject.value == null) {
                          Get.snackbar('Info', 'Please select a project first');
                        } else {
                          await timerController.startTimer();
                        }
                      }
                    },
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          timerController.isTimerRunning.value
                              ? 'Stop'
                              : 'Start Timer',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Obx(() {
                if (!timerController.isTimerRunning.value) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: GestureDetector(
                    onTap: () {
                      if (timerController.isPaused.value) {
                        timerController.resumeTimer();
                      } else {
                        timerController.pauseTimer();
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        timerController.isPaused.value
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: () {
                  if (timerController.isTimerRunning.value) {
                    Get.toNamed(Routes.FOCUS);
                  } else {
                    Get.snackbar(
                      'Timer Not Running',
                      'Please start the timer to enter Focus Mode.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.white.withOpacity(0.9),
                      colorText: AppColors.textPrimary,
                    );
                  }
                },
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.fullscreen_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showProjectSelectionSheet(BuildContext context) {
    final timerController = Get.find<TimerController>();
    final projects = Get.find<ProjectController>().projects;

    _showCustomSelectionSheet(
      context: context,
      title: 'Select Project',
      items: projects,
      itemBuilder: (project) => _SelectionItem(
        title: project.name,
        subtitle: project.clientName.isNotEmpty ? project.clientName : null,
        color: Color(project.colorValue),
        isSelected: timerController.selectedProject.value?.id == project.id,
        onTap: () {
          timerController.setProject(project);
          Get.back();
        },
      ),
    );
  }

  void _showTaskSelectionSheet(BuildContext context) {
    final timerController = Get.find<TimerController>();
    final tasks = timerController.availableTasks;

    _showCustomSelectionSheet(
      context: context,
      title: 'Select Task',
      items: tasks,
      itemBuilder: (task) => _SelectionItem(
        title: task.title,
        subtitle: task.status.name.capitalizeFirst,
        icon: Icons.assignment_outlined,
        isSelected: timerController.selectedTask.value?.id == task.id,
        onTap: () {
          timerController.setTask(task);
          Get.back();
        },
      ),
    );
  }

  void _showCustomSelectionSheet<T>({
    required BuildContext context,
    required String title,
    required List<T> items,
    required Widget Function(T) itemBuilder,
  }) {
    Get.bottomSheet(
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, size: 24),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.background,
                      foregroundColor: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: items.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 48,
                              color: AppColors.textHint,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No items found',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) =>
                          itemBuilder(items[index]),
                    ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _SelectionTrigger extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isLabelBold;
  final double fontSize;

  const _SelectionTrigger({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isLabelBold = false,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.white.withOpacity(0.8),
                size: fontSize + 2,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: fontSize,
                    fontWeight: isLabelBold ? FontWeight.bold : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white.withOpacity(0.6),
                size: fontSize + 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SelectionItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? color;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionItem({
    required this.title,
    this.subtitle,
    this.color,
    this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: isSelected ? AppColors.primaryLight : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (color != null)
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black12),
                    ),
                  )
                else if (icon != null)
                  Icon(icon, color: AppColors.primary, size: 20),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.w600,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  const Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primary,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
