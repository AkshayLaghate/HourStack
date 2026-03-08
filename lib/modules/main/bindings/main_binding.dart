import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../dashboard/controllers/dashboard_controller.dart';
import '../../projects/controllers/project_controller.dart';
import '../../reports/controllers/reports_controller.dart';
import '../../calendar/controllers/calendar_controller.dart';
import '../../kanban/controllers/kanban_controller.dart';
import '../../timer/controllers/timer_controller.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/task_repository.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MainController>(() => MainController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<ProjectController>(() => ProjectController());
    Get.lazyPut<ReportsController>(() => ReportsController());
    Get.lazyPut<CalendarController>(() => CalendarController());
    Get.lazyPut<KanbanController>(() => KanbanController());
    Get.lazyPut<TimerController>(() => TimerController());

    // Repositories
    Get.lazyPut<SessionRepository>(() => SessionRepository());
    Get.lazyPut<ProjectRepository>(() => ProjectRepository());
    Get.lazyPut<TaskRepository>(() => TaskRepository());
  }
}
