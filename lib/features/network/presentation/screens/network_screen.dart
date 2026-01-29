import 'package:flutter/material.dart';

class NetworkScreen extends StatelessWidget {
  const NetworkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Network'),
          centerTitle: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add_outlined),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Directory'),
              Tab(text: 'Connections'),
              Tab(text: 'Referrals'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _DirectoryTab(),
            _ConnectionsTab(),
            _ReferralsTab(),
          ],
        ),
      ),
    );
  }
}

class _DirectoryTab extends StatelessWidget {
  final List<Map<String, String>> _lawyers = const [
    {
      'name': 'Adv. Sarah Muthoni',
      'specialty': 'Corporate Law',
      'firm': 'Muthoni & Associates',
      'location': 'Nairobi',
    },
    {
      'name': 'Adv. James Otieno',
      'specialty': 'Criminal Defense',
      'firm': 'Otieno Law Chambers',
      'location': 'Kisumu',
    },
    {
      'name': 'Adv. Grace Wambui',
      'specialty': 'Family Law',
      'firm': 'Wambui Legal Services',
      'location': 'Nairobi',
    },
    {
      'name': 'Adv. Michael Kiprop',
      'specialty': 'Land & Property',
      'firm': 'Kiprop & Partners',
      'location': 'Eldoret',
    },
    {
      'name': 'Adv. Faith Achieng',
      'specialty': 'Employment Law',
      'firm': 'Achieng Legal Consultants',
      'location': 'Mombasa',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _lawyers.length,
      itemBuilder: (context, index) {
        final lawyer = _lawyers[index];
        return Card(
          elevation: 0,
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                lawyer['name']!.split(' ').last[0],
                style: TextStyle(
                  color: theme.colorScheme.onPrimaryContainer,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              lawyer['name']!,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(lawyer['specialty']!),
                Text(
                  '${lawyer['firm']} • ${lawyer['location']}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            isThreeLine: true,
            trailing: OutlinedButton(
              onPressed: () {},
              child: const Text('Connect'),
            ),
          ),
        );
      },
    );
  }
}

class _ConnectionsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No connections yet',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Connect with other lawyers to build your network',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.search),
            label: const Text('Find Lawyers'),
          ),
        ],
      ),
    );
  }
}

class _ReferralsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.share_outlined,
            size: 64,
            color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No referrals yet',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Send and receive case referrals from your network',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
