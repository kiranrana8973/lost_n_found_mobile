import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/services/storage/token_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late TokenService tokenService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    tokenService = TokenService(prefs: mockPrefs);
  });

  const tToken = 'test_auth_token_123';
  const tokenKey = 'auth_token';

  group('TokenService', () {
    group('saveToken', () {
      test('should save token to SharedPreferences', () async {
        // Arrange
        when(() => mockPrefs.setString(tokenKey, tToken))
            .thenAnswer((_) async => true);

        // Act
        await tokenService.saveToken(tToken);

        // Assert
        verify(() => mockPrefs.setString(tokenKey, tToken)).called(1);
      });

      test('should handle empty token', () async {
        // Arrange
        when(() => mockPrefs.setString(tokenKey, ''))
            .thenAnswer((_) async => true);

        // Act
        await tokenService.saveToken('');

        // Assert
        verify(() => mockPrefs.setString(tokenKey, '')).called(1);
      });
    });

    group('getToken', () {
      test('should return token when it exists', () async {
        // Arrange
        when(() => mockPrefs.getString(tokenKey)).thenReturn(tToken);

        // Act
        final result = await tokenService.getToken();

        // Assert
        expect(result, tToken);
        verify(() => mockPrefs.getString(tokenKey)).called(1);
      });

      test('should return null when token does not exist', () async {
        // Arrange
        when(() => mockPrefs.getString(tokenKey)).thenReturn(null);

        // Act
        final result = await tokenService.getToken();

        // Assert
        expect(result, isNull);
        verify(() => mockPrefs.getString(tokenKey)).called(1);
      });
    });

    group('removeToken', () {
      test('should remove token from SharedPreferences', () async {
        // Arrange
        when(() => mockPrefs.remove(tokenKey)).thenAnswer((_) async => true);

        // Act
        await tokenService.removeToken();

        // Assert
        verify(() => mockPrefs.remove(tokenKey)).called(1);
      });
    });

    group('token lifecycle', () {
      test('should save, retrieve, and remove token correctly', () async {
        // Arrange - Save
        when(() => mockPrefs.setString(tokenKey, tToken))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.getString(tokenKey)).thenReturn(tToken);
        when(() => mockPrefs.remove(tokenKey)).thenAnswer((_) async => true);

        // Act & Assert - Save
        await tokenService.saveToken(tToken);
        verify(() => mockPrefs.setString(tokenKey, tToken)).called(1);

        // Act & Assert - Get
        final retrievedToken = await tokenService.getToken();
        expect(retrievedToken, tToken);

        // Act & Assert - Remove
        await tokenService.removeToken();
        verify(() => mockPrefs.remove(tokenKey)).called(1);
      });
    });
  });
}
