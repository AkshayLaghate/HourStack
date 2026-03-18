import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/project_model.dart';
import '../../projects/controllers/project_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../controllers/timer_controller.dart';
import '../../../app/utils/number_extensions.dart';

class FocusView extends StatelessWidget {
  const FocusView({super.key});

  @override
  Widget build(BuildContext context) {
    final timerController = Get.find<TimerController>();
    final dashboardController = Get.find<DashboardController>();
    final projectController = Get.find<ProjectController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 200,
        leading: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_bottom_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'HourStack',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text(
              'Timer',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Projects',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text(
              'Reports',
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: const BoxDecoration(
              color: AppColors.background,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: AppColors.textSecondary,
                size: 20,
              ),
              onPressed: () {},
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 24.0, left: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFFED7AA),
              child: Text(
                'AL',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.brown,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          children: [
            // Main Timer Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Session Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.circle,
                          size: 8,
                          color: AppColors.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'CURRENT SESSION',
                          style: TextStyle(
                            color: AppColors.primary.withOpacity(0.8),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Timer text
                  Obx(
                    () => Text(
                      timerController.formattedTime,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Text(
                      timerController.selectedTask.value?.title ??
                          'Working on UI Design for Dashboard',
                      style: const TextStyle(
                        color: AppColors.textHint,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Project Selection
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Active Project',
                      style: TextStyle(
                        color: AppColors.textPrimary.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(
                    () => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<ProjectModel>(
                          value: timerController.selectedProject.value,
                          hint: const Text('Select Project'),
                          isExpanded: true,
                          items: projectController.projects.map((p) {
                            return DropdownMenuItem(
                              value: p,
                              child: Text(p.name),
                            );
                          }).toList(),
                          onChanged: timerController.isTimerRunning.value
                              ? null
                              : (p) => timerController.setProject(p),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Start/Stop Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Obx(() {
                          final isRunning =
                              timerController.isTimerRunning.value;
                          final isPaused = timerController.isPaused.value;
                          return ElevatedButton.icon(
                            onPressed: () {
                              if (isRunning) {
                                if (isPaused) {
                                  timerController.resumeTimer();
                                } else {
                                  timerController.pauseTimer();
                                }
                              } else {
                                timerController.startTimer();
                              }
                            },
                            icon: Icon(
                              isRunning && !isPaused
                                  ? Icons.pause_rounded
                                  : Icons.play_arrow_rounded,
                              size: 20,
                            ),
                            label: Text(
                              isRunning && !isPaused
                                  ? 'Pause'
                                  : (isPaused ? 'Resume' : 'Start Timer'),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            timerController.stopTimer();
                            Get.back();
                          },
                          icon: const Icon(Icons.stop_rounded, size: 20),
                          label: const Text(
                            'Stop',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            side: const BorderSide(color: AppColors.border),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Stats Cards
            Obx(
              () => Row(
                children: [
                  Expanded(
                    child: _buildStatCard(
                      'Today\'s Total Hours',
                      dashboardController.periodTotalHours.value
                          .toDurationString(),
                      '+1.2%',
                      AppColors.successLight,
                      AppColors.success,
                      Icons.access_time_filled_rounded,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildStatCard(
                      'Today\'s Revenue',
                      dashboardController.periodTotalRevenue.value.toCurrency(),
                      '+15%',
                      AppColors.infoLight,
                      AppColors.info,
                      Icons.payments_rounded,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Bottom Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBottomAction(Icons.notes_rounded, 'Add Note'),
                const SizedBox(width: 24),
                _buildBottomAction(Icons.local_offer_outlined, 'Add Tags'),
                const SizedBox(width: 24),
                _buildBottomAction(Icons.settings_outlined, 'Timer Settings'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    String trend,
    Color bgColor,
    Color iconColor,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      trend,
                      style: TextStyle(
                        color: iconColor,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAction(IconData icon, String label) {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
