import 'package:only_law_app/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.fullName,
    required super.phone,
    required super.email,
    super.avatarUrl,
    super.role,
    super.verificationStatus,
    super.lawyerProfile,
    required super.createdAt,
    super.lastLoginAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      avatarUrl: json['avatar_url'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.lawyer,
      ),
      verificationStatus: VerificationStatus.values.firstWhere(
        (e) => e.name == json['verification_status'],
        orElse: () => VerificationStatus.unverified,
      ),
      lawyerProfile: json['lawyer_profile'] != null
          ? LawyerProfileModel.fromJson(json['lawyer_profile'])
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'avatar_url': avatarUrl,
      'role': role.name,
      'verification_status': verificationStatus.name,
      'lawyer_profile': lawyerProfile != null
          ? (lawyerProfile as LawyerProfileModel).toJson()
          : null,
      'created_at': createdAt.toIso8601String(),
      'last_login_at': lastLoginAt?.toIso8601String(),
    };
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      fullName: entity.fullName,
      phone: entity.phone,
      email: entity.email,
      avatarUrl: entity.avatarUrl,
      role: entity.role,
      verificationStatus: entity.verificationStatus,
      lawyerProfile: entity.lawyerProfile,
      createdAt: entity.createdAt,
      lastLoginAt: entity.lastLoginAt,
    );
  }
}

class LawyerProfileModel extends LawyerProfile {
  const LawyerProfileModel({
    required super.lskNumber,
    required super.admissionYear,
    super.practicingCertNumber,
    super.lawFirm,
    super.position,
    super.practiceAreas,
    super.bio,
    super.practicingCertUrl,
    super.nationalIdUrl,
    super.verifiedAt,
    super.rejectionReason,
  });

  factory LawyerProfileModel.fromJson(Map<String, dynamic> json) {
    return LawyerProfileModel(
      lskNumber: json['lsk_number'] as String,
      admissionYear: json['admission_year'] as int,
      practicingCertNumber: json['practicing_cert_number'] as String?,
      lawFirm: json['law_firm'] as String?,
      position: json['position'] as String?,
      practiceAreas: (json['practice_areas'] as List<dynamic>?)
              ?.map((e) => PracticeArea.values.firstWhere(
                    (p) => p.name == e,
                    orElse: () => PracticeArea.litigationDispute,
                  ))
              .toList() ??
          [],
      bio: json['bio'] as String?,
      practicingCertUrl: json['practicing_cert_url'] as String?,
      nationalIdUrl: json['national_id_url'] as String?,
      verifiedAt: json['verified_at'] != null
          ? DateTime.parse(json['verified_at'] as String)
          : null,
      rejectionReason: json['rejection_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lsk_number': lskNumber,
      'admission_year': admissionYear,
      'practicing_cert_number': practicingCertNumber,
      'law_firm': lawFirm,
      'position': position,
      'practice_areas': practiceAreas.map((e) => e.name).toList(),
      'bio': bio,
      'practicing_cert_url': practicingCertUrl,
      'national_id_url': nationalIdUrl,
      'verified_at': verifiedAt?.toIso8601String(),
      'rejection_reason': rejectionReason,
    };
  }
}

class AuthResult {
  final bool success;
  final UserModel? user;
  final String? accessToken;
  final String? refreshToken;
  final String? error;

  const AuthResult({
    required this.success,
    this.user,
    this.accessToken,
    this.refreshToken,
    this.error,
  });

  factory AuthResult.success({
    required UserModel user,
    required String accessToken,
    String? refreshToken,
  }) {
    return AuthResult(
      success: true,
      user: user,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  factory AuthResult.failure(String error) {
    return AuthResult(success: false, error: error);
  }
}

class RegisterData {
  final String fullName;
  final String phone;
  final String email;
  final String password;
  final String lskNumber;
  final int admissionYear;
  final String? practicingCertNumber;
  final String? lawFirm;
  final String? position;
  final List<PracticeArea> practiceAreas;

  const RegisterData({
    required this.fullName,
    required this.phone,
    required this.email,
    required this.password,
    required this.lskNumber,
    required this.admissionYear,
    this.practicingCertNumber,
    this.lawFirm,
    this.position,
    this.practiceAreas = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'phone': phone,
      'email': email,
      'password': password,
      'lsk_number': lskNumber,
      'admission_year': admissionYear,
      'practicing_cert_number': practicingCertNumber,
      'law_firm': lawFirm,
      'position': position,
      'practice_areas': practiceAreas.map((e) => e.name).toList(),
    };
  }
}
