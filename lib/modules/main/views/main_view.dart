import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/main_controller.dart';
import '../../dashboard/views/dashboard_view.dart';
import '../../projects/views/project_list_view.dart';
import '../../projects/views/project_detail_view.dart';
import '../../projects/controllers/project_controller.dart';
import '../../reports/views/reports_view.dart';
import '../../settings/views/settings_view.dart';
import '../../calendar/views/calendar_view.dart';
import '../../dashboard/views/widgets/side_menu.dart';
import '../../../app/theme/app_colors.dart';

class MainView extends GetView<MainController> {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 1200;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Row(
        children: [
          if (isDesktop) const SideMenu(),
          Expanded(
            child: Obx(
              () => IndexedStack(
                index: controller.selectedIndex,
                children: [
                  const DashboardView(),
                  Obx(() {
                    final projectController = Get.find<ProjectController>();
                    final selectedProject =
                        projectController.selectedProject.value;
                    if (selectedProject != null) {
                      return ProjectDetailView(project: selectedProject);
                    }
                    return const ProjectListView();
                  }),
                  const CalendarView(),
                  const ReportsView(),
                  const SettingsView(),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: isDesktop ? null : const SideMenu(),
    );
  }
}
