import 'package:flutter/material.dart';

import '../../features/analytics/presentation/screens/analytics_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/insights/presentation/screens/ai_insight_screen.dart';
import '../../features/notifications/presentation/screens/notifications_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/profile/presentation/screens/settings_screen.dart';
import '../../features/splash/presentation/screens/splash_screen.dart';
import '../../features/tasks/presentation/screens/task_details_screen.dart';
import '../../features/tasks/presentation/screens/task_form_screen.dart';
import '../../features/tasks/presentation/screens/task_list_screen.dart';
import 'route_names.dart';

/// Centralized route configuration. Feature screens own their UI; this layer
/// only resolves navigation names and route arguments.
abstract final class AppRouter {
  static Route<void> onGenerateRoute(RouteSettings settings) {
    final Widget screen = switch (settings.name) {
      RouteNames.splash => const SplashScreen(),
      RouteNames.login => const LoginScreen(),
      RouteNames.register => const RegisterScreen(),
      RouteNames.dashboard => const DashboardScreen(),
      RouteNames.taskList => const TaskListScreen(),
      RouteNames.createTask => const TaskFormScreen(mode: TaskFormMode.create),
      RouteNames.editTask => TaskFormScreen(
        mode: TaskFormMode.edit,
        taskId: (settings.arguments as TaskFormRouteArguments?)?.taskId,
      ),
      RouteNames.taskDetails => TaskDetailsScreen(
        taskId: settings.arguments as String?,
      ),
      RouteNames.calendar => const CalendarScreen(),
      RouteNames.aiInsight => AiInsightScreen(
        taskId: settings.arguments as String?,
      ),
      RouteNames.analytics => const AnalyticsScreen(),
      RouteNames.notifications => const NotificationsScreen(),
      RouteNames.profile => const ProfileScreen(),
      RouteNames.settings => const SettingsScreen(),
      _ => const _UnknownRouteScreen(),
    };

    return MaterialPageRoute<void>(builder: (_) => screen, settings: settings);
  }
}

/// Arguments for the shared task form. An edit navigation supplies its task ID;
/// a create navigation uses the create route and needs no arguments.
class TaskFormRouteArguments {
  const TaskFormRouteArguments.edit({required this.taskId});

  final String taskId;
}

class _UnknownRouteScreen extends StatelessWidget {
  const _UnknownRouteScreen();

  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Route not found')));
}
