class InvoiceEntity {
  final String id;
  final String invoiceNumber;
  final String clientId;
  final String clientName;
  final String? caseId;
  final String? caseName;
  final List<InvoiceItem> items;
  final double subtotal;
  final double tax;
  final double total;
  final InvoiceStatus status;
  final DateTime createdAt;
  final DateTime dueDate;
  final DateTime? paidAt;
  final String? notes;

  const InvoiceEntity({
    required this.id,
    required this.invoiceNumber,
    required this.clientId,
    required this.clientName,
    this.caseId,
    this.caseName,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.dueDate,
    this.paidAt,
    this.notes,
  });
}

class InvoiceItem {
  final String description;
  final double quantity;
  final double rate;
  final double amount;

  const InvoiceItem({
    required this.description,
    required this.quantity,
    required this.rate,
    required this.amount,
  });
}

enum InvoiceStatus {
  draft,
  sent,
  paid,
  overdue,
  cancelled,
}
