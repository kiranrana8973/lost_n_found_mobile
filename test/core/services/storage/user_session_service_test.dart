import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/services/storage/user_session_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late UserSessionService userSessionService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    userSessionService = UserSessionService(prefs: mockPrefs);
  });

  // Test data
  const tUserId = 'user_123';
  const tEmail = 'test@example.com';
  const tFullName = 'Test User';
  const tUsername = 'testuser';
  const tPhoneNumber = '+1234567890';
  const tBatchId = 'batch_123';
  const tProfilePicture = 'https://example.com/profile.jpg';

  // Keys
  const keyIsLoggedIn = 'is_logged_in';
  const keyUserId = 'user_id';
  const keyUserEmail = 'user_email';
  const keyUserFullName = 'user_full_name';
  const keyUserUsername = 'user_username';
  const keyUserPhoneNumber = 'user_phone_number';
  const keyUserBatchId = 'user_batch_id';
  const keyUserProfilePicture = 'user_profile_picture';

  group('UserSessionService', () {
    group('saveUserSession', () {
      test('should save all required user session data', () async {
        // Arrange
        when(() => mockPrefs.setBool(keyIsLoggedIn, true))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserId, tUserId))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserEmail, tEmail))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserFullName, tFullName))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserUsername, tUsername))
            .thenAnswer((_) async => true);

        // Act
        await userSessionService.saveUserSession(
          userId: tUserId,
          email: tEmail,
          fullName: tFullName,
          username: tUsername,
        );

        // Assert
        verify(() => mockPrefs.setBool(keyIsLoggedIn, true)).called(1);
        verify(() => mockPrefs.setString(keyUserId, tUserId)).called(1);
        verify(() => mockPrefs.setString(keyUserEmail, tEmail)).called(1);
        verify(() => mockPrefs.setString(keyUserFullName, tFullName)).called(1);
        verify(() => mockPrefs.setString(keyUserUsername, tUsername)).called(1);
      });

      test('should save optional fields when provided', () async {
        // Arrange
        when(() => mockPrefs.setBool(keyIsLoggedIn, true))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserId, tUserId))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserEmail, tEmail))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserFullName, tFullName))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserUsername, tUsername))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserPhoneNumber, tPhoneNumber))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserBatchId, tBatchId))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserProfilePicture, tProfilePicture))
            .thenAnswer((_) async => true);

        // Act
        await userSessionService.saveUserSession(
          userId: tUserId,
          email: tEmail,
          fullName: tFullName,
          username: tUsername,
          phoneNumber: tPhoneNumber,
          batchId: tBatchId,
          profilePicture: tProfilePicture,
        );

        // Assert
        verify(() => mockPrefs.setString(keyUserPhoneNumber, tPhoneNumber))
            .called(1);
        verify(() => mockPrefs.setString(keyUserBatchId, tBatchId)).called(1);
        verify(() => mockPrefs.setString(keyUserProfilePicture, tProfilePicture))
            .called(1);
      });

      test('should not save optional fields when null', () async {
        // Arrange
        when(() => mockPrefs.setBool(keyIsLoggedIn, true))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserId, tUserId))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserEmail, tEmail))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserFullName, tFullName))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.setString(keyUserUsername, tUsername))
            .thenAnswer((_) async => true);

        // Act
        await userSessionService.saveUserSession(
          userId: tUserId,
          email: tEmail,
          fullName: tFullName,
          username: tUsername,
        );

        // Assert
        verifyNever(() => mockPrefs.setString(keyUserPhoneNumber, any()));
        verifyNever(() => mockPrefs.setString(keyUserBatchId, any()));
        verifyNever(() => mockPrefs.setString(keyUserProfilePicture, any()));
      });
    });

    group('isLoggedIn', () {
      test('should return true when user is logged in', () {
        // Arrange
        when(() => mockPrefs.getBool(keyIsLoggedIn)).thenReturn(true);

        // Act
        final result = userSessionService.isLoggedIn();

        // Assert
        expect(result, true);
        verify(() => mockPrefs.getBool(keyIsLoggedIn)).called(1);
      });

      test('should return false when user is not logged in', () {
        // Arrange
        when(() => mockPrefs.getBool(keyIsLoggedIn)).thenReturn(false);

        // Act
        final result = userSessionService.isLoggedIn();

        // Assert
        expect(result, false);
      });

      test('should return false when key does not exist', () {
        // Arrange
        when(() => mockPrefs.getBool(keyIsLoggedIn)).thenReturn(null);

        // Act
        final result = userSessionService.isLoggedIn();

        // Assert
        expect(result, false);
      });
    });

    group('getCurrentUserId', () {
      test('should return user ID when it exists', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserId)).thenReturn(tUserId);

        // Act
        final result = userSessionService.getCurrentUserId();

        // Assert
        expect(result, tUserId);
      });

      test('should return null when user ID does not exist', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserId)).thenReturn(null);

        // Act
        final result = userSessionService.getCurrentUserId();

        // Assert
        expect(result, isNull);
      });
    });

    group('getCurrentUserEmail', () {
      test('should return email when it exists', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserEmail)).thenReturn(tEmail);

        // Act
        final result = userSessionService.getCurrentUserEmail();

        // Assert
        expect(result, tEmail);
      });

      test('should return null when email does not exist', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserEmail)).thenReturn(null);

        // Act
        final result = userSessionService.getCurrentUserEmail();

        // Assert
        expect(result, isNull);
      });
    });

    group('getCurrentUserFullName', () {
      test('should return full name when it exists', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserFullName)).thenReturn(tFullName);

        // Act
        final result = userSessionService.getCurrentUserFullName();

        // Assert
        expect(result, tFullName);
      });

      test('should return null when full name does not exist', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserFullName)).thenReturn(null);

        // Act
        final result = userSessionService.getCurrentUserFullName();

        // Assert
        expect(result, isNull);
      });
    });

    group('getCurrentUserUsername', () {
      test('should return username when it exists', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserUsername)).thenReturn(tUsername);

        // Act
        final result = userSessionService.getCurrentUserUsername();

        // Assert
        expect(result, tUsername);
      });

      test('should return null when username does not exist', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserUsername)).thenReturn(null);

        // Act
        final result = userSessionService.getCurrentUserUsername();

        // Assert
        expect(result, isNull);
      });
    });

    group('getCurrentUserPhoneNumber', () {
      test('should return phone number when it exists', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserPhoneNumber))
            .thenReturn(tPhoneNumber);

        // Act
        final result = userSessionService.getCurrentUserPhoneNumber();

        // Assert
        expect(result, tPhoneNumber);
      });

      test('should return null when phone number does not exist', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserPhoneNumber)).thenReturn(null);

        // Act
        final result = userSessionService.getCurrentUserPhoneNumber();

        // Assert
        expect(result, isNull);
      });
    });

    group('getCurrentUserBatchId', () {
      test('should return batch ID when it exists', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserBatchId)).thenReturn(tBatchId);

        // Act
        final result = userSessionService.getCurrentUserBatchId();

        // Assert
        expect(result, tBatchId);
      });

      test('should return null when batch ID does not exist', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserBatchId)).thenReturn(null);

        // Act
        final result = userSessionService.getCurrentUserBatchId();

        // Assert
        expect(result, isNull);
      });
    });

    group('getCurrentUserProfilePicture', () {
      test('should return profile picture URL when it exists', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserProfilePicture))
            .thenReturn(tProfilePicture);

        // Act
        final result = userSessionService.getCurrentUserProfilePicture();

        // Assert
        expect(result, tProfilePicture);
      });

      test('should return null when profile picture does not exist', () {
        // Arrange
        when(() => mockPrefs.getString(keyUserProfilePicture)).thenReturn(null);

        // Act
        final result = userSessionService.getCurrentUserProfilePicture();

        // Assert
        expect(result, isNull);
      });
    });

    group('clearSession', () {
      test('should remove all user session data', () async {
        // Arrange
        when(() => mockPrefs.remove(keyIsLoggedIn))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove(keyUserId)).thenAnswer((_) async => true);
        when(() => mockPrefs.remove(keyUserEmail))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove(keyUserFullName))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove(keyUserUsername))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove(keyUserPhoneNumber))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove(keyUserBatchId))
            .thenAnswer((_) async => true);
        when(() => mockPrefs.remove(keyUserProfilePicture))
            .thenAnswer((_) async => true);

        // Act
        await userSessionService.clearSession();

        // Assert
        verify(() => mockPrefs.remove(keyIsLoggedIn)).called(1);
        verify(() => mockPrefs.remove(keyUserId)).called(1);
        verify(() => mockPrefs.remove(keyUserEmail)).called(1);
        verify(() => mockPrefs.remove(keyUserFullName)).called(1);
        verify(() => mockPrefs.remove(keyUserUsername)).called(1);
        verify(() => mockPrefs.remove(keyUserPhoneNumber)).called(1);
        verify(() => mockPrefs.remove(keyUserBatchId)).called(1);
        verify(() => mockPrefs.remove(keyUserProfilePicture)).called(1);
      });
    });
  });
}
