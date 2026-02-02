import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_law_app/features/leads/domain/entities/lead_entity.dart';

class LeadsScreen extends StatefulWidget {
  const LeadsScreen({super.key});

  @override
  State<LeadsScreen> createState() => _LeadsScreenState();
}

class _LeadsScreenState extends State<LeadsScreen> {
  LeadStatus? _filterStatus;

  final _leads = [
    LeadEntity(
      id: '1',
      clientName: 'Jane Wanjiku',
      clientPhone: '+254 722 111 222',
      clientEmail: 'jane.wanjiku@email.com',
      serviceNeeded: 'Family Law',
      description: 'Need help with divorce proceedings and child custody',
      status: LeadStatus.newLead,
      source: LeadSource.digiLaw,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      estimatedValue: 150000,
    ),
    LeadEntity(
      id: '2',
      clientName: 'Peter Mwangi',
      clientPhone: '+254 733 222 333',
      serviceNeeded: 'Property Law',
      description: 'Land dispute with neighbor in Kiambu',
      status: LeadStatus.contacted,
      source: LeadSource.digiLaw,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      lastContactedAt: DateTime.now().subtract(const Duration(hours: 5)),
      estimatedValue: 200000,
    ),
    LeadEntity(
      id: '3',
      clientName: 'Safaricom PLC',
      clientPhone: '+254 700 000 000',
      clientEmail: 'legal@safaricom.co.ke',
      serviceNeeded: 'Corporate Law',
      description: 'Contract review for new partnership agreement',
      status: LeadStatus.qualified,
      source: LeadSource.referral,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      lastContactedAt: DateTime.now().subtract(const Duration(days: 1)),
      estimatedValue: 500000,
    ),
    LeadEntity(
      id: '4',
      clientName: 'Mary Atieno',
      clientPhone: '+254 711 444 555',
      serviceNeeded: 'Employment Law',
      description: 'Wrongful termination case against former employer',
      status: LeadStatus.proposal,
      source: LeadSource.digiLaw,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      lastContactedAt: DateTime.now().subtract(const Duration(hours: 12)),
      estimatedValue: 100000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _LeadsHeader(onFilter: _showFilterSheet)),
            SliverToBoxAdapter(child: _PipelineOverview(leads: _leads)),
            SliverToBoxAdapter(child: _buildStatusFilter()),
            _buildLeadsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.person_add),
        label: const Text('Add Lead'),
      ),
    );
  }

  Widget _buildStatusFilter() {
    final theme = Theme.of(context);

    final filters = [
      (null, 'All', Icons.dashboard_outlined, null),
      (LeadStatus.newLead, 'New', Icons.fiber_new_outlined, Colors.blue),
      (LeadStatus.contacted, 'Contacted', Icons.call_made, Colors.orange),
      (LeadStatus.qualified, 'Qualified', Icons.verified_outlined, Colors.purple),
      (LeadStatus.proposal, 'Proposal', Icons.description_outlined, Colors.teal),
      (LeadStatus.converted, 'Won', Icons.celebration_outlined, Colors.green),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: filters.map((filter) {
            final isSelected = _filterStatus == filter.$1;
            final color = filter.$4 ?? theme.colorScheme.primary;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                avatar: Icon(
                  filter.$3,
                  size: 18,
                  color: isSelected ? theme.colorScheme.onPrimaryContainer : color,
                ),
                label: Text(filter.$2),
                selected: isSelected,
                onSelected: (_) => setState(() => _filterStatus = filter.$1),
                showCheckmark: false,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildLeadsList() {
    final filteredLeads = _filterStatus == null
        ? _leads
        : _leads.where((l) => l.status == _filterStatus).toList();

    if (filteredLeads.isEmpty) {
      return SliverFillRemaining(child: _buildEmptyState());
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => _LeadCard(
            lead: filteredLeads[index],
            onTap: () => context.push('/leads/${filteredLeads[index].id}'),
          ),
          childCount: filteredLeads.length,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
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
              child: Icon(Icons.person_search, size: 48, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 24),
            Text('No leads found', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              'Client inquiries from DigiLaw will appear here',
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) => _FilterBottomSheet(),
    );
  }
}

class _LeadsHeader extends StatelessWidget {
  final VoidCallback onFilter;

  const _LeadsHeader({required this.onFilter});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.green.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.trending_up, color: Colors.green),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Client Leads', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                Text('From DigiLaw app', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ],
            ),
          ),
          IconButton(onPressed: onFilter, icon: const Icon(Icons.filter_list)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.search)),
        ],
      ),
    );
  }
}

class _PipelineOverview extends StatelessWidget {
  final List<LeadEntity> leads;

  const _PipelineOverview({required this.leads});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final newCount = leads.where((l) => l.status == LeadStatus.newLead).length;
    final activeCount = leads.where((l) => l.status != LeadStatus.converted && l.status != LeadStatus.lost).length;
    final totalValue = leads.fold<double>(0, (sum, l) => sum + (l.estimatedValue ?? 0));

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Main stats card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade600, Colors.green.shade400],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Pipeline Value', style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.arrow_upward, size: 14, color: Colors.white.withValues(alpha: 0.9)),
                          const SizedBox(width: 2),
                          Text('+2 this week', style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.9))),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'KES ${_formatCurrency(totalValue)}',
                    style: theme.textTheme.headlineMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    _PipelineStat(icon: Icons.fiber_new, label: 'New', value: '$newCount', color: Colors.white),
                    Container(width: 1, height: 40, color: Colors.white24),
                    _PipelineStat(icon: Icons.pending_actions, label: 'Active', value: '$activeCount', color: Colors.white),
                    Container(width: 1, height: 40, color: Colors.white24),
                    _PipelineStat(icon: Icons.check_circle_outline, label: 'Converted', value: '0', color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Quick actions
          Row(
            children: [
              Expanded(child: _QuickAction(icon: Icons.download, label: 'Export', color: Colors.blue)),
              const SizedBox(width: 10),
              Expanded(child: _QuickAction(icon: Icons.analytics_outlined, label: 'Analytics', color: Colors.purple)),
              const SizedBox(width: 10),
              Expanded(child: _QuickAction(icon: Icons.auto_awesome, label: 'Auto-assign', color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double value) {
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    } else if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }
}

class _PipelineStat extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _PipelineStat({required this.icon, required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: color.withValues(alpha: 0.8), size: 20),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: TextStyle(color: color.withValues(alpha: 0.7), fontSize: 12)),
        ],
      ),
    );
  }
}

class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _QuickAction({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 4),
          Text(label, style: theme.textTheme.labelSmall),
        ],
      ),
    );
  }
}

class _LeadCard extends StatelessWidget {
  final LeadEntity lead;
  final VoidCallback onTap;

  const _LeadCard({required this.lead, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final statusInfo = _getStatusInfo(lead.status);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Avatar
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: statusInfo.$1.withValues(alpha: 0.3), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 24,
                          backgroundColor: statusInfo.$1.withValues(alpha: 0.1),
                          child: Text(
                            _getInitials(lead.clientName),
                            style: TextStyle(color: statusInfo.$1, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    lead.clientName,
                                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                _StatusBadge(status: lead.status),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    lead.serviceNeeded,
                                    style: TextStyle(fontSize: 12, color: theme.colorScheme.primary, fontWeight: FontWeight.w500),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                _SourceBadge(source: lead.source),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  // Description
                  if (lead.description != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      lead.description!,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  // Info row
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: 4),
                      Text(
                        _formatTime(lead.createdAt),
                        style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                      ),
                      if (lead.estimatedValue != null) ...[
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'KES ${_formatValue(lead.estimatedValue!)}',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            // Action buttons
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5))),
              ),
              child: Row(
                children: [
                  _CardAction(icon: Icons.phone_outlined, label: 'Call', color: Colors.green),
                  _buildDivider(context),
                  _CardAction(icon: Icons.message_outlined, label: 'SMS', color: Colors.blue),
                  _buildDivider(context),
                  _CardAction(icon: Icons.chat_outlined, label: 'WhatsApp', color: Colors.teal),
                  _buildDivider(context),
                  _CardAction(icon: Icons.email_outlined, label: 'Email', color: Colors.orange),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Container(width: 1, height: 24, color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.5));
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 2).toUpperCase();
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  String _formatValue(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(0)}K';
    }
    return value.toStringAsFixed(0);
  }

  (Color, String, IconData) _getStatusInfo(LeadStatus status) {
    switch (status) {
      case LeadStatus.newLead:
        return (Colors.blue, 'New', Icons.fiber_new);
      case LeadStatus.contacted:
        return (Colors.orange, 'Contacted', Icons.call_made);
      case LeadStatus.qualified:
        return (Colors.purple, 'Qualified', Icons.verified);
      case LeadStatus.proposal:
        return (Colors.teal, 'Proposal', Icons.description);
      case LeadStatus.converted:
        return (Colors.green, 'Converted', Icons.celebration);
      case LeadStatus.lost:
        return (Colors.grey, 'Lost', Icons.close);
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final LeadStatus status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final info = _getInfo();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: info.$1.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(info.$3, size: 12, color: info.$1),
          const SizedBox(width: 4),
          Text(info.$2, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: info.$1)),
        ],
      ),
    );
  }

  (Color, String, IconData) _getInfo() {
    switch (status) {
      case LeadStatus.newLead:
        return (Colors.blue, 'New', Icons.fiber_new);
      case LeadStatus.contacted:
        return (Colors.orange, 'Contacted', Icons.call_made);
      case LeadStatus.qualified:
        return (Colors.purple, 'Qualified', Icons.verified);
      case LeadStatus.proposal:
        return (Colors.teal, 'Proposal', Icons.description);
      case LeadStatus.converted:
        return (Colors.green, 'Won', Icons.celebration);
      case LeadStatus.lost:
        return (Colors.grey, 'Lost', Icons.close);
    }
  }
}

class _SourceBadge extends StatelessWidget {
  final LeadSource source;

  const _SourceBadge({required this.source});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final info = _getInfo();

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(info.$2, size: 12, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(width: 4),
        Text(info.$1, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }

  (String, IconData) _getInfo() {
    switch (source) {
      case LeadSource.digiLaw:
        return ('DigiLaw', Icons.phone_android);
      case LeadSource.referral:
        return ('Referral', Icons.people);
      case LeadSource.website:
        return ('Website', Icons.language);
      case LeadSource.directContact:
        return ('Direct', Icons.person);
    }
  }
}

class _CardAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _CardAction({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: InkWell(
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: color),
              const SizedBox(width: 4),
              Text(label, style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterBottomSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Text('Filter by Source', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                TextButton(onPressed: () => Navigator.pop(context), child: const Text('Reset')),
              ],
            ),
          ),
          const Divider(height: 1),
          ...LeadSource.values.map((source) {
            final info = _getSourceInfo(source);
            return ListTile(
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: info.$3.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(info.$2, size: 20, color: info.$3),
              ),
              title: Text(info.$1),
              trailing: const Icon(Icons.chevron_right, size: 20),
              onTap: () => Navigator.pop(context),
            );
          }),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  (String, IconData, Color) _getSourceInfo(LeadSource source) {
    switch (source) {
      case LeadSource.digiLaw:
        return ('DigiLaw App', Icons.phone_android, Colors.green);
      case LeadSource.referral:
        return ('Referral', Icons.people, Colors.blue);
      case LeadSource.website:
        return ('Website', Icons.language, Colors.purple);
      case LeadSource.directContact:
        return ('Direct Contact', Icons.person, Colors.orange);
    }
  }
}
