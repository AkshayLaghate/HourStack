import 'package:get/get.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as excel;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../../data/models/session_model.dart';
import '../../../data/repositories/session_repository.dart';

class ReportsController extends GetxController {
  final SessionRepository _repository = SessionRepository();
  final RxList<SessionModel> sessions = <SessionModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadReportData();
  }

  void _loadReportData() {
    isLoading.value = true;
    // For simplicity, loading all sessions for the current month
    final now = DateTime.now();
    final monthKey = '${now.year}-${now.month.toString().padLeft(2, '0')}';
    _repository.getSessionsForMonthStream(monthKey).listen((data) {
      sessions.assignAll(data);
      isLoading.value = false;
    });
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
