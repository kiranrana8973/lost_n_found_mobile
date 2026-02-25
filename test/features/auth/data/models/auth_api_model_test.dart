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

      final result = AuthApiModel.fromJson(json);

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

      final result = model.toJson();

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
      final result = tAuthApiModel.toEntity();

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
      final result = AuthApiModel.fromEntity(tAuthEntity);

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
      final models = [tAuthApiModel, tAuthApiModel];

      final result = AuthApiModel.toEntityList(models);

      expect(result, isA<List<AuthEntity>>());
      expect(result.length, 2);
      expect(result[0].fullName, 'Test User');
      expect(result[1].fullName, 'Test User');
    });
  });
}
