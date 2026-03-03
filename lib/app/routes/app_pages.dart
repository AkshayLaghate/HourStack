import 'package:get/get.dart';
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/register_view.dart';
import '../../modules/main/bindings/main_binding.dart';
import '../../modules/main/views/main_view.dart';
import '../../modules/dashboard/bindings/dashboard_binding.dart';
import '../../modules/dashboard/views/dashboard_view.dart';
import '../../modules/projects/bindings/project_binding.dart';
import '../../modules/projects/views/project_list_view.dart';
import '../../modules/kanban/bindings/kanban_binding.dart';
import '../../modules/kanban/views/kanban_view.dart';
import '../../modules/calendar/bindings/calendar_binding.dart';
import '../../modules/calendar/views/calendar_view.dart';
import '../../modules/reports/bindings/reports_binding.dart';
import '../../modules/reports/views/reports_view.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.LOGIN;

  static final routes = [
    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.MAIN,
      page: () => const MainView(),
      binding: MainBinding(),
    ),
    GetPage(
      name: Routes.DASHBOARD,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: Routes.PROJECTS,
      page: () => const ProjectListView(),
      binding: ProjectBinding(),
    ),
    GetPage(
      name: Routes.KANBAN,
      page: () => const KanbanView(),
      binding: KanbanBinding(),
    ),
    GetPage(
      name: Routes.CALENDAR,
      page: () => const CalendarView(),
      binding: CalendarBinding(),
    ),
    GetPage(
      name: Routes.REPORTS,
      page: () => const ReportsView(),
      binding: ReportsBinding(),
    ),
  ];
}
