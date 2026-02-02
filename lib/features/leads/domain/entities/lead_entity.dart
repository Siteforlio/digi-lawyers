enum LeadStatus {
  newLead,
  contacted,
  qualified,
  proposal,
  converted,
  lost,
}

enum LeadSource {
  digiLaw,
  referral,
  website,
  directContact,
}

class LeadEntity {
  final String id;
  final String clientName;
  final String clientPhone;
  final String? clientEmail;
  final String serviceNeeded;
  final String? description;
  final LeadStatus status;
  final LeadSource source;
  final DateTime createdAt;
  final DateTime? lastContactedAt;
  final double? estimatedValue;
  final String? notes;

  const LeadEntity({
    required this.id,
    required this.clientName,
    required this.clientPhone,
    this.clientEmail,
    required this.serviceNeeded,
    this.description,
    required this.status,
    required this.source,
    required this.createdAt,
    this.lastContactedAt,
    this.estimatedValue,
    this.notes,
  });

  LeadEntity copyWith({
    String? id,
    String? clientName,
    String? clientPhone,
    String? clientEmail,
    String? serviceNeeded,
    String? description,
    LeadStatus? status,
    LeadSource? source,
    DateTime? createdAt,
    DateTime? lastContactedAt,
    double? estimatedValue,
    String? notes,
  }) {
    return LeadEntity(
      id: id ?? this.id,
      clientName: clientName ?? this.clientName,
      clientPhone: clientPhone ?? this.clientPhone,
      clientEmail: clientEmail ?? this.clientEmail,
      serviceNeeded: serviceNeeded ?? this.serviceNeeded,
      description: description ?? this.description,
      status: status ?? this.status,
      source: source ?? this.source,
      createdAt: createdAt ?? this.createdAt,
      lastContactedAt: lastContactedAt ?? this.lastContactedAt,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      notes: notes ?? this.notes,
    );
  }
}
