import 'package:flutter/material.dart';

class RecentActivity extends StatelessWidget {
  const RecentActivity({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final activities = [
      _Activity(
        title: 'New client inquiry received',
        subtitle: 'Property dispute case',
        time: '2 hours ago',
        icon: Icons.mail_outline,
      ),
      _Activity(
        title: 'Payment received',
        subtitle: 'KES 25,000 from Ochieng Matter',
        time: '5 hours ago',
        icon: Icons.payments_outlined,
      ),
      _Activity(
        title: 'Document uploaded',
        subtitle: 'Witness statement - Case #127',
        time: 'Yesterday',
        icon: Icons.description_outlined,
      ),
      _Activity(
        title: 'Case status updated',
        subtitle: 'Mwangi vs Otieno - Adjourned',
        time: 'Yesterday',
        icon: Icons.update,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Activity',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: activities.length,
            separatorBuilder: (context, index) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final activity = activities[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(
                    activity.icon,
                    size: 20,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                title: Text(
                  activity.title,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                subtitle: Text(activity.subtitle),
                trailing: Text(
                  activity.time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _Activity {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;

  _Activity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
  });
}
