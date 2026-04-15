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
          colors: [Color(0xFF1A1545), Color(0xFF161040)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.12),
            blurRadius: 24,
            offset: const Offset(0, 8),
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
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: timerController.isTimerRunning.value
                              ? (timerController.isPaused.value
                                    ? AppColors.amberGlow
                                    : AppColors.greenGlow)
                              : AppColors.darkTextMuted,
                          shape: BoxShape.circle,
                          boxShadow: timerController.isTimerRunning.value
                              ? [
                                  BoxShadow(
                                    color: (timerController.isPaused.value
                                            ? AppColors.amberGlow
                                            : AppColors.greenGlow)
                                        .withValues(alpha: 0.6),
                                    blurRadius: 6,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        timerController.isTimerRunning.value
                            ? (timerController.isPaused.value
                                  ? 'PAUSED'
                                  : 'TRACKING')
                            : 'IDLE',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.more_horiz_rounded,
                color: Colors.white.withValues(alpha: 0.3),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 20),
          Obx(
            () => timerController.isTimerRunning.value
                ? Text(
                    'Project: ${timerController.selectedProject.value?.name ?? "None"}',
                    style: TextStyle(
                      color: AppColors.primaryGlow.withValues(alpha: 0.7),
                      fontSize: 13,
                    ),
                  )
                : _SelectionTrigger(
                    label:
                        timerController.selectedProject.value?.name ??
                        'Select Project',
                    icon: Icons.folder_open_rounded,
                    onTap: () => _showProjectSelectionSheet(context),
                    isLabelBold: true,
                    fontSize: 16,
                  ),
          ),
          const SizedBox(height: 10),
          Obx(
            () => timerController.isTimerRunning.value
                ? Text(
                    timerController.selectedTask.value?.title ??
                        'No Task Active',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
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
                          backgroundColor: AppColors.darkCard,
                          colorText: AppColors.darkTextPrimary,
                        );
                      } else {
                        _showTaskSelectionSheet(context);
                      }
                    },
                    isLabelBold: true,
                    fontSize: 16,
                  ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Obx(
              () => Text(
                timerController.formattedTime,
                style: TextStyle(
                  color: AppColors.darkTextPrimary,
                  fontSize: 44,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 3,
                  fontFamily: 'monospace',
                  shadows: [
                    Shadow(
                      color: AppColors.primaryGlow.withValues(alpha: 0.3),
                      blurRadius: 20,
                    ),
                  ],
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
                          Get.snackbar(
                            'Info',
                            'Please select a project first',
                            backgroundColor: AppColors.darkCard,
                            colorText: AppColors.darkTextPrimary,
                          );
                        } else {
                          await timerController.startTimer();
                        }
                      }
                    },
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: timerController.isTimerRunning.value
                              ? [AppColors.roseGlow, const Color(0xFFE11D48)]
                              : [AppColors.primary, const Color(0xFF4F46E5)],
                        ),
                        borderRadius: BorderRadius.circular(11),
                        boxShadow: [
                          BoxShadow(
                            color: (timerController.isTimerRunning.value
                                    ? AppColors.roseGlow
                                    : AppColors.primary)
                                .withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          timerController.isTimerRunning.value
                              ? 'Stop'
                              : 'Start Timer',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
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
                  padding: const EdgeInsets.only(left: 10),
                  child: GestureDetector(
                    onTap: () {
                      if (timerController.isPaused.value) {
                        timerController.resumeTimer();
                      } else {
                        timerController.pauseTimer();
                      }
                    },
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(11),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.06),
                        ),
                      ),
                      child: Icon(
                        timerController.isPaused.value
                            ? Icons.play_arrow_rounded
                            : Icons.pause_rounded,
                        color: Colors.white.withValues(alpha: 0.8),
                        size: 20,
                      ),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  if (timerController.isTimerRunning.value) {
                    Get.toNamed(Routes.FOCUS);
                  } else {
                    Get.snackbar(
                      'Timer Not Running',
                      'Please start the timer to enter Focus Mode.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: AppColors.darkCard,
                      colorText: AppColors.darkTextPrimary,
                    );
                  }
                },
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.06),
                    ),
                  ),
                  child: Icon(
                    Icons.fullscreen_rounded,
                    color: Colors.white.withValues(alpha: 0.8),
                    size: 20,
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
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border(
            top: BorderSide(color: AppColors.darkBorder.withValues(alpha: 0.5)),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 12),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.darkBorder,
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
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.darkTextPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close_rounded, size: 20),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.darkCard,
                      foregroundColor: AppColors.darkTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1,
              color: AppColors.darkBorderSubtle,
            ),
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
                              size: 44,
                              color: AppColors.darkTextMuted,
                            ),
                            const SizedBox(height: 14),
                            Text(
                              'No items found',
                              style: TextStyle(
                                color: AppColors.darkTextSecondary,
                                fontSize: 15,
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
                color: AppColors.primaryGlow.withValues(alpha: 0.6),
                size: fontSize + 2,
              ),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: fontSize,
                    fontWeight: isLabelBold ? FontWeight.w700 : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.white.withValues(alpha: 0.4),
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
      padding: const EdgeInsets.only(bottom: 6),
      child: Material(
        color: isSelected
            ? AppColors.primary.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                if (color != null)
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: color!.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  )
                else if (icon != null)
                  Icon(icon, color: AppColors.primaryGlow, size: 18),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: isSelected
                              ? AppColors.primaryGlow
                              : AppColors.darkTextPrimary,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          subtitle!,
                          style: TextStyle(
                            fontSize: 11,
                            color: AppColors.darkTextMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    color: AppColors.primaryGlow,
                    size: 18,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
