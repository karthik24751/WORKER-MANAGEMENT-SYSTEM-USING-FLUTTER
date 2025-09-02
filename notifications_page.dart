import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../app/theme/app_theme.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<AppNotification> _notifications = [];
  final List<String> _selectedNotifications = [];
  bool _isSelectionMode = false;

  @override
  void initState() {
    super.initState();
    _loadMockNotifications();
  }

  void _loadMockNotifications() {
    _notifications.addAll([
      AppNotification(
        id: '1',
        title: 'New Task Assigned',
        message: 'You have been assigned a new safety inspection task',
        type: NotificationType.task,
        timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
        isRead: false,
        actionData: {'taskId': 'task_123'},
      ),
      AppNotification(
        id: '2',
        title: 'Attendance Reminder',
        message: 'Don\'t forget to check in for today\'s work',
        type: NotificationType.attendance,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
        isRead: false,
      ),
      AppNotification(
        id: '3',
        title: 'Team Meeting',
        message: 'Weekly team meeting starts in 30 minutes',
        type: NotificationType.meeting,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: true,
      ),
      AppNotification(
        id: '4',
        title: 'System Update',
        message: 'WorkerHub app has been updated to version 2.1.0',
        type: NotificationType.system,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: true,
      ),
      AppNotification(
        id: '5',
        title: 'New Message',
        message: 'John Manager sent you a message in team chat',
        type: NotificationType.chat,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
        isRead: false,
        actionData: {'chatId': 'chat_456'},
      ),
      AppNotification(
        id: '6',
        title: 'Task Overdue',
        message: 'Quality control review task is now overdue',
        type: NotificationType.alert,
        timestamp: DateTime.now().subtract(const Duration(hours: 4)),
        isRead: false,
        actionData: {'taskId': 'task_789'},
      ),
      AppNotification(
        id: '7',
        title: 'Announcement',
        message: 'New safety protocols have been implemented',
        type: NotificationType.announcement,
        timestamp: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.white,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notifications',
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (unreadCount > 0)
              Text(
                '$unreadCount unread',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
          ],
        ),
        actions: [
          if (_isSelectionMode) ...[
            IconButton(
              onPressed: _markSelectedAsRead,
              icon: const Icon(Icons.mark_email_read),
              tooltip: 'Mark as read',
            ),
            IconButton(
              onPressed: _deleteSelected,
              icon: const Icon(Icons.delete),
              tooltip: 'Delete',
            ),
            IconButton(
              onPressed: _exitSelectionMode,
              icon: const Icon(Icons.close),
              tooltip: 'Cancel',
            ),
          ] else ...[
            IconButton(
              onPressed: _markAllAsRead,
              icon: const Icon(Icons.done_all),
              tooltip: 'Mark all as read',
            ),
            PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (context) => [
                const PopupMenuItem(
                  value: 'select',
                  child: Text('Select notifications'),
                ),
                const PopupMenuItem(
                  value: 'settings',
                  child: Text('Notification settings'),
                ),
                const PopupMenuItem(
                  value: 'clear',
                  child: Text('Clear all'),
                ),
              ],
              onSelected: (value) {
                switch (value) {
                  case 'select':
                    _enterSelectionMode();
                    break;
                  case 'settings':
                    _showNotificationSettings(context);
                    break;
                  case 'clear':
                    _clearAllNotifications();
                    break;
                }
              },
            ),
          ],
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState(theme)
          : ListView.builder(
              padding: EdgeInsets.all(AppTheme.paddingMedium),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationCard(notification, index)
                    .animate(delay: Duration(milliseconds: index * 50))
                    .fadeIn()
                    .slideX(begin: 0.3);
              },
            ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: theme.colorScheme.outline,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard(AppNotification notification, int index) {
    final theme = Theme.of(context);
    final isSelected = _selectedNotifications.contains(notification.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: notification.isRead ? 1 : 3,
      child: InkWell(
        onTap: () => _isSelectionMode 
            ? _toggleSelection(notification.id)
            : _handleNotificationTap(notification),
        onLongPress: () => _toggleSelection(notification.id),
        borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
        child: Container(
          padding: EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppTheme.borderRadiusMedium),
            color: isSelected 
                ? theme.colorScheme.primary.withOpacity(0.1)
                : notification.isRead 
                    ? null 
                    : theme.colorScheme.primary.withOpacity(0.05),
            border: isSelected 
                ? Border.all(color: theme.colorScheme.primary, width: 2)
                : null,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_isSelectionMode)
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: Checkbox(
                    value: isSelected,
                    onChanged: (_) => _toggleSelection(notification.id),
                  ),
                ),
              
              _buildNotificationIcon(notification.type, theme),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: notification.isRead 
                                  ? FontWeight.normal 
                                  : FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        if (!notification.isRead)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.primary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 4),
                    
                    Text(
                      notification.message,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatTimestamp(notification.timestamp),
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.5),
                          ),
                        ),
                        _buildNotificationTypeBadge(notification.type, theme),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(NotificationType type, ThemeData theme) {
    IconData icon;
    Color color;

    switch (type) {
      case NotificationType.task:
        icon = Icons.task_alt;
        color = Colors.blue;
        break;
      case NotificationType.attendance:
        icon = Icons.access_time;
        color = Colors.green;
        break;
      case NotificationType.meeting:
        icon = Icons.event;
        color = Colors.purple;
        break;
      case NotificationType.chat:
        icon = Icons.chat;
        color = Colors.orange;
        break;
      case NotificationType.alert:
        icon = Icons.warning;
        color = Colors.red;
        break;
      case NotificationType.announcement:
        icon = Icons.campaign;
        color = Colors.indigo;
        break;
      case NotificationType.system:
        icon = Icons.system_update;
        color = Colors.grey;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        color: color,
        size: 20,
      ),
    );
  }

  Widget _buildNotificationTypeBadge(NotificationType type, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        type.name.toUpperCase(),
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }

  void _handleNotificationTap(AppNotification notification) {
    if (!notification.isRead) {
      setState(() {
        notification.isRead = true;
      });
    }

    // Handle notification actions based on type
    switch (notification.type) {
      case NotificationType.task:
        if (notification.actionData?['taskId'] != null) {
          // Navigate to task details
          _showSnackBar('Opening task details...');
        }
        break;
      case NotificationType.chat:
        if (notification.actionData?['chatId'] != null) {
          // Navigate to chat
          _showSnackBar('Opening chat...');
        }
        break;
      case NotificationType.meeting:
        // Navigate to calendar or meeting details
        _showSnackBar('Opening meeting details...');
        break;
      default:
        _showNotificationDetails(notification);
        break;
    }
  }

  void _showNotificationDetails(AppNotification notification) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(notification.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(notification.message),
            const SizedBox(height: 16),
            Text(
              'Received: ${_formatFullTimestamp(notification.timestamp)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _toggleSelection(String notificationId) {
    setState(() {
      if (!_isSelectionMode) {
        _isSelectionMode = true;
      }
      
      if (_selectedNotifications.contains(notificationId)) {
        _selectedNotifications.remove(notificationId);
      } else {
        _selectedNotifications.add(notificationId);
      }
      
      if (_selectedNotifications.isEmpty) {
        _isSelectionMode = false;
      }
    });
  }

  void _enterSelectionMode() {
    setState(() {
      _isSelectionMode = true;
    });
  }

  void _exitSelectionMode() {
    setState(() {
      _isSelectionMode = false;
      _selectedNotifications.clear();
    });
  }

  void _markSelectedAsRead() {
    setState(() {
      for (final notification in _notifications) {
        if (_selectedNotifications.contains(notification.id)) {
          notification.isRead = true;
        }
      }
    });
    _exitSelectionMode();
    _showSnackBar('Selected notifications marked as read');
  }

  void _deleteSelected() {
    setState(() {
      _notifications.removeWhere((n) => _selectedNotifications.contains(n.id));
    });
    _exitSelectionMode();
    _showSnackBar('Selected notifications deleted');
  }

  void _markAllAsRead() {
    setState(() {
      for (final notification in _notifications) {
        notification.isRead = true;
      }
    });
    _showSnackBar('All notifications marked as read');
  }

  void _clearAllNotifications() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Notifications'),
        content: const Text('Are you sure you want to delete all notifications? This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _notifications.clear();
              });
              Navigator.pop(context);
              _showSnackBar('All notifications cleared');
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear All', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: EdgeInsets.all(AppTheme.paddingLarge),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Settings',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive notifications when app is closed'),
              value: true,
              onChanged: (value) {},
            ),
            
            SwitchListTile(
              title: const Text('Task Notifications'),
              subtitle: const Text('Get notified about new tasks and updates'),
              value: true,
              onChanged: (value) {},
            ),
            
            SwitchListTile(
              title: const Text('Chat Messages'),
              subtitle: const Text('Receive notifications for new messages'),
              value: true,
              onChanged: (value) {},
            ),
            
            SwitchListTile(
              title: const Text('Attendance Reminders'),
              subtitle: const Text('Daily check-in/check-out reminders'),
              value: false,
              onChanged: (value) {},
            ),
            
            const SizedBox(height: 16),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Save Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String _formatFullTimestamp(DateTime timestamp) {
    return '${timestamp.day}/${timestamp.month}/${timestamp.year} at ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}

enum NotificationType {
  task,
  attendance,
  meeting,
  chat,
  alert,
  announcement,
  system,
}

class AppNotification {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  bool isRead;
  final Map<String, dynamic>? actionData;

  AppNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
    this.actionData,
  });
}
