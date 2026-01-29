class ClientEntity {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String? company;
  final String? address;
  final ClientType type;
  final DateTime createdAt;
  final int activeCases;
  final double totalBilled;
  final double outstandingBalance;
  final String? notes;

  const ClientEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.company,
    this.address,
    required this.type,
    required this.createdAt,
    this.activeCases = 0,
    this.totalBilled = 0,
    this.outstandingBalance = 0,
    this.notes,
  });
}

enum ClientType {
  individual,
  corporate,
  government,
  ngo,
}
