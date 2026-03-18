import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../data/repositories/project_repository.dart';
import 'package:intl/intl.dart';

enum DateRangeType { day, week, month, custom }

class DashboardController extends GetxController {
  final SessionRepository _sessionRepo = Get.find<SessionRepository>();
  final ProjectRepository _projectRepo = Get.find<ProjectRepository>();

  // Dashboard stats
  final periodTotalHours = 0.0.obs;
  final periodTotalRevenue = 0.0.obs;
  final monthlyHours = 0.0.obs;
  final monthlyRevenue = 0.0.obs;
  final upcomingTasksCount = 0.obs;
  final tasksInProgressCount = 0.obs;

  // Date Range
  final rangeType = DateRangeType.day.obs;
  final startDate = DateTime.now().obs;
  final endDate = DateTime.now().obs;
  final selectedDate = DateTime.now().obs; // Keep for picker initial value

  String get rangeLabel {
    switch (rangeType.value) {
      case DateRangeType.day:
        return 'Daily Activity';
      case DateRangeType.week:
        return 'Weekly Activity';
      case DateRangeType.month:
        return 'Monthly Activity';
      case DateRangeType.custom:
        return 'Custom Range Activity';
    }
  }

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

  // Additional stats
  final projectDistribution = <ProjectModel, double>{}.obs;
  final activeProjectsCount = 0.obs;
  final heatmapDatasets = <DateTime, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadChartData(),
        loadPeriodStats(),
        loadHeatmapData(),
      ]);
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setRange(
    DateRangeType type, {
    DateTime? date,
    DateTimeRange? customRange,
  }) {
    rangeType.value = type;
    final now = date ?? selectedDate.value;
    selectedDate.value = now;

    switch (type) {
      case DateRangeType.day:
        startDate.value = DateTime(now.year, now.month, now.day);
        endDate.value = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
        break;
      case DateRangeType.week:
        // Assume Monday start
        int daysToSubtract = now.weekday - 1;
        final start = now.subtract(Duration(days: daysToSubtract));
        startDate.value = DateTime(start.year, start.month, start.day);
        final end = start.add(const Duration(days: 6));
        endDate.value = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);
        break;
      case DateRangeType.month:
        startDate.value = DateTime(now.year, now.month, 1);
        final nextMonth = DateTime(now.year, now.month + 1, 1);
        endDate.value = nextMonth.subtract(const Duration(milliseconds: 1));
        break;
      case DateRangeType.custom:
        if (customRange != null) {
          startDate.value = DateTime(
            customRange.start.year,
            customRange.start.month,
            customRange.start.day,
          );
          endDate.value = DateTime(
            customRange.end.year,
            customRange.end.month,
            customRange.end.day,
            23,
            59,
            59,
            999,
          );
        }
        break;
    }
    loadDashboardData();
  }

  Future<void> selectDateRange(BuildContext context) async {
    if (rangeType.value == DateRangeType.day) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
      );
      if (picked != null) setRange(DateRangeType.day, date: picked);
    } else if (rangeType.value == DateRangeType.week) {
      // Pick a day and calculate week
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
      );
      if (picked != null) setRange(DateRangeType.week, date: picked);
    } else if (rangeType.value == DateRangeType.month) {
      // Simple date picker for month (ignoring the day)
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
      );
      if (picked != null) setRange(DateRangeType.month, date: picked);
    } else if (rangeType.value == DateRangeType.custom) {
      final DateTimeRange? picked = await showDateRangePicker(
        context: context,
        initialDateRange: DateTimeRange(
          start: startDate.value,
          end: endDate.value,
        ),
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
      );
      if (picked != null) setRange(DateRangeType.custom, customRange: picked);
    }
  }

  Future<void> selectDate(context) async {
    // Legacy mapping - we'll update view to use selectDateRange
    selectDateRange(context);
  }

  Future<void> loadPeriodStats() async {
    final start = startDate.value;
    final end = endDate.value;

    final List<ProjectModel> projects = await _projectRepo
        .getProjectsStream()
        .first;
    final pMap = {for (var p in projects) p.id: p};
    projectMap.value = pMap;

    // Fetch sessions for the range (using a simplified method or custom logic)
    // For now, we'll fetch month sessions and filter locally as a proxy
    // ideally we'd have a repository method for range
    final monthKey = DateFormat('yyyy-MM').format(start);
    final List<SessionModel> sessions = await _sessionRepo
        .getSessionsForMonthStream(monthKey)
        .first;

    // Also fetch for end month if different
    final endMonthKey = DateFormat('yyyy-MM').format(end);
    if (endMonthKey != monthKey) {
      final List<SessionModel> endSessions = await _sessionRepo
          .getSessionsForMonthStream(endMonthKey)
          .first;
      sessions.addAll(endSessions);
    }

    double pHours = 0;
    double pRevenue = 0;
    final Map<ProjectModel, double> pDist = {};

    for (var p in projects) {
      if (p.isActive) {
        pDist[p] = 0.0;
      }
    }

    for (SessionModel session in sessions) {
      if (session.startTime.isAfter(
            start.subtract(const Duration(seconds: 1)),
          ) &&
          session.startTime.isBefore(end.add(const Duration(seconds: 1)))) {
        final ProjectModel? project = pMap[session.projectId];
        final double hours = session.durationMinutes / 60.0;
        final double revenue = hours * (project?.hourlyRate ?? 0.0);

        pHours += hours;
        pRevenue += revenue;

        if (project != null && hours > 0) {
          pDist[project] = (pDist[project] ?? 0) + hours;
        }
      }
    }

    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    recentSessions.value = sessions.take(5).toList();

    periodTotalHours.value = pHours;
    periodTotalRevenue.value = pRevenue;
    projectDistribution.value = pDist;
    activeProjectsCount.value = pDist.length;

    // Keep monthly stats as they are (based on current date)
    _loadFixedMonthlyStats(pMap);
  }

  Future<void> _loadFixedMonthlyStats(Map<String, ProjectModel> pMap) async {
    final now = DateTime.now();
    final monthKey = DateFormat('yyyy-MM').format(now);
    final sessions = await _sessionRepo
        .getSessionsForMonthStream(monthKey)
        .first;

    double mHours = 0;
    double mRevenue = 0;
    for (var session in sessions) {
      final project = pMap[session.projectId];
      final hours = session.durationMinutes / 60.0;
      mHours += hours;
      mRevenue += hours * (project?.hourlyRate ?? 0.0);
    }
    monthlyHours.value = mHours;
    monthlyRevenue.value = mRevenue;
  }

  Future<void> loadChartData() async {
    final start = startDate.value;
    final end = endDate.value;
    final type = rangeType.value;

    if (type == DateRangeType.day) {
      // Hourly view for current day
      const dataPoints = 24;
      final labels = List.generate(
        dataPoints,
        (i) => '${i.toString().padLeft(2, '0')}h',
      );
      final billable = List<double>.filled(dataPoints, 0.0);
      final nonBillable = List<double>.filled(dataPoints, 0.0);

      final dateKey = DateFormat('yyyy-MM-dd').format(start);
      final sessions = await _sessionRepo
          .getSessionsForDateStream(dateKey)
          .first;
      final projects = await _projectRepo.getProjectsStream().first;
      final projectMap = {for (var p in projects) p.id: p};

      for (var session in sessions) {
        final hour = session.startTime.hour;
        if (hour < dataPoints) {
          final project = projectMap[session.projectId];
          final bool isBillable = project?.isBillable ?? true;
          if (isBillable) {
            billable[hour] += session.durationMinutes / 60.0;
          } else {
            nonBillable[hour] += session.durationMinutes / 60.0;
          }
        }
      }

      chartLabels.value = labels;
      billableData.value = billable;
      nonBillableData.value = nonBillable;
      return;
    }

    final duration = end.difference(start).inDays + 1;
    final List<DateTime> dates;
    if (duration <= 7) {
      dates = List.generate(duration, (i) => start.add(Duration(days: i)));
    } else if (duration <= 31) {
      dates = List.generate(duration, (i) => start.add(Duration(days: i)));
    } else {
      // Just last 30 days if range is too long for daily chart
      dates = List.generate(30, (i) => end.subtract(Duration(days: 29 - i)));
    }

    final labels = dates.map((date) => DateFormat('dd').format(date)).toList();
    chartLabels.value = labels;

    final billable = List<double>.filled(dates.length, 0.0);
    final nonBillable = List<double>.filled(dates.length, 0.0);

    final projects = await _projectRepo.getProjectsStream().first;
    final projectMap = {for (var p in projects) p.id: p};

    for (int i = 0; i < dates.length; i++) {
      final date = dates[i];
      final dateKey = DateFormat('yyyy-MM-dd').format(date);
      final sessions = await _sessionRepo
          .getSessionsForDateStream(dateKey)
          .first;

      for (var session in sessions) {
        final project = projectMap[session.projectId];
        final bool isBillable = project?.isBillable ?? true;
        if (isBillable) {
          billable[i] += session.durationMinutes / 60.0;
        } else {
          nonBillable[i] += session.durationMinutes / 60.0;
        }
      }
    }

    billableData.value = billable;
    nonBillableData.value = nonBillable;
  }

  Future<void> loadHeatmapData() async {
    final now = DateTime.now();
    final start = now.subtract(const Duration(days: 365));

    final sessions = await _sessionRepo
        .getSessionsForRangeStream(start, now)
        .first;
    final Map<DateTime, int> heatmap = {};

    for (var session in sessions) {
      final date = DateTime(
        session.startTime.year,
        session.startTime.month,
        session.startTime.day,
      );
      final minutes = session.durationMinutes;
      heatmap[date] = (heatmap[date] ?? 0) + minutes;
    }

    // Convert minutes to a scale 1-5
    final Map<DateTime, int> scaledHeatmap = {};
    for (var entry in heatmap.entries) {
      final hours = entry.value / 60.0;
      if (hours <= 0) continue;

      int intensity = 1;
      if (hours > 6) {
        intensity = 5;
      } else if (hours > 4) {
        intensity = 4;
      } else if (hours > 2) {
        intensity = 3;
      } else if (hours > 1) {
        intensity = 2;
      }
      scaledHeatmap[entry.key] = intensity;
    }

    heatmapDatasets.value = scaledHeatmap;
  }

  Future<void> loadMonthlyAndTodayStats() async {
    // Legacy - mapped to loadPeriodStats
    loadPeriodStats();
  }

  Future<void> loadWeeklyData() async {
    // Legacy - mapped to loadChartData
    loadChartData();
  }
}
