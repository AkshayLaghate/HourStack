import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../projects/controllers/project_controller.dart';

class TimerController extends GetxController {
  final SessionRepository _repository = SessionRepository();
  final TaskRepository _taskRepository = TaskRepository();

  // Active Timer State
  final RxBool isTimerRunning = false.obs;
  final RxBool isPaused = false.obs;
  final RxInt elapsedSeconds = 0.obs;

  // Current Selections
  final Rx<ProjectModel?> selectedProject = Rx<ProjectModel?>(null);
  final Rx<TaskModel?> selectedTask = Rx<TaskModel?>(null);
  final RxList<TaskModel> availableTasks = <TaskModel>[].obs;

  // Internal Tracking
  Timer? _ticker;
  SessionModel? _activeSession;
  StreamSubscription? _taskSubscription;

  @override
  void onInit() {
    super.onInit();
    _checkActiveSessions();

    // Auto-select first project if available
    final projectController = Get.find<ProjectController>();
    // Auto-select first project when available if nothing is selected
    once(projectController.projects, (_) {
      if (selectedProject.value == null &&
          projectController.projects.isNotEmpty) {
        setProject(projectController.projects.first);
      }
    });

    // Listen to project changes to update tasks
    ever(selectedProject, (ProjectModel? project) {
      if (project != null) {
        _loadTasksForProject(project.id);
      } else {
        availableTasks.clear();
        selectedTask.value = null;
      }
    });
  }

  void _loadTasksForProject(String projectId) {
    _taskSubscription?.cancel();
    _taskSubscription = _taskRepository.getTasksStream(projectId).listen((
      tasks,
    ) {
      availableTasks.value = tasks;
      // If current selected task is no longer in the list, clear it
      if (selectedTask.value != null &&
          !tasks.any((t) => t.id == selectedTask.value!.id)) {
        selectedTask.value = null;
      }
    });
  }

  void setProject(ProjectModel? project) {
    selectedProject.value = project;
  }

  void setTask(TaskModel? task) {
    selectedTask.value = task;
  }

  void _checkActiveSessions() {
    _repository.getActiveSessionsStream().listen((sessions) {
      if (sessions.isNotEmpty && !isTimerRunning.value) {
        // Recover active session if app closed
        _activeSession = sessions.first;
        final now = DateTime.now();
        final diff = now.difference(_activeSession!.startTime);
        elapsedSeconds.value = diff.inSeconds;
        isTimerRunning.value = true;
        _startTicker();

        // Load IDs and try to find objects
        final projectController = Get.find<ProjectController>();
        selectedProject.value = projectController.projects.firstWhereOrNull(
          (p) => p.id == _activeSession!.projectId,
        );
        // Note: selectedTask will be updated via the 'ever' listener if project matches
      }
    });
  }

  @override
  void onClose() {
    _ticker?.cancel();
    _taskSubscription?.cancel();
    super.onClose();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsedSeconds.value++;
    });
  }

  Future<void> startTimer() async {
    if (selectedProject.value == null) {
      Get.snackbar('Error', 'Please select a project first');
      return;
    }

    final now = DateTime.now();
    final dateKey = DateFormat('yyyy-MM-dd').format(now);
    final monthKey = DateFormat('yyyy-MM').format(now);

    final newSession = SessionModel(
      id: '',
      projectId: selectedProject.value!.id,
      taskId: selectedTask.value?.id,
      startTime: now,
      dateKey: dateKey,
      monthKey: monthKey,
    );

    try {
      final id = await _repository.createSession(newSession);
      _activeSession = newSession.copyWith(id: id);
      isTimerRunning.value = true;
      isPaused.value = false;
      elapsedSeconds.value = 0;
      _startTicker();
    } catch (e) {
      Get.snackbar('Error', 'Failed to start timer');
    }
  }

  void pauseTimer() {
    if (!isTimerRunning.value || isPaused.value) return;
    _ticker?.cancel();
    isPaused.value = true;
  }

  Future<void> resumeTimer() async {
    if (!isTimerRunning.value || !isPaused.value || _activeSession == null) {
      return;
    }

    // To resume accurately across app restarts, we update the Firestore startTime
    // such that (now - newStartTime) equal to the current elapsedSeconds.
    final now = DateTime.now();
    final newStartTime = now.subtract(Duration(seconds: elapsedSeconds.value));

    final resumedSession = _activeSession!.copyWith(startTime: newStartTime);

    try {
      await _repository.updateSession(resumedSession);
      _activeSession = resumedSession;
      isPaused.value = false;
      _startTicker();
    } catch (e) {
      Get.snackbar('Error', 'Failed to resume timer');
    }
  }

  Future<void> stopTimer() async {
    if (_activeSession == null) return;

    _ticker?.cancel();
    isTimerRunning.value = false;
    isPaused.value = false;

    final end = DateTime.now();
    final durationMins = (elapsedSeconds.value / 60).round();

    final completedSession = _activeSession!.copyWith(
      endTime: end,
      durationMinutes: durationMins,
    );

    try {
      await _repository.updateSession(completedSession);
      _activeSession = null;
      elapsedSeconds.value = 0;

      // Notify success
      Get.snackbar('Success', 'Logged $durationMins minutes');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save session');
    }
  }

  String get formattedTime {
    int hours = elapsedSeconds.value ~/ 3600;
    int minutes = (elapsedSeconds.value % 3600) ~/ 60;
    int seconds = elapsedSeconds.value % 60;
    return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
