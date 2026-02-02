import 'package:device_calendar/device_calendar.dart';
import 'package:flutter/material.dart';
import 'package:only_law_app/features/calendar/data/services/calendar_sync_service.dart';

class CalendarSyncScreen extends StatefulWidget {
  const CalendarSyncScreen({super.key});

  @override
  State<CalendarSyncScreen> createState() => _CalendarSyncScreenState();
}

class _CalendarSyncScreenState extends State<CalendarSyncScreen> {
  final CalendarSyncService _syncService = CalendarSyncService();
  bool _isLoading = true;
  bool _hasPermission = false;
  List<Calendar> _calendars = [];

  @override
  void initState() {
    super.initState();
    _loadCalendars();
  }

  Future<void> _loadCalendars() async {
    setState(() => _isLoading = true);

    _hasPermission = await _syncService.requestPermissions();
    if (_hasPermission) {
      _calendars = await _syncService.fetchCalendars();
    }

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _SyncHeader(onBack: () => Navigator.pop(context))),
            SliverToBoxAdapter(child: _IntegrationCards()),
            if (_isLoading)
              const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (!_hasPermission)
              SliverFillRemaining(child: _PermissionDenied(onRetry: _loadCalendars))
            else if (_calendars.isEmpty)
              SliverFillRemaining(child: _NoCalendars())
            else ...[
              SliverToBoxAdapter(child: _SectionHeader(title: 'Available Calendars')),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _CalendarTile(
                      calendar: _calendars[index],
                      syncService: _syncService,
                      onToggle: () => setState(() {}),
                    ),
                    childCount: _calendars.length,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _SyncHeader extends StatelessWidget {
  final VoidCallback onBack;

  const _SyncHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back),
                style: IconButton.styleFrom(
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Calendar Sync',
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Connect external calendars',
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _IntegrationCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Supported Integrations',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _IntegrationCard(
                icon: Icons.g_mobiledata,
                name: 'Google',
                color: Colors.blue,
                isConnected: true,
              )),
              const SizedBox(width: 12),
              Expanded(child: _IntegrationCard(
                icon: Icons.apple,
                name: 'Apple',
                color: Colors.grey.shade800,
                isConnected: false,
              )),
              const SizedBox(width: 12),
              Expanded(child: _IntegrationCard(
                icon: Icons.mail_outline,
                name: 'Outlook',
                color: Colors.blue.shade700,
                isConnected: false,
              )),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Court dates and deadlines will sync to your selected calendars automatically.',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.blue.shade700),
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

class _IntegrationCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final Color color;
  final bool isConnected;

  const _IntegrationCard({
    required this.icon,
    required this.name,
    required this.color,
    required this.isConnected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isConnected ? color.withValues(alpha: 0.5) : theme.colorScheme.outlineVariant,
          width: isConnected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              if (isConnected)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.colorScheme.surface, width: 2),
                    ),
                    child: const Icon(Icons.check, size: 10, color: Colors.white),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(name, style: theme.textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w600)),
          Text(
            isConnected ? 'Connected' : 'Not connected',
            style: theme.textTheme.labelSmall?.copyWith(
              color: isConnected ? Colors.green : theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        children: [
          Icon(Icons.calendar_month, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _CalendarTile extends StatelessWidget {
  final Calendar calendar;
  final CalendarSyncService syncService;
  final VoidCallback onToggle;

  const _CalendarTile({
    required this.calendar,
    required this.syncService,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final typeInfo = syncService.getCalendarTypeInfo(calendar);
    final isSynced = syncService.isCalendarSynced(calendar.id ?? '');

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSynced
              ? typeInfo.color.withValues(alpha: 0.5)
              : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          width: isSynced ? 2 : 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: typeInfo.color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(typeInfo.icon, color: typeInfo.color, size: 24),
        ),
        title: Text(
          calendar.name ?? 'Unknown Calendar',
          style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
        ),
        subtitle: Row(
          children: [
            Icon(
              typeInfo.icon,
              size: 12,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(width: 4),
            Text(
              typeInfo.displayName,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
            if (calendar.isReadOnly ?? false) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Read-only',
                  style: theme.textTheme.labelSmall?.copyWith(fontSize: 10),
                ),
              ),
            ],
          ],
        ),
        trailing: Switch(
          value: isSynced,
          onChanged: (value) {
            syncService.toggleCalendarSync(calendar.id ?? '');
            onToggle();
          },
          activeTrackColor: typeInfo.color.withValues(alpha: 0.5),
          activeThumbColor: typeInfo.color,
        ),
      ),
    );
  }
}

class _PermissionDenied extends StatelessWidget {
  final VoidCallback onRetry;

  const _PermissionDenied({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.lock_outline, size: 48, color: Colors.orange),
            ),
            const SizedBox(height: 24),
            Text(
              'Permission Required',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Calendar access is needed to sync your events with Google or Apple Calendar.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Grant Permission'),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoCalendars extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.calendar_today, size: 48, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text(
              'No Calendars Found',
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Add a Google or Apple account to your device to sync calendars.',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.settings),
              label: const Text('Open Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
