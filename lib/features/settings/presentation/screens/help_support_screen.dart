import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  final _searchController = TextEditingController();
  int? _expandedFaq;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

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
                  _SearchBar(controller: _searchController),
                  const SizedBox(height: 24),
                  _QuickHelpCards(),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.question_answer, title: 'FAQs'),
                  const SizedBox(height: 12),
                  _FaqSection(
                    expandedIndex: _expandedFaq,
                    onExpand: (index) => setState(() {
                      _expandedFaq = _expandedFaq == index ? null : index;
                    }),
                  ),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.headset_mic, title: 'Contact Us'),
                  const SizedBox(height: 12),
                  _ContactOptions(),
                  const SizedBox(height: 24),
                  _SectionTitle(icon: Icons.feedback, title: 'Feedback'),
                  const SizedBox(height: 12),
                  _FeedbackCard(),
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
              color: Colors.amber.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.help_outline, color: Colors.amber),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Help & Support', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('Get assistance and answers', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;

  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: 'Search for help...',
          prefixIcon: const Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class _QuickHelpCards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      ('Getting Started', Icons.play_circle_outline, Colors.blue),
      ('Case Management', Icons.gavel, Colors.purple),
      ('Billing Guide', Icons.receipt_long, Colors.green),
      ('Video Tutorials', Icons.ondemand_video, Colors.orange),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: items.map((item) => _QuickHelpCard(title: item.$1, icon: item.$2, color: item.$3)).toList(),
    );
  }
}

class _QuickHelpCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _QuickHelpCard({required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(title, style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600)),
          ],
        ),
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

class _FaqSection extends StatelessWidget {
  final int? expandedIndex;
  final ValueChanged<int> onExpand;

  const _FaqSection({required this.expandedIndex, required this.onExpand});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final faqs = [
      ('How do I add a new case?', 'Go to Cases tab, tap the + button, fill in the case details including case number, court, client information, and case type. You can also attach documents and set reminders.'),
      ('How do I sync with Google Calendar?', 'Navigate to Settings > Calendar Sync, tap on Google Calendar, grant permissions when prompted, and select which calendars to sync with DigiLaw.'),
      ('How do I generate an invoice?', 'Go to Billing > Create Invoice, select the client and case, add line items for your services, set the due date, and send directly to your client via email or WhatsApp.'),
      ('How do I verify my LSK membership?', 'Go to Profile > Verification, enter your LSK number, upload your practicing certificate, and submit for verification. Verification typically takes 24-48 hours.'),
      ('How do I receive payments via M-Pesa?', 'Set up your M-Pesa Paybill or Till number in Billing > Payment Settings. Clients can pay directly through the app, and you\'ll receive instant notifications.'),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: faqs.asMap().entries.map((entry) {
          final index = entry.key;
          final faq = entry.value;
          final isExpanded = expandedIndex == index;
          final isLast = index == faqs.length - 1;

          return Column(
            children: [
              InkWell(
                onTap: () => onExpand(index),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(faq.$1, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                      ),
                      Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, size: 20),
                    ],
                  ),
                ),
              ),
              if (isExpanded)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(faq.$2, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ),
              if (!isLast) const Divider(height: 1),
            ],
          );
        }).toList(),
      ),
    );
  }
}

class _ContactOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final options = [
      ('Email Support', 'support@digilaw.co.ke', Icons.email, Colors.blue, () => _launchEmail()),
      ('WhatsApp', '+254 700 123 456', Icons.chat, Colors.green, () => _launchWhatsApp()),
      ('Call Us', '+254 20 123 4567', Icons.phone, Colors.orange, () => _launchPhone()),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Column(
        children: options.asMap().entries.map((entry) {
          final option = entry.value;
          final isLast = entry.key == options.length - 1;

          return Column(
            children: [
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: option.$4.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(option.$3, color: option.$4, size: 20),
                ),
                title: Text(option.$1, style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500)),
                subtitle: Text(option.$2, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                trailing: const Icon(Icons.chevron_right, size: 20),
                onTap: option.$5,
              ),
              if (!isLast) const Divider(height: 1, indent: 56),
            ],
          );
        }).toList(),
      ),
    );
  }

  Future<void> _launchEmail() async {
    final uri = Uri.parse('mailto:support@digilaw.co.ke');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchWhatsApp() async {
    final uri = Uri.parse('https://wa.me/254700123456');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchPhone() async {
    final uri = Uri.parse('tel:+254201234567');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _FeedbackCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.rate_review, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Share Your Feedback', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    Text('Help us improve DigiLaw', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showFeedbackDialog(context),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Write Feedback'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                    side: const BorderSide(color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => _rateApp(),
                  icon: const Icon(Icons.star, size: 18),
                  label: const Text('Rate App'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFeedbackDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 16),
            Text('Send Feedback', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Tell us what you think...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Thank you for your feedback!')),
                  );
                },
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _rateApp() {
    // Would launch app store rating
  }
}
