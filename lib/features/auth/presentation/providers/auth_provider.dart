import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:only_law_app/features/auth/data/models/user_model.dart';
import 'package:only_law_app/features/auth/data/repositories/auth_repository.dart';
import 'package:only_law_app/features/auth/data/repositories/mock_auth_repository.dart';
import 'package:only_law_app/features/auth/data/services/secure_storage_service.dart';
import 'package:only_law_app/features/auth/domain/entities/user_entity.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SecureStorageService _storageService;

  AuthStatus _status = AuthStatus.initial;
  UserModel? _user;
  String? _error;
  bool _isLoading = false;
  StreamSubscription<UserModel?>? _authSubscription;

  AuthProvider({
    AuthRepository? authRepository,
    SecureStorageService? storageService,
  })  : _authRepository = authRepository ?? MockAuthRepository(),
        _storageService = storageService ?? SecureStorageService() {
    _init();
  }

  // Getters
  AuthStatus get status => _status;
  UserModel? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated && _user != null;
  bool get isVerified => _user?.verificationStatus == VerificationStatus.verified;
  bool get isPendingVerification => _user?.verificationStatus == VerificationStatus.pending;

  void _init() {
    _authSubscription = _authRepository.authStateChanges.listen((user) {
      _user = user;
      _status = user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      notifyListeners();
    });
  }

  /// Check if user has stored session and restore it
  Future<void> checkAuthState() async {
    _setLoading(true);

    try {
      final hasCredentials = await _storageService.hasStoredCredentials();
      if (!hasCredentials) {
        _status = AuthStatus.unauthenticated;
        _setLoading(false);
        return;
      }

      final isExpired = await _storageService.isTokenExpired();
      if (isExpired) {
        // Try to refresh token
        final refreshToken = await _storageService.getRefreshToken();
        if (refreshToken != null) {
          final result = await _authRepository.refreshToken(refreshToken);
          if (result.success) {
            _user = result.user;
            _status = AuthStatus.authenticated;
            await _saveTokens(result);
          } else {
            await _storageService.clearAll();
            _status = AuthStatus.unauthenticated;
          }
        } else {
          await _storageService.clearAll();
          _status = AuthStatus.unauthenticated;
        }
      } else {
        // Token still valid, get current user
        _user = await _authRepository.getCurrentUser();
        _status = _user != null ? AuthStatus.authenticated : AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// Login with phone/email and password
  Future<bool> login({
    required String identifier,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.login(
        identifier: identifier,
        password: password,
      );

      if (result.success && result.user != null) {
        _user = result.user;
        _status = AuthStatus.authenticated;
        await _saveTokens(result);
        _setLoading(false);
        return true;
      } else {
        _error = result.error ?? 'Login failed';
        _status = AuthStatus.error;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      _setLoading(false);
      return false;
    }
  }

  /// Register a new lawyer account
  Future<bool> register(RegisterData data) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authRepository.register(data);

      if (result.success && result.user != null) {
        _user = result.user;
        _status = AuthStatus.authenticated;
        await _saveTokens(result);
        _setLoading(false);
        return true;
      } else {
        _error = result.error ?? 'Registration failed';
        _status = AuthStatus.error;
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _status = AuthStatus.error;
      _setLoading(false);
      return false;
    }
  }

  /// Send OTP to phone
  Future<bool> sendOtp(String phone) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authRepository.sendOtp(phone);
      _setLoading(false);
      if (!success) {
        _error = 'Failed to send OTP';
      }
      return success;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Verify OTP
  Future<bool> verifyOtp({required String phone, required String otp}) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authRepository.verifyOtp(phone: phone, otp: otp);
      _setLoading(false);
      if (!success) {
        _error = 'Invalid OTP code';
      }
      return success;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Request password reset
  Future<bool> forgotPassword(String identifier) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authRepository.forgotPassword(identifier);
      _setLoading(false);
      if (!success) {
        _error = 'No account found with this phone/email';
      }
      return success;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Reset password
  Future<bool> resetPassword({
    required String identifier,
    required String code,
    required String newPassword,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authRepository.resetPassword(
        identifier: identifier,
        code: code,
        newPassword: newPassword,
      );
      _setLoading(false);
      if (!success) {
        _error = 'Invalid reset code';
      }
      return success;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Upload verification documents
  Future<bool> uploadVerificationDocuments({
    required String practicingCertPath,
    required String nationalIdPath,
    String? photoPath,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final success = await _authRepository.uploadVerificationDocuments(
        practicingCertPath: practicingCertPath,
        nationalIdPath: nationalIdPath,
        photoPath: photoPath,
      );
      _setLoading(false);
      if (!success) {
        _error = 'Failed to upload documents';
      }
      return success;
    } catch (e) {
      _error = e.toString();
      _setLoading(false);
      return false;
    }
  }

  /// Check if phone is registered
  Future<bool> isPhoneRegistered(String phone) async {
    return await _authRepository.isPhoneRegistered(phone);
  }

  /// Check if email is registered
  Future<bool> isEmailRegistered(String email) async {
    return await _authRepository.isEmailRegistered(email);
  }

  /// Check if LSK number is registered
  Future<bool> isLskNumberRegistered(String lskNumber) async {
    return await _authRepository.isLskNumberRegistered(lskNumber);
  }

  /// Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      await _authRepository.logout();
      await _storageService.clearAll();
      _user = null;
      _status = AuthStatus.unauthenticated;
    } catch (e) {
      _error = e.toString();
    }

    _setLoading(false);
  }

  /// Clear any error state
  void clearError() {
    _clearError();
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  Future<void> _saveTokens(AuthResult result) async {
    if (result.accessToken != null && result.user != null) {
      await _storageService.saveAuthTokens(
        accessToken: result.accessToken!,
        refreshToken: result.refreshToken,
        userId: result.user!.id,
        expiry: DateTime.now().add(const Duration(hours: 24)),
      );
    }
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
