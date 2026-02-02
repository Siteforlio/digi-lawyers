import 'package:flutter/material.dart';

class SecuritySettingsScreen extends StatefulWidget {
  const SecuritySettingsScreen({super.key});

  @override
  State<SecuritySettingsScreen> createState() => _SecuritySettingsScreenState();
}

class _SecuritySettingsScreenState extends State<SecuritySettingsScreen> {
  bool _biometricEnabled = false;
  bool _twoFactorEnabled = false;
  bool _loginAlerts = true;

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
                  _SecurityStatusCard(twoFactorEnabled: _twoFactorEnabled, biometricEnabled: _biometricEnabled),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.lock_outline, title: 'Password'),
                  const SizedBox(height: 12),
                  _PasswordSection(),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.fingerprint, title: 'Biometric Authentication'),
                  const SizedBox(height: 12),
                  _BiometricCard(
                    enabled: _biometricEnabled,
                    onChanged: (v) => setState(() => _biometricEnabled = v),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.security, title: 'Two-Factor Authentication'),
                  const SizedBox(height: 12),
                  _TwoFactorCard(
                    enabled: _twoFactorEnabled,
                    onChanged: (v) => setState(() => _twoFactorEnabled = v),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.devices, title: 'Active Sessions'),
                  const SizedBox(height: 12),
                  _SessionsCard(),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.notifications_active, title: 'Security Alerts'),
                  const SizedBox(height: 12),
                  _SecurityAlertsCard(
                    loginAlerts: _loginAlerts,
                    onLoginAlertsChanged: (v) => setState(() => _loginAlerts = v),
                  ),
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
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.security, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Security', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('Protect your account', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
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

class _SecurityStatusCard extends StatelessWidget {
  final bool twoFactorEnabled;
  final bool biometricEnabled;

  const _SecurityStatusCard({required this.twoFactorEnabled, required this.biometricEnabled});

  @override
  Widget build(BuildContext context) {
    final score = (twoFactorEnabled ? 1 : 0) + (biometricEnabled ? 1 : 0);
    final status = score == 2 ? 'Excellent' : score == 1 ? 'Good' : 'Needs Improvement';
    final color = score == 2 ? Colors.green : score == 1 ? Colors.orange : Colors.red;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.shade600, color.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.shield, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Security Status', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
                    const SizedBox(height: 4),
                    Text(status, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _StatusItem(icon: Icons.verified_user, label: '2FA', enabled: twoFactorEnabled),
              const SizedBox(width: 16),
              _StatusItem(icon: Icons.fingerprint, label: 'Biometric', enabled: biometricEnabled),
              const SizedBox(width: 16),
              _StatusItem(icon: Icons.lock, label: 'Password', enabled: true),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool enabled;

  const _StatusItem({required this.icon, required this.label, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: enabled ? Colors.greenAccent : Colors.white54, size: 20),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
            Icon(enabled ? Icons.check_circle : Icons.cancel, color: enabled ? Colors.greenAccent : Colors.white54, size: 14),
          ],
        ),
      ),
    );
  }
}

class _PasswordSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Password', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text('Last changed: ', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                        Text('30 days ago', style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange, fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ],
                ),
              ),
              FilledButton.tonal(
                onPressed: () => _showChangePasswordDialog(context),
                child: const Text('Change'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Colors.amber, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'We recommend changing your password every 90 days',
                    style: theme.textTheme.bodySmall?.copyWith(color: Colors.amber.shade700),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _ChangePasswordSheet(),
      ),
    );
  }
}

class _ChangePasswordSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Change Password', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Current Password',
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'New Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Confirm New Password',
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Password updated successfully')),
                  );
                },
                child: const Text('Update Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BiometricCard extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _BiometricCard({required this.enabled, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: enabled ? Colors.blue.withValues(alpha: 0.1) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: enabled ? Colors.blue.withValues(alpha: 0.3) : theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: enabled ? Colors.blue.withValues(alpha: 0.2) : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.fingerprint, color: enabled ? Colors.blue : theme.colorScheme.onSurfaceVariant, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Face ID / Fingerprint', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Quick & secure login', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Switch(
                value: enabled,
                onChanged: onChanged,
                activeTrackColor: Colors.blue.withValues(alpha: 0.5),
                activeThumbColor: Colors.blue,
              ),
            ],
          ),
          if (enabled) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 18),
                  const SizedBox(width: 8),
                  Text('Biometric login is active', style: theme.textTheme.bodySmall?.copyWith(color: Colors.green)),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TwoFactorCard extends StatelessWidget {
  final bool enabled;
  final ValueChanged<bool> onChanged;

  const _TwoFactorCard({required this.enabled, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: enabled ? Colors.purple.withValues(alpha: 0.1) : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: enabled ? Colors.purple.withValues(alpha: 0.3) : theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: enabled ? Colors.purple.withValues(alpha: 0.2) : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.verified_user, color: enabled ? Colors.purple : theme.colorScheme.onSurfaceVariant, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Two-Factor Auth (2FA)', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                    Text('Extra layer of security', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
              Switch(
                value: enabled,
                onChanged: onChanged,
                activeTrackColor: Colors.purple.withValues(alpha: 0.5),
                activeThumbColor: Colors.purple,
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (!enabled)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.orange, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'We strongly recommend enabling 2FA for enhanced security',
                      style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange.shade700),
                    ),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.smartphone, size: 18),
                    label: const Text('Authenticator App'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sms, size: 18),
                    label: const Text('SMS Backup'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _SessionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final sessions = [
      ('iPhone 14 Pro', 'Nairobi, Kenya', 'This device', true),
      ('Chrome on MacBook', 'Nairobi, Kenya', '2 hours ago', false),
      ('Safari on iPad', 'Mombasa, Kenya', '1 day ago', false),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          ...sessions.asMap().entries.map((entry) {
            final session = entry.value;
            final isLast = entry.key == sessions.length - 1;
            return Column(
              children: [
                ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: session.$4 ? Colors.green.withValues(alpha: 0.1) : theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      session.$1.contains('iPhone') ? Icons.phone_iphone : session.$1.contains('iPad') ? Icons.tablet_mac : Icons.computer,
                      color: session.$4 ? Colors.green : theme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                  title: Text(session.$1, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                  subtitle: Text('${session.$2} • ${session.$3}', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                  trailing: session.$4
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text('Current', style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.w500)),
                        )
                      : IconButton(
                          icon: const Icon(Icons.logout, size: 18),
                          onPressed: () {},
                        ),
                ),
                if (!isLast) const Divider(height: 1, indent: 56),
              ],
            );
          }),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.logout, size: 18, color: Colors.red),
              label: const Text('Sign out all other devices', style: TextStyle(color: Colors.red)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecurityAlertsCard extends StatelessWidget {
  final bool loginAlerts;
  final ValueChanged<bool> onLoginAlertsChanged;

  const _SecurityAlertsCard({required this.loginAlerts, required this.onLoginAlertsChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Login Alerts', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                Text('Get notified of new sign-ins', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(value: loginAlerts, onChanged: onLoginAlertsChanged),
        ],
      ),
    );
  }
}
