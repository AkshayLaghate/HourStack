import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/kanban_controller.dart';
import '../../../data/models/task_model.dart';
import '../../tasks/widgets/task_form_dialog.dart';

class KanbanView extends GetView<KanbanController> {
  const KanbanView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${controller.currentProject.value?.name ?? ""} Board',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  tooltip: 'Add Task',
                  onPressed: () => Get.dialog(const TaskFormDialog()),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(16),
              children: [
                _buildKanbanColumn(context, 'Backlog', TaskStatus.backlog),
                const SizedBox(width: 16),
                _buildKanbanColumn(
                  context,
                  'In Progress',
                  TaskStatus.inProgress,
                ),
                const SizedBox(width: 16),
                _buildKanbanColumn(context, 'Review', TaskStatus.review),
                const SizedBox(width: 16),
                _buildKanbanColumn(context, 'Done', TaskStatus.done),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildKanbanColumn(
    BuildContext context,
    String title,
    TaskStatus status,
  ) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Get.isDarkMode ? Colors.grey[800] : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$title (${controller.getTasksForStatus(status).length})',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add, size: 20),
                  onPressed: () =>
                      Get.dialog(TaskFormDialog(initialStatus: status)),
                ),
              ],
            ),
          ),
          Expanded(
            child: DragTarget<TaskModel>(
              onWillAcceptWithDetails: (details) =>
                  details.data.status != status, // accept if different
              onAcceptWithDetails: (details) {
                controller.updateTaskStatus(details.data, status);
              },
              builder: (context, candidateData, rejectedData) {
                final tasks = controller.getTasksForStatus(status);

                return Container(
                  color: candidateData.isNotEmpty
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.transparent,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return Draggable<TaskModel>(
                        data: task,
                        feedback: Material(
                          elevation: 4,
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 280),
                            child: _buildTaskCard(task),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.3,
                          child: _buildTaskCard(task),
                        ),
                        child: _buildTaskCard(task),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskCard(TaskModel task) {
    Color priorityColor = Colors.grey;
    if (task.priority == TaskPriority.high) priorityColor = Colors.red;
    if (task.priority == TaskPriority.medium) priorityColor = Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {
          // Open detail view or full screen editor
        },
        onLongPress: () {
          controller.deleteTask(task.id);
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: priorityColor,
                    ),
                  ),
                ],
              ),
              if (task.description.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  task.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Est: ${task.estimatedHours}h',
                    style: const TextStyle(fontSize: 12),
                  ),
                  Text(
                    'Tracked: ${(task.trackedMinutes / 60).toStringAsFixed(1)}h',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
