import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/usecases/create_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_items_by_user_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/update_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_photo_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_video_usecase.dart';
import 'package:lost_n_found/features/item/presentation/state/item_state.dart';
import 'package:lost_n_found/features/item/presentation/view_model/item_viewmodel.dart';
import 'package:mocktail/mocktail.dart';

class MockGetAllItemsUsecase extends Mock implements GetAllItemsUsecase {}

class MockGetItemByIdUsecase extends Mock implements GetItemByIdUsecase {}

class MockGetItemsByUserUsecase extends Mock implements GetItemsByUserUsecase {}

class MockCreateItemUsecase extends Mock implements CreateItemUsecase {}

class MockUpdateItemUsecase extends Mock implements UpdateItemUsecase {}

class MockDeleteItemUsecase extends Mock implements DeleteItemUsecase {}

class MockUploadPhotoUsecase extends Mock implements UploadPhotoUsecase {}

class MockUploadVideoUsecase extends Mock implements UploadVideoUsecase {}

class MockFile extends Mock implements File {}

void main() {
  late MockGetAllItemsUsecase mockGetAllItemsUsecase;
  late MockGetItemByIdUsecase mockGetItemByIdUsecase;
  late MockGetItemsByUserUsecase mockGetItemsByUserUsecase;
  late MockCreateItemUsecase mockCreateItemUsecase;
  late MockUpdateItemUsecase mockUpdateItemUsecase;
  late MockDeleteItemUsecase mockDeleteItemUsecase;
  late MockUploadPhotoUsecase mockUploadPhotoUsecase;
  late MockUploadVideoUsecase mockUploadVideoUsecase;
  late ProviderContainer container;

  setUpAll(() {
    registerFallbackValue(
      const CreateItemParams(
        itemName: 'fallback',
        location: 'fallback',
        type: ItemType.lost,
      ),
    );
    registerFallbackValue(const GetItemByIdParams(itemId: 'fallback'));
    registerFallbackValue(const GetItemsByUserParams(userId: 'fallback'));
    registerFallbackValue(
      const UpdateItemParams(
        itemId: 'fallback',
        itemName: 'fallback',
        location: 'fallback',
        type: ItemType.lost,
      ),
    );
    registerFallbackValue(const DeleteItemParams(itemId: 'fallback'));
    registerFallbackValue(MockFile());
  });

  setUp(() {
    mockGetAllItemsUsecase = MockGetAllItemsUsecase();
    mockGetItemByIdUsecase = MockGetItemByIdUsecase();
    mockGetItemsByUserUsecase = MockGetItemsByUserUsecase();
    mockCreateItemUsecase = MockCreateItemUsecase();
    mockUpdateItemUsecase = MockUpdateItemUsecase();
    mockDeleteItemUsecase = MockDeleteItemUsecase();
    mockUploadPhotoUsecase = MockUploadPhotoUsecase();
    mockUploadVideoUsecase = MockUploadVideoUsecase();

    container = ProviderContainer(
      overrides: [
        getAllItemsUsecaseProvider.overrideWithValue(mockGetAllItemsUsecase),
        getItemByIdUsecaseProvider.overrideWithValue(mockGetItemByIdUsecase),
        getItemsByUserUsecaseProvider.overrideWithValue(
          mockGetItemsByUserUsecase,
        ),
        createItemUsecaseProvider.overrideWithValue(mockCreateItemUsecase),
        updateItemUsecaseProvider.overrideWithValue(mockUpdateItemUsecase),
        deleteItemUsecaseProvider.overrideWithValue(mockDeleteItemUsecase),
        uploadPhotoUsecaseProvider.overrideWithValue(mockUploadPhotoUsecase),
        uploadVideoUsecaseProvider.overrideWithValue(mockUploadVideoUsecase),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  const tLostItem = ItemEntity(
    itemId: '1',
    itemName: 'Lost Phone',
    type: ItemType.lost,
    location: 'Library',
    reportedBy: 'user1',
  );

  const tFoundItem = ItemEntity(
    itemId: '2',
    itemName: 'Found Keys',
    type: ItemType.found,
    location: 'Cafeteria',
    reportedBy: 'user2',
  );

  final tItems = [tLostItem, tFoundItem];

  group('ItemViewModel', () {
    group('initial state', () {
      test('should have initial state when created', () {
        // Act
        final state = container.read(itemViewModelProvider);

        // Assert
        expect(state.status, ItemStatus.initial);
        expect(state.items, isEmpty);
        expect(state.lostItems, isEmpty);
        expect(state.foundItems, isEmpty);
        expect(state.selectedItem, isNull);
        expect(state.errorMessage, isNull);
      });
    });

    group('getAllItems', () {
      test(
        'should emit loaded state with items separated into lost and found when successful',
        () async {
          // Arrange
          when(
            () => mockGetAllItemsUsecase(),
          ).thenAnswer((_) async => Right(tItems));

          final viewModel = container.read(itemViewModelProvider.notifier);

          // Act
          await viewModel.getAllItems();

          // Assert
          final state = container.read(itemViewModelProvider);
          expect(state.status, ItemStatus.loaded);
          expect(state.items.length, 2);
          expect(state.lostItems.length, 1);
          expect(state.foundItems.length, 1);
          expect(state.lostItems.first.itemName, 'Lost Phone');
          expect(state.foundItems.first.itemName, 'Found Keys');
          verify(() => mockGetAllItemsUsecase()).called(1);
        },
      );

      test('should emit error state when failed', () async {
        // Arrange
        const failure = ApiFailure(message: 'Failed to fetch items');
        when(
          () => mockGetAllItemsUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(itemViewModelProvider.notifier);

        // Act
        await viewModel.getAllItems();

        // Assert
        final state = container.read(itemViewModelProvider);
        expect(state.status, ItemStatus.error);
        expect(state.errorMessage, 'Failed to fetch items');
      });
    });

    group('getItemById', () {
      test(
        'should emit loaded state with selectedItem when successful',
        () async {
          // Arrange
          when(
            () => mockGetItemByIdUsecase(any()),
          ).thenAnswer((_) async => const Right(tLostItem));

          final viewModel = container.read(itemViewModelProvider.notifier);

          // Act
          await viewModel.getItemById('1');

          // Assert
          final state = container.read(itemViewModelProvider);
          expect(state.status, ItemStatus.loaded);
          expect(state.selectedItem, tLostItem);
          verify(() => mockGetItemByIdUsecase(any())).called(1);
        },
      );

      test('should emit error state when failed', () async {
        // Arrange
        const failure = ApiFailure(message: 'Item not found');
        when(
          () => mockGetItemByIdUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(itemViewModelProvider.notifier);

        // Act
        await viewModel.getItemById('1');

        // Assert
        final state = container.read(itemViewModelProvider);
        expect(state.status, ItemStatus.error);
        expect(state.errorMessage, 'Item not found');
      });
    });

    group('getMyItems', () {
      test(
        'should emit loaded state with myLostItems and myFoundItems when successful',
        () async {
          // Arrange
          when(
            () => mockGetItemsByUserUsecase(any()),
          ).thenAnswer((_) async => Right(tItems));

          final viewModel = container.read(itemViewModelProvider.notifier);

          // Act
          await viewModel.getMyItems('user1');

          // Assert
          final state = container.read(itemViewModelProvider);
          expect(state.status, ItemStatus.loaded);
          expect(state.myLostItems.length, 1);
          expect(state.myFoundItems.length, 1);
          verify(() => mockGetItemsByUserUsecase(any())).called(1);
        },
      );

      test('should emit error state when failed', () async {
        // Arrange
        const failure = ApiFailure(message: 'Failed to fetch user items');
        when(
          () => mockGetItemsByUserUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(itemViewModelProvider.notifier);

        // Act
        await viewModel.getMyItems('user1');

        // Assert
        final state = container.read(itemViewModelProvider);
        expect(state.status, ItemStatus.error);
        expect(state.errorMessage, 'Failed to fetch user items');
      });
    });

    group('createItem', () {
      test(
        'should emit created state and refresh items when successful',
        () async {
          // Arrange
          when(
            () => mockCreateItemUsecase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetAllItemsUsecase(),
          ).thenAnswer((_) async => Right(tItems));

          final viewModel = container.read(itemViewModelProvider.notifier);

          // Act
          await viewModel.createItem(
            itemName: 'New Item',
            location: 'Test Location',
            type: ItemType.lost,
          );

          // Assert
          verify(() => mockCreateItemUsecase(any())).called(1);
          verify(() => mockGetAllItemsUsecase()).called(1);
        },
      );

      test('should emit error state when creation fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Failed to create item');
        when(
          () => mockCreateItemUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(itemViewModelProvider.notifier);

        // Act
        await viewModel.createItem(
          itemName: 'New Item',
          location: 'Test Location',
          type: ItemType.lost,
        );

        // Assert
        final state = container.read(itemViewModelProvider);
        expect(state.status, ItemStatus.error);
        expect(state.errorMessage, 'Failed to create item');
        verify(() => mockCreateItemUsecase(any())).called(1);
        verifyNever(() => mockGetAllItemsUsecase());
      });
    });

    group('updateItem', () {
      test(
        'should emit updated state and refresh items when successful',
        () async {
          // Arrange
          when(
            () => mockUpdateItemUsecase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetAllItemsUsecase(),
          ).thenAnswer((_) async => Right(tItems));

          final viewModel = container.read(itemViewModelProvider.notifier);

          // Act
          await viewModel.updateItem(
            itemId: '1',
            itemName: 'Updated Item',
            location: 'Updated Location',
            type: ItemType.lost,
          );

          // Assert
          verify(() => mockUpdateItemUsecase(any())).called(1);
          verify(() => mockGetAllItemsUsecase()).called(1);
        },
      );

      test('should emit error state when update fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Failed to update item');
        when(
          () => mockUpdateItemUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(itemViewModelProvider.notifier);

        // Act
        await viewModel.updateItem(
          itemId: '1',
          itemName: 'Updated Item',
          location: 'Updated Location',
          type: ItemType.lost,
        );

        // Assert
        final state = container.read(itemViewModelProvider);
        expect(state.status, ItemStatus.error);
        expect(state.errorMessage, 'Failed to update item');
        verifyNever(() => mockGetAllItemsUsecase());
      });
    });

    group('deleteItem', () {
      test(
        'should emit deleted state and refresh items when successful',
        () async {
          // Arrange
          when(
            () => mockDeleteItemUsecase(any()),
          ).thenAnswer((_) async => const Right(true));
          when(
            () => mockGetAllItemsUsecase(),
          ).thenAnswer((_) async => Right(tItems));

          final viewModel = container.read(itemViewModelProvider.notifier);

          // Act
          await viewModel.deleteItem('1');

          // Assert
          verify(() => mockDeleteItemUsecase(any())).called(1);
          verify(() => mockGetAllItemsUsecase()).called(1);
        },
      );

      test('should emit error state when deletion fails', () async {
        // Arrange
        const failure = ApiFailure(message: 'Failed to delete item');
        when(
          () => mockDeleteItemUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(itemViewModelProvider.notifier);

        // Act
        await viewModel.deleteItem('1');

        // Assert
        final state = container.read(itemViewModelProvider);
        expect(state.status, ItemStatus.error);
        expect(state.errorMessage, 'Failed to delete item');
        verifyNever(() => mockGetAllItemsUsecase());
      });
    });

    group('uploadPhoto', () {
      test('should return URL and update state when successful', () async {
        // Arrange
        final mockFile = MockFile();
        when(
          () => mockUploadPhotoUsecase(any()),
        ).thenAnswer((_) async => const Right('https://example.com/photo.jpg'));

        final viewModel = container.read(itemViewModelProvider.notifier);

        // Act
        final result = await viewModel.uploadPhoto(mockFile);

        // Assert
        expect(result, 'https://example.com/photo.jpg');
        final state = container.read(itemViewModelProvider);
        expect(state.status, ItemStatus.loaded);
        expect(state.uploadedPhotoUrl, 'https://example.com/photo.jpg');
        verify(() => mockUploadPhotoUsecase(any())).called(1);
      });

      test('should return null and emit error state when failed', () async {
        // Arrange
        final mockFile = MockFile();
        const failure = ApiFailure(message: 'Failed to upload photo');
        when(
          () => mockUploadPhotoUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(itemViewModelProvider.notifier);

        // Act
        final result = await viewModel.uploadPhoto(mockFile);

        // Assert
        expect(result, isNull);
        final state = container.read(itemViewModelProvider);
        expect(state.status, ItemStatus.error);
        expect(state.errorMessage, 'Failed to upload photo');
      });
    });

    group('uploadVideo', () {
      test('should return URL and update state when successful', () async {
        // Arrange
        final mockFile = MockFile();
        when(
          () => mockUploadVideoUsecase(any()),
        ).thenAnswer((_) async => const Right('https://example.com/video.mp4'));

        final viewModel = container.read(itemViewModelProvider.notifier);

        // Act
        final result = await viewModel.uploadVideo(mockFile);

        // Assert
        expect(result, 'https://example.com/video.mp4');
        final state = container.read(itemViewModelProvider);
        expect(state.status, ItemStatus.loaded);
        verify(() => mockUploadVideoUsecase(any())).called(1);
      });

      test('should return null and emit error state when failed', () async {
        // Arrange
        final mockFile = MockFile();
        const failure = ApiFailure(message: 'Failed to upload video');
        when(
          () => mockUploadVideoUsecase(any()),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(itemViewModelProvider.notifier);

        // Act
        final result = await viewModel.uploadVideo(mockFile);

        // Assert
        expect(result, isNull);
        final state = container.read(itemViewModelProvider);
        expect(state.status, ItemStatus.error);
        expect(state.errorMessage, 'Failed to upload video');
      });
    });

    group('clearError', () {
      test('should clear error message', () async {
        // Arrange
        const failure = ApiFailure(message: 'Some error');
        when(
          () => mockGetAllItemsUsecase(),
        ).thenAnswer((_) async => const Left(failure));

        final viewModel = container.read(itemViewModelProvider.notifier);
        await viewModel.getAllItems();

        // Verify error is set
        var state = container.read(itemViewModelProvider);
        expect(state.errorMessage, 'Some error');

        // Act
        viewModel.clearError();

        // Assert
        state = container.read(itemViewModelProvider);
        expect(state.errorMessage, isNull);
      });
    });

    group('clearSelectedItem', () {
      test('should clear selected item', () async {
        // Arrange
        when(
          () => mockGetItemByIdUsecase(any()),
        ).thenAnswer((_) async => const Right(tLostItem));

        final viewModel = container.read(itemViewModelProvider.notifier);
        await viewModel.getItemById('1');

        // Verify selectedItem is set
        var state = container.read(itemViewModelProvider);
        expect(state.selectedItem, tLostItem);

        // Act
        viewModel.clearSelectedItem();

        // Assert
        state = container.read(itemViewModelProvider);
        expect(state.selectedItem, isNull);
      });
    });

    group('clearReportState', () {
      test(
        'should reset to initial status and clear uploaded photo url',
        () async {
          // Arrange
          final mockFile = MockFile();
          when(() => mockUploadPhotoUsecase(any())).thenAnswer(
            (_) async => const Right('https://example.com/photo.jpg'),
          );

          final viewModel = container.read(itemViewModelProvider.notifier);
          await viewModel.uploadPhoto(mockFile);

          // Verify uploadedPhotoUrl is set
          var state = container.read(itemViewModelProvider);
          expect(state.uploadedPhotoUrl, 'https://example.com/photo.jpg');

          // Act
          viewModel.clearReportState();

          // Assert
          state = container.read(itemViewModelProvider);
          expect(state.status, ItemStatus.initial);
          expect(state.uploadedPhotoUrl, isNull);
        },
      );
    });
  });

  group('ItemState', () {
    test('should have correct initial values', () {
      // Arrange
      const state = ItemState();

      // Assert
      expect(state.status, ItemStatus.initial);
      expect(state.items, isEmpty);
      expect(state.lostItems, isEmpty);
      expect(state.foundItems, isEmpty);
      expect(state.myLostItems, isEmpty);
      expect(state.myFoundItems, isEmpty);
      expect(state.selectedItem, isNull);
      expect(state.errorMessage, isNull);
      expect(state.uploadedPhotoUrl, isNull);
    });

    test('copyWith should update specified fields', () {
      // Arrange
      const state = ItemState();

      // Act
      final newState = state.copyWith(status: ItemStatus.loaded, items: tItems);

      // Assert
      expect(newState.status, ItemStatus.loaded);
      expect(newState.items, tItems);
      expect(newState.selectedItem, isNull);
      expect(newState.errorMessage, isNull);
    });

    test(
      'copyWith should reset selectedItem when resetSelectedItem is true',
      () {
        // Arrange
        const state = ItemState(selectedItem: tLostItem);

        // Act
        final newState = state.copyWith(resetSelectedItem: true);

        // Assert
        expect(newState.selectedItem, isNull);
      },
    );

    test(
      'copyWith should reset errorMessage when resetErrorMessage is true',
      () {
        // Arrange
        const state = ItemState(errorMessage: 'Some error');

        // Act
        final newState = state.copyWith(resetErrorMessage: true);

        // Assert
        expect(newState.errorMessage, isNull);
      },
    );

    test(
      'copyWith should reset uploadedPhotoUrl when resetUploadedPhotoUrl is true',
      () {
        // Arrange
        const state = ItemState(
          uploadedPhotoUrl: 'https://example.com/photo.jpg',
        );

        // Act
        final newState = state.copyWith(resetUploadedPhotoUrl: true);

        // Assert
        expect(newState.uploadedPhotoUrl, isNull);
      },
    );

    test('props should contain all fields', () {
      // Arrange
      const state = ItemState(
        status: ItemStatus.loaded,
        items: [],
        lostItems: [],
        foundItems: [],
        myLostItems: [],
        myFoundItems: [],
        selectedItem: tLostItem,
        errorMessage: 'error',
        uploadedPhotoUrl: 'url',
      );

      // Assert
      expect(state.props, [
        ItemStatus.loaded,
        [],
        [],
        [],
        [],
        [],
        tLostItem,
        'error',
        'url',
      ]);
    });
  });
}
