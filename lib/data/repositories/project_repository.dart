import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/project_model.dart';
import '../services/auth_service.dart';
import 'package:get/get.dart';

class ProjectRepository {
  FirebaseFirestore? _firestore;
  AuthService? _authService;

  FirebaseFirestore get firestore => _firestore ??= FirebaseFirestore.instance;
  AuthService get authService => _authService ??= Get.find<AuthService>();

  String? get currentUserId => authService.currentUser.value?.id;

  CollectionReference<Map<String, dynamic>> _getProjectsCollection() {
    if (currentUserId == null) throw Exception('User not authenticated');
    return firestore
        .collection('users')
        .doc(currentUserId!)
        .collection('projects');
  }

  Stream<List<ProjectModel>> getProjectsStream() {
    return _getProjectsCollection()
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => ProjectModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<void> addProject(ProjectModel project) async {
    await _getProjectsCollection().add(project.toMap());
  }

  Future<void> updateProject(ProjectModel project) async {
    await _getProjectsCollection().doc(project.id).update(project.toMap());
  }

  Future<void> deleteProject(String projectId) async {
    await _getProjectsCollection().doc(projectId).delete();
  }
}
