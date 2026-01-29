import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_law_app/features/clients/domain/entities/client_entity.dart';

class ClientsScreen extends StatelessWidget {
  const ClientsScreen({super.key});

  static final _dummyClients = [
    ClientEntity(
      id: '1',
      name: 'John Kamau',
      email: 'john.kamau@email.com',
      phone: '+254 712 345 678',
      type: ClientType.individual,
      createdAt: DateTime.now(),
      activeCases: 2,
      totalBilled: 120000,
      outstandingBalance: 45000,
    ),
    ClientEntity(
      id: '2',
      name: 'Wanjiku Holdings Ltd',
      email: 'legal@wanjikuholdings.co.ke',
      phone: '+254 720 111 222',
      company: 'Wanjiku Holdings Ltd',
      type: ClientType.corporate,
      createdAt: DateTime.now(),
      activeCases: 3,
      totalBilled: 450000,
      outstandingBalance: 0,
    ),
    ClientEntity(
      id: '3',
      name: 'Peter Ochieng',
      email: 'peter.o@email.com',
      phone: '+254 733 444 555',
      type: ClientType.individual,
      createdAt: DateTime.now(),
      activeCases: 1,
      totalBilled: 75000,
      outstandingBalance: 25000,
    ),
    ClientEntity(
      id: '4',
      name: 'Kenya Red Cross',
      email: 'legal@redcross.or.ke',
      phone: '+254 700 600 700',
      company: 'Kenya Red Cross Society',
      type: ClientType.ngo,
      createdAt: DateTime.now(),
      activeCases: 1,
      totalBilled: 200000,
      outstandingBalance: 0,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clients'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _dummyClients.length,
        itemBuilder: (context, index) {
          final client = _dummyClients[index];
          return _ClientCard(
            client: client,
            onTap: () => context.push('/clients/${client.id}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/clients/add'),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Client'),
      ),
    );
  }
}

class _ClientCard extends StatelessWidget {
  final ClientEntity client;
  final VoidCallback onTap;

  const _ClientCard({
    required this.client,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: _getTypeColor(client.type).withValues(alpha: 0.1),
                child: Text(
                  client.name.substring(0, 1),
                  style: TextStyle(
                    color: _getTypeColor(client.type),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            client.name,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        _TypeChip(type: client.type),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      client.email,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        _InfoChip(
                          icon: Icons.folder_outlined,
                          label: '${client.activeCases} cases',
                        ),
                        const SizedBox(width: 12),
                        if (client.outstandingBalance > 0)
                          _InfoChip(
                            icon: Icons.payments_outlined,
                            label: 'KES ${(client.outstandingBalance / 1000).toStringAsFixed(0)}K due',
                            color: Colors.orange,
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Color _getTypeColor(ClientType type) {
    switch (type) {
      case ClientType.individual:
        return Colors.blue;
      case ClientType.corporate:
        return Colors.purple;
      case ClientType.government:
        return Colors.green;
      case ClientType.ngo:
        return Colors.orange;
    }
  }
}

class _TypeChip extends StatelessWidget {
  final ClientType type;

  const _TypeChip({required this.type});

  @override
  Widget build(BuildContext context) {
    String label;
    Color color;

    switch (type) {
      case ClientType.individual:
        label = 'Individual';
        color = Colors.blue;
        break;
      case ClientType.corporate:
        label = 'Corporate';
        color = Colors.purple;
        break;
      case ClientType.government:
        label = 'Govt';
        color = Colors.green;
        break;
      case ClientType.ngo:
        label = 'NGO';
        color = Colors.orange;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;

  const _InfoChip({
    required this.icon,
    required this.label,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chipColor = color ?? theme.colorScheme.onSurfaceVariant;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: chipColor),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(color: chipColor),
        ),
      ],
    );
  }
}
