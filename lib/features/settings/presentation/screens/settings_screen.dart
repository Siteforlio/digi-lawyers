import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _SettingsHeader()),
            SliverToBoxAdapter(child: _AccountCard()),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _SettingsSection(
                    title: 'General',
                    items: [
                      _SettingsItem(
                        icon: Icons.notifications_outlined,
                        title: 'Notifications',
                        subtitle: 'Push, email & reminders',
                        color: Colors.orange,
                        onTap: () => context.push('/settings/notifications'),
                      ),
                      _SettingsItem(
                        icon: Icons.palette_outlined,
                        title: 'Appearance',
                        subtitle: 'Theme, language & display',
                        color: Colors.purple,
                        onTap: () => context.push('/settings/appearance'),
                      ),
                      _SettingsItem(
                        icon: Icons.sync,
                        title: 'Calendar Sync',
                        subtitle: 'Google & Apple Calendar',
                        color: Colors.blue,
                        onTap: () => context.push('/calendar/sync'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SettingsSection(
                    title: 'Privacy & Security',
                    items: [
                      _SettingsItem(
                        icon: Icons.security_outlined,
                        title: 'Security',
                        subtitle: 'Password, 2FA & biometrics',
                        color: Colors.green,
                        onTap: () => context.push('/settings/security'),
                      ),
                      _SettingsItem(
                        icon: Icons.privacy_tip_outlined,
                        title: 'Privacy',
                        subtitle: 'Data sharing & visibility',
                        color: Colors.teal,
                        onTap: () => context.push('/settings/privacy'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SettingsSection(
                    title: 'Data',
                    items: [
                      _SettingsItem(
                        icon: Icons.storage_outlined,
                        title: 'Storage & Data',
                        subtitle: 'Cache, backup & export',
                        color: Colors.indigo,
                        onTap: () => context.push('/settings/storage'),
                      ),
                      _SettingsItem(
                        icon: Icons.download_outlined,
                        title: 'Download Data',
                        subtitle: 'Export your information',
                        color: Colors.cyan,
                        onTap: () {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  _SettingsSection(
                    title: 'Support',
                    items: [
                      _SettingsItem(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        subtitle: 'FAQs, contact & feedback',
                        color: Colors.amber,
                        onTap: () => context.push('/settings/help'),
                      ),
                      _SettingsItem(
                        icon: Icons.info_outline,
                        title: 'About',
                        subtitle: 'Version, terms & licenses',
                        color: Colors.blueGrey,
                        onTap: () => context.push('/settings/about'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _DangerZone(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SettingsHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            style: IconButton.styleFrom(backgroundColor: theme.colorScheme.surfaceContainerHighest),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Settings', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('Manage your preferences', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 2),
            ),
            child: const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white24,
              child: Text('JK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Adv. John Kamau', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Icon(Icons.check, size: 10, color: theme.colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('john.kamau@lawfirm.co.ke', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, size: 14, color: Colors.greenAccent),
                      SizedBox(width: 4),
                      Text('LSK Verified', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => context.push('/profile/edit'),
            icon: const Icon(Icons.edit_outlined, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<_SettingsItem> items;

  const _SettingsSection({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary)),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final isLast = entry.key == items.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast) Divider(height: 1, indent: 72, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _SettingsItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
      title: Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: onTap,
    );
  }
}

class _DangerZone extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red.shade400, size: 20),
              const SizedBox(width: 8),
              Text('Danger Zone', style: theme.textTheme.titleSmall?.copyWith(color: Colors.red.shade400, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout, size: 18),
                  label: const Text('Sign Out'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showDeleteAccountDialog(context),
                  icon: const Icon(Icons.delete_forever, size: 18),
                  label: const Text('Delete'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: BorderSide(color: Colors.red.withValues(alpha: 0.5)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign Out'),
        content: const Text('Are you sure you want to sign out of your account?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/login');
            },
            child: const Text('Sign Out'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'This action is irreversible. All your data, including cases, documents, and billing history will be permanently deleted.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
