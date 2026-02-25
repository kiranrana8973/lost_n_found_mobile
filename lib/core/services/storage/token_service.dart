import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/api/api_client.dart';

final tokenServiceProvider = Provider<TokenService>((ref) {
  return TokenService(apiClient: ref.read(apiClientProvider));
});

class TokenService {
  final ApiClient _apiClient;

  TokenService({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<void> saveToken(String token) async {
    await _apiClient.saveTokens(accessToken: token);
  }

  Future<String?> getToken() async {
    return _apiClient.getAccessToken();
  }

  Future<void> removeToken() async {
    await _apiClient.clearTokens();
  }
}
