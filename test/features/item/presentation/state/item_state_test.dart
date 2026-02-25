import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/presentation/state/item_state.dart';

void main() {
  const tItem1 = ItemEntity(
    itemId: 'item-1',
    itemName: 'Lost Phone',
    type: ItemType.lost,
    location: 'Library',
  );

  const tItem2 = ItemEntity(
    itemId: 'item-2',
    itemName: 'Found Wallet',
    type: ItemType.found,
    location: 'Cafeteria',
  );

  group('ItemState', () {
    test('should have correct default values', () {
      const state = ItemState();

      expect(state.status, ItemStatus.initial);
      expect(state.items, const <ItemEntity>[]);
      expect(state.lostItems, const <ItemEntity>[]);
      expect(state.foundItems, const <ItemEntity>[]);
      expect(state.myLostItems, const <ItemEntity>[]);
      expect(state.myFoundItems, const <ItemEntity>[]);
      expect(state.selectedItem, isNull);
      expect(state.errorMessage, isNull);
      expect(state.uploadedPhotoUrl, isNull);
    });

    test('should create with provided values', () {
      const state = ItemState(
        status: ItemStatus.loaded,
        items: [tItem1, tItem2],
        lostItems: [tItem1],
        foundItems: [tItem2],
        myLostItems: [tItem1],
        myFoundItems: [tItem2],
        selectedItem: tItem1,
        errorMessage: 'Some error',
        uploadedPhotoUrl: 'https://example.com/photo.jpg',
      );

      expect(state.status, ItemStatus.loaded);
      expect(state.items, [tItem1, tItem2]);
      expect(state.lostItems, [tItem1]);
      expect(state.foundItems, [tItem2]);
      expect(state.myLostItems, [tItem1]);
      expect(state.myFoundItems, [tItem2]);
      expect(state.selectedItem, tItem1);
      expect(state.errorMessage, 'Some error');
      expect(state.uploadedPhotoUrl, 'https://example.com/photo.jpg');
    });

    group('copyWith', () {
      test('should preserve unchanged fields when no arguments are passed', () {
        const original = ItemState(
          status: ItemStatus.loaded,
          items: [tItem1],
          lostItems: [tItem1],
          foundItems: [tItem2],
          myLostItems: [tItem1],
          myFoundItems: [tItem2],
          selectedItem: tItem1,
          errorMessage: 'error',
          uploadedPhotoUrl: 'url',
        );

        final copied = original.copyWith();

        expect(copied.status, ItemStatus.loaded);
        expect(copied.items, [tItem1]);
        expect(copied.lostItems, [tItem1]);
        expect(copied.foundItems, [tItem2]);
        expect(copied.myLostItems, [tItem1]);
        expect(copied.myFoundItems, [tItem2]);
        expect(copied.selectedItem, tItem1);
        expect(copied.errorMessage, 'error');
        expect(copied.uploadedPhotoUrl, 'url');
      });

      test('should update status only', () {
        const original = ItemState();

        final copied = original.copyWith(status: ItemStatus.loading);

        expect(copied.status, ItemStatus.loading);
        expect(copied.items, const <ItemEntity>[]);
      });

      test('should update items list', () {
        const original = ItemState();

        final copied = original.copyWith(items: [tItem1, tItem2]);

        expect(copied.items, [tItem1, tItem2]);
        expect(copied.status, ItemStatus.initial);
      });

      test('should update selectedItem', () {
        const original = ItemState();

        final copied = original.copyWith(selectedItem: tItem1);

        expect(copied.selectedItem, tItem1);
      });

      test('should reset selectedItem to null with resetSelectedItem flag', () {
        const original = ItemState(selectedItem: tItem1);

        final copied = original.copyWith(resetSelectedItem: true);

        expect(copied.selectedItem, isNull);
      });

      test('should reset errorMessage to null with resetErrorMessage flag', () {
        const original = ItemState(errorMessage: 'Some error');

        final copied = original.copyWith(resetErrorMessage: true);

        expect(copied.errorMessage, isNull);
      });

      test(
        'should reset uploadedPhotoUrl to null with resetUploadedPhotoUrl flag',
        () {
          const original = ItemState(
            uploadedPhotoUrl: 'https://example.com/photo.jpg',
          );

          final copied = original.copyWith(resetUploadedPhotoUrl: true);

          expect(copied.uploadedPhotoUrl, isNull);
        },
      );

      test('should update multiple fields at once', () {
        const original = ItemState();

        final copied = original.copyWith(
          status: ItemStatus.loaded,
          items: [tItem1],
          lostItems: [tItem1],
          foundItems: [tItem2],
          errorMessage: 'test error',
        );

        expect(copied.status, ItemStatus.loaded);
        expect(copied.items, [tItem1]);
        expect(copied.lostItems, [tItem1]);
        expect(copied.foundItems, [tItem2]);
        expect(copied.errorMessage, 'test error');
      });
    });

    group('equality', () {
      test('should be equal when all properties are the same', () {
        const state1 = ItemState(
          status: ItemStatus.loaded,
          items: [tItem1],
          selectedItem: tItem1,
        );
        const state2 = ItemState(
          status: ItemStatus.loaded,
          items: [tItem1],
          selectedItem: tItem1,
        );

        expect(state1, equals(state2));
      });

      test('should not be equal when status differs', () {
        const state1 = ItemState(status: ItemStatus.initial);
        const state2 = ItemState(status: ItemStatus.loading);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when items differ', () {
        const state1 = ItemState(items: [tItem1]);
        const state2 = ItemState(items: [tItem2]);

        expect(state1, isNot(equals(state2)));
      });

      test('should not be equal when selectedItem differs', () {
        const state1 = ItemState(selectedItem: tItem1);
        const state2 = ItemState(selectedItem: tItem2);

        expect(state1, isNot(equals(state2)));
      });

      test('should have correct props list', () {
        const state = ItemState();

        expect(state.props, [
          ItemStatus.initial,
          const <ItemEntity>[],
          const <ItemEntity>[],
          const <ItemEntity>[],
          const <ItemEntity>[],
          const <ItemEntity>[],
          null,
          null,
          null,
        ]);
      });
    });
  });
}
