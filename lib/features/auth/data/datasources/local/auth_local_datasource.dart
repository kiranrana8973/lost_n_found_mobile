import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/constants/hive_table_constant.dart';
import 'package:lost_n_found/core/services/hive/hive_box.dart';
import 'package:lost_n_found/core/services/storage/token_service.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:lost_n_found/features/auth/data/datasources/auth_datasource.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';

final authLocalDatasourceProvider = Provider<AuthLocalDatasource>((ref) {
  final userSessionService = ref.read(userSessionServiceProvider);
  final tokenService = ref.read(tokenServiceProvider);
  return AuthLocalDatasource(
    userSessionService: userSessionService,
    tokenService: tokenService,
  );
});

class AuthLocalDatasource implements IAuthLocalDataSource {
  final HiveBox<AuthHiveModel> _box;
  final UserSessionService _userSessionService;
  final TokenService _tokenService;

  AuthLocalDatasource({
    required UserSessionService userSessionService,
    required TokenService tokenService,
  }) : _box = HiveBox<AuthHiveModel>(HiveTableConstant.studentTable),
       _userSessionService = userSessionService,
       _tokenService = tokenService;

  @override
  Future<AuthHiveModel> register(AuthHiveModel user) async {
    return await _box.put(user.authId!, user);
  }

  @override
  Future<AuthHiveModel?> login(String email, String password) async {
    try {
      final user = _box.firstWhere(
        (u) => u.email == email && u.password == password,
      );
      if (user != null && user.authId != null) {
        await _userSessionService.saveUserSession(
          userId: user.authId!,
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
  Future<AuthHiveModel?> getCurrentUser() async {
    try {
      if (!_userSessionService.isLoggedIn()) return null;

      final userId = _userSessionService.getCurrentUserId();
      if (userId == null) return null;

      return _box.get(userId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> logout() async {
    try {
      await _userSessionService.clearSession();
      await _tokenService.removeToken();
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<AuthHiveModel?> getUserById(String authId) async {
    try {
      return _box.get(authId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<AuthHiveModel?> getUserByEmail(String email) async {
    try {
      return _box.firstWhere((u) => u.email == email);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<bool> updateUser(AuthHiveModel user) async {
    try {
      return await _box.update(user.authId!, user);
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteUser(String authId) async {
    try {
      await _box.delete(authId);
      return true;
    } catch (e) {
      return false;
    }
  }
}
