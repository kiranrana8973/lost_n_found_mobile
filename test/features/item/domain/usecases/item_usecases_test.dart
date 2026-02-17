import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:lost_n_found/features/item/domain/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/usecases/create_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/delete_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_all_items_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_item_by_id_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/get_items_by_user_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/update_item_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_photo_usecase.dart';
import 'package:lost_n_found/features/item/domain/usecases/upload_video_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockItemRepository extends Mock implements IItemRepository {}

class MockFile extends Mock implements File {}

void main() {
  late MockItemRepository mockRepo;

  const tItem = ItemEntity(
    itemId: 'item-1',
    itemName: 'Lost Wallet',
    type: ItemType.lost,
    location: 'Library',
    reportedBy: 'user-1',
  );

  final tItems = [
    tItem,
    const ItemEntity(
      itemId: 'item-2',
      itemName: 'Found Phone',
      type: ItemType.found,
      location: 'Cafeteria',
    ),
  ];

  setUp(() {
    mockRepo = MockItemRepository();
  });

  setUpAll(() {
    registerFallbackValue(tItem);
    registerFallbackValue(MockFile());
  });

  group('GetAllItemsUsecase', () {
    late GetAllItemsUsecase usecase;

    setUp(() {
      usecase = GetAllItemsUsecase(itemRepository: mockRepo);
    });

    test('should return list of items from repository', () async {
      when(() => mockRepo.getAllItems())
          .thenAnswer((_) async => Right(tItems));

      final result = await usecase();

      expect(result, Right(tItems));
      verify(() => mockRepo.getAllItems()).called(1);
    });

    test('should return failure when repository fails', () async {
      when(() => mockRepo.getAllItems())
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await usecase();

      expect(result, const Left(NetworkFailure()));
    });
  });

  group('GetItemByIdUsecase', () {
    late GetItemByIdUsecase usecase;

    setUp(() {
      usecase = GetItemByIdUsecase(itemRepository: mockRepo);
    });

    test('should call repository.getItemById with correct id', () async {
      when(() => mockRepo.getItemById(any()))
          .thenAnswer((_) async => const Right(tItem));

      final result = await usecase(const GetItemByIdParams(itemId: 'item-1'));

      expect(result, const Right(tItem));
      verify(() => mockRepo.getItemById('item-1')).called(1);
    });

    test('should return failure when item not found', () async {
      when(() => mockRepo.getItemById(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Not found')));

      final result = await usecase(const GetItemByIdParams(itemId: 'invalid'));

      expect(result, const Left(ApiFailure(message: 'Not found')));
    });
  });

  group('GetItemsByUserUsecase', () {
    late GetItemsByUserUsecase usecase;

    setUp(() {
      usecase = GetItemsByUserUsecase(itemRepository: mockRepo);
    });

    test('should call repository.getItemsByUser with correct userId', () async {
      when(() => mockRepo.getItemsByUser(any()))
          .thenAnswer((_) async => Right(tItems));

      final result = await usecase(const GetItemsByUserParams(userId: 'user-1'));

      expect(result, Right(tItems));
      verify(() => mockRepo.getItemsByUser('user-1')).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepo.getItemsByUser(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Error')));

      final result = await usecase(const GetItemsByUserParams(userId: 'user-1'));

      expect(result, const Left(ApiFailure(message: 'Error')));
    });
  });

  group('CreateItemUsecase', () {
    late CreateItemUsecase usecase;

    setUp(() {
      usecase = CreateItemUsecase(itemRepository: mockRepo);
    });

    const tParams = CreateItemParams(
      itemName: 'Lost Wallet',
      location: 'Library',
      type: ItemType.lost,
      reportedBy: 'user-1',
      category: 'cat-1',
    );

    test('should call repository.createItem with ItemEntity', () async {
      when(() => mockRepo.createItem(any()))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockRepo.createItem(any())).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepo.createItem(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Create failed')));

      final result = await usecase(tParams);

      expect(result, const Left(ApiFailure(message: 'Create failed')));
    });
  });

  group('UpdateItemUsecase', () {
    late UpdateItemUsecase usecase;

    setUp(() {
      usecase = UpdateItemUsecase(itemRepository: mockRepo);
    });

    const tParams = UpdateItemParams(
      itemId: 'item-1',
      itemName: 'Updated Wallet',
      location: 'Library 2F',
      type: ItemType.lost,
    );

    test('should call repository.updateItem with ItemEntity', () async {
      when(() => mockRepo.updateItem(any()))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(tParams);

      expect(result, const Right(true));
      verify(() => mockRepo.updateItem(any())).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepo.updateItem(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Update failed')));

      final result = await usecase(tParams);

      expect(result, const Left(ApiFailure(message: 'Update failed')));
    });
  });

  group('DeleteItemUsecase', () {
    late DeleteItemUsecase usecase;

    setUp(() {
      usecase = DeleteItemUsecase(itemRepository: mockRepo);
    });

    test('should call repository.deleteItem with correct id', () async {
      when(() => mockRepo.deleteItem(any()))
          .thenAnswer((_) async => const Right(true));

      final result = await usecase(const DeleteItemParams(itemId: 'item-1'));

      expect(result, const Right(true));
      verify(() => mockRepo.deleteItem('item-1')).called(1);
    });

    test('should return failure on error', () async {
      when(() => mockRepo.deleteItem(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Delete failed')));

      final result = await usecase(const DeleteItemParams(itemId: 'item-1'));

      expect(result, const Left(ApiFailure(message: 'Delete failed')));
    });
  });

  group('UploadPhotoUsecase', () {
    late UploadPhotoUsecase usecase;
    late MockFile mockFile;

    setUp(() {
      usecase = UploadPhotoUsecase(itemRepository: mockRepo);
      mockFile = MockFile();
    });

    test('should call repository.uploadPhoto with file', () async {
      when(() => mockRepo.uploadPhoto(any()))
          .thenAnswer((_) async => const Right('photo-url.jpg'));

      final result = await usecase(mockFile);

      expect(result, const Right('photo-url.jpg'));
      verify(() => mockRepo.uploadPhoto(mockFile)).called(1);
    });

    test('should return failure on upload error', () async {
      when(() => mockRepo.uploadPhoto(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Upload failed')));

      final result = await usecase(mockFile);

      expect(result, const Left(ApiFailure(message: 'Upload failed')));
    });
  });

  group('UploadVideoUsecase', () {
    late UploadVideoUsecase usecase;
    late MockFile mockFile;

    setUp(() {
      usecase = UploadVideoUsecase(itemRepository: mockRepo);
      mockFile = MockFile();
    });

    test('should call repository.uploadVideo with file', () async {
      when(() => mockRepo.uploadVideo(any()))
          .thenAnswer((_) async => const Right('video-url.mp4'));

      final result = await usecase(mockFile);

      expect(result, const Right('video-url.mp4'));
      verify(() => mockRepo.uploadVideo(mockFile)).called(1);
    });

    test('should return failure on upload error', () async {
      when(() => mockRepo.uploadVideo(any()))
          .thenAnswer((_) async => const Left(ApiFailure(message: 'Upload failed')));

      final result = await usecase(mockFile);

      expect(result, const Left(ApiFailure(message: 'Upload failed')));
    });
  });
}
