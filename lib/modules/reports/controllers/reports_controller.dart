import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/project_model.dart';
import '../../../data/repositories/session_repository.dart';
import '../../projects/controllers/project_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart'; // For DateRangeType

class ReportsController extends GetxController {
  final SessionRepository _repository = Get.find<SessionRepository>();
  final ProjectController projectController = Get.find<ProjectController>();

  final RxList<SessionModel> sessions = <SessionModel>[].obs;
  final RxBool isLoading = true.obs;

  // Filter Observables
  final Rxn<ProjectModel> selectedProject = Rxn<ProjectModel>();
  final Rx<DateRangeType> rangeType = DateRangeType.month.obs;
  final Rx<DateTime> startDate = DateTime.now().obs;
  final Rx<DateTime> endDate = DateTime.now().obs;
  final Rx<DateTime> selectedDate = DateTime.now().obs;

  final RxList<ReportEntry> reportEntries = <ReportEntry>[].obs;
  final RxDouble totalHours = 0.0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxDouble avgDay = 0.0.obs;
  final RxDouble billablePercent = 0.0.obs;
  final RxDouble avgRate = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    // Default to current month range
    setRange(DateRangeType.month, date: DateTime.now());
  }

  @override
  void onClose() {
    _sessionSubscription?.cancel();
    super.onClose();
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
    _loadReportData();
  }

  Future<void> selectDateRange(BuildContext context) async {
    if (rangeType.value == DateRangeType.day ||
        rangeType.value == DateRangeType.week ||
        rangeType.value == DateRangeType.month) {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate.value,
        firstDate: DateTime(2020),
        lastDate: DateTime(2101),
      );
      if (picked != null) setRange(rangeType.value, date: picked);
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

  void onProjectChanged(ProjectModel? project) {
    selectedProject.value = project;
    _loadReportData();
  }

  String get rangeLabel {
    final startFormat = DateFormat('MMM dd, yyyy');
    if (rangeType.value == DateRangeType.day) {
      return startFormat.format(startDate.value);
    } else if (rangeType.value == DateRangeType.month) {
      return DateFormat('MMMM yyyy').format(startDate.value);
    } else {
      return '${startFormat.format(startDate.value)} - ${startFormat.format(endDate.value)}';
    }
  }

  StreamSubscription? _sessionSubscription;

  void _loadReportData() {
    isLoading.value = true;
    _sessionSubscription?.cancel();

    _sessionSubscription = _repository
        .getSessionsForRangeStream(startDate.value, endDate.value)
        .listen((data) {
          List<SessionModel> filteredSessions = data.where((s) {
            bool matchesProject =
                selectedProject.value == null ||
                s.projectId == selectedProject.value!.id;
            return matchesProject;
          }).toList();

          sessions.assignAll(filteredSessions);
          _calculateStats();
          _generateReportEntries();
          isLoading.value = false;
        });
  }

  void _calculateStats() {
    if (sessions.isEmpty) {
      totalHours.value = 0.0;
      totalRevenue.value = 0.0;
      avgDay.value = 0.0;
      billablePercent.value = 0.0;
      avgRate.value = 0.0;
      return;
    }

    double totalMinutes = 0;
    double billableMinutes = 0;
    double revenue = 0;

    final projectMap = {for (var p in projectController.projects) p.id: p};

    for (var session in sessions) {
      final project = projectMap[session.projectId];
      final double hours = session.durationMinutes / 60.0;
      totalMinutes += session.durationMinutes;

      if (project != null && project.isBillable) {
        billableMinutes += session.durationMinutes;
        revenue += hours * project.hourlyRate;
      }
    }

    totalHours.value = totalMinutes / 60;
    totalRevenue.value = revenue;

    int days = endDate.value.difference(startDate.value).inDays + 1;
    avgDay.value = totalHours.value / (days > 0 ? days : 1);
    billablePercent.value = totalMinutes > 0
        ? (billableMinutes / totalMinutes) * 100
        : 0;
    avgRate.value = totalHours.value > 0 ? revenue / totalHours.value : 0;
  }

  void _generateReportEntries() {
    final projectMap = {for (var p in projectController.projects) p.id: p};

    final entries = sessions.map((session) {
      final project = projectMap[session.projectId];
      final hours = session.durationMinutes / 60.0;
      final rate = project?.hourlyRate ?? 0.0;

      return ReportEntry(
        date: DateFormat('MMM dd, yyyy').format(session.startTime),
        project: project?.name ?? 'Unknown',
        hours: double.parse(hours.toStringAsFixed(2)),
        rate: rate,
        revenue: hours * rate,
        color: project?.colorValue ?? 0xFF64748B,
      );
    }).toList();

    // Sort by date descending
    entries.sort((a, b) => b.date.compareTo(a.date));
    reportEntries.assignAll(entries);
  }

  Future<void> exportToCSV() async {
    if (sessions.isEmpty) {
      Get.snackbar('Empty Report', 'No data to export.');
      return;
    }

    final StringBuffer buffer = StringBuffer();
    buffer.writeln('Date,Project,Task,Duration(m)');

    for (var session in sessions) {
      buffer.writeln(
        '${session.dateKey},${session.projectId},${session.taskId ?? ''},${session.durationMinutes}',
      );
    }

    // In a real app, save to file using path_provider and share it.
    // For demo/web, just print it for now.
    print(buffer.toString());
    Get.snackbar('Export Success', 'CSV exported to console for demo.');
  }

  Future<void> exportToExcel() async {
    if (sessions.isEmpty) {
      Get.snackbar('Empty Report', 'No data to export.');
      return;
    }

    final excel.Workbook workbook = excel.Workbook();
    final excel.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByIndex(1, 1).setText('Date');
    sheet.getRangeByIndex(1, 2).setText('Project');
    sheet.getRangeByIndex(1, 3).setText('Task');
    sheet.getRangeByIndex(1, 4).setText('Duration (m)');

    for (int i = 0; i < sessions.length; i++) {
      final session = sessions[i];
      sheet.getRangeByIndex(i + 2, 1).setText(session.dateKey);
      sheet.getRangeByIndex(i + 2, 2).setText(session.projectId);
      sheet.getRangeByIndex(i + 2, 3).setText(session.taskId ?? '');
      sheet
          .getRangeByIndex(i + 2, 4)
          .setNumber(session.durationMinutes.toDouble());
    }

    workbook.saveAsStream(); // Generates bytes, ignored for demo
    workbook.dispose();

    Get.snackbar('Export Success', 'Excel generated in memory.');
  }

  Future<void> exportToPDF() async {
    if (sessions.isEmpty) {
      Get.snackbar('Empty Report', 'No data to export.');
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'HourStack Timesheet Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.TableHelper.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Date', 'Project', 'Task', 'Duration (m)'],
                  ...sessions.map(
                    (s) => [
                      s.dateKey,
                      s.projectId,
                      s.taskId ?? 'N/A',
                      s.durationMinutes.toString(),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}

class ReportEntry {
  final String date;
  final String project;
  final double hours;
  final double rate;
  final double revenue;
  final int color;

  ReportEntry({
    required this.date,
    required this.project,
    required this.hours,
    required this.rate,
    required this.revenue,
    required this.color,
  });
}
