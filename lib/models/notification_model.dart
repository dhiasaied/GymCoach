import 'package:flutter/material.dart';

enum NotificationAction {
  progressAnalytics,
  aiCoach,
  activityHistory,
  settings,
  help,
}

class NotificationModel {
  NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    required this.timeLabel,
    required this.section,
    required this.category,
    required this.icon,
    required this.iconColor,
    required this.borderColor,
    required this.glowColor,
    required this.action,
    this.isCritical = false,
    this.isRead = false,
  });

  final String id;
  final String title;
  final String body;
  final String timeLabel;
  final String section;
  final String category;
  final IconData icon;
  final Color iconColor;
  final Color borderColor;
  final Color glowColor;
  final NotificationAction action;
  bool isCritical;
  bool isRead;
}
