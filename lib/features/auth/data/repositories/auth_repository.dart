import 'package:only_law_app/features/auth/data/models/user_model.dart';

/// Abstract interface for authentication operations.
/// This allows easy swapping between mock and real implementations.
abstract class AuthRepository {
  /// Login with phone/email and password
  Future<AuthResult> login({
    required String identifier, // phone or email
    required String password,
  });

  /// Register a new lawyer account
  Future<AuthResult> register(RegisterData data);

  /// Send OTP to phone number
  Future<bool> sendOtp(String phone);

  /// Verify OTP code
  Future<bool> verifyOtp({
    required String phone,
    required String otp,
  });

  /// Request password reset
  Future<bool> forgotPassword(String identifier);

  /// Reset password with code
  Future<bool> resetPassword({
    required String identifier,
    required String code,
    required String newPassword,
  });

  /// Get current authenticated user
  Future<UserModel?> getCurrentUser();

  /// Refresh authentication token
  Future<AuthResult> refreshToken(String refreshToken);

  /// Logout and clear session
  Future<void> logout();

  /// Upload verification documents
  Future<bool> uploadVerificationDocuments({
    required String practicingCertPath,
    required String nationalIdPath,
    String? photoPath,
  });

  /// Check if phone number is already registered
  Future<bool> isPhoneRegistered(String phone);

  /// Check if email is already registered
  Future<bool> isEmailRegistered(String email);

  /// Check if LSK number is already registered
  Future<bool> isLskNumberRegistered(String lskNumber);

  /// Stream of auth state changes
  Stream<UserModel?> get authStateChanges;
}
