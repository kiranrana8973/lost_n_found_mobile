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
      final json = {
        '_id': '1',
        'name': 'Electronics',
        'description': 'Electronic items',
        'status': 'active',
      };

      final result = CategoryApiModel.fromJson(json);

      expect(result.id, '1');
      expect(result.name, 'Electronics');
      expect(result.description, 'Electronic items');
      expect(result.status, 'active');
    });
  });

  group('toJson', () {
    test('should return a JSON map with name and description', () {
      final result = tCategoryApiModel.toJson();

      expect(result['name'], 'Electronics');
      expect(result['description'], 'Electronic items');
      expect(result.containsKey('_id'), false);
      expect(result.containsKey('status'), false);
    });

    test('should not include description when null', () {
      final modelWithoutDesc = CategoryApiModel(id: '2', name: 'Books');

      final result = modelWithoutDesc.toJson();

      expect(result['name'], 'Books');
      expect(result.containsKey('description'), false);
    });
  });

  group('toEntity', () {
    test('should convert CategoryApiModel to CategoryEntity correctly', () {
      final result = tCategoryApiModel.toEntity();

      expect(result, isA<CategoryEntity>());
      expect(result.categoryId, '1');
      expect(result.name, 'Electronics');
      expect(result.description, 'Electronic items');
      expect(result.status, 'active');
    });
  });

  group('fromEntity', () {
    test('should convert CategoryEntity to CategoryApiModel correctly', () {
      final result = CategoryApiModel.fromEntity(tCategoryEntity);

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
        final models = [tCategoryApiModel, tCategoryApiModel];

        final result = CategoryApiModel.toEntityList(models);

        expect(result, isA<List<CategoryEntity>>());
        expect(result.length, 2);
        expect(result[0].name, 'Electronics');
        expect(result[1].name, 'Electronics');
      },
    );
  });
}
