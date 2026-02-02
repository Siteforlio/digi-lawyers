import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_law_app/features/notifications/domain/entities/notification_entity.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _notifications = [
    NotificationEntity(
      id: '1',
      title: 'New Lead Received',
      body: 'Jane Wanjiku is looking for a family law attorney',
      type: NotificationType.newLead,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      actionRoute: '/leads',
    ),
    NotificationEntity(
      id: '2',
      title: 'Court Date Reminder',
      body: 'Kamau vs. State hearing tomorrow at 9:00 AM',
      type: NotificationType.courtDate,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      actionRoute: '/cases',
      actionId: '1',
    ),
    NotificationEntity(
      id: '3',
      title: 'Payment Received',
      body: 'KES 50,000 received from Wanjiku Holdings Ltd',
      type: NotificationType.payment,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isRead: true,
    ),
    NotificationEntity(
      id: '4',
      title: 'Case Update',
      body: 'Documents uploaded for HCCC/2024/001',
      type: NotificationType.caseUpdate,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      isRead: true,
    ),
    NotificationEntity(
      id: '5',
      title: 'New Connection Request',
      body: 'Adv. Mary Otieno wants to connect with you',
      type: NotificationType.connection,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      actionRoute: '/network',
    ),
    NotificationEntity(
      id: '6',
      title: 'Job Application',
      body: '3 new applications for Senior Associate position',
      type: NotificationType.jobApplication,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      actionRoute: '/jobs',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final unreadCount = _notifications.where((n) => !n.isRead).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState(context)
          : _buildNotificationsList(context),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'No notifications',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'You\'re all caught up!',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context) {
    final today = <NotificationEntity>[];
    final earlier = <NotificationEntity>[];
    final now = DateTime.now();

    for (final notification in _notifications) {
      if (notification.createdAt.day == now.day) {
        today.add(notification);
      } else {
        earlier.add(notification);
      }
    }

    return ListView(
      children: [
        if (today.isNotEmpty) ...[
          _buildSectionHeader(context, 'Today'),
          ...today.map((n) => _NotificationTile(
                notification: n,
                onTap: () => _onNotificationTap(n),
                onDismiss: () => _dismissNotification(n),
              )),
        ],
        if (earlier.isNotEmpty) ...[
          _buildSectionHeader(context, 'Earlier'),
          ...earlier.map((n) => _NotificationTile(
                notification: n,
                onTap: () => _onNotificationTap(n),
                onDismiss: () => _dismissNotification(n),
              )),
        ],
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _onNotificationTap(NotificationEntity notification) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = notification.copyWith(isRead: true);
      }
    });

    if (notification.actionRoute != null) {
      context.push(notification.actionRoute!);
    }
  }

  void _dismissNotification(NotificationEntity notification) {
    setState(() {
      _notifications.removeWhere((n) => n.id == notification.id);
    });
  }

  void _markAllAsRead() {
    setState(() {
      for (var i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;
  final VoidCallback onDismiss;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        color: theme.colorScheme.error,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: Icon(
          Icons.delete_outline,
          color: theme.colorScheme.onError,
        ),
      ),
      child: ListTile(
        leading: _buildIcon(context),
        title: Text(
          notification.title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: notification.isRead ? FontWeight.normal : FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.body,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              _formatTime(notification.createdAt),
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        trailing: notification.isRead
            ? null
            : Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary,
                  shape: BoxShape.circle,
                ),
              ),
        onTap: onTap,
        tileColor: notification.isRead
            ? null
            : theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
      ),
    );
  }

  Widget _buildIcon(BuildContext context) {
    final (icon, color) = _getIconAndColor();

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  (IconData, Color) _getIconAndColor() {
    switch (notification.type) {
      case NotificationType.caseUpdate:
        return (Icons.folder_outlined, Colors.blue);
      case NotificationType.newLead:
        return (Icons.person_add_outlined, Colors.green);
      case NotificationType.payment:
        return (Icons.payments_outlined, Colors.teal);
      case NotificationType.courtDate:
        return (Icons.gavel, Colors.orange);
      case NotificationType.message:
        return (Icons.message_outlined, Colors.purple);
      case NotificationType.connection:
        return (Icons.people_outline, Colors.indigo);
      case NotificationType.jobApplication:
        return (Icons.work_outline, Colors.amber);
      case NotificationType.systemAlert:
        return (Icons.info_outline, Colors.grey);
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    } else if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    } else {
      return '${diff.inDays}d ago';
    }
  }
}
