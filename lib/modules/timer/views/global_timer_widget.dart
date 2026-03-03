import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/timer_controller.dart';
import '../../../data/models/project_model.dart';
import '../../../modules/projects/controllers/project_controller.dart';

class GlobalTimerWidget extends StatelessWidget {
  const GlobalTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Put TimerController if not present (usually initialized in Dashboard routing or bindings)
    final timerController = Get.put(TimerController(), permanent: true);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[900] : Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withOpacity(0.2))),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Project Selector
            Expanded(
              flex: 2,
              child: Obx(() {
                final projectCtrl = Get.isRegistered<ProjectController>()
                    ? Get.find<ProjectController>()
                    : Get.put(ProjectController());
                final projects = projectCtrl.projects;

                return DropdownButtonHideUnderline(
                  child: DropdownButton<ProjectModel>(
                    isExpanded: true,
                    hint: const Text('Select Project...'),
                    value: timerController.selectedProject.value,
                    items: projects
                        .map(
                          (p) => DropdownMenuItem(
                            value: p,
                            child: Text(
                              p.name,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: timerController.isTimerRunning.value
                        ? null
                        : (val) {
                            timerController.selectedProject.value = val;
                            timerController.selectedTask.value =
                                null; // reset task
                          },
                  ),
                );
              }),
            ),
            const SizedBox(width: 16),
            // Time Display
            Obx(
              () => Text(
                timerController.formattedTime,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Start/Stop Button
            Obx(
              () => IconButton(
                icon: Icon(
                  timerController.isTimerRunning.value
                      ? Icons.stop_circle
                      : Icons.play_circle_fill,
                  color: timerController.isTimerRunning.value
                      ? Colors.red
                      : Colors.green,
                  size: 36,
                ),
                onPressed: () {
                  if (timerController.isTimerRunning.value) {
                    timerController.stopTimer();
                  } else {
                    timerController.startTimer();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
