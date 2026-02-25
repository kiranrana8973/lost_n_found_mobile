import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';

void main() {
  const tCategoryEntity = CategoryEntity(
    categoryId: 'cat-1',
    name: 'Electronics',
    description: 'Electronic items like phones, laptops',
    status: 'active',
  );

  group('CategoryEntity', () {
    test('should create a CategoryEntity with required fields only', () {
      const entity = CategoryEntity(name: 'Books');

      expect(entity.name, 'Books');
      expect(entity.categoryId, isNull);
      expect(entity.description, isNull);
      expect(entity.status, isNull);
    });

    test('should create a CategoryEntity with all fields', () {
      expect(tCategoryEntity.categoryId, 'cat-1');
      expect(tCategoryEntity.name, 'Electronics');
      expect(tCategoryEntity.description, 'Electronic items like phones, laptops');
      expect(tCategoryEntity.status, 'active');
    });

    test('should be equal when all properties are the same', () {
      const anotherEntity = CategoryEntity(
        categoryId: 'cat-1',
        name: 'Electronics',
        description: 'Electronic items like phones, laptops',
        status: 'active',
      );

      expect(tCategoryEntity, equals(anotherEntity));
    });

    test('should not be equal when properties differ', () {
      const differentEntity = CategoryEntity(
        categoryId: 'cat-2',
        name: 'Clothing',
        description: 'Clothes and accessories',
        status: 'inactive',
      );

      expect(tCategoryEntity, isNot(equals(differentEntity)));
    });

    test('should have correct props list', () {
      expect(tCategoryEntity.props, [
        'cat-1',
        'Electronics',
        'Electronic items like phones, laptops',
        'active',
      ]);
    });
  });
}
