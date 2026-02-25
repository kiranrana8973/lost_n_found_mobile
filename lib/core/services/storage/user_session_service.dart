import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences must be overridden in main.dart');
});

final userSessionServiceProvider = Provider<UserSessionService>((ref) {
  final prefs = ref.read(sharedPreferencesProvider);
  return UserSessionService(prefs: prefs);
});

class UserSessionService {
  final SharedPreferences _prefs;

  static const String _keyIsLoggedIn = 'is_logged_in';
  static const String _keyUserId = 'user_id';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserFullName = 'user_full_name';
  static const String _keyUserUsername = 'user_username';
  static const String _keyUserPhoneNumber = 'user_phone_number';
  static const String _keyUserBatchId = 'user_batch_id';
  static const String _keyUserProfilePicture = 'user_profile_picture';
  static const String _keyHasSeenOnboarding = 'has_seen_onboarding';

  UserSessionService({required SharedPreferences prefs}) : _prefs = prefs;

  Future<void> saveUserSession({
    required String userId,
    required String email,
    required String fullName,
    required String username,
    String? phoneNumber,
    String? batchId,
    String? profilePicture,
  }) async {
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserId, userId);
    await _prefs.setString(_keyUserEmail, email);
    await _prefs.setString(_keyUserFullName, fullName);
    await _prefs.setString(_keyUserUsername, username);
    if (phoneNumber != null) {
      await _prefs.setString(_keyUserPhoneNumber, phoneNumber);
    }
    if (batchId != null) {
      await _prefs.setString(_keyUserBatchId, batchId);
    }
    if (profilePicture != null) {
      await _prefs.setString(_keyUserProfilePicture, profilePicture);
    }
  }

  bool isLoggedIn() {
    return _prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  String? getCurrentUserId() {
    return _prefs.getString(_keyUserId);
  }

  String? getCurrentUserEmail() {
    return _prefs.getString(_keyUserEmail);
  }

  String? getCurrentUserFullName() {
    return _prefs.getString(_keyUserFullName);
  }

  String? getCurrentUserUsername() {
    return _prefs.getString(_keyUserUsername);
  }

  String? getCurrentUserPhoneNumber() {
    return _prefs.getString(_keyUserPhoneNumber);
  }

  String? getCurrentUserBatchId() {
    return _prefs.getString(_keyUserBatchId);
  }

  String? getCurrentUserProfilePicture() {
    return _prefs.getString(_keyUserProfilePicture);
  }

  bool hasSeenOnboarding() {
    return _prefs.getBool(_keyHasSeenOnboarding) ?? false;
  }

  Future<void> setOnboardingSeen() async {
    await _prefs.setBool(_keyHasSeenOnboarding, true);
  }

  Future<void> clearSession() async {
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserId);
    await _prefs.remove(_keyUserEmail);
    await _prefs.remove(_keyUserFullName);
    await _prefs.remove(_keyUserUsername);
    await _prefs.remove(_keyUserPhoneNumber);
    await _prefs.remove(_keyUserBatchId);
    await _prefs.remove(_keyUserProfilePicture);
  }
}
