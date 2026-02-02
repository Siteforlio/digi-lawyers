enum ConnectionStatus {
  none,
  pending,
  connected,
}

class LawyerEntity {
  final String id;
  final String name;
  final String? profileImage;
  final String firm;
  final String location;
  final List<String> practiceAreas;
  final int yearsOfExperience;
  final bool isVerified;
  final ConnectionStatus connectionStatus;
  final String? bio;

  const LawyerEntity({
    required this.id,
    required this.name,
    this.profileImage,
    required this.firm,
    required this.location,
    required this.practiceAreas,
    required this.yearsOfExperience,
    this.isVerified = false,
    this.connectionStatus = ConnectionStatus.none,
    this.bio,
  });

  LawyerEntity copyWith({
    String? id,
    String? name,
    String? profileImage,
    String? firm,
    String? location,
    List<String>? practiceAreas,
    int? yearsOfExperience,
    bool? isVerified,
    ConnectionStatus? connectionStatus,
    String? bio,
  }) {
    return LawyerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      profileImage: profileImage ?? this.profileImage,
      firm: firm ?? this.firm,
      location: location ?? this.location,
      practiceAreas: practiceAreas ?? this.practiceAreas,
      yearsOfExperience: yearsOfExperience ?? this.yearsOfExperience,
      isVerified: isVerified ?? this.isVerified,
      connectionStatus: connectionStatus ?? this.connectionStatus,
      bio: bio ?? this.bio,
    );
  }
}

class ReferralEntity {
  final String id;
  final String fromLawyerId;
  final String fromLawyerName;
  final String clientName;
  final String caseType;
  final String? notes;
  final DateTime createdAt;
  final ReferralStatus status;

  const ReferralEntity({
    required this.id,
    required this.fromLawyerId,
    required this.fromLawyerName,
    required this.clientName,
    required this.caseType,
    this.notes,
    required this.createdAt,
    required this.status,
  });
}

enum ReferralStatus {
  pending,
  accepted,
  declined,
  completed,
}
