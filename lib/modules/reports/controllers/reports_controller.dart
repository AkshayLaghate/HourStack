import 'package:get/get.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../data/models/session_model.dart';
import '../../../data/repositories/session_repository.dart';

class ReportsController extends GetxController {
  final SessionRepository _repository = Get.find<SessionRepository>();
  final RxList<SessionModel> sessions = <SessionModel>[].obs;
  final RxBool isLoading = true.obs;

  final RxList<ReportEntry> reportEntries = <ReportEntry>[].obs;
  final RxDouble totalHours = 0.0.obs;
  final RxDouble totalRevenue = 0.0.obs;
  final RxDouble avgDay = 0.0.obs;
  final RxDouble billablePercent = 0.0.obs;
  final RxDouble avgRate = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadReportData();
  }

  void _loadReportData() {
    isLoading.value = true;
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    _repository.getSessionsForMonthStream(monthKey).listen((data) {
      sessions.assignAll(data);
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
    // For demo/simplicity, we'll assume a fixed rate if project data isn't fully linked here
    // In a real app, we'd fetch project details for each session
    for (var session in sessions) {
      totalMinutes += session.durationMinutes;
    }

    totalHours.value = totalMinutes / 60;
    // Mocking revenue and other stats for the redesign demo
    totalRevenue.value = 21385.00;
    avgDay.value = 6.8;
    billablePercent.value = 92.4;
    avgRate.value = 142.50;
  }

  void _generateReportEntries() {
    // Generating dummy entries to match the design screenshot
    reportEntries.assignAll([
      ReportEntry(
        date: 'Oct 12, 2023',
        project: 'Website Redesign',
        hours: 4.5,
        rate: 150.00,
        revenue: 675.00,
        color: 0xFF3B82F6,
      ),
      ReportEntry(
        date: 'Oct 13, 2023',
        project: 'Mobile App Architecture',
        hours: 8.0,
        rate: 150.00,
        revenue: 1200.00,
        color: 0xFF10B981,
      ),
      ReportEntry(
        date: 'Oct 14, 2023',
        project: 'Brand Identity System',
        hours: 6.2,
        rate: 125.00,
        revenue: 775.00,
        color: 0xFFF59E0B,
      ),
      ReportEntry(
        date: 'Oct 15, 2023',
        project: 'Website Redesign',
        hours: 3.5,
        rate: 150.00,
        revenue: 525.00,
        color: 0xFF3B82F6,
      ),
      ReportEntry(
        date: 'Oct 16, 2023',
        project: 'Internal Marketing',
        hours: 2.0,
        rate: 0.00,
        revenue: 0.00,
        color: 0xFF6366F1,
      ),
    ]);
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
              pw.Table.fromTextArray(
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
