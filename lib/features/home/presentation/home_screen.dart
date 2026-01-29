import 'package:flutter/material.dart';
import 'package:only_law_app/core/config/env_config.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(EnvConfig.appName),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWelcomeCard(context),
            const SizedBox(height: 24),
            Text(
              'Legal Services',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildServicesGrid(context),
            const SizedBox(height: 24),
            Text(
              'Latest Updates',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildUpdatesSection(context),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {},
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.library_books_outlined),
            selectedIcon: Icon(Icons.library_books),
            label: 'Laws',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Card(
      elevation: 0,
      color: colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome to ${EnvConfig.appName}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Access legal resources, statutes, and legal information at your fingertips.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton.tonal(
                    onPressed: () {},
                    child: const Text('Browse Laws'),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Icon(
              Icons.gavel,
              size: 64,
              color: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid(BuildContext context) {
    final services = [
      _ServiceItem(
        icon: Icons.search,
        label: 'Search Laws',
        color: Colors.indigo,
      ),
      _ServiceItem(
        icon: Icons.article_outlined,
        label: 'Statutes',
        color: Colors.teal,
      ),
      _ServiceItem(
        icon: Icons.cases_outlined,
        label: 'Case Law',
        color: Colors.amber.shade700,
      ),
      _ServiceItem(
        icon: Icons.school_outlined,
        label: 'Learn',
        color: Colors.pink,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.5,
      ),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return _buildServiceCard(context, service);
      },
    );
  }

  Widget _buildServiceCard(BuildContext context, _ServiceItem service) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: service.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  service.icon,
                  color: service.color,
                  size: 28,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                service.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpdatesSection(BuildContext context) {
    final updates = [
      _Update(
        title: 'New Legal Amendment',
        subtitle: 'Recent changes to civil procedures',
        date: 'Jan 15, 2026',
        icon: Icons.new_releases,
      ),
      _Update(
        title: 'Supreme Court Ruling',
        subtitle: 'Landmark decision on property rights',
        date: 'Jan 12, 2026',
        icon: Icons.gavel,
      ),
      _Update(
        title: 'Legal Guide Updated',
        subtitle: 'Family law section revised',
        date: 'Jan 10, 2026',
        icon: Icons.menu_book,
      ),
    ];

    return Card(
      elevation: 0,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: updates.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final update = updates[index];
          return ListTile(
            leading: CircleAvatar(
              child: Icon(update.icon, size: 20),
            ),
            title: Text(update.title),
            subtitle: Text(update.subtitle),
            trailing: Text(
              update.date,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            onTap: () {},
          );
        },
      ),
    );
  }
}

class _ServiceItem {
  final IconData icon;
  final String label;
  final Color color;

  _ServiceItem({
    required this.icon,
    required this.label,
    required this.color,
  });
}

class _Update {
  final String title;
  final String subtitle;
  final String date;
  final IconData icon;

  _Update({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
  });
}
