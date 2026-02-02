import 'package:flutter/material.dart';

class StorageSettingsScreen extends StatefulWidget {
  const StorageSettingsScreen({super.key});

  @override
  State<StorageSettingsScreen> createState() => _StorageSettingsScreenState();
}

class _StorageSettingsScreenState extends State<StorageSettingsScreen> {
  bool _autoBackup = true;
  String _backupFrequency = 'Weekly';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _Header()),
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _StorageOverview(),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.cleaning_services, title: 'Cache'),
                  const SizedBox(height: 12),
                  _CacheSection(onClearCache: _clearCache),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.backup, title: 'Backup'),
                  const SizedBox(height: 12),
                  _BackupSection(
                    autoBackup: _autoBackup,
                    backupFrequency: _backupFrequency,
                    onAutoBackupChanged: (v) => setState(() => _autoBackup = v),
                    onFrequencyChanged: (v) => setState(() => _backupFrequency = v),
                    onBackupNow: _backupNow,
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.download, title: 'Export Data'),
                  const SizedBox(height: 12),
                  _ExportSection(),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.folder_open, title: 'Offline Data'),
                  const SizedBox(height: 12),
                  _OfflineDataSection(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text('This will clear all cached data including images and temporary files. Your account data will not be affected.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cache cleared successfully')));
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _backupNow() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Backup started...')));
  }
}

class _Header extends StatelessWidget {
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.indigo.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.storage, color: Colors.indigo),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Storage & Data', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('Cache, backup & export', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StorageOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.indigo, Colors.indigo.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Storage Used', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
                    const SizedBox(height: 4),
                    const Text('156.4 MB', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('of 2 GB cloud storage', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12)),
                  ],
                ),
              ),
              SizedBox(
                width: 80,
                height: 80,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircularProgressIndicator(
                      value: 0.08,
                      strokeWidth: 8,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      valueColor: const AlwaysStoppedAnimation(Colors.white),
                    ),
                    const Text('8%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _StorageBreakdown(),
        ],
      ),
    );
  }
}

class _StorageBreakdown extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      ('Documents', 85.2, Colors.blue),
      ('Cases', 42.8, Colors.purple),
      ('Cache', 18.4, Colors.orange),
      ('Other', 10.0, Colors.grey),
    ];

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: Row(
            children: items.map((item) {
              final flex = (item.$2 / 156.4 * 100).round();
              return Expanded(
                flex: flex > 0 ? flex : 1,
                child: Container(height: 8, color: item.$3),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.map((item) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: item.$3, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 4),
                Text('${item.$1}\n${item.$2} MB', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 9), textAlign: TextAlign.center),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;

  const _SectionTitle({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
      ],
    );
  }
}

class _CacheSection extends StatelessWidget {
  final VoidCallback onClearCache;

  const _CacheSection({required this.onClearCache});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = [
      ('Image Cache', '12.4 MB', Icons.image),
      ('Document Cache', '4.2 MB', Icons.description),
      ('Network Cache', '1.8 MB', Icons.wifi),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          ...items.asMap().entries.map((entry) {
            final item = entry.value;
            return Column(
              children: [
                ListTile(
                  leading: Icon(item.$3, color: theme.colorScheme.onSurfaceVariant),
                  title: Text(item.$1, style: theme.textTheme.bodyMedium),
                  trailing: Text(item.$2, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ),
                const Divider(height: 1, indent: 56),
              ],
            );
          }),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: onClearCache,
                icon: const Icon(Icons.delete_sweep, size: 18),
                label: const Text('Clear All Cache (18.4 MB)'),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.orange),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BackupSection extends StatelessWidget {
  final bool autoBackup;
  final String backupFrequency;
  final ValueChanged<bool> onAutoBackupChanged;
  final ValueChanged<String> onFrequencyChanged;
  final VoidCallback onBackupNow;

  const _BackupSection({
    required this.autoBackup,
    required this.backupFrequency,
    required this.onAutoBackupChanged,
    required this.onFrequencyChanged,
    required this.onBackupNow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          SwitchListTile(
            secondary: Icon(Icons.cloud_sync, color: theme.colorScheme.primary),
            title: const Text('Automatic Backup'),
            subtitle: const Text('Back up to cloud automatically'),
            value: autoBackup,
            onChanged: onAutoBackupChanged,
          ),
          if (autoBackup) ...[
            const Divider(height: 1, indent: 56),
            ListTile(
              leading: const Icon(Icons.schedule),
              title: const Text('Backup Frequency'),
              trailing: DropdownButton<String>(
                value: backupFrequency,
                underline: const SizedBox(),
                items: ['Daily', 'Weekly', 'Monthly'].map((f) => DropdownMenuItem(value: f, child: Text(f))).toList(),
                onChanged: (v) => onFrequencyChanged(v!),
              ),
            ),
          ],
          const Divider(height: 1, indent: 56),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Last Backup'),
            subtitle: const Text('Jan 28, 2024 at 10:30 AM'),
            trailing: TextButton(onPressed: onBackupNow, child: const Text('Backup Now')),
          ),
        ],
      ),
    );
  }
}

class _ExportSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final exports = [
      ('Cases & Matters', 'Export all case data as CSV or PDF', Icons.gavel, Colors.purple),
      ('Client Information', 'Export client records', Icons.people, Colors.blue),
      ('Financial Records', 'Export invoices and payments', Icons.receipt_long, Colors.green),
      ('Full Account Backup', 'Download all your data as ZIP', Icons.archive, Colors.indigo),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: exports.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == exports.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: item.$4.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(item.$3, color: item.$4, size: 20),
                ),
                title: Text(item.$1, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Text(item.$2, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                trailing: IconButton(
                  icon: const Icon(Icons.download, size: 20),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Preparing ${item.$1} export...')));
                  },
                ),
              ),
              if (!isLast) const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _OfflineDataSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.offline_bolt, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Offline Access', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                    Text('5 cases available offline', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('Manage')),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: theme.colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Offline data is stored securely on your device and syncs when connected.',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
