import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/session_model.dart';
import '../services/auth_service.dart';
import 'package:get/get.dart';

class SessionRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthService _authService = Get.find<AuthService>();

  String? get currentUserId => _authService.firebaseUser.value?.uid;

  CollectionReference<Map<String, dynamic>> _getSessionsCollection() {
    if (currentUserId == null) throw Exception('User not authenticated');
    return _firestore
        .collection('users')
        .doc(currentUserId!)
        .collection('sessions');
  }

  Stream<List<SessionModel>> getActiveSessionsStream() {
    return _getSessionsCollection()
        .where('endTime', isNull: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SessionModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Stream<List<SessionModel>> getSessionsForDateStream(String dateKey) {
    return _getSessionsCollection()
        .where('dateKey', isEqualTo: dateKey)
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SessionModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Stream<List<SessionModel>> getSessionsForRangeStream(
    DateTime start,
    DateTime end,
  ) {
    return _getSessionsCollection()
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('startTime', isLessThanOrEqualTo: Timestamp.fromDate(end))
        .orderBy('startTime', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SessionModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Stream<List<SessionModel>> getSessionsForMonthStream(String monthKey) {
    return _getSessionsCollection()
        .where('monthKey', isEqualTo: monthKey)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => SessionModel.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<String> createSession(SessionModel session) async {
    final docRef = await _getSessionsCollection().add(session.toMap());
    return docRef.id;
  }

  Future<void> updateSession(SessionModel session) async {
    await _getSessionsCollection().doc(session.id).update(session.toMap());
  }

  /// CRITICAL ROUNDING LOGIC
  /// Retrieves all sessions for a specific project on a specific date,
  /// calculates total minutes, and rounds to the nearest hour.
  Future<int> getRoundedDailyHoursForProject(
    String projectId,
    String dateKey,
  ) async {
    final query = await _getSessionsCollection()
        .where('projectId', isEqualTo: projectId)
        .where('dateKey', isEqualTo: dateKey)
        .get();

    int totalMinutes = 0;
    for (var doc in query.docs) {
      final session = SessionModel.fromMap(doc.data(), doc.id);
      totalMinutes += session.durationMinutes;
    }

    // Rounding applies to DAILY aggregate total
    return (totalMinutes / 60).round();
  }
}
