import 'package:flutter_test/flutter_test.dart';
import 'package:hourstack/data/models/project_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  group('ProjectModel Deadline Test', () {
    final deadline = DateTime(2026, 12, 31);

    test('should include deadline in toMap', () {
      final project = ProjectModel(
        id: 'test-id',
        name: 'Test Project',
        createdAt: DateTime.now(),
        deadline: deadline,
      );

      final map = project.toMap();
      expect(map['deadline'], isA<Timestamp>());
      expect((map['deadline'] as Timestamp).toDate(), deadline);
    });

    test('should parse deadline from fromMap', () {
      final now = DateTime.now();
      final map = {
        'name': 'Test Project',
        'createdAt': Timestamp.fromDate(now),
        'deadline': Timestamp.fromDate(deadline),
      };

      final project = ProjectModel.fromMap(map, 'test-id');
      expect(project.deadline, deadline);
    });

    test('should handle null deadline in toMap/fromMap', () {
      final project = ProjectModel(
        id: 'test-id',
        name: 'Test Project',
        createdAt: DateTime.now(),
        deadline: null,
      );

      final map = project.toMap();
      expect(map['deadline'], isNull);

      final fromMapProject = ProjectModel.fromMap(map, 'test-id');
      expect(fromMapProject.deadline, isNull);
    });
  });
}
