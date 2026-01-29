import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:only_law_app/features/cases/presentation/widgets/case_card.dart';

class CasesScreen extends StatelessWidget {
  const CasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cases'),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _dummyCases.length,
        itemBuilder: (context, index) {
          final caseItem = _dummyCases[index];
          return CaseCard(
            caseData: caseItem,
            onTap: () => context.push('/cases/${caseItem['id']}'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/cases/add'),
        icon: const Icon(Icons.add),
        label: const Text('New Case'),
      ),
    );
  }
}

final List<Map<String, dynamic>> _dummyCases = [
  {
    'id': '1',
    'title': 'Kamau vs State',
    'caseNumber': 'HCCR/2024/001234',
    'client': 'John Kamau',
    'type': 'Criminal',
    'status': 'Active',
    'court': 'Milimani Law Courts',
    'nextDate': '2024-02-15',
  },
  {
    'id': '2',
    'title': 'Wanjiku Land Dispute',
    'caseNumber': 'ELC/2024/000567',
    'client': 'Jane Wanjiku',
    'type': 'Land',
    'status': 'Active',
    'court': 'Environment & Land Court',
    'nextDate': '2024-02-20',
  },
  {
    'id': '3',
    'title': 'Ochieng Employment Matter',
    'caseNumber': 'ELRC/2024/000789',
    'client': 'Peter Ochieng',
    'type': 'Employment',
    'status': 'Pending',
    'court': 'Employment & Labour Court',
    'nextDate': '2024-03-01',
  },
  {
    'id': '4',
    'title': 'Mwangi vs Otieno',
    'caseNumber': 'CMCC/2024/002345',
    'client': 'David Mwangi',
    'type': 'Civil',
    'status': 'Adjourned',
    'court': 'Kibera Law Courts',
    'nextDate': '2024-03-15',
  },
  {
    'id': '5',
    'title': 'Njeri Family Succession',
    'caseNumber': 'SUCC/2024/000123',
    'client': 'Mary Njeri',
    'type': 'Succession',
    'status': 'Active',
    'court': 'Nairobi High Court',
    'nextDate': '2024-02-28',
  },
];
