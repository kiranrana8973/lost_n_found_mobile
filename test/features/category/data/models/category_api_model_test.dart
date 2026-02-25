import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/category/data/models/category_api_model.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';

void main() {
  final tCategoryApiModel = CategoryApiModel(
    id: '1',
    name: 'Electronics',
    description: 'Electronic items',
    status: 'active',
  );

  const tCategoryEntity = CategoryEntity(
    categoryId: '1',
    name: 'Electronics',
    description: 'Electronic items',
    status: 'active',
  );

  group('fromJson', () {
    test('should return a valid CategoryApiModel from JSON', () {
      // Arrange
      final json = {
        '_id': '1',
        'name': 'Electronics',
        'description': 'Electronic items',
        'status': 'active',
      };

      // Act
      final result = CategoryApiModel.fromJson(json);

      // Assert
      expect(result.id, '1');
      expect(result.name, 'Electronics');
      expect(result.description, 'Electronic items');
      expect(result.status, 'active');
    });
  });

  group('toJson', () {
    test('should return a JSON map with name and description', () {
      // Act
      final result = tCategoryApiModel.toJson();

      // Assert
      expect(result['name'], 'Electronics');
      expect(result['description'], 'Electronic items');
      expect(result.containsKey('_id'), false);
      expect(result.containsKey('status'), false);
    });

    test('should not include description when null', () {
      // Arrange
      final modelWithoutDesc = CategoryApiModel(
        id: '2',
        name: 'Books',
      );

      // Act
      final result = modelWithoutDesc.toJson();

      // Assert
      expect(result['name'], 'Books');
      expect(result.containsKey('description'), false);
    });
  });

  group('toEntity', () {
    test('should convert CategoryApiModel to CategoryEntity correctly', () {
      // Act
      final result = tCategoryApiModel.toEntity();

      // Assert
      expect(result, isA<CategoryEntity>());
      expect(result.categoryId, '1');
      expect(result.name, 'Electronics');
      expect(result.description, 'Electronic items');
      expect(result.status, 'active');
    });
  });

  group('fromEntity', () {
    test('should convert CategoryEntity to CategoryApiModel correctly', () {
      // Act
      final result = CategoryApiModel.fromEntity(tCategoryEntity);

      // Assert
      expect(result, isA<CategoryApiModel>());
      expect(result.id, '1');
      expect(result.name, 'Electronics');
      expect(result.description, 'Electronic items');
      expect(result.status, 'active');
    });
  });

  group('toEntityList', () {
    test(
        'should convert list of CategoryApiModel to list of CategoryEntity',
        () {
      // Arrange
      final models = [tCategoryApiModel, tCategoryApiModel];

      // Act
      final result = CategoryApiModel.toEntityList(models);

      // Assert
      expect(result, isA<List<CategoryEntity>>());
      expect(result.length, 2);
      expect(result[0].name, 'Electronics');
      expect(result[1].name, 'Electronics');
    });
  });
}
