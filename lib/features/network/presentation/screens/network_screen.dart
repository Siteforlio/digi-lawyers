import 'package:flutter/material.dart';
import 'package:only_law_app/features/network/domain/entities/lawyer_entity.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Network'),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Directory'),
            Tab(text: 'Connections'),
            Tab(text: 'Referrals'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _DirectoryTab(),
          _ConnectionsTab(),
          _ReferralsTab(),
        ],
      ),
    );
  }
}

class _DirectoryTab extends StatelessWidget {
  final _lawyers = const [
    LawyerEntity(
      id: '1',
      name: 'Mary Otieno',
      firm: 'Otieno & Associates',
      location: 'Nairobi',
      practiceAreas: ['Corporate Law', 'M&A'],
      yearsOfExperience: 15,
      isVerified: true,
    ),
    LawyerEntity(
      id: '2',
      name: 'James Mwangi',
      firm: 'Mwangi Legal',
      location: 'Mombasa',
      practiceAreas: ['Maritime Law', 'International Trade'],
      yearsOfExperience: 12,
      isVerified: true,
      connectionStatus: ConnectionStatus.connected,
    ),
    LawyerEntity(
      id: '3',
      name: 'Sarah Kimani',
      firm: 'Kimani & Partners',
      location: 'Nairobi',
      practiceAreas: ['Family Law', 'Estate Planning'],
      yearsOfExperience: 8,
      connectionStatus: ConnectionStatus.pending,
    ),
    LawyerEntity(
      id: '4',
      name: 'Peter Odhiambo',
      firm: 'Odhiambo Law Chambers',
      location: 'Kisumu',
      practiceAreas: ['Criminal Law', 'Litigation'],
      yearsOfExperience: 20,
      isVerified: true,
    ),
    LawyerEntity(
      id: '5',
      name: 'Grace Wambui',
      firm: 'Wambui Legal Services',
      location: 'Nakuru',
      practiceAreas: ['Property Law', 'Conveyancing'],
      yearsOfExperience: 10,
      isVerified: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildFilters(context),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _lawyers.length,
            itemBuilder: (context, index) => _LawyerCard(lawyer: _lawyers[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _FilterChip(label: 'All', isSelected: true),
          _FilterChip(label: 'Corporate'),
          _FilterChip(label: 'Litigation'),
          _FilterChip(label: 'Family'),
          _FilterChip(label: 'Property'),
        ],
      ),
    );
  }
}

class _ConnectionsTab extends StatelessWidget {
  final _connections = const [
    LawyerEntity(
      id: '2',
      name: 'James Mwangi',
      firm: 'Mwangi Legal',
      location: 'Mombasa',
      practiceAreas: ['Maritime Law'],
      yearsOfExperience: 12,
      isVerified: true,
      connectionStatus: ConnectionStatus.connected,
    ),
  ];

  final _pendingRequests = const [
    LawyerEntity(
      id: '3',
      name: 'Sarah Kimani',
      firm: 'Kimani & Partners',
      location: 'Nairobi',
      practiceAreas: ['Family Law'],
      yearsOfExperience: 8,
      connectionStatus: ConnectionStatus.pending,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (_pendingRequests.isNotEmpty) ...[
          Text(
            'Pending Requests',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ..._pendingRequests.map((l) => _ConnectionRequestCard(lawyer: l)),
          const SizedBox(height: 24),
        ],
        Text(
          'My Connections (${_connections.length})',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (_connections.isEmpty)
          _buildEmptyState(context)
        else
          ..._connections.map((l) => _LawyerCard(lawyer: l)),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Icon(Icons.people_outline, size: 48, color: theme.colorScheme.onSurfaceVariant),
            const SizedBox(height: 16),
            const Text('No connections yet'),
          ],
        ),
      ),
    );
  }
}

class _ReferralsTab extends StatelessWidget {
  final _referrals = [
    ReferralEntity(
      id: '1',
      fromLawyerId: '2',
      fromLawyerName: 'James Mwangi',
      clientName: 'John Doe',
      caseType: 'Property Law',
      notes: 'Client needs help with land dispute',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      status: ReferralStatus.pending,
    ),
    ReferralEntity(
      id: '2',
      fromLawyerId: '4',
      fromLawyerName: 'Peter Odhiambo',
      clientName: 'ABC Company Ltd',
      caseType: 'Corporate Law',
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      status: ReferralStatus.accepted,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pending = _referrals.where((r) => r.status == ReferralStatus.pending).length;
    final accepted = _referrals.where((r) => r.status == ReferralStatus.accepted).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _StatColumn(value: '$pending', label: 'Pending', color: theme.colorScheme.primary),
                _StatColumn(value: '$accepted', label: 'Accepted', color: Colors.green),
                _StatColumn(value: '${_referrals.length}', label: 'Total', color: theme.colorScheme.onSurface),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ..._referrals.map((r) => _ReferralCard(referral: r)),
      ],
    );
  }
}

class _StatColumn extends StatelessWidget {
  final String value;
  final String label;
  final Color color;

  const _StatColumn({required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: color),
          ),
          Text(label),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;

  const _FilterChip({required this.label, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(label: Text(label), selected: isSelected, onSelected: (_) {}),
    );
  }
}

class _LawyerCard extends StatelessWidget {
  final LawyerEntity lawyer;

  const _LawyerCard({required this.lawyer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                lawyer.name[0],
                style: TextStyle(color: theme.colorScheme.onPrimaryContainer, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(lawyer.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      if (lawyer.isVerified) ...[
                        const SizedBox(width: 4),
                        Icon(Icons.verified, size: 16, color: theme.colorScheme.primary),
                      ],
                    ],
                  ),
                  Text(lawyer.firm, style: theme.textTheme.bodySmall),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          '${lawyer.location} • ${lawyer.yearsOfExperience}y exp',
                          style: theme.textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 4,
                    children: lawyer.practiceAreas.take(2).map((area) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(area, style: theme.textTheme.labelSmall),
                    )).toList(),
                  ),
                ],
              ),
            ),
            _buildActionButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton() {
    switch (lawyer.connectionStatus) {
      case ConnectionStatus.none:
        return FilledButton.tonal(onPressed: () {}, child: const Text('Connect'));
      case ConnectionStatus.pending:
        return OutlinedButton(onPressed: () {}, child: const Text('Pending'));
      case ConnectionStatus.connected:
        return OutlinedButton(onPressed: () {}, child: const Text('Message'));
    }
  }
}

class _ConnectionRequestCard extends StatelessWidget {
  final LawyerEntity lawyer;

  const _ConnectionRequestCard({required this.lawyer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(lawyer.name[0]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(lawyer.name, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                  Text(lawyer.firm, style: theme.textTheme.bodySmall),
                ],
              ),
            ),
            IconButton(icon: const Icon(Icons.close), onPressed: () {}),
            IconButton(icon: const Icon(Icons.check), color: Colors.green, onPressed: () {}),
          ],
        ),
      ),
    );
  }
}

class _ReferralCard extends StatelessWidget {
  final ReferralEntity referral;

  const _ReferralCard({required this.referral});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(referral.clientName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                      Text(referral.caseType, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.primary)),
                    ],
                  ),
                ),
                _StatusChip(status: referral.status),
              ],
            ),
            const SizedBox(height: 8),
            Text('Referred by ${referral.fromLawyerName}', style: theme.textTheme.bodySmall),
            if (referral.notes != null) ...[
              const SizedBox(height: 8),
              Text(referral.notes!, style: theme.textTheme.bodySmall),
            ],
            if (referral.status == ReferralStatus.pending) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Decline'))),
                  const SizedBox(width: 12),
                  Expanded(child: FilledButton(onPressed: () {}, child: const Text('Accept'))),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final ReferralStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, label) = switch (status) {
      ReferralStatus.pending => (Colors.orange, 'Pending'),
      ReferralStatus.accepted => (Colors.green, 'Accepted'),
      ReferralStatus.declined => (Colors.red, 'Declined'),
      ReferralStatus.completed => (Colors.blue, 'Completed'),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: TextStyle(fontSize: 12, color: color, fontWeight: FontWeight.w500)),
    );
  }
}
