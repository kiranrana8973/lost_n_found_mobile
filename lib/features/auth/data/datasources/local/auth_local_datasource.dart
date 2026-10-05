import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/services/database/app_database.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';

// Create provider
final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final appDatabase = ref.read(appDatabaseProvider);
  final userSessionService = ref.read(userSessionServiceProvider);
  return AuthLocalDatasource(
    appDatabase: appDatabase,
    userSessionService: userSessionService,
  );
});

class AuthLocalDatasource implements IAuthDataSource {
  final AppDatabase _db;
  final UserSessionService _userSessionService;

  AuthLocalDatasource({
    required AppDatabase appDatabase,
    required UserSessionService userSessionService,
  }) : _db = appDatabase,
       _userSessionService = userSessionService;

  @override
  Future<AuthModel> register(AuthModel user) async {
    return await _db.register(user);
  }

  @override
  Future<AuthModel?> login(String email, String password) async {
    try {
      final user = await _db.login(email, password);
      if (user != null) {
        // Save user session to SharedPreferences : Pachi app restart vayo vani pani user logged in rahos
        await _userSessionService.saveUserSession(
          userId: user.authId,
          email: user.email,
          fullName: user.fullName,
          username: user.username,
          phoneNumber: user.phoneNumber,
          batchId: user.batchId,
          profilePicture: user.profilePicture,
        );
      }
      return user;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthModel?> getCurrentUser() async {
    try {
      // Check if user is logged in
      if (!_userSessionService.isLoggedIn()) {
        return null;
      }

      // Get user ID from session
      final userId = _userSessionService.getCurrentUserId();
      if (userId == null) {
        return null;
      }

      // Fetch user from the database
      return await _db.getUserById(userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _userSessionService.clearSession();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthModel?> getUserById(String authId) async {
    try {
      return await _db.getUserById(authId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthModel?> getUserByEmail(String email) async {
    try {
      return await _db.getUserByEmail(email);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateUser(AuthModel user) async {
    try {
      return await _db.updateUser(user);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteUser(String authId) async {
    try {
      await _db.deleteUser(authId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
