import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_law_app/features/leads/domain/entities/lead_entity.dart';

class LeadDetailScreen extends StatefulWidget {
  final String leadId;

  const LeadDetailScreen({super.key, required this.leadId});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {
  late LeadEntity _lead;

  @override
  void initState() {
    super.initState();
    _lead = LeadEntity(
      id: widget.leadId,
      clientName: 'Jane Wanjiku',
      clientPhone: '+254 722 111 222',
      clientEmail: 'jane.wanjiku@email.com',
      serviceNeeded: 'Family Law',
      description: 'Need help with divorce proceedings and child custody. Has been married for 10 years with 2 children. Looking for an amicable settlement if possible.',
      status: LeadStatus.newLead,
      source: LeadSource.digiLaw,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      estimatedValue: 150000,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lead Details'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleMenuAction,
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'convert', child: Text('Convert to Client')),
              const PopupMenuItem(value: 'lost', child: Text('Mark as Lost')),
              const PopupMenuItem(value: 'delete', child: Text('Delete Lead')),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildClientInfo(context),
          const SizedBox(height: 16),
          _buildQuickActions(context),
          const SizedBox(height: 16),
          _buildStatusSection(context),
          const SizedBox(height: 16),
          _buildDetailsCard(context),
          const SizedBox(height: 16),
          _buildNotesSection(context),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _convertToClient(context),
            icon: const Icon(Icons.person_add),
            label: const Text('Convert to Client'),
          ),
        ],
      ),
    );
  }

  Widget _buildClientInfo(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: theme.colorScheme.primaryContainer,
              child: Text(
                _lead.clientName[0],
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _lead.clientName,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _lead.serviceNeeded,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Via ${_getSourceLabel(_lead.source)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _QuickActionButton(
            icon: Icons.phone,
            label: 'Call',
            color: Colors.green,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.message,
            label: 'SMS',
            color: Colors.blue,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _QuickActionButton(
            icon: Icons.email,
            label: 'Email',
            color: Colors.orange,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildStatusSection(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Lead Status',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: LeadStatus.values
                    .where((s) => s != LeadStatus.lost)
                    .map((status) => _StatusStep(
                          status: status,
                          isActive: _lead.status == status,
                          isPast: _lead.status.index > status.index,
                          onTap: () => _updateStatus(status),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DetailRow(label: 'Phone', value: _lead.clientPhone, icon: Icons.phone),
            if (_lead.clientEmail != null)
              _DetailRow(label: 'Email', value: _lead.clientEmail!, icon: Icons.email),
            _DetailRow(
              label: 'Estimated Value',
              value: 'KES ${_lead.estimatedValue?.toStringAsFixed(0) ?? 'N/A'}',
              icon: Icons.attach_money,
            ),
            _DetailRow(
              label: 'Received',
              value: _formatDate(_lead.createdAt),
              icon: Icons.calendar_today,
            ),
            if (_lead.description != null) ...[
              const Divider(height: 24),
              Text(
                'Description',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(_lead.description!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Notes',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _addNote,
                  icon: const Icon(Icons.add, size: 18),
                  label: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'No notes yet. Add notes to track your interactions.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateStatus(LeadStatus status) {
    setState(() {
      _lead = _lead.copyWith(status: status);
    });
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'convert':
        _convertToClient(context);
        break;
      case 'lost':
        _updateStatus(LeadStatus.lost);
        break;
      case 'delete':
        context.pop();
        break;
    }
  }

  void _convertToClient(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Convert to Client'),
        content: const Text('This will create a new client from this lead. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.go('/clients/add');
            },
            child: const Text('Convert'),
          ),
        ],
      ),
    );
  }

  void _addNote() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          MediaQuery.of(context).viewInsets.bottom + 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const TextField(
              decoration: InputDecoration(
                labelText: 'Add a note',
                hintText: 'Enter your note here...',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Save Note'),
            ),
          ],
        ),
      ),
    );
  }

  String _getSourceLabel(LeadSource source) {
    switch (source) {
      case LeadSource.digiLaw:
        return 'DigiLaw App';
      case LeadSource.referral:
        return 'Referral';
      case LeadSource.website:
        return 'Website';
      case LeadSource.directContact:
        return 'Direct Contact';
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Icon(icon, color: color),
              const SizedBox(height: 4),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _DetailRow({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(value, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusStep extends StatelessWidget {
  final LeadStatus status;
  final bool isActive;
  final bool isPast;
  final VoidCallback onTap;

  const _StatusStep({
    required this.status,
    required this.isActive,
    required this.isPast,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = isActive
        ? theme.colorScheme.primary
        : isPast
            ? theme.colorScheme.primary.withValues(alpha: 0.5)
            : theme.colorScheme.outline;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.1) : null,
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          _getLabel(),
          style: TextStyle(
            color: color,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  String _getLabel() {
    switch (status) {
      case LeadStatus.newLead:
        return 'New';
      case LeadStatus.contacted:
        return 'Contacted';
      case LeadStatus.qualified:
        return 'Qualified';
      case LeadStatus.proposal:
        return 'Proposal';
      case LeadStatus.converted:
        return 'Converted';
      case LeadStatus.lost:
        return 'Lost';
    }
  }
}
