import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
                  _AppInfoCard(),
                  const SizedBox(height: 24),
                  _SectionTitle(title: 'Legal'),
                  const SizedBox(height: 12),
                  _LegalSection(),
                  const SizedBox(height: 24),
                  _SectionTitle(title: 'Connect With Us'),
                  const SizedBox(height: 12),
                  _SocialLinks(),
                  const SizedBox(height: 24),
                  _SectionTitle(title: 'Acknowledgments'),
                  const SizedBox(height: 12),
                  _AcknowledgmentsCard(),
                  const SizedBox(height: 24),
                  _MadeWithLove(),
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
              color: Colors.blueGrey.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.info_outline, color: Colors.blueGrey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('About', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('Version, terms & licenses', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AppInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(Icons.gavel, color: Colors.white, size: 48),
          ),
          const SizedBox(height: 16),
          const Text(
            'DigiLaw',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            'For Legal Professionals',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.verified, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text('Version 1.0.0 (Build 100)', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _InfoChip(icon: Icons.update, label: 'Up to date'),
              const SizedBox(width: 12),
              _InfoChip(icon: Icons.security, label: 'Secure'),
            ],
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.greenAccent, size: 14),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 11)),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold));
  }
}

class _LegalSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = [
      ('Terms of Service', Icons.description, () => _openUrl('https://digilaw.co.ke/terms')),
      ('Privacy Policy', Icons.privacy_tip, () => _openUrl('https://digilaw.co.ke/privacy')),
      ('Open Source Licenses', Icons.code, () => _showLicenses(context)),
      ('Data Protection (KDPA)', Icons.shield, () => _openUrl('https://digilaw.co.ke/data-protection')),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final item = entry.value;
          final isLast = entry.key == items.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Icon(item.$2, color: theme.colorScheme.onSurfaceVariant, size: 22),
                title: Text(item.$1, style: theme.textTheme.bodyMedium),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: item.$3,
              ),
              if (!isLast) const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'DigiLaw',
      applicationVersion: '1.0.0',
      applicationIcon: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(Icons.gavel, size: 48, color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _SocialLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final socials = [
      ('Website', Icons.language, Colors.blue, 'https://digilaw.co.ke'),
      ('Twitter', Icons.flutter_dash, Colors.lightBlue, 'https://twitter.com/digilawke'),
      ('LinkedIn', Icons.work, Colors.indigo, 'https://linkedin.com/company/digilaw'),
      ('Instagram', Icons.camera_alt, Colors.pink, 'https://instagram.com/digilawke'),
    ];

    return Row(
      children: socials.map((social) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: social.$1 != 'Instagram' ? 8 : 0),
            child: InkWell(
              onTap: () => _openUrl(social.$4),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: social.$3.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: social.$3.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Icon(social.$2, color: social.$3, size: 24),
                    const SizedBox(height: 4),
                    Text(social.$1, style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _AcknowledgmentsCard extends StatelessWidget {
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
              Icon(Icons.favorite, color: Colors.red.shade400, size: 20),
              const SizedBox(width: 8),
              Text('Special Thanks', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 12),
          _AckItem(title: 'Law Society of Kenya', subtitle: 'For verification partnerships'),
          const SizedBox(height: 8),
          _AckItem(title: 'Kenya ICT Authority', subtitle: 'For data protection guidance'),
          const SizedBox(height: 8),
          _AckItem(title: 'Flutter & Dart Team', subtitle: 'For the amazing framework'),
          const SizedBox(height: 8),
          _AckItem(title: 'Open Source Community', subtitle: 'For the incredible packages'),
        ],
      ),
    );
  }
}

class _AckItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const _AckItem({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Container(
          width: 4,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
            Text(subtitle, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
        ),
      ],
    );
  }
}

class _MadeWithLove extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Made with ', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              const Icon(Icons.favorite, color: Colors.red, size: 14),
              Text(' in Nairobi, Kenya', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
          const SizedBox(height: 4),
          Text('© 2024 DigiLaw Technologies Ltd.', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        ],
      ),
    );
  }
}
