import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/theme/app_colors.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/task_model.dart';
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
        leading: IconButton(
          icon: const Icon(
            Icons.close_fullscreen_rounded,
            color: AppColors.textSecondary,
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'HourStack',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: AppColors.textSecondary,
            ),
            onPressed: () {},
          ),
          const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFFED7AA),
              child: Text(
                'AL',
                style: TextStyle(fontSize: 10, color: Colors.brown),
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
                  const Text(
                    'SESSION 1 OF 4',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
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

                  const SizedBox(height: 16),

                  // Task Selection
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Working on Task',
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
                        child: DropdownButton<TaskModel>(
                          value: timerController.selectedTask.value,
                          hint: const Text('Select Task'),
                          isExpanded: true,
                          items: timerController.availableTasks.map((t) {
                            return DropdownMenuItem(
                              value: t,
                              child: Text(t.title),
                            );
                          }).toList(),
                          onChanged: timerController.isTimerRunning.value
                              ? null
                              : (t) => timerController.setTask(t),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Start/Stop Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => ElevatedButton.icon(
                            onPressed: timerController.isTimerRunning.value
                                ? null
                                : () => timerController.startTimer(),
                            icon: const Icon(Icons.play_arrow_rounded),
                            label: const Text('Start Timer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            timerController.stopTimer();
                            Get.back();
                          },
                          icon: const Icon(Icons.stop_rounded),
                          label: const Text('Stop'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.textPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            side: const BorderSide(color: AppColors.divider),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
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
                      '${dashboardController.periodTotalHours.value.toFormattedString(2)} hrs',
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  color: iconColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
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
