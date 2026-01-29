import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AddCaseScreen extends StatefulWidget {
  const AddCaseScreen({super.key});

  @override
  State<AddCaseScreen> createState() => _AddCaseScreenState();
}

class _AddCaseScreenState extends State<AddCaseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _caseNumberController = TextEditingController();
  final _clientController = TextEditingController();
  final _courtController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedType = 'Civil';
  String _selectedStatus = 'Active';

  final List<String> _caseTypes = [
    'Civil',
    'Criminal',
    'Land',
    'Employment',
    'Family',
    'Succession',
    'Commercial',
    'Constitutional',
  ];

  final List<String> _statusOptions = [
    'Active',
    'Pending',
    'Adjourned',
    'Closed',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _caseNumberController.dispose();
    _clientController.dispose();
    _courtController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Case'),
        actions: [
          TextButton(
            onPressed: _saveCase,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Case Title *',
                hintText: 'e.g., Kamau vs State',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a case title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _caseNumberController,
              decoration: const InputDecoration(
                labelText: 'Case Number *',
                hintText: 'e.g., HCCR/2024/001234',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a case number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(
                labelText: 'Case Type *',
              ),
              items: _caseTypes.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedType = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedStatus,
              decoration: const InputDecoration(
                labelText: 'Status',
              ),
              items: _statusOptions.map((status) {
                return DropdownMenuItem(
                  value: status,
                  child: Text(status),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _clientController,
              decoration: const InputDecoration(
                labelText: 'Client Name *',
                hintText: 'Enter client name',
                suffixIcon: Icon(Icons.person_add_outlined),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter client name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _courtController,
              decoration: const InputDecoration(
                labelText: 'Court *',
                hintText: 'e.g., Milimani Law Courts',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter court name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Brief description of the case',
                alignLabelWithHint: true,
              ),
              maxLines: 4,
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: _saveCase,
              child: const Text('Create Case'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveCase() {
    if (_formKey.currentState!.validate()) {
      // Save case logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Case created successfully')),
      );
      context.pop();
    }
  }
}
