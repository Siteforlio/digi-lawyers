import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreateInvoiceScreen extends StatefulWidget {
  const CreateInvoiceScreen({super.key});

  @override
  State<CreateInvoiceScreen> createState() => _CreateInvoiceScreenState();
}

class _CreateInvoiceScreenState extends State<CreateInvoiceScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedClient;
  String? _selectedCase;
  final List<_InvoiceLineItem> _lineItems = [
    _InvoiceLineItem(),
  ];

  final _clients = ['John Kamau', 'Jane Wanjiku', 'Peter Ochieng', 'Mary Njeri'];
  final _cases = ['Kamau vs State', 'Wanjiku Land Dispute', 'Ochieng Employment Matter'];

  double get _subtotal => _lineItems.fold(0, (sum, item) => sum + item.amount);
  double get _tax => _subtotal * 0.16;
  double get _total => _subtotal + _tax;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Invoice'),
        actions: [
          TextButton(
            onPressed: _saveInvoice,
            child: const Text('Save'),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildClientSection(context),
            const SizedBox(height: 24),
            _buildLineItems(context),
            const SizedBox(height: 24),
            _buildTotals(context),
            const SizedBox(height: 24),
            _buildNotes(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildClientSection(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Client Details',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedClient,
          decoration: const InputDecoration(
            labelText: 'Select Client *',
            prefixIcon: Icon(Icons.person_outline),
          ),
          items: _clients.map((client) {
            return DropdownMenuItem(value: client, child: Text(client));
          }).toList(),
          onChanged: (value) => setState(() => _selectedClient = value),
          validator: (value) => value == null ? 'Please select a client' : null,
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          value: _selectedCase,
          decoration: const InputDecoration(
            labelText: 'Link to Case (Optional)',
            prefixIcon: Icon(Icons.folder_outlined),
          ),
          items: _cases.map((c) {
            return DropdownMenuItem(value: c, child: Text(c));
          }).toList(),
          onChanged: (value) => setState(() => _selectedCase = value),
        ),
      ],
    );
  }

  Widget _buildLineItems(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Line Items',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: _addLineItem,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Item'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._lineItems.asMap().entries.map((entry) {
          return _LineItemCard(
            item: entry.value,
            index: entry.key,
            onRemove: _lineItems.length > 1
                ? () => setState(() => _lineItems.removeAt(entry.key))
                : null,
            onChanged: () => setState(() {}),
          );
        }),
      ],
    );
  }

  Widget _buildTotals(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _TotalRow(label: 'Subtotal', value: 'KES ${_subtotal.toStringAsFixed(0)}'),
            const Divider(),
            _TotalRow(label: 'VAT (16%)', value: 'KES ${_tax.toStringAsFixed(0)}'),
            const Divider(),
            _TotalRow(
              label: 'Total',
              value: 'KES ${_total.toStringAsFixed(0)}',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotes(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Notes (Optional)',
        hintText: 'Add any additional notes for the client',
        alignLabelWithHint: true,
      ),
      maxLines: 3,
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 12,
        bottom: MediaQuery.of(context).padding.bottom + 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _saveAsDraft(),
              child: const Text('Save Draft'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: _sendInvoice,
              child: const Text('Send Invoice'),
            ),
          ),
        ],
      ),
    );
  }

  void _addLineItem() {
    setState(() {
      _lineItems.add(_InvoiceLineItem());
    });
  }

  void _saveInvoice() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice saved')),
      );
      context.pop();
    }
  }

  void _saveAsDraft() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invoice saved as draft')),
    );
    context.pop();
  }

  void _sendInvoice() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invoice sent to client')),
      );
      context.pop();
    }
  }
}

class _InvoiceLineItem {
  final descriptionController = TextEditingController();
  final quantityController = TextEditingController(text: '1');
  final rateController = TextEditingController();

  double get amount {
    final qty = double.tryParse(quantityController.text) ?? 0;
    final rate = double.tryParse(rateController.text) ?? 0;
    return qty * rate;
  }
}

class _LineItemCard extends StatelessWidget {
  final _InvoiceLineItem item;
  final int index;
  final VoidCallback? onRemove;
  final VoidCallback onChanged;

  const _LineItemCard({
    required this.item,
    required this.index,
    this.onRemove,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  'Item ${index + 1}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (onRemove != null)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    onPressed: onRemove,
                    color: theme.colorScheme.error,
                  ),
              ],
            ),
            TextFormField(
              controller: item.descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'e.g., Legal consultation',
              ),
              validator: (v) => v?.isEmpty == true ? 'Required' : null,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: item.quantityController,
                    decoration: const InputDecoration(labelText: 'Qty'),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => onChanged(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    controller: item.rateController,
                    decoration: const InputDecoration(
                      labelText: 'Rate (KES)',
                      hintText: '0',
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => onChanged(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Amount',
                        style: theme.textTheme.bodySmall,
                      ),
                      Text(
                        'KES ${item.amount.toStringAsFixed(0)}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _TotalRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = isBold
        ? theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)
        : theme.textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
