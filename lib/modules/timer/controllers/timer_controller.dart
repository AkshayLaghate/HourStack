import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/session_repository.dart';

class TimerController extends GetxController {
  final SessionRepository _repository = SessionRepository();

  // Active Timer State
  final RxBool isTimerRunning = false.obs;
  final RxInt elapsedSeconds = 0.obs;

  // Current Selections
  final Rx<ProjectModel?> selectedProject = Rx<ProjectModel?>(null);
  final Rx<TaskModel?> selectedTask = Rx<TaskModel?>(null);

  // Internal Tracking
  Timer? _ticker;
  SessionModel? _activeSession;

  @override
  void onInit() {
    super.onInit();
    _checkActiveSessions();
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
        // Optionially load selected Project/Task from IDs, omitted for brevity
      }
    });
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
      elapsedSeconds.value = 0;
      _startTicker();
    } catch (e) {
      Get.snackbar('Error', 'Failed to start timer');
    }
  }

  Future<void> stopTimer() async {
    if (_activeSession == null) return;

    _ticker?.cancel();
    isTimerRunning.value = false;

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
