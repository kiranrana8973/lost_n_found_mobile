import 'package:lost_n_found/features/auth/data/models/auth_model.dart';

abstract interface class IAuthDataSource {
  Future<AuthModel> register(AuthModel user);
  Future<AuthModel?> login(String email, String password);
  Future<AuthModel?> getCurrentUser();
  Future<bool> logout();
  Future<AuthModel?> getUserById(String authId);
  Future<AuthModel?> getUserByEmail(String email);
  Future<bool> updateUser(AuthModel user);
  Future<bool> deleteUser(String authId);
}
