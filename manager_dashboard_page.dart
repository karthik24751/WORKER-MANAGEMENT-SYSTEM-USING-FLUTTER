import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/routes/app_router.dart';
import '../../../../app/theme/app_theme.dart';

class ManagerDashboardPage extends StatefulWidget {
  const ManagerDashboardPage({super.key});

  @override
  State<ManagerDashboardPage> createState() => _ManagerDashboardPageState();
}

class _ManagerDashboardPageState extends State<ManagerDashboardPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manager Dashboard'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => AppRouter.goToNotifications(context),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => AppRouter.goToSettings(context),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme),
              const SizedBox(height: 24),
              _buildStatsCards(theme),
              const SizedBox(height: 20),
              _buildTeamOverview(theme),
              const SizedBox(height: 20),
              _buildQuickActions(theme),
              const SizedBox(height: 20),
              _buildRecentAlerts(theme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(theme, context),
    );
  }

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manager Dashboard',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                'Team Alpha - Construction Site',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () => AppRouter.goToProfile(context),
          icon: CircleAvatar(
            radius: 20,
            backgroundColor: theme.colorScheme.secondary,
            child: Text(
              'JM',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ).animate().fadeIn().slideX(begin: -0.3);
  }

  Widget _buildStatsCards(ThemeData theme) {
    final stats = [
      {'title': 'Team Members', 'value': '24', 'icon': Icons.people, 'color': Colors.blue},
      {'title': 'Active Tasks', 'value': '18', 'icon': Icons.task_alt, 'color': Colors.orange},
      {'title': 'Completed Today', 'value': '12', 'icon': Icons.check_circle, 'color': Colors.green},
      {'title': 'Attendance Rate', 'value': '92%', 'icon': Icons.trending_up, 'color': Colors.purple},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.3,
      ),
      itemCount: stats.length,
      itemBuilder: (context, index) {
        final stat = stats[index];
        return Container(
          padding: EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: (stat['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      stat['icon'] as IconData,
                      color: stat['color'] as Color,
                      size: 20,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.trending_up,
                    color: Colors.green,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                stat['value'] as String,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              Text(
                stat['title'] as String,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ).animate(delay: Duration(milliseconds: 200 + (index * 100)))
            .fadeIn()
            .scale(begin: const Offset(0.8, 0.8));
      },
    );
  }

  Widget _buildTeamOverview(ThemeData theme) {
    final teamMembers = [
      {'name': 'John Worker', 'status': 'active', 'task': 'Safety Inspection', 'avatar': 'JW'},
      {'name': 'Sarah Smith', 'status': 'break', 'task': 'Equipment Check', 'avatar': 'SS'},
      {'name': 'Mike Johnson', 'status': 'active', 'task': 'Site Cleanup', 'avatar': 'MJ'},
      {'name': 'Lisa Brown', 'status': 'offline', 'task': 'Documentation', 'avatar': 'LB'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Team Overview',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: teamMembers.length,
          itemBuilder: (context, index) {
            final member = teamMembers[index];
            final status = member['status'] as String;
            Color statusColor = status == 'active' 
                ? Colors.green 
                : status == 'break' 
                    ? Colors.orange 
                    : Colors.grey;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(AppTheme.paddingMedium),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                border: Border.all(color: theme.colorScheme.outline.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: theme.colorScheme.primary,
                        child: Text(
                          member['avatar'] as String,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member['name'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          member['task'] as String,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      status.toUpperCase(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate(delay: Duration(milliseconds: 600 + (index * 100)))
                .fadeIn()
                .slideX(begin: 0.3);
          },
        ),
      ],
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    final actions = [
      {'icon': Icons.assignment, 'label': 'Assign Task', 'color': Colors.blue},
      {'icon': Icons.schedule, 'label': 'Schedule', 'color': Colors.green},
      {'icon': Icons.analytics, 'label': 'Reports', 'color': Colors.purple},
      {'icon': Icons.notifications, 'label': 'Alerts', 'color': Colors.orange},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: actions.map((action) {
            final index = actions.indexOf(action);
            return Expanded(
              child: Container(
                margin: EdgeInsets.only(right: index < actions.length - 1 ? 12 : 0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: (action['color'] as Color).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                  border: Border.all(
                    color: (action['color'] as Color).withOpacity(0.3),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      action['icon'] as IconData,
                      color: action['color'] as Color,
                      size: 28,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      action['label'] as String,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ).animate(delay: Duration(milliseconds: 800 + (index * 100)))
                  .fadeIn()
                  .scale(begin: const Offset(0.8, 0.8)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRecentAlerts(ThemeData theme) {
    final alerts = [
      {'title': 'Safety violation reported', 'time': '2 hours ago', 'type': 'warning'},
      {'title': 'Equipment maintenance due', 'time': '4 hours ago', 'type': 'info'},
      {'title': 'Worker overtime alert', 'time': '6 hours ago', 'type': 'warning'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Alerts',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: alerts.length,
          itemBuilder: (context, index) {
            final alert = alerts[index];
            final type = alert['type'] as String;
            Color alertColor = type == 'warning' ? Colors.orange : Colors.blue;
            IconData alertIcon = type == 'warning' ? Icons.warning : Icons.info;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: EdgeInsets.all(AppTheme.paddingMedium),
              decoration: BoxDecoration(
                color: alertColor.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
                border: Border.all(color: alertColor.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    alertIcon,
                    color: alertColor,
                    size: 20,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert['title'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        Text(
                          alert['time'] as String,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: theme.colorScheme.onSurface.withOpacity(0.5),
                  ),
                ],
              ),
            ).animate(delay: Duration(milliseconds: 1000 + (index * 100)))
                .fadeIn()
                .slideX(begin: -0.3);
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavBar(ThemeData theme, BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.dashboard, 'Dashboard', true, theme, () {}),
          _buildNavItem(Icons.people, 'Team', false, theme, () => AppRouter.goToTasks(context)),
          _buildNavItem(Icons.analytics, 'Reports', false, theme, () => AppRouter.goToChat(context)),
          _buildNavItem(Icons.person, 'Profile', false, theme, () => AppRouter.goToProfile(context)),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, ThemeData theme, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: isActive ? theme.colorScheme.secondary : theme.colorScheme.onSurface.withOpacity(0.6),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: isActive ? theme.colorScheme.secondary : theme.colorScheme.onSurface.withOpacity(0.6),
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
