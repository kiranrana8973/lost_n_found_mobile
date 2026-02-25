import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/auth/domain/entities/auth_entity.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

void main() {
  const tBatch = BatchEntity(
    batchId: 'batch-1',
    batchName: 'Batch 2024',
    status: 'active',
  );

  const tAuthEntity = AuthEntity(
    authId: 'auth-123',
    fullName: 'John Doe',
    email: 'john@example.com',
    phoneNumber: '1234567890',
    username: 'johndoe',
    password: 'secret123',
    batchId: 'batch-1',
    batch: tBatch,
    profilePicture: 'https://example.com/photo.jpg',
  );

  group('AuthEntity', () {
    test('should create an AuthEntity with required fields only', () {
      const entity = AuthEntity(
        fullName: 'Jane Doe',
        email: 'jane@example.com',
        username: 'janedoe',
      );

      expect(entity.fullName, 'Jane Doe');
      expect(entity.email, 'jane@example.com');
      expect(entity.username, 'janedoe');
      expect(entity.authId, isNull);
      expect(entity.phoneNumber, isNull);
      expect(entity.password, isNull);
      expect(entity.batchId, isNull);
      expect(entity.batch, isNull);
      expect(entity.profilePicture, isNull);
    });

    test('should create an AuthEntity with all fields', () {
      expect(tAuthEntity.authId, 'auth-123');
      expect(tAuthEntity.fullName, 'John Doe');
      expect(tAuthEntity.email, 'john@example.com');
      expect(tAuthEntity.phoneNumber, '1234567890');
      expect(tAuthEntity.username, 'johndoe');
      expect(tAuthEntity.password, 'secret123');
      expect(tAuthEntity.batchId, 'batch-1');
      expect(tAuthEntity.batch, tBatch);
      expect(tAuthEntity.profilePicture, 'https://example.com/photo.jpg');
    });

    test('should be equal when all properties are the same', () {
      const anotherEntity = AuthEntity(
        authId: 'auth-123',
        fullName: 'John Doe',
        email: 'john@example.com',
        phoneNumber: '1234567890',
        username: 'johndoe',
        password: 'secret123',
        batchId: 'batch-1',
        batch: tBatch,
        profilePicture: 'https://example.com/photo.jpg',
      );

      expect(tAuthEntity, equals(anotherEntity));
    });

    test('should not be equal when properties differ', () {
      const differentEntity = AuthEntity(
        authId: 'auth-456',
        fullName: 'Jane Smith',
        email: 'jane@example.com',
        username: 'janesmith',
      );

      expect(tAuthEntity, isNot(equals(differentEntity)));
    });

    test('should have correct props list', () {
      expect(tAuthEntity.props, [
        'auth-123',
        'John Doe',
        'john@example.com',
        '1234567890',
        'johndoe',
        'secret123',
        'batch-1',
        tBatch,
        'https://example.com/photo.jpg',
      ]);
    });
  });
}
