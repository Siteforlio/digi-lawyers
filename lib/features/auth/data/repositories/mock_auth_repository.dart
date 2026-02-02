import 'dart:async';
import 'package:only_law_app/features/auth/data/models/user_model.dart';
import 'package:only_law_app/features/auth/data/repositories/auth_repository.dart';
import 'package:only_law_app/features/auth/domain/entities/user_entity.dart';

/// Mock implementation of AuthRepository for development and testing.
/// Replace with real API implementation when backend is ready.
class MockAuthRepository implements AuthRepository {
  final _authStateController = StreamController<UserModel?>.broadcast();
  UserModel? _currentUser;
  String? _pendingOtpPhone;
  final String _mockOtp = '123456'; // For testing

  // Mock registered users database
  final Map<String, _MockUserData> _registeredUsers = {
    '+254712345678': _MockUserData(
      password: 'password123',
      user: UserModel(
        id: 'user_001',
        fullName: 'John Kamau',
        phone: '+254712345678',
        email: 'john.kamau@lawfirm.co.ke',
        avatarUrl: null,
        role: UserRole.lawyer,
        verificationStatus: VerificationStatus.verified,
        lawyerProfile: const LawyerProfileModel(
          lskNumber: 'LSK/2015/12345',
          admissionYear: 2015,
          practicingCertNumber: 'PC/2024/56789',
          lawFirm: 'Kamau & Associates Advocates',
          position: 'Partner',
          practiceAreas: [
            PracticeArea.commercialCorporate,
            PracticeArea.litigationDispute,
            PracticeArea.landConveyancing,
          ],
          bio: 'Experienced advocate with over 9 years in commercial litigation.',
        ),
        createdAt: DateTime(2023, 1, 15),
        lastLoginAt: DateTime.now(),
      ),
    ),
  };

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  Future<AuthResult> login({
    required String identifier,
    required String password,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    // Normalize phone number
    final normalizedId = _normalizePhone(identifier);

    final userData = _registeredUsers[normalizedId];
    if (userData == null) {
      return AuthResult.failure('No account found with this phone number');
    }

    if (userData.password != password) {
      return AuthResult.failure('Incorrect password');
    }

    _currentUser = userData.user;
    _authStateController.add(_currentUser);

    return AuthResult.success(
      user: _currentUser!,
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<AuthResult> register(RegisterData data) async {
    await Future.delayed(const Duration(seconds: 2));

    final normalizedPhone = _normalizePhone(data.phone);

    // Check if already registered
    if (_registeredUsers.containsKey(normalizedPhone)) {
      return AuthResult.failure('This phone number is already registered');
    }

    // Create new user
    final newUser = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      fullName: data.fullName,
      phone: normalizedPhone,
      email: data.email,
      role: UserRole.lawyer,
      verificationStatus: VerificationStatus.pending,
      lawyerProfile: LawyerProfileModel(
        lskNumber: data.lskNumber,
        admissionYear: data.admissionYear,
        practicingCertNumber: data.practicingCertNumber,
        lawFirm: data.lawFirm,
        position: data.position,
        practiceAreas: data.practiceAreas,
      ),
      createdAt: DateTime.now(),
    );

    // Store in mock database
    _registeredUsers[normalizedPhone] = _MockUserData(
      password: data.password,
      user: newUser,
    );

    _currentUser = newUser;
    _authStateController.add(_currentUser);

    return AuthResult.success(
      user: newUser,
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<bool> sendOtp(String phone) async {
    await Future.delayed(const Duration(seconds: 1));
    _pendingOtpPhone = _normalizePhone(phone);
    // In real implementation, this would send SMS via Africa's Talking or similar
    return true;
  }

  @override
  Future<bool> verifyOtp({required String phone, required String otp}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final normalizedPhone = _normalizePhone(phone);
    if (_pendingOtpPhone != normalizedPhone) {
      return false;
    }

    // Accept mock OTP for testing
    if (otp == _mockOtp) {
      _pendingOtpPhone = null;
      return true;
    }

    return false;
  }

  @override
  Future<bool> forgotPassword(String identifier) async {
    await Future.delayed(const Duration(seconds: 1));

    final normalizedId = _normalizePhone(identifier);
    if (!_registeredUsers.containsKey(normalizedId)) {
      return false;
    }

    _pendingOtpPhone = normalizedId;
    return true;
  }

  @override
  Future<bool> resetPassword({
    required String identifier,
    required String code,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    if (code != _mockOtp) {
      return false;
    }

    final normalizedId = _normalizePhone(identifier);
    final userData = _registeredUsers[normalizedId];
    if (userData == null) {
      return false;
    }

    _registeredUsers[normalizedId] = _MockUserData(
      password: newPassword,
      user: userData.user,
    );

    return true;
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _currentUser;
  }

  @override
  Future<AuthResult> refreshToken(String refreshToken) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (_currentUser == null) {
      return AuthResult.failure('Session expired. Please login again.');
    }

    return AuthResult.success(
      user: _currentUser!,
      accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'mock_refresh_token_${DateTime.now().millisecondsSinceEpoch}',
    );
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<bool> uploadVerificationDocuments({
    required String practicingCertPath,
    required String nationalIdPath,
    String? photoPath,
  }) async {
    await Future.delayed(const Duration(seconds: 2));

    if (_currentUser == null) {
      return false;
    }

    // Update user status to pending verification
    final updatedUser = UserModel(
      id: _currentUser!.id,
      fullName: _currentUser!.fullName,
      phone: _currentUser!.phone,
      email: _currentUser!.email,
      avatarUrl: photoPath ?? _currentUser!.avatarUrl,
      role: _currentUser!.role,
      verificationStatus: VerificationStatus.pending,
      lawyerProfile: _currentUser!.lawyerProfile != null
          ? LawyerProfileModel(
              lskNumber: _currentUser!.lawyerProfile!.lskNumber,
              admissionYear: _currentUser!.lawyerProfile!.admissionYear,
              practicingCertNumber: _currentUser!.lawyerProfile!.practicingCertNumber,
              lawFirm: _currentUser!.lawyerProfile!.lawFirm,
              position: _currentUser!.lawyerProfile!.position,
              practiceAreas: _currentUser!.lawyerProfile!.practiceAreas,
              bio: _currentUser!.lawyerProfile!.bio,
              practicingCertUrl: practicingCertPath,
              nationalIdUrl: nationalIdPath,
            )
          : null,
      createdAt: _currentUser!.createdAt,
      lastLoginAt: DateTime.now(),
    );

    _currentUser = updatedUser;
    _registeredUsers[_currentUser!.phone] = _MockUserData(
      password: _registeredUsers[_currentUser!.phone]?.password ?? '',
      user: updatedUser,
    );
    _authStateController.add(_currentUser);

    return true;
  }

  @override
  Future<bool> isPhoneRegistered(String phone) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _registeredUsers.containsKey(_normalizePhone(phone));
  }

  @override
  Future<bool> isEmailRegistered(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _registeredUsers.values.any((u) => u.user.email == email.toLowerCase());
  }

  @override
  Future<bool> isLskNumberRegistered(String lskNumber) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _registeredUsers.values.any(
      (u) => u.user.lawyerProfile?.lskNumber == lskNumber.toUpperCase(),
    );
  }

  String _normalizePhone(String phone) {
    var normalized = phone.replaceAll(RegExp(r'[\s\-()]'), '');
    if (normalized.startsWith('0')) {
      normalized = '+254${normalized.substring(1)}';
    } else if (normalized.startsWith('254')) {
      normalized = '+$normalized';
    } else if (!normalized.startsWith('+')) {
      normalized = '+254$normalized';
    }
    return normalized;
  }

  void dispose() {
    _authStateController.close();
  }
}

class _MockUserData {
  final String password;
  final UserModel user;

  _MockUserData({required this.password, required this.user});
}
