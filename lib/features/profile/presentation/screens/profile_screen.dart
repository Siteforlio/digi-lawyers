import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _ProfileHeader()),
            SliverToBoxAdapter(child: _ProfileCard()),
            SliverToBoxAdapter(child: _StatsCard()),
            SliverToBoxAdapter(child: _AboutSection()),
            SliverToBoxAdapter(child: _PracticeAreasSection()),
            SliverToBoxAdapter(child: _QuickLinksSection()),
            SliverToBoxAdapter(child: _MenuSection()),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 120,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withValues(alpha: 0.7),
            theme.colorScheme.primaryContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.qr_code_scanner, color: theme.colorScheme.onPrimary),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () => context.push('/profile/edit'),
                    icon: Icon(Icons.edit_outlined, color: theme.colorScheme.onPrimary),
                  ),
                  IconButton(
                    onPressed: () => context.push('/settings'),
                    icon: Icon(Icons.settings_outlined, color: theme.colorScheme.onPrimary),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.translate(
      offset: const Offset(0, -50),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            // Avatar with border
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: theme.colorScheme.surface, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: theme.colorScheme.primaryContainer,
                child: Text(
                  'JK',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Name with verified badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Adv. John Kamau',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.check, size: 12, color: theme.colorScheme.onPrimary),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Senior Advocate | Criminal & Civil Litigation',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Location and LSK info
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _InfoChip(icon: Icons.location_on_outlined, label: 'Nairobi'),
                const SizedBox(width: 8),
                _InfoChip(icon: Icons.verified_outlined, label: 'LSK #12345'),
                const SizedBox(width: 8),
                _InfoChip(icon: Icons.calendar_today_outlined, label: '8 yrs'),
              ],
            ),
            const SizedBox(height: 16),
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () => context.push('/profile/edit'),
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Edit Profile'),
                  ),
                ),
                const SizedBox(width: 12),
                OutlinedButton(
                  onPressed: () {},
                  child: const Icon(Icons.share),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _StatItem(value: '12', label: 'Active Cases', icon: Icons.folder_outlined, color: Colors.blue),
            _buildDivider(context),
            _StatItem(value: '156', label: 'Total Cases', icon: Icons.cases_outlined, color: Colors.green),
            _buildDivider(context),
            _StatItem(value: '45', label: 'Connections', icon: Icons.people_outline, color: Colors.purple),
            _buildDivider(context),
            _StatItem(value: '4.8', label: 'Rating', icon: Icons.star_outline, color: Colors.orange),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({required this.value, required this.label, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}

class _AboutSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.translate(
      offset: const Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.person_outline, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('About', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Experienced advocate with over 8 years in criminal defense and civil litigation. '
                'Passionate about access to justice and pro bono work. Former clerk at the Supreme Court of Kenya. '
                'Currently managing partner at Kamau & Associates.',
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PracticeAreasSection extends StatelessWidget {
  final _areas = const [
    ('Criminal Law', Icons.gavel, Colors.red),
    ('Civil Litigation', Icons.balance, Colors.blue),
    ('Family Law', Icons.family_restroom, Colors.pink),
    ('Land & Property', Icons.landscape, Colors.green),
    ('Commercial Law', Icons.business, Colors.orange),
    ('Employment', Icons.work, Colors.purple),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Transform.translate(
      offset: const Offset(0, -10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.workspace_premium_outlined, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text('Practice Areas', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _areas.map((area) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: (area.$3 as Color).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: (area.$3 as Color).withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(area.$2, size: 16, color: area.$3),
                      const SizedBox(width: 6),
                      Text(area.$1, style: TextStyle(fontSize: 13, color: area.$3, fontWeight: FontWeight.w500)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuickLinksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final links = [
      ('Education', 'LLB - UoN, KSL', Icons.school_outlined, Colors.blue),
      ('CLE Points', '45/50 this year', Icons.star_outline, Colors.orange),
      ('Documents', '5 verified', Icons.description_outlined, Colors.green),
      ('Reviews', '24 reviews', Icons.rate_review_outlined, Colors.purple),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.link, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text('Quick Links', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.2,
            children: links.map((link) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: (link.$4 as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(link.$3, size: 18, color: link.$4),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(link.$1, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
                          Text(
                            link.$2,
                            style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MenuSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final menuItems = [
      _MenuItem(icon: Icons.payments_outlined, title: 'Billing & Payments', color: Colors.green),
      _MenuItem(icon: Icons.notifications_outlined, title: 'Notifications', color: Colors.blue),
      _MenuItem(icon: Icons.security_outlined, title: 'Privacy & Security', color: Colors.orange),
      _MenuItem(icon: Icons.help_outline, title: 'Help & Support', color: Colors.purple),
      _MenuItem(icon: Icons.logout, title: 'Sign Out', color: Colors.red, isDestructive: true),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings_outlined, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text('Settings', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: Column(
              children: menuItems.asMap().entries.map((entry) {
                final item = entry.value;
                final isLast = entry.key == menuItems.length - 1;
                return Column(
                  children: [
                    ListTile(
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: item.color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(item.icon, size: 20, color: item.color),
                      ),
                      title: Text(
                        item.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: item.isDestructive ? theme.colorScheme.error : null,
                        ),
                      ),
                      trailing: item.isDestructive ? null : const Icon(Icons.chevron_right, size: 20),
                      onTap: () {},
                    ),
                    if (!isLast) Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final Color color;
  final bool isDestructive;

  _MenuItem({required this.icon, required this.title, required this.color, this.isDestructive = false});
}
