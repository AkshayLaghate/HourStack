import 'package:cloud_firestore/cloud_firestore.dart';

class SessionModel {
  final String id;
  final String projectId;
  final String? taskId;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationMinutes;
  final String dateKey; // yyyy-MM-dd
  final String monthKey; // yyyy-MM

  SessionModel({
    required this.id,
    required this.projectId,
    this.taskId,
    required this.startTime,
    this.endTime,
    this.durationMinutes = 0,
    required this.dateKey,
    required this.monthKey,
  });

  factory SessionModel.fromMap(Map<String, dynamic> map, String documentId) {
    return SessionModel(
      id: documentId,
      projectId: map['projectId'] ?? '',
      taskId: map['taskId'],
      startTime: (map['startTime'] as Timestamp).toDate(),
      endTime: (map['endTime'] as Timestamp?)?.toDate(),
      durationMinutes: map['durationMinutes'] ?? 0,
      dateKey: map['dateKey'] ?? '',
      monthKey: map['monthKey'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'projectId': projectId,
      'taskId': taskId,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': endTime != null ? Timestamp.fromDate(endTime!) : null,
      'durationMinutes': durationMinutes,
      'dateKey': dateKey,
      'monthKey': monthKey,
    };
  }

  SessionModel copyWith({
    String? id,
    String? projectId,
    String? taskId,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    String? dateKey,
    String? monthKey,
  }) {
    return SessionModel(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      taskId: taskId ?? this.taskId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      dateKey: dateKey ?? this.dateKey,
      monthKey: monthKey ?? this.monthKey,
    );
  }
}
