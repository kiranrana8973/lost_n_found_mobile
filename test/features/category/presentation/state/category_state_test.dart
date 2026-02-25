import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:lost_n_found/features/category/presentation/state/category_state.dart';

void main() {
  const tCategory1 = CategoryEntity(
    categoryId: 'cat-1',
    name: 'Electronics',
    description: 'Electronic items',
    status: 'active',
  );

  const tCategory2 = CategoryEntity(
    categoryId: 'cat-2',
    name: 'Clothing',
    description: 'Clothes and accessories',
    status: 'active',
  );

  group('CategoryState', () {
    test('should have correct default values', () {
      const state = CategoryState();

      expect(state.status, CategoryStatus.initial);
      expect(state.categories, const <CategoryEntity>[]);
      expect(state.selectedCategory, isNull);
      expect(state.errorMessage, isNull);
    });

    test('should create with provided values', () {
      const state = CategoryState(
        status: CategoryStatus.loaded,
        categories: [tCategory1, tCategory2],
        selectedCategory: tCategory1,
        errorMessage: 'Some error',
      );

      expect(state.status, CategoryStatus.loaded);
      expect(state.categories, [tCategory1, tCategory2]);
      expect(state.selectedCategory, tCategory1);
      expect(state.errorMessage, 'Some error');
    });

    group('copyWith', () {
      test('should preserve unchanged fields when no arguments are passed', () {
        const original = CategoryState(
          status: CategoryStatus.loaded,
          categories: [tCategory1],
          selectedCategory: tCategory1,
          errorMessage: 'error',
        );

        final copied = original.copyWith();

        expect(copied.status, CategoryStatus.loaded);
        expect(copied.categories, [tCategory1]);
        expect(copied.selectedCategory, tCategory1);
        expect(copied.errorMessage, 'error');
      });

      test('should update only status', () {
        const original = CategoryState();

        final copied = original.copyWith(status: CategoryStatus.loading);

        expect(copied.status, CategoryStatus.loading);
        expect(copied.categories, const <CategoryEntity>[]);
        expect(copied.selectedCategory, isNull);
        expect(copied.errorMessage, isNull);
      });

      test('should update only categories', () {
        const original = CategoryState();

        final copied = original.copyWith(categories: [tCategory1, tCategory2]);

        expect(copied.status, CategoryStatus.initial);
        expect(copied.categories, [tCategory1, tCategory2]);
      });

      test('should update only selectedCategory', () {
        const original = CategoryState();

        final copied = original.copyWith(selectedCategory: tCategory1);

        expect(copied.selectedCategory, tCategory1);
        expect(copied.status, CategoryStatus.initial);
      });

      test('should update only errorMessage', () {
        const original = CategoryState();

        final copied = original.copyWith(errorMessage: 'Failed to load');

        expect(copied.errorMessage, 'Failed to load');
        expect(copied.status, CategoryStatus.initial);
      });

      test('should update all fields', () {
        const original = CategoryState();

        final copied = original.copyWith(
          status: CategoryStatus.error,
          categories: [tCategory1],
          selectedCategory: tCategory1,
          errorMessage: 'Error occurred',
        );

        expect(copied.status, CategoryStatus.error);
        expect(copied.categories, [tCategory1]);
        expect(copied.selectedCategory, tCategory1);
        expect(copied.errorMessage, 'Error occurred');
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        const state1 = CategoryState(
          status: CategoryStatus.loaded,
          categories: [tCategory1],
          selectedCategory: tCategory1,
        );
        const state2 = CategoryState(
          status: CategoryStatus.loaded,
          categories: [tCategory1],
          selectedCategory: tCategory1,
        );

        expect(state1, equals(state2));
      });

      test('should not be equal when status differs', () {
        const state1 = CategoryState(status: CategoryStatus.initial);
        const state2 = CategoryState(status: CategoryStatus.loading);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when categories differ', () {
        const state1 = CategoryState(categories: [tCategory1]);
        const state2 = CategoryState(categories: [tCategory2]);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when selectedCategory differs', () {
        const state1 = CategoryState(selectedCategory: tCategory1);
        const state2 = CategoryState(selectedCategory: tCategory2);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when errorMessage differs', () {
        const state1 = CategoryState(errorMessage: 'error1');
        const state2 = CategoryState(errorMessage: 'error2');

        expect(state1, isNot(equals(state2)));
      });

      test('should have correct props list', () {
        const state = CategoryState(
          status: CategoryStatus.loaded,
          categories: [tCategory1],
          selectedCategory: tCategory1,
          errorMessage: 'test',
        );

        expect(state.props, [
          CategoryStatus.loaded,
          [tCategory1],
          tCategory1,
          'test',
        ]);
      });
    });
  });
}
