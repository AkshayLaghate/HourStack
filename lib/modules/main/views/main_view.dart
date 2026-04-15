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
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          // Subtle ambient glow — top-right
          Positioned(
            top: -120,
            right: -80,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Subtle ambient glow — bottom-left
          Positioned(
            bottom: -100,
            left: -60,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.primaryGlow.withValues(alpha: 0.04),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          // Main content
          Row(
            children: [
              if (isDesktop) const SideMenu(),
              Expanded(
                child: Obx(
                  () => IndexedStack(
                    index: controller.selectedIndex,
                    children: [
                      const DashboardView(),
                      Obx(() {
                        final projectController =
                            Get.find<ProjectController>();
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
        ],
      ),
      drawer: isDesktop ? null : const Drawer(child: SideMenu()),
    );
  }
}
