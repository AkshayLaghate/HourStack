import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../data/repositories/project_repository.dart';
import 'package:intl/intl.dart';

class DashboardController extends GetxController {
  final SessionRepository _sessionRepo = Get.find<SessionRepository>();
  final ProjectRepository _projectRepo = Get.find<ProjectRepository>();

  // Dashboard stats
  final todayHours = 0.0.obs;
  final todayRevenue = 0.0.obs;
  final monthlyHours = 0.0.obs;
  final monthlyRevenue = 0.0.obs;
  final upcomingTasksCount = 0.obs;
  final tasksInProgressCount = 0.obs;

  // Chart data
  final billableData = <double>[0, 0, 0, 0, 0, 0, 0].obs;
  final nonBillableData = <double>[0, 0, 0, 0, 0, 0, 0].obs;
  final chartLabels = <String>[
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
    'Sun',
  ].obs;
  final isLoading = true.obs;

  // Recent entries
  final recentSessions = <SessionModel>[].obs;
  final projectMap = <String, ProjectModel>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      await Future.wait([loadWeeklyData(), loadMonthlyAndTodayStats()]);
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMonthlyAndTodayStats() async {
    final now = DateTime.now();
    final todayKey = DateFormat('yyyy-MM-dd').format(now);
    final monthKey = DateFormat('yyyy-MM').format(now);

    final List<SessionModel> monthSessions = await _sessionRepo
        .getSessionsForMonthStream(monthKey)
        .first;
    final List<ProjectModel> projects = await _projectRepo
        .getProjectsStream()
        .first;
    final pMap = {for (var p in projects) p.id: p};
    projectMap.value = pMap;

    double tHours = 0;
    double tRevenue = 0;
    double mHours = 0;
    double mRevenue = 0;

    // Sort sessions by startTime descending
    final List<SessionModel> sortedSessions = List.from(monthSessions)
      ..sort((a, b) => b.startTime.compareTo(a.startTime));

    for (SessionModel session in sortedSessions) {
      final ProjectModel? project = pMap[session.projectId];
      final double hours = session.durationMinutes / 60.0;
      final double revenue = hours * (project?.hourlyRate ?? 0.0);

      mHours += hours;
      mRevenue += revenue;

      if (session.dateKey == todayKey) {
        tHours += hours;
        tRevenue += revenue;
      }
    }

    recentSessions.value = sortedSessions.take(5).toList();
    todayHours.value = tHours;
    todayRevenue.value = tRevenue;
    monthlyHours.value = mHours;
    monthlyRevenue.value = mRevenue;
  }

  Future<void> loadWeeklyData() async {
    final now = DateTime.now();
    final last7Days = List.generate(
      7,
      (index) => now.subtract(Duration(days: 6 - index)),
    );

    final labels = last7Days
        .map((date) => DateFormat('E').format(date))
        .toList();
    chartLabels.value = labels;

    final billable = List<double>.filled(7, 0.0);
    final nonBillable = List<double>.filled(7, 0.0);

    // Fetch all projects to check billability
    final projects = await _projectRepo.getProjectsStream().first;
    final projectMap = {for (var p in projects) p.id: p};

    for (int i = 0; i < 7; i++) {
      final date = last7Days[i];
      final dateKey = DateFormat('yyyy-MM-dd').format(date);

      final sessions = await _sessionRepo
          .getSessionsForDateStream(dateKey)
          .first;

      double dayBillableMinutes = 0;
      double dayNonBillableMinutes = 0;

      for (SessionModel session in sessions) {
        final ProjectModel? project = projectMap[session.projectId];
        final bool isBillable = project?.isBillable ?? true;

        if (isBillable) {
          dayBillableMinutes += session.durationMinutes;
        } else {
          dayNonBillableMinutes += session.durationMinutes;
        }
      }

      billable[i] = dayBillableMinutes / 60.0;
      nonBillable[i] = dayNonBillableMinutes / 60.0;
    }

    billableData.value = billable;
    nonBillableData.value = nonBillable;
  }
}
