import 'package:flutter/material.dart';

class PrivacySettingsScreen extends StatefulWidget {
  const PrivacySettingsScreen({super.key});

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  // Profile visibility
  String _profileVisibility = 'All Lawyers';
  bool _showEmail = true;
  bool _showPhone = false;
  bool _showLocation = true;

  // Activity
  bool _showOnlineStatus = true;
  bool _showLastSeen = true;
  bool _activityStatus = true;

  // Data sharing
  bool _analyticsEnabled = true;
  bool _personalizedAds = false;
  bool _shareWithPartners = false;

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
                  _SectionTitle(icon: Icons.visibility, title: 'Profile Visibility'),
                  const SizedBox(height: 12),
                  _ProfileVisibilityCard(
                    visibility: _profileVisibility,
                    onChanged: (v) => setState(() => _profileVisibility = v),
                  ),
                  const SizedBox(height: 16),
                  _ContactInfoSection(
                    showEmail: _showEmail,
                    showPhone: _showPhone,
                    showLocation: _showLocation,
                    onEmailChanged: (v) => setState(() => _showEmail = v),
                    onPhoneChanged: (v) => setState(() => _showPhone = v),
                    onLocationChanged: (v) => setState(() => _showLocation = v),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.circle, title: 'Activity Status'),
                  const SizedBox(height: 12),
                  _ActivitySection(
                    showOnlineStatus: _showOnlineStatus,
                    showLastSeen: _showLastSeen,
                    activityStatus: _activityStatus,
                    onOnlineStatusChanged: (v) => setState(() => _showOnlineStatus = v),
                    onLastSeenChanged: (v) => setState(() => _showLastSeen = v),
                    onActivityStatusChanged: (v) => setState(() => _activityStatus = v),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.share, title: 'Data Sharing'),
                  const SizedBox(height: 12),
                  _DataSharingSection(
                    analyticsEnabled: _analyticsEnabled,
                    personalizedAds: _personalizedAds,
                    shareWithPartners: _shareWithPartners,
                    onAnalyticsChanged: (v) => setState(() => _analyticsEnabled = v),
                    onAdsChanged: (v) => setState(() => _personalizedAds = v),
                    onPartnersChanged: (v) => setState(() => _shareWithPartners = v),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.block, title: 'Blocked Users'),
                  const SizedBox(height: 12),
                  _BlockedUsersCard(),
                  const SizedBox(height: 24),
                  _DataRequestsCard(),
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
              color: Colors.teal.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.privacy_tip, color: Colors.teal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Privacy', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('Control your data', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
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

class _ProfileVisibilityCard extends StatelessWidget {
  final String visibility;
  final ValueChanged<String> onChanged;

  const _ProfileVisibilityCard({required this.visibility, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final options = ['Everyone', 'All Lawyers', 'Connections Only', 'Private'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Who can see your profile?', style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: options.map((option) {
              final isSelected = visibility == option;
              return ChoiceChip(
                label: Text(option),
                selected: isSelected,
                onSelected: (_) => onChanged(option),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ContactInfoSection extends StatelessWidget {
  final bool showEmail;
  final bool showPhone;
  final bool showLocation;
  final ValueChanged<bool> onEmailChanged;
  final ValueChanged<bool> onPhoneChanged;
  final ValueChanged<bool> onLocationChanged;

  const _ContactInfoSection({
    required this.showEmail,
    required this.showPhone,
    required this.showLocation,
    required this.onEmailChanged,
    required this.onPhoneChanged,
    required this.onLocationChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _PrivacyToggle(icon: Icons.email, title: 'Show Email', value: showEmail, onChanged: onEmailChanged),
          const Divider(height: 1, indent: 56),
          _PrivacyToggle(icon: Icons.phone, title: 'Show Phone Number', value: showPhone, onChanged: onPhoneChanged),
          const Divider(height: 1, indent: 56),
          _PrivacyToggle(icon: Icons.location_on, title: 'Show Location', value: showLocation, onChanged: onLocationChanged),
        ],
      ),
    );
  }
}

class _ActivitySection extends StatelessWidget {
  final bool showOnlineStatus;
  final bool showLastSeen;
  final bool activityStatus;
  final ValueChanged<bool> onOnlineStatusChanged;
  final ValueChanged<bool> onLastSeenChanged;
  final ValueChanged<bool> onActivityStatusChanged;

  const _ActivitySection({
    required this.showOnlineStatus,
    required this.showLastSeen,
    required this.activityStatus,
    required this.onOnlineStatusChanged,
    required this.onLastSeenChanged,
    required this.onActivityStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _PrivacyToggle(icon: Icons.circle, title: 'Show Online Status', subtitle: 'Let others see when you\'re online', value: showOnlineStatus, onChanged: onOnlineStatusChanged),
          const Divider(height: 1, indent: 56),
          _PrivacyToggle(icon: Icons.access_time, title: 'Show Last Seen', subtitle: 'Display when you were last active', value: showLastSeen, onChanged: onLastSeenChanged),
          const Divider(height: 1, indent: 56),
          _PrivacyToggle(icon: Icons.trending_up, title: 'Activity Status', subtitle: 'Show your activity in the network', value: activityStatus, onChanged: onActivityStatusChanged),
        ],
      ),
    );
  }
}

class _DataSharingSection extends StatelessWidget {
  final bool analyticsEnabled;
  final bool personalizedAds;
  final bool shareWithPartners;
  final ValueChanged<bool> onAnalyticsChanged;
  final ValueChanged<bool> onAdsChanged;
  final ValueChanged<bool> onPartnersChanged;

  const _DataSharingSection({
    required this.analyticsEnabled,
    required this.personalizedAds,
    required this.shareWithPartners,
    required this.onAnalyticsChanged,
    required this.onAdsChanged,
    required this.onPartnersChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: [
          _PrivacyToggle(icon: Icons.analytics, title: 'Analytics', subtitle: 'Help improve the app', value: analyticsEnabled, onChanged: onAnalyticsChanged),
          const Divider(height: 1, indent: 56),
          _PrivacyToggle(icon: Icons.ads_click, title: 'Personalized Ads', subtitle: 'See relevant advertisements', value: personalizedAds, onChanged: onAdsChanged),
          const Divider(height: 1, indent: 56),
          _PrivacyToggle(icon: Icons.handshake, title: 'Share with Partners', subtitle: 'Allow data sharing with LSK', value: shareWithPartners, onChanged: onPartnersChanged),
        ],
      ),
    );
  }
}

class _PrivacyToggle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _PrivacyToggle({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                if (subtitle != null)
                  Text(subtitle!, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _BlockedUsersCard extends StatelessWidget {
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.block, color: Colors.red, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Blocked Users', style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                Text('0 users blocked', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}

class _DataRequestsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.download, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Text('Your Data Rights', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Under Kenya\'s Data Protection Act, you have the right to access, rectify, or delete your personal data.',
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text('Request Data'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  child: const Text('Delete Data'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
