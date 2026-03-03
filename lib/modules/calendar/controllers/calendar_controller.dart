import 'package:get/get.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../data/repositories/project_repository.dart';

class CalendarController extends GetxController {
  final SessionRepository _sessionRepository = SessionRepository();
  final ProjectRepository _projectRepository = ProjectRepository();

  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = Rx<DateTime?>(null);
  final RxString viewType = 'Month'.obs; // Month, Week, Day

  // Map of dateKey (yyyy-MM-dd) to List of Sessions
  final RxMap<String, List<SessionModel>> sessionsMap =
      <String, List<SessionModel>>{}.obs;

  // Map of projectId to ProjectModel for quick lookup
  final RxMap<String, ProjectModel> projectsMap = <String, ProjectModel>{}.obs;

  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    selectedDay.value = focusedDay.value;
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    isLoading.value = true;
    await _loadProjects();
    _loadMonthData(focusedDay.value);
  }

  Future<void> _loadProjects() async {
    final projects = await _projectRepository.getProjectsStream().first;
    final newMap = <String, ProjectModel>{};
    for (var project in projects) {
      newMap[project.id] = project;
    }
    projectsMap.assignAll(newMap);
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    selectedDay.value = selected;
    focusedDay.value = focused;
  }

  void onPageChanged(DateTime focused) {
    focusedDay.value = focused;
    _loadMonthData(focused);
  }

  void changeView(String type) {
    viewType.value = type;
  }

  void _loadMonthData(DateTime focused) {
    isLoading.value = true;
    final monthKey =
        '${focused.year}-${focused.month.toString().padLeft(2, '0')}';

    _sessionRepository.getSessionsForMonthStream(monthKey).listen((sessions) {
      final newMap = <String, List<SessionModel>>{};
      for (var session in sessions) {
        if (!newMap.containsKey(session.dateKey)) {
          newMap[session.dateKey] = [];
        }
        newMap[session.dateKey]!.add(session);
      }
      sessionsMap.assignAll(newMap);
      isLoading.value = false;
    });
  }

  List<SessionModel> getSessionsForDay(DateTime day) {
    final dateKey =
        '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
    return sessionsMap[dateKey] ?? [];
  }

  double getTotalHoursForDay(DateTime day) {
    final sessions = getSessionsForDay(day);
    return sessions.fold(0.0, (sum, s) => sum + (s.durationMinutes / 60.0));
  }

  double getTotalRevenueForDay(DateTime day) {
    final sessions = getSessionsForDay(day);
    double total = 0.0;
    for (var session in sessions) {
      final project = projectsMap[session.projectId];
      if (project != null) {
        total += (session.durationMinutes / 60.0) * project.hourlyRate;
      }
    }
    return total;
  }

  void nextMonth() {
    focusedDay.value = DateTime(
      focusedDay.value.year,
      focusedDay.value.month + 1,
      1,
    );
    _loadMonthData(focusedDay.value);
  }

  void previousMonth() {
    focusedDay.value = DateTime(
      focusedDay.value.year,
      focusedDay.value.month - 1,
      1,
    );
    _loadMonthData(focusedDay.value);
  }
}
