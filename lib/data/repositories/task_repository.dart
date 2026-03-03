import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';
import '../services/auth_service.dart';
import 'package:get/get.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = Get.find<AuthService>();

  String? get currentUserId => _authService.currentUser.value?.id;

  CollectionReference<Map<String, dynamic>> _getTasksCollection(
    String projectId,
  ) {
    if (currentUserId == null) throw Exception('User not authenticated');
    return _firestore
        .collection('users')
        .doc(currentUserId!)
        .collection('projects')
        .doc(projectId)
        .collection('tasks');
  }

  Stream<List<TaskModel>> getTasksStream(String projectId) {
    return _getTasksCollection(
      projectId,
    ).orderBy('updatedAt', descending: true).snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => TaskModel.fromMap(doc.data(), doc.id))
          .toList();
    });
  }

  Future<void> addTask(String projectId, TaskModel task) async {
    await _getTasksCollection(projectId).add(task.toMap());
  }

  Future<void> updateTask(String projectId, TaskModel task) async {
    final updatedTask = task.copyWith(updatedAt: DateTime.now());
    await _getTasksCollection(
      projectId,
    ).doc(task.id).update(updatedTask.toMap());
  }

  Future<void> updateTaskStatus(
    String projectId,
    String taskId,
    TaskStatus status,
  ) async {
    await _getTasksCollection(
      projectId,
    ).doc(taskId).update({'status': status.name, 'updatedAt': Timestamp.now()});
  }

  Future<void> deleteTask(String projectId, String taskId) async {
    await _getTasksCollection(projectId).doc(taskId).delete();
  }
}
