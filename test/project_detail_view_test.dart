import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:hourstack/modules/projects/views/project_detail_view.dart';
import 'package:hourstack/modules/projects/controllers/project_controller.dart';
import 'package:hourstack/data/repositories/project_repository.dart';
import 'package:hourstack/data/models/project_model.dart';

class MockProjectRepository extends ProjectRepository {
  @override
  Stream<List<ProjectModel>> getProjectsStream() => Stream.value([]);
  @override
  Future<void> addProject(ProjectModel project) async {}
}

class MockProjectController extends ProjectController {
  MockProjectController() : super(repository: MockProjectRepository());

  @override
  void onInit() {
    super.onInit();
    isLoading.value = false;
  }
}

void main() {
  testWidgets('ProjectDetailView renders core components', (
    WidgetTester tester,
  ) async {
    final mockProject = ProjectModel(
      id: '1',
      name: 'E-commerce Redesign',
      clientName: 'Acme Corp',
      hourlyRate: 85.0,
      totalHours: 142.5,
      totalRevenue: 12112.50,
      weeklyGoalHours: 45.0,
      thisWeekHours: 38.5,
      lastWeekHours: 32.2,
      milestoneProgress: 0.95,
      createdAt: DateTime.now(),
    );

    Get.put<ProjectController>(MockProjectController() as dynamic);

    await tester.pumpWidget(
      GetMaterialApp(
        initialRoute: '/details',
        getPages: [
          GetPage(
            name: '/details',
            page: () => ProjectDetailView(project: mockProject),
            arguments: mockProject,
          ),
        ],
      ),
    );

    await tester.pumpAndSettle();

    // Verify Project Name is displayed
    expect(
      find.text('E-commerce Redesign'),
      findsWidgets,
    ); // Breadcrumb + Title
    expect(find.text('Client: Acme Corp'), findsOneWidget);

    // Verify Summary Cards values
    expect(find.text('₹85.00'), findsOneWidget); // Hourly Rate
    expect(find.text('142.5 hrs'), findsOneWidget); // Total Hours
    expect(find.text('₹12,112.50'), findsOneWidget); // Total Revenue

    // Verify Tabs
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Kanban Board'), findsOneWidget);
    expect(find.text('Analytics'), findsOneWidget);

    // Verify Session Item
    expect(find.text('Homepage Wireframes'), findsOneWidget);
  });
}
