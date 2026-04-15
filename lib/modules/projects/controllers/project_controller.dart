import 'package:get/get.dart';
import '../../../data/models/project_model.dart';
import '../../../data/models/session_model.dart';
import '../../../data/models/task_model.dart';
import '../../../data/repositories/project_repository.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../app/utils/constants.dart';
import 'package:image_picker/image_picker.dart';

class ProjectController extends GetxController {
  final ProjectRepository _repository;
  final SessionRepository _sessionRepository;
  final TaskRepository _taskRepository;

  ProjectController({
    ProjectRepository? repository,
    SessionRepository? sessionRepository,
    TaskRepository? taskRepository,
  }) : _repository = repository ?? Get.find<ProjectRepository>(),
       _sessionRepository = sessionRepository ?? Get.find<SessionRepository>(),
       _taskRepository = taskRepository ?? Get.find<TaskRepository>();

  final RxList<ProjectModel> projects = <ProjectModel>[].obs;
  final RxList<String> clients = <String>[].obs;
  final RxBool isLoading = true.obs;
  final Rxn<ProjectModel> selectedProject = Rxn<ProjectModel>();
  final Rxn<XFile> selectedCoverImage = Rxn<XFile>();
  final _picker = ImagePicker();
  final RxList<SessionModel> recentSessions = <SessionModel>[].obs;
  final RxMap<String, String> taskNamesCache = <String, String>{}.obs;

  void selectProject(ProjectModel? project) {
    selectedProject.value = project;
    if (project != null) {
      _updateProjectHistoricalStats(project);
      _fetchRecentSessions(project);
    } else {
      recentSessions.clear();
    }
  }

  Future<void> _fetchRecentSessions(ProjectModel project) async {
    try {
      final now = DateTime.now();
      final thirtyDaysAgo = now.subtract(const Duration(days: 30));
      final sessions = await _sessionRepository
          .getSessionsForRangeStream(thirtyDaysAgo, now)
          .first;
      final projectSessions = sessions
          .where((s) => s.projectId == project.id && s.endTime != null)
          .toList();
      recentSessions.value = projectSessions;

      // Fetch task names for sessions that have a taskId
      final taskIds = projectSessions
          .where((s) => s.taskId != null && !taskNamesCache.containsKey(s.taskId))
          .map((s) => s.taskId!)
          .toSet();
      if (taskIds.isNotEmpty) {
        final tasks = await _taskRepository.getTasksStream(project.id).first;
        for (var task in tasks) {
          taskNamesCache[task.id] = task.title;
        }
      }
    } catch (e) {
      // Silently fail — UI will show empty state
    }
  }

  String getSessionTitle(SessionModel session) {
    if (session.taskId != null && taskNamesCache.containsKey(session.taskId)) {
      return taskNamesCache[session.taskId]!;
    }
    return 'Work Session';
  }

  Future<void> _updateProjectHistoricalStats(ProjectModel project) async {
    final now = DateTime.now();
    final List<double> weeklyHours = [0.0, 0.0, 0.0, 0.0];

    // Calculate dates for the last 4 weeks
    for (int i = 0; i < 4; i++) {
      // i=0: This Week, i=1: Last Week, i=2: Week 2, i=3: Week 1 (from the UI perspective)
      // Actually the UI shows: Week 1, Week 2, Last Week, This Week
      // indices in my list: [3, 2, 1, 0]

      final weekStart = now.subtract(Duration(days: now.weekday - 1 + (i * 7)));
      final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
      final end = start.add(
        const Duration(days: 6, hours: 23, minutes: 59, seconds: 59),
      );

      try {
        final sessions = await _sessionRepository
            .getSessionsForRangeStream(start, end)
            .first;
        final projectSessions = sessions.where(
          (s) => s.projectId == project.id,
        );

        double totalMinutes = 0;
        for (var session in projectSessions) {
          totalMinutes += session.durationMinutes;
        }

        // Reverse indexing to match the UI expectation: [Week 1, Week 2, Last Week, This Week]
        weeklyHours[3 - i] = totalMinutes / 60.0;
      } catch (e) {
        // Log error or handle gracefully
      }
    }

    // Update the project with calculated stats
    final updatedProject = ProjectModel(
      id: project.id,
      name: project.name,
      description: project.description,
      clientName: project.clientName,
      hourlyRate: project.hourlyRate,
      currency: project.currency,
      createdAt: project.createdAt,
      isActive: project.isActive,
      monthlyHours: project.monthlyHours,
      monthlyProgress: project.monthlyProgress,
      colorValue: project.colorValue,
      iconCodePoint: project.iconCodePoint,
      paymentType: project.paymentType,
      fixedPrice: project.fixedPrice,
      estimatedBudget: project.estimatedBudget,
      isBillable: project.isBillable,
      isBudgetAlertEnabled: project.isBudgetAlertEnabled,
      totalHours: project.totalHours,
      totalRevenue: project.totalRevenue,
      weeklyGoalHours: project.weeklyGoalHours,
      thisWeekHours: weeklyHours[3],
      lastWeekHours: weeklyHours[2],
      milestoneProgress: project.milestoneProgress,
      deadline: project.deadline,
      coverImageUrl: project.coverImageUrl,
      historicalWeeklyHours: weeklyHours,
    );

    // Update in the list to trigger UI update
    int index = projects.indexWhere((p) => p.id == project.id);
    if (index != -1) {
      projects[index] = updatedProject;
      if (selectedProject.value?.id == project.id) {
        selectedProject.value = updatedProject;
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    projects.bindStream(_repository.getProjectsStream());

    // Initialize clients from projects if any

    // Listen for projects changes to sync clients
    ever(projects, (List<ProjectModel> projectList) {
      if (isLoading.value) isLoading.value = false;

      // Update clients list with any new client names found in projects
      for (var project in projectList) {
        if (project.clientName.isNotEmpty &&
            !clients.contains(project.clientName)) {
          clients.add(project.clientName);
        }
      }
    });
  }

  Future<void> addProject(
    String name,
    String description,
    double hourlyRate, {
    String clientName = '',
    String currency = AppConstants.defaultCurrency,
    double monthlyHours = 0.0,
    double monthlyProgress = 0.0,
    int colorValue = 0xFF6366F1,
    int iconCodePoint = 0xe232,
    double weeklyGoalHours = 0.0,
    String paymentType = 'Hourly',
    double fixedPrice = 0.0,
    double estimatedBudget = 0.0,
    bool isBillable = true,
    bool isBudgetAlertEnabled = false,
    DateTime? deadline,
    String? coverImageUrl,
  }) async {
    final newProject = ProjectModel(
      id: '', // Generated by Firestore
      name: name,
      description: description,
      clientName: clientName,
      hourlyRate: hourlyRate,
      currency: currency,
      createdAt: DateTime.now(),
      isActive: true,
      monthlyHours: monthlyHours,
      monthlyProgress: monthlyProgress,
      colorValue: colorValue,
      iconCodePoint: iconCodePoint,
      weeklyGoalHours: weeklyGoalHours,
      paymentType: paymentType,
      fixedPrice: fixedPrice,
      estimatedBudget: estimatedBudget,
      isBillable: isBillable,
      isBudgetAlertEnabled: isBudgetAlertEnabled,
      deadline: deadline,
      coverImageUrl: coverImageUrl,
    );
    try {
      final projectRef = await _repository.firestore
          .collection('users')
          .doc(_repository.currentUserId)
          .collection('projects')
          .add(newProject.toMap());

      // If image is selected, upload it and update the project
      if (selectedCoverImage.value != null) {
        final url = await _repository.uploadProjectCover(
          selectedCoverImage.value!,
          projectRef.id,
        );
        if (url != null) {
          await projectRef.update({'coverImageUrl': url});
        }
      }

      selectedCoverImage.value = null; // Clear selection
      Get.back();
      Get.snackbar('Success', 'Project created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create project: $e');
    }
  }

  Future<void> updateProject(
    ProjectModel project, {
    String? name,
    String? description,
    double? hourlyRate,
    String? clientName,
    String? currency,
    String? paymentType,
    double? fixedPrice,
    bool? isBillable,
    DateTime? deadline,
    String? coverImageUrl,
  }) async {
    String? finalImageUrl = coverImageUrl ?? project.coverImageUrl;

    try {
      if (selectedCoverImage.value != null) {
        finalImageUrl = await _repository.uploadProjectCover(
          selectedCoverImage.value!,
          project.id,
        );
      }

      final updatedProject = ProjectModel(
        id: project.id,
        name: name ?? project.name,
        description: description ?? project.description,
        clientName: clientName ?? project.clientName,
        hourlyRate: hourlyRate ?? project.hourlyRate,
        currency: currency ?? project.currency,
        createdAt: project.createdAt,
        isActive: project.isActive,
        monthlyHours: project.monthlyHours,
        monthlyProgress: project.monthlyProgress,
        colorValue: project.colorValue,
        iconCodePoint: project.iconCodePoint,
        paymentType: paymentType ?? project.paymentType,
        fixedPrice: fixedPrice ?? project.fixedPrice,
        estimatedBudget: project.estimatedBudget,
        isBillable: isBillable ?? project.isBillable,
        isBudgetAlertEnabled: project.isBudgetAlertEnabled,
        totalHours: project.totalHours,
        totalRevenue: project.totalRevenue,
        weeklyGoalHours: project.weeklyGoalHours,
        thisWeekHours: project.thisWeekHours,
        lastWeekHours: project.lastWeekHours,
        milestoneProgress: project.milestoneProgress,
        deadline: deadline ?? project.deadline,
        coverImageUrl: finalImageUrl,
      );

      await _repository.updateProject(updatedProject);
      selectedCoverImage.value = null; // Clear selection
      Get.back();
      Get.snackbar('Success', 'Project updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update project: $e');
    }
  }

  void addClient(String name) {
    if (name.isNotEmpty && !clients.contains(name)) {
      clients.add(name);
    }
  }

  Future<void> toggleProjectActiveStatus(ProjectModel project) async {
    final updatedProject = ProjectModel(
      id: project.id,
      name: project.name,
      description: project.description,
      clientName: project.clientName,
      hourlyRate: project.hourlyRate,
      currency: project.currency,
      createdAt: project.createdAt,
      isActive: !project.isActive,
      monthlyHours: project.monthlyHours,
      monthlyProgress: project.monthlyProgress,
      colorValue: project.colorValue,
      iconCodePoint: project.iconCodePoint,
      totalHours: project.totalHours,
      totalRevenue: project.totalRevenue,
      weeklyGoalHours: project.weeklyGoalHours,
      thisWeekHours: project.thisWeekHours,
      lastWeekHours: project.lastWeekHours,
      milestoneProgress: project.milestoneProgress,
    );
    try {
      await _repository.updateProject(updatedProject);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update project: $e');
    }
  }

  Future<void> deleteProject(String projectId) async {
    try {
      await _repository.deleteProject(projectId);
      Get.back();
      Get.snackbar('Success', 'Project deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete project: $e');
    }
  }

  Future<void> pickCoverImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );
    if (image != null) {
      selectedCoverImage.value = image;
    }
  }
}
