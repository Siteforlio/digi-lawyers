enum VerificationStatus { unverified, pending, verified, rejected }

enum UserRole { lawyer, admin }

class UserEntity {
  final String id;
  final String fullName;
  final String phone;
  final String email;
  final String? avatarUrl;
  final UserRole role;
  final VerificationStatus verificationStatus;
  final LawyerProfile? lawyerProfile;
  final DateTime createdAt;
  final DateTime? lastLoginAt;

  const UserEntity({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.email,
    this.avatarUrl,
    this.role = UserRole.lawyer,
    this.verificationStatus = VerificationStatus.unverified,
    this.lawyerProfile,
    required this.createdAt,
    this.lastLoginAt,
  });

  bool get isVerified => verificationStatus == VerificationStatus.verified;
  bool get isPending => verificationStatus == VerificationStatus.pending;

  UserEntity copyWith({
    String? id,
    String? fullName,
    String? phone,
    String? email,
    String? avatarUrl,
    UserRole? role,
    VerificationStatus? verificationStatus,
    LawyerProfile? lawyerProfile,
    DateTime? createdAt,
    DateTime? lastLoginAt,
  }) {
    return UserEntity(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      verificationStatus: verificationStatus ?? this.verificationStatus,
      lawyerProfile: lawyerProfile ?? this.lawyerProfile,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
    );
  }
}

class LawyerProfile {
  final String lskNumber;
  final int admissionYear;
  final String? practicingCertNumber;
  final String? lawFirm;
  final String? position;
  final List<PracticeArea> practiceAreas;
  final String? bio;
  final String? practicingCertUrl;
  final String? nationalIdUrl;
  final DateTime? verifiedAt;
  final String? rejectionReason;

  const LawyerProfile({
    required this.lskNumber,
    required this.admissionYear,
    this.practicingCertNumber,
    this.lawFirm,
    this.position,
    this.practiceAreas = const [],
    this.bio,
    this.practicingCertUrl,
    this.nationalIdUrl,
    this.verifiedAt,
    this.rejectionReason,
  });

  LawyerProfile copyWith({
    String? lskNumber,
    int? admissionYear,
    String? practicingCertNumber,
    String? lawFirm,
    String? position,
    List<PracticeArea>? practiceAreas,
    String? bio,
    String? practicingCertUrl,
    String? nationalIdUrl,
    DateTime? verifiedAt,
    String? rejectionReason,
  }) {
    return LawyerProfile(
      lskNumber: lskNumber ?? this.lskNumber,
      admissionYear: admissionYear ?? this.admissionYear,
      practicingCertNumber: practicingCertNumber ?? this.practicingCertNumber,
      lawFirm: lawFirm ?? this.lawFirm,
      position: position ?? this.position,
      practiceAreas: practiceAreas ?? this.practiceAreas,
      bio: bio ?? this.bio,
      practicingCertUrl: practicingCertUrl ?? this.practicingCertUrl,
      nationalIdUrl: nationalIdUrl ?? this.nationalIdUrl,
      verifiedAt: verifiedAt ?? this.verifiedAt,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

enum PracticeArea {
  commercialCorporate('Commercial & Corporate Law'),
  criminal('Criminal Law'),
  familyMatrimonial('Family & Matrimonial'),
  landConveyancing('Land & Conveyancing'),
  employmentLabour('Employment & Labour'),
  bankingFinance('Banking & Finance'),
  intellectualProperty('Intellectual Property'),
  taxLaw('Tax Law'),
  immigration('Immigration'),
  humanRightsConstitutional('Human Rights & Constitutional'),
  litigationDispute('Litigation & Dispute Resolution'),
  environmental('Environmental Law'),
  insurance('Insurance Law'),
  probateEstate('Probate & Estate Planning');

  final String displayName;
  const PracticeArea(this.displayName);
}

enum LawyerPosition {
  partner('Partner'),
  seniorPartner('Senior Partner'),
  managingPartner('Managing Partner'),
  associate('Associate'),
  seniorAssociate('Senior Associate'),
  counsel('Counsel'),
  inHouseCounsel('In-House Counsel'),
  independent('Independent Practitioner'),
  pupil('Pupil');

  final String displayName;
  const LawyerPosition(this.displayName);
}
