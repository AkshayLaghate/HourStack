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

  // Trend data
  final periodHoursTrend = ''.obs;
  final periodRevenueTrend = ''.obs;
  final activeProjectsTrend = ''.obs;
  final monthlyHoursTrend = ''.obs;

  final isPeriodHoursPositive = true.obs;
  final isPeriodRevenuePositive = true.obs;
  final isActiveProjectsPositive = true.obs;
  final isMonthlyHoursPositive = true.obs;

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

  String get trendDescription {
    switch (rangeType.value) {
      case DateRangeType.day:
        return 'vs yesterday';
      case DateRangeType.week:
        return 'vs last week';
      case DateRangeType.month:
        return 'vs last month';
      case DateRangeType.custom:
        return 'vs prev period';
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
  final heatmapMinutes = <DateTime, int>{}.obs;

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

    // Fetch current period sessions
    final List<SessionModel> sessions = await _sessionRepo
        .getSessionsForRangeStream(start, end)
        .first;

    double pHours = 0;
    double pRevenue = 0;
    final Map<ProjectModel, double> pDist = {};

    for (var p in projects) {
      if (p.isActive) {
        pDist[p] = 0.0;
      }
    }

    for (SessionModel session in sessions) {
      final ProjectModel? project = pMap[session.projectId];
      final double hours = session.durationMinutes / 60.0;
      final double revenue = hours * (project?.hourlyRate ?? 0.0);

      pHours += hours;
      pRevenue += revenue;

      if (project != null && hours > 0) {
        pDist[project] = (pDist[project] ?? 0) + hours;
      }
    }

    // Previous Period Calculations
    final Duration actualDuration = Duration(days: end.difference(start).inDays + 1);
    DateTime prevStart;
    DateTime prevEnd;

    if (rangeType.value == DateRangeType.month) {
      prevStart = DateTime(start.year, start.month - 1, 1);
      final lastDayPrevMonth = DateTime(start.year, start.month, 0);
      prevEnd = DateTime(prevStart.year, prevStart.month, lastDayPrevMonth.day, 23, 59, 59, 999);
    } else {
      prevStart = start.subtract(actualDuration);
      prevEnd = end.subtract(actualDuration);
    }

    final List<SessionModel> prevSessions = await _sessionRepo
        .getSessionsForRangeStream(prevStart, prevEnd)
        .first;

    double prevHours = 0;
    double prevRevenue = 0;
    final Set<String> prevActiveProjectIds = {};

    for (var session in prevSessions) {
      final hours = session.durationMinutes / 60.0;
      prevHours += hours;
      final project = pMap[session.projectId];
      prevRevenue += hours * (project?.hourlyRate ?? 0.0);
      if (hours > 0) prevActiveProjectIds.add(session.projectId);
    }

    _calculateTrend(pHours, prevHours, periodHoursTrend, isPeriodHoursPositive);
    _calculateTrend(pRevenue, prevRevenue, periodRevenueTrend, isPeriodRevenuePositive);
    
    int currentActive = pDist.values.where((h) => h > 0).length;
    _calculateTrend(currentActive.toDouble(), prevActiveProjectIds.length.toDouble(), activeProjectsTrend, isActiveProjectsPositive);

    sessions.sort((a, b) => b.startTime.compareTo(a.startTime));
    recentSessions.value = sessions.take(5).toList();

    periodTotalHours.value = pHours;
    periodTotalRevenue.value = pRevenue;
    projectDistribution.value = pDist;
    activeProjectsCount.value = currentActive;

    // Keep monthly stats as they are (based on current date)
    _loadFixedMonthlyStats(pMap);
  }

  void _calculateTrend(double current, double previous, RxString trendVar, RxBool isPositiveVar) {
    if (previous == 0) {
      if (current > 0) {
        trendVar.value = '+100%';
        isPositiveVar.value = true;
      } else {
        trendVar.value = '0%';
        isPositiveVar.value = true;
      }
      return;
    }
    final diff = current - previous;
    final percent = (diff / previous) * 100;
    isPositiveVar.value = percent >= 0;
    final sign = percent >= 0 ? '+' : '';
    trendVar.value = '$sign${percent.toStringAsFixed(1)}%';
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

    // Prev month
    final prevMonthStart = DateTime(now.year, now.month - 1, 1);
    final prevMonthKey = DateFormat('yyyy-MM').format(prevMonthStart);
    final prevSessions = await _sessionRepo
        .getSessionsForMonthStream(prevMonthKey)
        .first;
    
    double prevMHours = 0;
    for (var session in prevSessions) {
      prevMHours += session.durationMinutes / 60.0;
    }

    _calculateTrend(mHours, prevMHours, monthlyHoursTrend, isMonthlyHoursPositive);

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

    heatmapMinutes.value = heatmap;
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
