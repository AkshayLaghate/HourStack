import 'package:cloud_firestore/cloud_firestore.dart';
import '../../app/utils/constants.dart';

class ProjectModel {
  final String id;
  final String name;
  final String description;
  final String clientName;
  final double hourlyRate;
  final String currency;
  final DateTime createdAt;
  final bool isActive;
  final double monthlyHours;
  final double monthlyProgress;
  final int colorValue;
  final int iconCodePoint;

  // New fields for redesign
  final double totalHours;
  final double totalRevenue;
  final double weeklyGoalHours;
  final double thisWeekHours;
  final double lastWeekHours;
  final double milestoneProgress;

  ProjectModel({
    required this.id,
    required this.name,
    this.description = '',
    this.clientName = '',
    this.hourlyRate = 0.0,
    this.currency = AppConstants.defaultCurrency,
    required this.createdAt,
    this.isActive = true,
    this.monthlyHours = 0.0,
    this.monthlyProgress = 0.0,
    this.colorValue = 0xFF6366F1,
    this.iconCodePoint = 0xe232, // folder icon as default
    this.totalHours = 0.0,
    this.totalRevenue = 0.0,
    this.weeklyGoalHours = 0.0,
    this.thisWeekHours = 0.0,
    this.lastWeekHours = 0.0,
    this.milestoneProgress = 0.0,
  });

  factory ProjectModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProjectModel(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      clientName: map['clientName'] ?? '',
      hourlyRate: (map['hourlyRate'] ?? 0.0).toDouble(),
      currency: map['currency'] ?? AppConstants.defaultCurrency,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isActive: map['isActive'] ?? true,
      monthlyHours: (map['monthlyHours'] ?? 0.0).toDouble(),
      monthlyProgress: (map['monthlyProgress'] ?? 0.0).toDouble(),
      colorValue: map['colorValue'] ?? 0xFF6366F1,
      iconCodePoint: map['iconCodePoint'] ?? 0xe232,
      totalHours: (map['totalHours'] ?? 0.0).toDouble(),
      totalRevenue: (map['totalRevenue'] ?? 0.0).toDouble(),
      weeklyGoalHours: (map['weeklyGoalHours'] ?? 0.0).toDouble(),
      thisWeekHours: (map['thisWeekHours'] ?? 0.0).toDouble(),
      lastWeekHours: (map['lastWeekHours'] ?? 0.0).toDouble(),
      milestoneProgress: (map['milestoneProgress'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'clientName': clientName,
      'hourlyRate': hourlyRate,
      'currency': currency,
      'createdAt': Timestamp.fromDate(createdAt),
      'isActive': isActive,
      'monthlyHours': monthlyHours,
      'monthlyProgress': monthlyProgress,
      'colorValue': colorValue,
      'iconCodePoint': iconCodePoint,
      'totalHours': totalHours,
      'totalRevenue': totalRevenue,
      'weeklyGoalHours': weeklyGoalHours,
      'thisWeekHours': thisWeekHours,
      'lastWeekHours': lastWeekHours,
      'milestoneProgress': milestoneProgress,
    };
  }
}
