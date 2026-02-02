import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  // Push notifications
  bool _pushEnabled = true;
  bool _courtReminders = true;
  bool _deadlineAlerts = true;
  bool _clientMessages = true;
  bool _caseUpdates = true;
  bool _paymentAlerts = true;
  bool _newLeads = true;
  bool _networkActivity = false;

  // Email notifications
  bool _emailEnabled = true;
  bool _dailyDigest = true;
  bool _weeklyReport = true;
  bool _marketingEmails = false;

  // Reminder timing
  String _courtReminderTime = '1 day before';
  String _deadlineReminderTime = '2 days before';

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
                  _MasterSwitch(
                    icon: Icons.notifications_active,
                    title: 'Push Notifications',
                    subtitle: 'Receive alerts on your device',
                    value: _pushEnabled,
                    color: Colors.orange,
                    onChanged: (v) => setState(() => _pushEnabled = v),
                  ),
                  if (_pushEnabled) ...[
                    const SizedBox(height: 16),
                    _NotificationSection(
                      title: 'Case & Calendar',
                      children: [
                        _NotificationToggle(
                          icon: Icons.gavel,
                          title: 'Court Reminders',
                          subtitle: 'Upcoming hearings & mentions',
                          value: _courtReminders,
                          onChanged: (v) => setState(() => _courtReminders = v),
                        ),
                        _NotificationToggle(
                          icon: Icons.timer,
                          title: 'Deadline Alerts',
                          subtitle: 'Filing deadlines & due dates',
                          value: _deadlineAlerts,
                          onChanged: (v) => setState(() => _deadlineAlerts = v),
                        ),
                        _NotificationToggle(
                          icon: Icons.update,
                          title: 'Case Updates',
                          subtitle: 'Status changes & notes',
                          value: _caseUpdates,
                          onChanged: (v) => setState(() => _caseUpdates = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _NotificationSection(
                      title: 'Clients & Leads',
                      children: [
                        _NotificationToggle(
                          icon: Icons.message,
                          title: 'Client Messages',
                          subtitle: 'New messages from clients',
                          value: _clientMessages,
                          onChanged: (v) => setState(() => _clientMessages = v),
                        ),
                        _NotificationToggle(
                          icon: Icons.person_add,
                          title: 'New Leads',
                          subtitle: 'Inquiries from DigiLaw app',
                          value: _newLeads,
                          onChanged: (v) => setState(() => _newLeads = v),
                        ),
                        _NotificationToggle(
                          icon: Icons.payments,
                          title: 'Payment Alerts',
                          subtitle: 'Invoices & payment received',
                          value: _paymentAlerts,
                          onChanged: (v) => setState(() => _paymentAlerts = v),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _NotificationSection(
                      title: 'Network & Community',
                      children: [
                        _NotificationToggle(
                          icon: Icons.people,
                          title: 'Network Activity',
                          subtitle: 'Connections & referrals',
                          value: _networkActivity,
                          onChanged: (v) => setState(() => _networkActivity = v),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  _MasterSwitch(
                    icon: Icons.email,
                    title: 'Email Notifications',
                    subtitle: 'Receive updates via email',
                    value: _emailEnabled,
                    color: Colors.blue,
                    onChanged: (v) => setState(() => _emailEnabled = v),
                  ),
                  if (_emailEnabled) ...[
                    const SizedBox(height: 16),
                    _NotificationSection(
                      title: 'Email Preferences',
                      children: [
                        _NotificationToggle(
                          icon: Icons.today,
                          title: 'Daily Digest',
                          subtitle: "Summary of today's activities",
                          value: _dailyDigest,
                          onChanged: (v) => setState(() => _dailyDigest = v),
                        ),
                        _NotificationToggle(
                          icon: Icons.analytics,
                          title: 'Weekly Report',
                          subtitle: 'Performance & billing summary',
                          value: _weeklyReport,
                          onChanged: (v) => setState(() => _weeklyReport = v),
                        ),
                        _NotificationToggle(
                          icon: Icons.campaign,
                          title: 'Marketing Emails',
                          subtitle: 'News, tips & promotions',
                          value: _marketingEmails,
                          onChanged: (v) => setState(() => _marketingEmails = v),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  _ReminderTimingSection(
                    courtReminderTime: _courtReminderTime,
                    deadlineReminderTime: _deadlineReminderTime,
                    onCourtReminderChanged: (v) => setState(() => _courtReminderTime = v),
                    onDeadlineReminderChanged: (v) => setState(() => _deadlineReminderTime = v),
                  ),
                  const SizedBox(height: 24),
                  _QuietHoursCard(),
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
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_outlined, color: Colors.orange),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Notifications', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('Manage your alerts', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MasterSwitch extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final Color color;
  final ValueChanged<bool> onChanged;

  const _MasterSwitch({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: value ? color.withValues(alpha: 0.1) : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: value ? color.withValues(alpha: 0.3) : theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: value ? color.withValues(alpha: 0.2) : theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: value ? color : theme.colorScheme.onSurfaceVariant, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: color.withValues(alpha: 0.5),
            activeThumbColor: color,
          ),
        ],
      ),
    );
  }
}

class _NotificationSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _NotificationSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(title, style: theme.textTheme.labelLarge?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ),
        Container(
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: children.asMap().entries.map((entry) {
              final isLast = entry.key == children.length - 1;
              return Column(
                children: [
                  entry.value,
                  if (!isLast) Divider(height: 1, indent: 56, color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _NotificationToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _NotificationToggle({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }
}

class _ReminderTimingSection extends StatelessWidget {
  final String courtReminderTime;
  final String deadlineReminderTime;
  final ValueChanged<String> onCourtReminderChanged;
  final ValueChanged<String> onDeadlineReminderChanged;

  const _ReminderTimingSection({
    required this.courtReminderTime,
    required this.deadlineReminderTime,
    required this.onCourtReminderChanged,
    required this.onDeadlineReminderChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = ['30 minutes before', '1 hour before', '1 day before', '2 days before', '1 week before'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Row(
            children: [
              Icon(Icons.schedule, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text('Reminder Timing', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
          ),
          child: Column(
            children: [
              _TimingDropdown(
                icon: Icons.gavel,
                title: 'Court Hearings',
                value: courtReminderTime,
                options: options,
                onChanged: onCourtReminderChanged,
              ),
              const Divider(height: 24),
              _TimingDropdown(
                icon: Icons.timer,
                title: 'Deadlines',
                value: deadlineReminderTime,
                options: options,
                onChanged: onDeadlineReminderChanged,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TimingDropdown extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  const _TimingDropdown({
    required this.icon,
    required this.title,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 16),
        Expanded(
          child: Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButton<String>(
            value: value,
            underline: const SizedBox(),
            isDense: true,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
            items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
            onChanged: (v) => onChanged(v!),
          ),
        ),
      ],
    );
  }
}

class _QuietHoursCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.indigo.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.indigo.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.indigo.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.nights_stay, color: Colors.indigo, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quiet Hours', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Pause notifications during specific times', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Switch(value: false, onChanged: (v) {}),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 8),
                          Text('10:00 PM', style: theme.textTheme.bodyMedium),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('To', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: theme.colorScheme.outlineVariant),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time, size: 16),
                          const SizedBox(width: 8),
                          Text('7:00 AM', style: theme.textTheme.bodyMedium),
                        ],
                      ),
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
