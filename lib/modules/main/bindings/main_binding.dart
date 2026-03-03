import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../projects/controllers/project_controller.dart';
import '../../reports/controllers/reports_controller.dart';
import '../../calendar/controllers/calendar_controller.dart';
import '../../kanban/controllers/kanban_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ProjectController>(() => ProjectController());
    Get.lazyPut<ReportsController>(() => ReportsController());
    Get.lazyPut<CalendarController>(() => CalendarController());
    Get.lazyPut<KanbanController>(() => KanbanController());
  }
}
