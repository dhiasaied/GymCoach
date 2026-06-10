import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../models/notification_model.dart';

class NotificationsProvider extends ChangeNotifier {
  NotificationsProvider() {
    _items.addAll(_seedNotifications());
  }

  final List<NotificationModel> _items = [];

  List<NotificationModel> get items => List.unmodifiable(_items);

  int get total => _items.length;
  int get unread => _items.where((n) => !n.isRead).length;
  int get critical => _items.where((n) => n.isCritical).length;

  void markRead(String id) {
    final item = _items.firstWhere((n) => n.id == id);
    item.isRead = true;
    notifyListeners();
  }

  void remove(String id) {
    _items.removeWhere((n) => n.id == id);
    notifyListeners();
  }

  void clearAll() {
    _items.clear();
    notifyListeners();
  }

  List<NotificationModel> filteredBy(int filterIndex) {
    if (filterIndex <= 0) return items;
    const categories = ['', 'ai-coach', 'workouts', 'system'];
    if (filterIndex >= categories.length) return items;
    final category = categories[filterIndex];
    return _items.where((n) => n.category == category).toList();
  }

  static List<NotificationModel> _seedNotifications() => [
        NotificationModel(
          id: '1',
          title: 'Goal Achieved',
          body:
              'You reached your weekly volume target of 15,000kg! Keep it up.',
          timeLabel: '2 min ago',
          section: 'Today',
          category: 'workouts',
          icon: Icons.check_circle,
          iconColor: AppColors.primaryContainer,
          borderColor: AppColors.primaryContainer,
          glowColor: AppColors.primary,
          action: NotificationAction.activityHistory,
        ),
        NotificationModel(
          id: '2',
          title: 'AI Recovery Insight',
          body:
              'Rest recommended. Muscle fatigue detected in your quads. Focus on mobility.',
          timeLabel: '1h ago',
          section: 'Today',
          category: 'ai-coach',
          icon: Icons.smart_toy,
          iconColor: AppColors.secondary,
          borderColor: AppColors.secondary,
          glowColor: AppColors.secondaryContainer,
          action: NotificationAction.aiCoach,
        ),
        NotificationModel(
          id: '3',
          title: 'Hydration Check',
          body: 'You are 400ml behind your daily hydration goal.',
          timeLabel: 'Yesterday',
          section: 'Yesterday',
          category: 'system',
          icon: Icons.water_drop,
          iconColor: const Color(0xFFFF6D00),
          borderColor: const Color(0xFFFF6D00),
          glowColor: const Color(0xFFFF6D00),
          action: NotificationAction.settings,
        ),
        NotificationModel(
          id: '4',
          title: 'Intense Fatigue Detected',
          body:
              'High CNS load detected during your heavy pull day. Prioritize 8h+ sleep.',
          timeLabel: 'Yesterday',
          section: 'Yesterday',
          category: 'system',
          icon: Icons.error,
          iconColor: AppColors.error,
          borderColor: AppColors.error,
          glowColor: AppColors.error,
          action: NotificationAction.help,
          isCritical: true,
        ),
      ];
}
