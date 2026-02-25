import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/auth/data/models/auth_api_model.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';

void main() {
  final tAuthApiModel = AuthApiModel(
    id: '1',
    fullName: 'Test User',
    email: 'test@test.com',
    phoneNumber: '123',
    username: 'testuser',
    password: 'password123',
    batchId: null,
    profilePicture: null,
    batch: null,
  );

  const tAuthEntity = AuthEntity(
    authId: '1',
    fullName: 'Test User',
    email: 'test@test.com',
    phoneNumber: '123',
    username: 'testuser',
    password: 'password123',
    batchId: null,
    profilePicture: null,
    batch: null,
  );

  group('fromJson', () {
    test('should return a valid AuthApiModel from JSON', () {
      // Arrange
      final json = {
        '_id': '1',
        'name': 'Test User',
        'email': 'test@test.com',
        'username': 'testuser',
        'phoneNumber': '123',
        'batchId': null,
        'profilePicture': null,
        'batch': null,
      };

      // Act
      final result = AuthApiModel.fromJson(json);

      // Assert
      expect(result.id, '1');
      expect(result.fullName, 'Test User');
      expect(result.email, 'test@test.com');
      expect(result.username, 'testuser');
      expect(result.phoneNumber, '123');
      expect(result.batchId, null);
      expect(result.profilePicture, null);
      expect(result.batch, null);
    });
  });

  group('toJson', () {
    test('should return a JSON map with name key (not fullName)', () {
      // Arrange
      final model = AuthApiModel(
        id: '1',
        fullName: 'Test User',
        email: 'test@test.com',
        phoneNumber: '123',
        username: 'testuser',
        password: 'password123',
        batchId: 'batch1',
        profilePicture: 'pic.jpg',
      );

      // Act
      final result = model.toJson();

      // Assert
      expect(result['name'], 'Test User');
      expect(result['email'], 'test@test.com');
      expect(result['phoneNumber'], '123');
      expect(result['username'], 'testuser');
      expect(result['password'], 'password123');
      expect(result['batchId'], 'batch1');
      expect(result['profilePicture'], 'pic.jpg');
      expect(result.containsKey('fullName'), false);
    });
  });

  group('toEntity', () {
    test('should convert AuthApiModel to AuthEntity correctly', () {
      // Act
      final result = tAuthApiModel.toEntity();

      // Assert
      expect(result, isA<AuthEntity>());
      expect(result.authId, '1');
      expect(result.fullName, 'Test User');
      expect(result.email, 'test@test.com');
      expect(result.phoneNumber, '123');
      expect(result.username, 'testuser');
      expect(result.batchId, null);
      expect(result.profilePicture, null);
      expect(result.batch, null);
    });
  });

  group('fromEntity', () {
    test('should convert AuthEntity to AuthApiModel correctly', () {
      // Act
      final result = AuthApiModel.fromEntity(tAuthEntity);

      // Assert
      expect(result, isA<AuthApiModel>());
      expect(result.fullName, 'Test User');
      expect(result.email, 'test@test.com');
      expect(result.phoneNumber, '123');
      expect(result.username, 'testuser');
      expect(result.password, 'password123');
      expect(result.batchId, null);
      expect(result.profilePicture, null);
    });
  });

  group('toEntityList', () {
    test('should convert list of AuthApiModel to list of AuthEntity', () {
      // Arrange
      final models = [tAuthApiModel, tAuthApiModel];

      // Act
      final result = AuthApiModel.toEntityList(models);

      // Assert
      expect(result, isA<List<AuthEntity>>());
      expect(result.length, 2);
      expect(result[0].fullName, 'Test User');
      expect(result[1].fullName, 'Test User');
    });
  });
}
