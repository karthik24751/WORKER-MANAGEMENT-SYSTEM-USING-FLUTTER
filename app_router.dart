import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/welcome_page.dart';
import '../../features/auth/presentation/pages/role_selection_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/dashboard/presentation/pages/worker_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/manager_dashboard_page.dart';
import '../../features/dashboard/presentation/pages/general_user_dashboard_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../../features/settings/presentation/pages/profile_page.dart';
import '../../features/attendance/presentation/pages/attendance_page.dart';
import '../../features/tasks/presentation/pages/tasks_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';

class AppRouter {
  static const String welcome = '/';
  static const String roleSelection = '/role-selection';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String workerDashboard = '/worker-dashboard';
  static const String managerDashboard = '/manager-dashboard';
  static const String generalUserDashboard = '/general-user-dashboard';
  static const String chat = '/chat';
  static const String settings = '/settings';
  static const String profile = '/profile';
  static const String attendance = '/attendance';
  static const String tasks = '/tasks';
  static const String notifications = '/notifications';

  static final GoRouter router = GoRouter(
    initialLocation: welcome,
    routes: [
      // Authentication routes
      GoRoute(
        path: welcome,
        name: 'welcome',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const WelcomePage(),
        ),
      ),
      GoRoute(
        path: roleSelection,
        name: 'roleSelection',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const RoleSelectionPage(),
        ),
      ),
      GoRoute(
        path: login,
        name: 'login',
        pageBuilder: (context, state) {
          final role = state.uri.queryParameters['role'] ?? 'worker';
          return _buildPageWithTransition(
            context,
            state,
            LoginPage(role: role),
          );
        },
      ),
      GoRoute(
        path: forgotPassword,
        name: 'forgotPassword',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const ForgotPasswordPage(),
        ),
      ),

      // Dashboard routes
      GoRoute(
        path: workerDashboard,
        name: 'workerDashboard',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const WorkerDashboardPage(),
        ),
      ),
      GoRoute(
        path: managerDashboard,
        name: 'managerDashboard',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const ManagerDashboardPage(),
        ),
      ),
      GoRoute(
        path: generalUserDashboard,
        name: 'generalUserDashboard',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const GeneralUserDashboardPage(),
        ),
      ),

      // Feature routes
      GoRoute(
        path: chat,
        name: 'chat',
        pageBuilder: (context, state) {
          final chatId = state.uri.queryParameters['chatId'];
          return _buildPageWithTransition(
            context,
            state,
            ChatPage(chatId: chatId),
          );
        },
      ),
      GoRoute(
        path: attendance,
        name: 'attendance',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const AttendancePage(),
        ),
      ),
      GoRoute(
        path: tasks,
        name: 'tasks',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const TasksPage(),
        ),
      ),
      GoRoute(
        path: notifications,
        name: 'notifications',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const NotificationsPage(),
        ),
      ),
      GoRoute(
        path: settings,
        name: 'settings',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const SettingsPage(),
        ),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        pageBuilder: (context, state) => _buildPageWithTransition(
          context,
          state,
          const ProfilePage(),
        ),
      ),
    ],
  );

  static Page<dynamic> _buildPageWithTransition(
    BuildContext context,
    GoRouterState state,
    Widget child,
  ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: animation.drive(
            Tween(begin: const Offset(1.0, 0.0), end: Offset.zero).chain(
              CurveTween(curve: Curves.easeInOut),
            ),
          ),
          child: child,
        );
      },
    );
  }

  // Navigation helper methods
  static void goToWelcome(BuildContext context) {
    context.go(welcome);
  }

  static void goToRoleSelection(BuildContext context) {
    context.go(roleSelection);
  }

  static void goToLogin(BuildContext context, String role) {
    context.go('$login?role=$role');
  }

  static void goToForgotPassword(BuildContext context) {
    context.go(forgotPassword);
  }

  static void goToDashboard(BuildContext context, String role) {
    switch (role.toLowerCase()) {
      case 'worker':
        context.go(workerDashboard);
        break;
      case 'manager':
        context.go(managerDashboard);
        break;
      case 'user':
      default:
        context.go(generalUserDashboard);
        break;
    }
  }

  static void goToChat(BuildContext context, {String? chatId}) {
    final uri = chatId != null ? '$chat?chatId=$chatId' : chat;
    context.go(uri);
  }

  static void goToAttendance(BuildContext context) {
    context.go(attendance);
  }

  static void goToTasks(BuildContext context) {
    context.go(tasks);
  }

  static void goToSettings(BuildContext context) {
    context.go(settings);
  }

  static void goToProfile(BuildContext context) {
    context.go(profile);
  }

  static void goToNotifications(BuildContext context) {
    context.go(notifications);
  }

  static void goToWorkerDashboard(BuildContext context) {
    context.go(workerDashboard);
  }

  static void goToManagerDashboard(BuildContext context) {
    context.go(managerDashboard);
  }

  static void goToGeneralUserDashboard(BuildContext context) {
    context.go(generalUserDashboard);
  }
}
