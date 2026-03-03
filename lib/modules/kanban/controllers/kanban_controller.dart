import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/task_repository.dart';

class KanbanController extends GetxController {
  final TaskRepository _repository = TaskRepository();

  late final ProjectModel currentProject;

  final RxList<TaskModel> allTasks = <TaskModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // ProjectModel is passed as arguments to the Get page
    currentProject = Get.arguments as ProjectModel;

    allTasks.bindStream(_repository.getTasksStream(currentProject.id));
    ever(allTasks, (_) {
      if (isLoading.value) isLoading.value = false;
    });
  }

  List<TaskModel> getTasksForStatus(TaskStatus status) {
    return allTasks.where((task) => task.status == status).toList();
  }

  Future<void> addTask(
    String title,
    String description,
    double estimatedHours,
    TaskPriority priority,
  ) async {
    final newTask = TaskModel(
      id: '',
      title: title,
      description: description,
      estimatedHours: estimatedHours,
      priority: priority,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: TaskStatus.backlog,
    );
    try {
      await _repository.addTask(currentProject.id, newTask);
      Get.back();
      Get.snackbar('Success', 'Task added to Backlog');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: $e');
    }
  }

  Future<void> updateTaskStatus(TaskModel task, TaskStatus newStatus) async {
    if (task.status == newStatus) return; // No change

    try {
      await _repository.updateTaskStatus(currentProject.id, task.id, newStatus);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task status: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      await _repository.deleteTask(currentProject.id, taskId);
      Get.snackbar('Success', 'Task deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: $e');
    }
  }
}
