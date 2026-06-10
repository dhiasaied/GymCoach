import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_routes.dart';
import '../models/notification_model.dart';
import '../providers/notifications_provider.dart';

void handleNotificationAction(BuildContext context, NotificationModel item) {
  context.read<NotificationsProvider>().markRead(item.id);

  final route = switch (item.action) {
    NotificationAction.progressAnalytics => AppRoutes.progressAnalytics,
    NotificationAction.aiCoach => AppRoutes.aiCoach,
    NotificationAction.activityHistory => AppRoutes.activityHistory,
    NotificationAction.settings => AppRoutes.settings,
    NotificationAction.help => AppRoutes.help,
  };

  Navigator.of(context).pushNamed(route);
}
