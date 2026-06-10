import 'package:flutter/material.dart';

import '../constants/app_routes.dart';
import '../models/workout_card.dart';

class NavigationService {
  const NavigationService();

  static void goHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => route.settings.name == AppRoutes.home,
    );
  }

  static void goLogin(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.login,
      (_) => false,
    );
  }

  static void openNotifications(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.notifications);
  }

  static void openSettings(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.settings);
  }

  static void openHelp(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.help);
  }

  static void openWorkoutDetail(BuildContext context, WorkoutCardData workout) {
    Navigator.of(context).pushNamed(AppRoutes.workoutDetail, arguments: workout);
  }
}
