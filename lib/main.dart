import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'constants/app_colors.dart';
import 'constants/app_routes.dart';
import 'constants/app_typography.dart';
import 'models/workout_card.dart';
import 'providers/analytics_provider.dart';
import 'providers/auth_provider.dart';
import 'providers/notifications_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/workout_provider.dart';
import 'screens/about_screen.dart';
import 'screens/activity_history_screen.dart';
import 'screens/ai_coach_screen.dart';
import 'screens/create_workout_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/help_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/notifications_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/progress_analytics_screen.dart';
import 'screens/register_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/team_screen.dart';
import 'screens/workout_detail_screen.dart';
import 'screens/workout_session_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final authProvider = AuthProvider();
  final workoutProvider = WorkoutProvider();
  final settingsProvider = SettingsProvider();
  await authProvider.init();
  await workoutProvider.init();
  await settingsProvider.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: workoutProvider),
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => NotificationsProvider()),
      ],
      child: const GymCoachApp(),
    ),
  );
}

class GymCoachApp extends StatelessWidget {
  const GymCoachApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GYMCOACH',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primary,
          onPrimary: AppColors.onPrimary,
          surface: AppColors.surface,
          onSurface: AppColors.onSurface,
          error: AppColors.error,
        ),
        textTheme: TextTheme(
          bodyMedium: AppTypography.bodyMd(),
          headlineMedium: AppTypography.headlineMd(),
        ),
        useMaterial3: true,
      ),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.register: (_) => const RegisterScreen(),
        AppRoutes.forgotPassword: (_) => const ForgotPasswordScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.dashboard: (_) => const DashboardScreen(),
        AppRoutes.progressAnalytics: (_) => const ProgressAnalyticsScreen(),
        AppRoutes.aiCoach: (_) => const AiCoachScreen(),
        AppRoutes.profile: (_) => const ProfileScreen(),
        AppRoutes.about: (_) => const AboutScreen(),
        AppRoutes.notifications: (_) => const NotificationsScreen(),
        AppRoutes.createWorkout: (_) => const CreateWorkoutScreen(),
        AppRoutes.activityHistory: (_) => const ActivityHistoryScreen(),
        AppRoutes.settings: (_) => const SettingsScreen(),
        AppRoutes.team: (_) => const TeamScreen(),
        AppRoutes.help: (_) => const HelpScreen(),
        AppRoutes.workoutDetail: (context) {
          final workout = ModalRoute.of(context)!.settings.arguments! as WorkoutCardData;
          return WorkoutDetailScreen(workout: workout);
        },
        AppRoutes.workoutSession: (context) {
          final workout = ModalRoute.of(context)!.settings.arguments! as WorkoutCardData;
          return WorkoutSessionScreen(workout: workout);
        },
      },
    );
  }
}
