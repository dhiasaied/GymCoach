abstract final class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const register = '/register';
  static const forgotPassword = '/forgot-password';
  static const home = '/home';
  static const dashboard = '/dashboard';
  static const progressAnalytics = '/progress-analytics';
  static const aiCoach = '/ai-coach';
  static const profile = '/profile';
  static const about = '/about';
  static const notifications = '/notifications';
  static const workoutSession = '/workout-session';
  static const createWorkout = '/create-workout';
  static const activityHistory = '/activity-history';
  static const legal = '/legal';
  static const settings = '/settings';
  static const team = '/team';
  static const help = '/help';
  static const workoutDetail = '/workout-detail';
}

enum BottomNavKey { training, about, insights, coach, profile }

extension BottomNavKeyX on BottomNavKey {
  String get route {
    switch (this) {
      case BottomNavKey.training:
        return AppRoutes.home;
      case BottomNavKey.about:
        return AppRoutes.about;
      case BottomNavKey.insights:
        return AppRoutes.progressAnalytics;
      case BottomNavKey.coach:
        return AppRoutes.aiCoach;
      case BottomNavKey.profile:
        return AppRoutes.profile;
    }
  }

  static BottomNavKey? fromRoute(String? route) {
    switch (route) {
      case AppRoutes.home:
        return BottomNavKey.training;
      case AppRoutes.about:
        return BottomNavKey.about;
      case AppRoutes.progressAnalytics:
        return BottomNavKey.insights;
      case AppRoutes.aiCoach:
        return BottomNavKey.coach;
      case AppRoutes.profile:
        return BottomNavKey.profile;
      default:
        return null;
    }
  }
}
