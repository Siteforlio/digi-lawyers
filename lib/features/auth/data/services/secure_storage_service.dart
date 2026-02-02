import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for securely storing sensitive data like tokens.
/// Uses flutter_secure_storage which encrypts data using:
/// - iOS: Keychain
/// - Android: EncryptedSharedPreferences (AES encryption)
class SecureStorageService {
  static const _accessTokenKey = 'access_token';
  static const _refreshTokenKey = 'refresh_token';
  static const _userIdKey = 'user_id';
  static const _tokenExpiryKey = 'token_expiry';

  final FlutterSecureStorage _storage;

  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(encryptedSharedPreferences: true),
              iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
            );

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await _storage.write(key: _accessTokenKey, value: token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(key: _refreshTokenKey, value: token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  /// Save user ID
  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  /// Get user ID
  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  /// Save token expiry timestamp
  Future<void> saveTokenExpiry(DateTime expiry) async {
    await _storage.write(key: _tokenExpiryKey, value: expiry.toIso8601String());
  }

  /// Get token expiry
  Future<DateTime?> getTokenExpiry() async {
    final expiryStr = await _storage.read(key: _tokenExpiryKey);
    if (expiryStr == null) return null;
    return DateTime.tryParse(expiryStr);
  }

  /// Check if token is expired
  Future<bool> isTokenExpired() async {
    final expiry = await getTokenExpiry();
    if (expiry == null) return true;
    return DateTime.now().isAfter(expiry);
  }

  /// Save all auth tokens at once
  Future<void> saveAuthTokens({
    required String accessToken,
    String? refreshToken,
    required String userId,
    DateTime? expiry,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      if (refreshToken != null) saveRefreshToken(refreshToken),
      saveUserId(userId),
      if (expiry != null) saveTokenExpiry(expiry),
    ]);
  }

  /// Clear all stored auth data (on logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  /// Check if user has stored credentials
  Future<bool> hasStoredCredentials() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }
}
