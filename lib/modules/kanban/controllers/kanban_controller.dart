import 'dart:async';
import 'package:get/get.dart';
import '../../../data/models/task_model.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/task_repository.dart';

class KanbanController extends GetxController {
  final TaskRepository _repository = TaskRepository();

  Rxn<ProjectModel> currentProject = Rxn<ProjectModel>();

  final RxList<TaskModel> allTasks = <TaskModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    // ProjectModel might be passed as arguments, but also might be set manually
    if (Get.arguments is ProjectModel) {
      setProject(Get.arguments as ProjectModel);
    }
  }

  void setProject(ProjectModel project) {
    if (currentProject.value?.id == project.id) return;

    try {
      currentProject.value = project;
      isLoading.value = true;
      allTasks.clear();

      // Clear any previous bindings and listeners
      allTasks.bindStream(_repository.getTasksStream(project.id));

      // Listen for the first update to stop loading
      StreamSubscription? sub;
      sub = allTasks.listen(
        (tasks) {
          if (isLoading.value) {
            isLoading.value = false;
            sub?.cancel();
          }
        },
        onError: (error) {
          isLoading.value = false;
          Get.snackbar('Error', 'Failed to load tasks: $error');
          sub?.cancel();
        },
      );
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Failed to initialize Kanban: $e');
    }
  }

  List<TaskModel> getTasksForStatus(TaskStatus status) {
    return allTasks.where((task) => task.status == status).toList();
  }

  Future<void> addTask(
    String title,
    String description,
    double estimatedHours,
    TaskPriority priority, {
    TaskStatus? status,
    DateTime? dueDate,
  }) async {
    final newTask = TaskModel(
      id: '',
      title: title,
      description: description,
      estimatedHours: estimatedHours,
      priority: priority,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      status: status ?? TaskStatus.backlog,
      dueDate: dueDate,
    );
    try {
      if (currentProject.value == null) return;
      await _repository.addTask(currentProject.value!.id, newTask);
      Get.back();
      Get.snackbar('Success', 'Task added to Backlog');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add task: $e');
    }
  }

  Future<void> updateTaskStatus(TaskModel task, TaskStatus newStatus) async {
    if (task.status == newStatus) return; // No change

    try {
      if (currentProject.value == null) return;
      await _repository.updateTaskStatus(
        currentProject.value!.id,
        task.id,
        newStatus,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update task status: $e');
    }
  }

  Future<void> deleteTask(String taskId) async {
    try {
      if (currentProject.value == null) return;
      await _repository.deleteTask(currentProject.value!.id, taskId);
      Get.snackbar('Success', 'Task deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete task: $e');
    }
  }

  Future<void> seedMockTasks() async {
    final project = currentProject.value;
    if (project == null) {
      Get.snackbar('Error', 'No project selected');
      return;
    }

    final mockTasks = [
      TaskModel(
        id: '',
        title: 'Design System Audit',
        description: 'Review color tokens and typography consistency',
        estimatedHours: 4.0,
        priority: TaskPriority.high,
        status: TaskStatus.backlog,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      TaskModel(
        id: '',
        title: 'API Integration',
        description: 'Connect login flow with backend services',
        estimatedHours: 8.0,
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      TaskModel(
        id: '',
        title: 'Style Guide Documentation',
        description: 'Update Wiki with new component usage rules',
        estimatedHours: 2.0,
        priority: TaskPriority.low,
        status: TaskStatus.review,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      TaskModel(
        id: '',
        title: 'Project Setup',
        description: 'Initial repository setup and dependencies',
        estimatedHours: 2.0,
        priority: TaskPriority.medium,
        status: TaskStatus.done,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    try {
      for (var task in mockTasks) {
        await _repository.addTask(project.id, task);
      }
      Get.snackbar('Success', 'Dummy tasks added to ${project.name}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to seed tasks: $e');
    }
  }
}
