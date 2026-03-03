import 'package:get/get.dart';

class DashboardController extends GetxController {
  // Dashboard stats
  final todayHours = 0.0.obs;
  final todayRevenue = 0.0.obs;
  final monthlyHours = 0.0.obs;
  final monthlyRevenue = 0.0.obs;
  final upcomingTasksCount = 0.obs;
  final tasksInProgressCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Load initial data
  }
}
