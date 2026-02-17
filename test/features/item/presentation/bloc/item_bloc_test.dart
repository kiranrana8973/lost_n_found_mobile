import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
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
import 'package:lost_n_found/features/item/presentation/bloc/item_bloc.dart';
import 'package:lost_n_found/features/item/presentation/bloc/item_event.dart';
import 'package:lost_n_found/features/item/presentation/state/item_state.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
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
  late ItemBloc itemBloc;
  late MockGetAllItemsUsecase mockGetAllItemsUsecase;
  late MockGetItemByIdUsecase mockGetItemByIdUsecase;
  late MockGetItemsByUserUsecase mockGetItemsByUserUsecase;
  late MockCreateItemUsecase mockCreateItemUsecase;
  late MockUpdateItemUsecase mockUpdateItemUsecase;
  late MockDeleteItemUsecase mockDeleteItemUsecase;
  late MockUploadPhotoUsecase mockUploadPhotoUsecase;
  late MockUploadVideoUsecase mockUploadVideoUsecase;

  const tLostItem = ItemEntity(
    itemId: 'item-1',
    itemName: 'Lost Wallet',
    type: ItemType.lost,
    location: 'Library',
    reportedBy: 'user-1',
  );

  const tFoundItem = ItemEntity(
    itemId: 'item-2',
    itemName: 'Found Phone',
    type: ItemType.found,
    location: 'Cafeteria',
    reportedBy: 'user-2',
  );

  final tItems = [tLostItem, tFoundItem];

  setUpAll(() {
    registerFallbackValue(const GetItemByIdParams(itemId: ''));
    registerFallbackValue(const GetItemsByUserParams(userId: ''));
    registerFallbackValue(
      CreateItemParams(itemName: '', location: '', type: ItemType.lost),
    );
    registerFallbackValue(
      UpdateItemParams(
        itemId: '',
        itemName: '',
        location: '',
        type: ItemType.lost,
      ),
    );
    registerFallbackValue(const DeleteItemParams(itemId: ''));
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

    itemBloc = ItemBloc(
      getAllItemsUsecase: mockGetAllItemsUsecase,
      getItemByIdUsecase: mockGetItemByIdUsecase,
      getItemsByUserUsecase: mockGetItemsByUserUsecase,
      createItemUsecase: mockCreateItemUsecase,
      updateItemUsecase: mockUpdateItemUsecase,
      deleteItemUsecase: mockDeleteItemUsecase,
      uploadPhotoUsecase: mockUploadPhotoUsecase,
      uploadVideoUsecase: mockUploadVideoUsecase,
    );
  });

  tearDown(() {
    itemBloc.close();
  });

  test('initial state is ItemState with initial status', () {
    expect(itemBloc.state, const ItemState());
    expect(itemBloc.state.status, ItemStatus.initial);
  });

  group('ItemGetAllEvent', () {
    blocTest<ItemBloc, ItemState>(
      'emits [loading, loaded] with filtered items when succeeds',
      build: () {
        when(
          () => mockGetAllItemsUsecase(),
        ).thenAnswer((_) async => Right(tItems));
        return itemBloc;
      },
      act: (bloc) => bloc.add(const ItemGetAllEvent()),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        ItemState(
          status: ItemStatus.loaded,
          items: tItems,
          lostItems: const [tLostItem],
          foundItems: const [tFoundItem],
        ),
      ],
    );

    blocTest<ItemBloc, ItemState>(
      'emits [loading, error] when fails',
      build: () {
        when(() => mockGetAllItemsUsecase()).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Server error')),
        );
        return itemBloc;
      },
      act: (bloc) => bloc.add(const ItemGetAllEvent()),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        const ItemState(status: ItemStatus.error, errorMessage: 'Server error'),
      ],
    );
  });

  group('ItemGetByIdEvent', () {
    blocTest<ItemBloc, ItemState>(
      'emits [loading, loaded] with selected item when succeeds',
      build: () {
        when(
          () => mockGetItemByIdUsecase(any()),
        ).thenAnswer((_) async => const Right(tLostItem));
        return itemBloc;
      },
      act: (bloc) => bloc.add(const ItemGetByIdEvent(itemId: 'item-1')),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        const ItemState(status: ItemStatus.loaded, selectedItem: tLostItem),
      ],
    );

    blocTest<ItemBloc, ItemState>(
      'emits [loading, error] when fails',
      build: () {
        when(() => mockGetItemByIdUsecase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Item not found')),
        );
        return itemBloc;
      },
      act: (bloc) => bloc.add(const ItemGetByIdEvent(itemId: 'item-1')),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        const ItemState(
          status: ItemStatus.error,
          errorMessage: 'Item not found',
        ),
      ],
    );
  });

  group('ItemGetMyItemsEvent', () {
    blocTest<ItemBloc, ItemState>(
      'emits [loading, loaded] with my items filtered by type',
      build: () {
        when(
          () => mockGetItemsByUserUsecase(any()),
        ).thenAnswer((_) async => Right(tItems));
        return itemBloc;
      },
      act: (bloc) => bloc.add(const ItemGetMyItemsEvent(userId: 'user-1')),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        const ItemState(
          status: ItemStatus.loaded,
          myLostItems: [tLostItem],
          myFoundItems: [tFoundItem],
        ),
      ],
    );

    blocTest<ItemBloc, ItemState>(
      'emits [loading, error] when fails',
      build: () {
        when(
          () => mockGetItemsByUserUsecase(any()),
        ).thenAnswer((_) async => const Left(NetworkFailure()));
        return itemBloc;
      },
      act: (bloc) => bloc.add(const ItemGetMyItemsEvent(userId: 'user-1')),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        const ItemState(
          status: ItemStatus.error,
          errorMessage: 'No internet connection',
        ),
      ],
    );
  });

  group('ItemCreateEvent', () {
    const tCreateEvent = ItemCreateEvent(
      itemName: 'Lost Wallet',
      location: 'Library',
      type: ItemType.lost,
      reportedBy: 'user-1',
    );

    blocTest<ItemBloc, ItemState>(
      'emits [loading, created] and triggers GetAll when succeeds',
      build: () {
        when(
          () => mockCreateItemUsecase(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockGetAllItemsUsecase(),
        ).thenAnswer((_) async => Right(tItems));
        return itemBloc;
      },
      act: (bloc) => bloc.add(tCreateEvent),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        const ItemState(status: ItemStatus.created),
        // GetAll triggered: loading then loaded
        const ItemState(status: ItemStatus.loading),
        ItemState(
          status: ItemStatus.loaded,
          items: tItems,
          lostItems: const [tLostItem],
          foundItems: const [tFoundItem],
        ),
      ],
      verify: (_) {
        verify(() => mockCreateItemUsecase(any())).called(1);
        verify(() => mockGetAllItemsUsecase()).called(1);
      },
    );

    blocTest<ItemBloc, ItemState>(
      'emits [loading, error] when create fails',
      build: () {
        when(() => mockCreateItemUsecase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Create failed')),
        );
        return itemBloc;
      },
      act: (bloc) => bloc.add(tCreateEvent),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        const ItemState(
          status: ItemStatus.error,
          errorMessage: 'Create failed',
        ),
      ],
    );
  });

  group('ItemDeleteEvent', () {
    blocTest<ItemBloc, ItemState>(
      'emits [loading, deleted] and triggers GetAll when succeeds',
      build: () {
        when(
          () => mockDeleteItemUsecase(any()),
        ).thenAnswer((_) async => const Right(true));
        when(
          () => mockGetAllItemsUsecase(),
        ).thenAnswer((_) async => const Right([]));
        return itemBloc;
      },
      act: (bloc) => bloc.add(const ItemDeleteEvent(itemId: 'item-1')),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        const ItemState(status: ItemStatus.deleted),
        const ItemState(status: ItemStatus.loading),
        const ItemState(status: ItemStatus.loaded),
      ],
      verify: (_) {
        verify(() => mockDeleteItemUsecase(any())).called(1);
        verify(() => mockGetAllItemsUsecase()).called(1);
      },
    );
  });

  group('ItemUploadPhotoEvent', () {
    late MockFile mockFile;

    setUp(() {
      mockFile = MockFile();
    });

    blocTest<ItemBloc, ItemState>(
      'emits [loading, loaded] with uploaded url when succeeds',
      build: () {
        when(
          () => mockUploadPhotoUsecase(any()),
        ).thenAnswer((_) async => const Right('photo-url.jpg'));
        return itemBloc;
      },
      act: (bloc) => bloc.add(ItemUploadPhotoEvent(photo: mockFile)),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        const ItemState(
          status: ItemStatus.loaded,
          uploadedPhotoUrl: 'photo-url.jpg',
        ),
      ],
    );

    blocTest<ItemBloc, ItemState>(
      'emits [loading, error] when upload fails',
      build: () {
        when(() => mockUploadPhotoUsecase(any())).thenAnswer(
          (_) async => const Left(ApiFailure(message: 'Upload failed')),
        );
        return itemBloc;
      },
      act: (bloc) => bloc.add(ItemUploadPhotoEvent(photo: mockFile)),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        const ItemState(
          status: ItemStatus.error,
          errorMessage: 'Upload failed',
        ),
      ],
    );
  });

  group('ItemUploadVideoEvent', () {
    late MockFile mockFile;

    setUp(() {
      mockFile = MockFile();
    });

    blocTest<ItemBloc, ItemState>(
      'emits [loading, loaded] with uploaded url when succeeds',
      build: () {
        when(
          () => mockUploadVideoUsecase(any()),
        ).thenAnswer((_) async => const Right('video-url.mp4'));
        return itemBloc;
      },
      act: (bloc) => bloc.add(ItemUploadVideoEvent(video: mockFile)),
      expect: () => [
        const ItemState(status: ItemStatus.loading),
        const ItemState(
          status: ItemStatus.loaded,
          uploadedPhotoUrl: 'video-url.mp4',
        ),
      ],
    );
  });

  group('ItemClearErrorEvent', () {
    blocTest<ItemBloc, ItemState>(
      'clears error message from state',
      build: () => itemBloc,
      seed: () =>
          const ItemState(status: ItemStatus.error, errorMessage: 'Some error'),
      act: (bloc) => bloc.add(const ItemClearErrorEvent()),
      expect: () => [const ItemState(status: ItemStatus.error)],
    );
  });

  group('ItemClearReportStateEvent', () {
    blocTest<ItemBloc, ItemState>(
      'resets to initial state clearing uploads and errors',
      build: () => itemBloc,
      seed: () => const ItemState(
        status: ItemStatus.created,
        uploadedPhotoUrl: 'some-url',
        errorMessage: 'some error',
      ),
      act: (bloc) => bloc.add(const ItemClearReportStateEvent()),
      expect: () => [const ItemState(status: ItemStatus.initial)],
    );
  });
}
