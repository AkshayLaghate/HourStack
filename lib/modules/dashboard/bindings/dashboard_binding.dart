import 'package:get/get.dart';
import '../controllers/dashboard_controller.dart';
import '../../timer/controllers/timer_controller.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/task_repository.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<TimerController>(() => TimerController());

    // Repositories
    Get.lazyPut<SessionRepository>(() => SessionRepository());
    Get.lazyPut<ProjectRepository>(() => ProjectRepository());
    Get.lazyPut<TaskRepository>(() => TaskRepository());
  }
}
