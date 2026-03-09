import 'package:flutter_test/flutter_test.dart';
import 'package:hourstack/data/models/task_model.dart';
import 'package:hourstack/data/models/project_model.dart';

void main() {
  group('Model Equality Tests', () {
    test('TaskModel equality should be based on ID', () {
      final now = DateTime.now();
      final task1 = TaskModel(
        id: 'task-1',
        title: 'Task 1',
        createdAt: now,
        updatedAt: now,
      );
      final task2 = TaskModel(
        id: 'task-1',
        title: 'Task 1 Different Name',
        createdAt: now,
        updatedAt: now,
      );
      final task3 = TaskModel(
        id: 'task-2',
        title: 'Task 1',
        createdAt: now,
        updatedAt: now,
      );

      expect(task1 == task2, isTrue);
      expect(task1 == task3, isFalse);
      expect(task1.hashCode == task2.hashCode, isTrue);
    });

    test('ProjectModel equality should be based on ID', () {
      final now = DateTime.now();
      final project1 = ProjectModel(
        id: 'project-1',
        name: 'Project 1',
        createdAt: now,
      );
      final project2 = ProjectModel(
        id: 'project-1',
        name: 'Project 1 Different Name',
        createdAt: now,
      );
      final project3 = ProjectModel(
        id: 'project-2',
        name: 'Project 1',
        createdAt: now,
      );

      expect(project1 == project2, isTrue);
      expect(project1 == project3, isFalse);
      expect(project1.hashCode == project2.hashCode, isTrue);
    });
  });
}
