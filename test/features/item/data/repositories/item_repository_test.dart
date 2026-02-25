import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/item/data/datasources/local/item_local_datasource.dart';
import 'package:lost_n_found/features/item/data/models/item_api_model.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../mocks/test_mocks.dart';

class MockItemLocalDatasource extends Mock implements ItemLocalDatasource {}

class FakeItemApiModel extends Fake implements ItemApiModel {}

class FakeItemHiveModel extends Fake implements ItemHiveModel {}

void main() {
  late ItemRepository repository;
  late MockItemLocalDatasource mockLocalDataSource;
  late MockItemRemoteDataSource mockRemoteDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUpAll(() {
    registerFallbackValue(FakeItemApiModel());
    registerFallbackValue(FakeItemHiveModel());
    registerFallbackValue(FakeFile());
  });

  setUp(() {
    mockLocalDataSource = MockItemLocalDatasource();
    mockRemoteDataSource = MockItemRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ItemRepository(
      localDatasource: mockLocalDataSource,
      remoteDatasource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  const tItemEntity = ItemEntity(
    itemId: '1',
    reportedBy: 'user1',
    category: 'cat1',
    itemName: 'Test Item',
    description: 'A test item',
    type: ItemType.lost,
    location: 'Library',
    isClaimed: false,
    status: 'available',
  );

  final tItemApiModel = ItemApiModel(
    id: '1',
    reportedBy: 'user1',
    category: 'cat1',
    itemName: 'Test Item',
    description: 'A test item',
    type: 'lost',
    location: 'Library',
    isClaimed: false,
    status: 'available',
  );

  final tItemApiModels = [tItemApiModel];

  final tItemHiveModel = ItemHiveModel(
    itemId: '1',
    reportedBy: 'user1',
    category: 'cat1',
    itemName: 'Test Item',
    description: 'A test item',
    type: 'lost',
    location: 'Library',
    isClaimed: false,
    status: 'available',
  );

  final tItemHiveModels = [tItemHiveModel];

  group('getAllItems', () {
    test(
      'should return Right(List<ItemEntity>) and cache items when online',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.getAllItems(),
        ).thenAnswer((_) async => tItemApiModels);
        when(
          () => mockLocalDataSource.cacheAllItems(any()),
        ).thenAnswer((_) async {});

        final result = await repository.getAllItems();

        expect(result.isRight(), true);
        result.fold((_) => fail('Should be Right'), (items) {
          expect(items, isA<List<ItemEntity>>());
          expect(items.length, 1);
          expect(items[0].itemName, 'Test Item');
        });
        verify(() => mockLocalDataSource.cacheAllItems(any())).called(1);
      },
    );

    test('should return cached items when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(
        () => mockLocalDataSource.getAllItems(),
      ).thenAnswer((_) async => tItemHiveModels);

      final result = await repository.getAllItems();

      expect(result.isRight(), true);
      result.fold((_) => fail('Should be Right'), (items) {
        expect(items, isA<List<ItemEntity>>());
        expect(items.length, 1);
      });
      verify(() => mockLocalDataSource.getAllItems()).called(1);
      verifyNever(() => mockRemoteDataSource.getAllItems());
    });
  });

  group('createItem', () {
    test(
      'should return Right(true) when online and creation succeeds',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.createItem(any()),
        ).thenAnswer((_) async => tItemApiModel);

        final result = await repository.createItem(tItemEntity);

        expect(result, const Right(true));
        verify(() => mockRemoteDataSource.createItem(any())).called(1);
      },
    );

    test('should return Left(NetworkFailure) when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.createItem(tItemEntity);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should be Left'),
      );
    });
  });

  group('deleteItem', () {
    const tItemId = '1';

    test(
      'should return Right(true) when online and deletion succeeds',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.deleteItem(any()),
        ).thenAnswer((_) async => true);

        final result = await repository.deleteItem(tItemId);

        expect(result, const Right(true));
        verify(() => mockRemoteDataSource.deleteItem(tItemId)).called(1);
      },
    );

    test(
      'should return Right(true) when offline and local delete succeeds',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(
          () => mockLocalDataSource.deleteItem(any()),
        ).thenAnswer((_) async => true);

        final result = await repository.deleteItem(tItemId);

        expect(result, const Right(true));
        verify(() => mockLocalDataSource.deleteItem(tItemId)).called(1);
      },
    );
  });

  group('uploadPhoto', () {
    late File tFile;

    setUp(() {
      tFile = File('test_photo.jpg');
    });

    test(
      'should return Right(String) when online and upload succeeds',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(
          () => mockRemoteDataSource.uploadPhoto(any()),
        ).thenAnswer((_) async => 'http://example.com/photo.jpg');

        final result = await repository.uploadPhoto(tFile);

        expect(result.isRight(), true);
        result.fold(
          (_) => fail('Should be Right'),
          (url) => expect(url, 'http://example.com/photo.jpg'),
        );
      },
    );

    test('should return Left(NetworkFailure) when offline', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.uploadPhoto(tFile);

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should be Left'),
      );
    });
  });
}
