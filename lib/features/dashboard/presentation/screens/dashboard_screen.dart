import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {},
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _DashboardHeader()),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _FinancialSummaryCard(),
                    const SizedBox(height: 20),
                    _TodayScheduleCard(),
                    const SizedBox(height: 20),
                    _QuickActionsGrid(),
                    const SizedBox(height: 20),
                    _NewLeadsCard(),
                    const SizedBox(height: 20),
                    _RecentActivityCard(),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hour = DateTime.now().hour;
    String greeting = hour < 12 ? 'Good morning' : hour < 17 ? 'Good afternoon' : 'Good evening';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.push('/profile'),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                'JK',
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  'Adv. John Kamau',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push('/notifications'),
            icon: Badge(
              label: const Text('3'),
              child: const Icon(Icons.notifications_outlined),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          ),
        ],
      ),
    );
  }
}

class _FinancialSummaryCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'This Month',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, size: 14, color: Colors.greenAccent),
                    SizedBox(width: 4),
                    Text('+12%', style: TextStyle(color: Colors.greenAccent, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'KES 485,000',
            style: theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Total Revenue',
            style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _FinanceItem(label: 'Collected', value: 'KES 340K', icon: Icons.check_circle_outline, color: Colors.greenAccent),
              Container(width: 1, height: 40, color: Colors.white24),
              _FinanceItem(label: 'Pending', value: 'KES 145K', icon: Icons.schedule, color: Colors.orangeAccent),
              Container(width: 1, height: 40, color: Colors.white24),
              _FinanceItem(label: 'Overdue', value: 'KES 45K', icon: Icons.warning_amber_outlined, color: Colors.redAccent),
            ],
          ),
        ],
      ),
    );
  }
}

class _FinanceItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _FinanceItem({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
        ],
      ),
    );
  }
}

class _TodayScheduleCard extends StatelessWidget {
  final _events = const [
    ('Court Hearing', 'Kamau vs State', '9:00 AM', 'Milimani Courts', Icons.gavel, Colors.red),
    ('Client Meeting', 'Jane Wanjiku', '2:00 PM', 'Office', Icons.people, Colors.blue),
    ('Filing Deadline', 'Civil Case 234', '5:00 PM', '', Icons.timer, Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text("Today's Schedule", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${_events.length}',
                    style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            TextButton(onPressed: () => context.go('/calendar'), child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 8),
        ..._events.map((e) => _ScheduleItem(title: e.$1, subtitle: e.$2, time: e.$3, location: e.$4, icon: e.$5, color: e.$6)),
      ],
    );
  }
}

class _ScheduleItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;
  final String location;
  final IconData icon;
  final Color color;

  const _ScheduleItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.location,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
                Text(
                  subtitle + (location.isNotEmpty ? ' • $location' : ''),
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: theme.colorScheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(8)),
            child: Text(time, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final actions = [
      ('New Case', Icons.folder_open_outlined, Colors.blue, '/cases/add'),
      ('Add Event', Icons.event_outlined, Colors.orange, '/calendar/add'),
      ('Invoice', Icons.receipt_long_outlined, Colors.green, '/billing/create'),
      ('Add Client', Icons.person_add_outlined, Colors.purple, '/clients/add'),
      ('Documents', Icons.description_outlined, Colors.teal, '/documents'),
      ('Network', Icons.people_outline, Colors.indigo, '/network'),
      ('Leads', Icons.trending_up, Colors.pink, '/leads'),
      ('Jobs', Icons.work_outline, Colors.amber, '/jobs'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Quick Actions', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: actions.length,
          itemBuilder: (context, index) {
            final action = actions[index];
            return _QuickActionItem(label: action.$1, icon: action.$2, color: action.$3, onTap: () => context.push(action.$4));
          },
        ),
      ],
    );
  }
}

class _QuickActionItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionItem({required this.label, required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 6),
          Text(label, style: theme.textTheme.labelSmall, textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _NewLeadsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.person_add, color: Colors.green, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('3 New Leads', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                Text('from DigiLaw app today', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: () => context.push('/leads'),
            style: FilledButton.styleFrom(backgroundColor: Colors.green.withValues(alpha: 0.2), foregroundColor: Colors.green.shade700),
            child: const Text('View'),
          ),
        ],
      ),
    );
  }
}

class _RecentActivityCard extends StatelessWidget {
  final _activities = const [
    ('Payment received', 'KES 25,000 from Ochieng Matter', '2h ago', Icons.payments_outlined, Colors.green),
    ('Document uploaded', 'Witness statement - Case #127', '5h ago', Icons.description_outlined, Colors.blue),
    ('Case updated', 'Mwangi vs Otieno - Adjourned', '1d ago', Icons.update, Colors.orange),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Activity', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            TextButton(onPressed: () => context.push('/notifications'), child: const Text('View All')),
          ],
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 0,
          child: Column(
            children: _activities.asMap().entries.map((entry) {
              final a = entry.value;
              final isLast = entry.key == _activities.length - 1;
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: a.$5.withValues(alpha: 0.1),
                      child: Icon(a.$4, color: a.$5, size: 20),
                    ),
                    title: Text(a.$1, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                    subtitle: Text(a.$2, style: theme.textTheme.bodySmall),
                    trailing: Text(a.$3, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ),
                  if (!isLast) const Divider(height: 1),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
