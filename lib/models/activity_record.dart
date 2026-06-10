import 'package:flutter/material.dart';

class ActivityRecord {
  const ActivityRecord({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.durationMinutes,
    required this.completedAt,
    required this.icon,
    required this.colorValue,
    this.workoutId,
  });

  final String id;
  final String title;
  final String subtitle;
  final int durationMinutes;
  final DateTime completedAt;
  final IconData icon;
  final int colorValue;
  final String? workoutId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subtitle': subtitle,
        'durationMinutes': durationMinutes,
        'completedAt': completedAt.toIso8601String(),
        'iconCodePoint': icon.codePoint,
        'iconFontFamily': icon.fontFamily,
        'iconFontPackage': icon.fontPackage,
        'colorValue': colorValue,
        'workoutId': workoutId,
      };

  factory ActivityRecord.fromJson(Map<String, dynamic> json) {
    return ActivityRecord(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      durationMinutes: json['durationMinutes'] as int,
      completedAt: DateTime.parse(json['completedAt'] as String),
      icon: IconData(
        json['iconCodePoint'] as int,
        fontFamily: json['iconFontFamily'] as String?,
        fontPackage: json['iconFontPackage'] as String?,
      ),
      colorValue: json['colorValue'] as int,
      workoutId: json['workoutId'] as String?,
    );
  }
}
