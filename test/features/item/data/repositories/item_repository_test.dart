import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/item/data/datasources/local/item_local_datasource.dart';
import 'package:lost_n_found/features/item/data/datasources/remote/item_remote_datasource.dart';
import 'package:lost_n_found/features/item/data/models/item_api_model.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';
import 'package:lost_n_found/features/item/data/repositories/item_repository.dart';
import 'package:lost_n_found/features/item/domain/entities/item_entity.dart';
import 'package:mocktail/mocktail.dart';

class MockItemLocalDatasource extends Mock implements ItemLocalDatasource {}

class MockItemRemoteDatasource extends Mock implements ItemRemoteDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockFile extends Mock implements File {}

void main() {
  late ItemRepository repository;
  late MockItemLocalDatasource mockLocalDatasource;
  late MockItemRemoteDatasource mockRemoteDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockLocalDatasource = MockItemLocalDatasource();
    mockRemoteDatasource = MockItemRemoteDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = ItemRepository(
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  setUpAll(() {
    registerFallbackValue(
      ItemApiModel(
        itemName: 'Test',
        type: 'lost',
        location: 'Test Location',
      ),
    );
    registerFallbackValue(
      ItemHiveModel(
        itemName: 'Test',
        type: 'lost',
        location: 'Test Location',
      ),
    );
    registerFallbackValue(<ItemHiveModel>[]);
  });

  const tItemEntity = ItemEntity(
    itemId: '1',
    reportedBy: 'user1',
    category: 'electronics',
    itemName: 'Test Item',
    description: 'Test Description',
    type: ItemType.lost,
    location: 'Test Location',
  );

  final tItemApiModel = ItemApiModel(
    id: '1',
    reportedBy: 'user1',
    category: 'electronics',
    itemName: 'Test Item',
    description: 'Test Description',
    type: 'lost',
    location: 'Test Location',
  );

  final tItemHiveModel = ItemHiveModel(
    itemId: '1',
    reportedBy: 'user1',
    category: 'electronics',
    itemName: 'Test Item',
    description: 'Test Description',
    type: 'lost',
    location: 'Test Location',
  );

  final tItemApiModelList = [
    ItemApiModel(
      id: '1',
      itemName: 'Lost Phone',
      type: 'lost',
      location: 'Library',
    ),
    ItemApiModel(
      id: '2',
      itemName: 'Found Keys',
      type: 'found',
      location: 'Cafeteria',
    ),
  ];

  final tItemHiveModelList = [
    ItemHiveModel(
      itemId: '1',
      itemName: 'Lost Phone',
      type: 'lost',
      location: 'Library',
    ),
    ItemHiveModel(
      itemId: '2',
      itemName: 'Found Keys',
      type: 'found',
      location: 'Cafeteria',
    ),
  ];

  group('createItem', () {
    test('should return Right(true) when online and remote call succeeds',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.createItem(any()))
          .thenAnswer((_) async => tItemApiModel);

      // Act
      final result = await repository.createItem(tItemEntity);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRemoteDatasource.createItem(any())).called(1);
      verifyNever(() => mockLocalDatasource.createItem(any()));
    });

    test('should return Left(ApiFailure) when online and remote call fails',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.createItem(any()))
          .thenThrow(Exception('API Error'));

      // Act
      final result = await repository.createItem(tItemEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (_) => fail('Should return failure'),
      );
    });

    test('should return Left(NetworkFailure) when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.createItem(tItemEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should return failure'),
      );
      verifyNever(() => mockRemoteDatasource.createItem(any()));
    });
  });

  group('getAllItems', () {
    test(
        'should return remote data and cache it locally when online and remote call succeeds',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getAllItems())
          .thenAnswer((_) async => tItemApiModelList);
      when(() => mockLocalDatasource.cacheAllItems(any()))
          .thenAnswer((_) async {});

      // Act
      final result = await repository.getAllItems();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return data'),
        (items) {
          expect(items.length, 2);
          expect(items[0].itemName, 'Lost Phone');
        },
      );
      verify(() => mockRemoteDatasource.getAllItems()).called(1);
      verify(() => mockLocalDatasource.cacheAllItems(any())).called(1);
    });

    test(
        'should return cached data when online but remote call fails', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getAllItems())
          .thenThrow(Exception('API Error'));
      when(() => mockLocalDatasource.getAllItems())
          .thenAnswer((_) async => tItemHiveModelList);

      // Act
      final result = await repository.getAllItems();

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return cached data'),
        (items) => expect(items.length, 2),
      );
    });

    test('should return cached data when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getAllItems())
          .thenAnswer((_) async => tItemHiveModelList);

      // Act
      final result = await repository.getAllItems();

      // Assert
      expect(result.isRight(), true);
      verifyNever(() => mockRemoteDatasource.getAllItems());
      verify(() => mockLocalDatasource.getAllItems()).called(1);
    });

    test(
        'should return Left(LocalDatabaseFailure) when offline and local call fails',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getAllItems())
          .thenThrow(Exception('Database Error'));

      // Act
      final result = await repository.getAllItems();

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('getItemById', () {
    test('should return item from remote when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getItemById('1'))
          .thenAnswer((_) async => tItemApiModel);

      // Act
      final result = await repository.getItemById('1');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return item'),
        (item) => expect(item.itemName, 'Test Item'),
      );
    });

    test('should return Left(ApiFailure) when online and remote call fails',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getItemById('1'))
          .thenThrow(Exception('API Error'));

      // Act
      final result = await repository.getItemById('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (_) => fail('Should return failure'),
      );
    });

    test('should return item from local when offline and item exists',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getItemById('1'))
          .thenAnswer((_) async => tItemHiveModel);

      // Act
      final result = await repository.getItemById('1');

      // Assert
      expect(result.isRight(), true);
      verifyNever(() => mockRemoteDatasource.getItemById(any()));
    });

    test(
        'should return Left(LocalDatabaseFailure) when offline and item not found',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getItemById('1'))
          .thenAnswer((_) async => null);

      // Act
      final result = await repository.getItemById('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('getItemsByUser', () {
    test('should return items from remote when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getItemsByUser('user1'))
          .thenAnswer((_) async => [tItemApiModel]);

      // Act
      final result = await repository.getItemsByUser('user1');

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return items'),
        (items) => expect(items.length, 1),
      );
    });

    test('should return items from local when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getItemsByUser('user1'))
          .thenAnswer((_) async => [tItemHiveModel]);

      // Act
      final result = await repository.getItemsByUser('user1');

      // Assert
      expect(result.isRight(), true);
      verifyNever(() => mockRemoteDatasource.getItemsByUser(any()));
    });
  });

  group('getLostItems', () {
    test('should return lost items from remote when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getLostItems())
          .thenAnswer((_) async => [tItemApiModel]);

      // Act
      final result = await repository.getLostItems();

      // Assert
      expect(result.isRight(), true);
    });

    test('should return lost items from local when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getLostItems())
          .thenAnswer((_) async => [tItemHiveModel]);

      // Act
      final result = await repository.getLostItems();

      // Assert
      expect(result.isRight(), true);
      verifyNever(() => mockRemoteDatasource.getLostItems());
    });
  });

  group('getFoundItems', () {
    test('should return found items from remote when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getFoundItems())
          .thenAnswer((_) async => [tItemApiModelList[1]]);

      // Act
      final result = await repository.getFoundItems();

      // Assert
      expect(result.isRight(), true);
    });

    test('should return found items from local when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getFoundItems())
          .thenAnswer((_) async => [tItemHiveModelList[1]]);

      // Act
      final result = await repository.getFoundItems();

      // Assert
      expect(result.isRight(), true);
      verifyNever(() => mockRemoteDatasource.getFoundItems());
    });
  });

  group('getItemsByCategory', () {
    test('should return items from remote when online', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getItemsByCategory('electronics'))
          .thenAnswer((_) async => [tItemApiModel]);

      // Act
      final result = await repository.getItemsByCategory('electronics');

      // Assert
      expect(result.isRight(), true);
    });

    test('should return items from local when offline', () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.getItemsByCategory('electronics'))
          .thenAnswer((_) async => [tItemHiveModel]);

      // Act
      final result = await repository.getItemsByCategory('electronics');

      // Assert
      expect(result.isRight(), true);
      verifyNever(() => mockRemoteDatasource.getItemsByCategory(any()));
    });
  });

  group('updateItem', () {
    test('should return Right(true) when online and remote call succeeds',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.updateItem(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.updateItem(tItemEntity);

      // Assert
      expect(result, const Right(true));
      verify(() => mockRemoteDatasource.updateItem(any())).called(1);
    });

    test('should return Left(ApiFailure) when online and remote call fails',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.updateItem(any()))
          .thenThrow(Exception('API Error'));

      // Act
      final result = await repository.updateItem(tItemEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (_) => fail('Should return failure'),
      );
    });

    test('should update locally when offline and local call succeeds',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.updateItem(any()))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.updateItem(tItemEntity);

      // Assert
      expect(result, const Right(true));
      verifyNever(() => mockRemoteDatasource.updateItem(any()));
      verify(() => mockLocalDatasource.updateItem(any())).called(1);
    });

    test(
        'should return Left(LocalDatabaseFailure) when offline and local call fails',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.updateItem(any()))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.updateItem(tItemEntity);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('deleteItem', () {
    test('should return Right(true) when online and remote call succeeds',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.deleteItem('1'))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.deleteItem('1');

      // Assert
      expect(result, const Right(true));
      verify(() => mockRemoteDatasource.deleteItem('1')).called(1);
    });

    test('should return Left(ApiFailure) when online and remote call fails',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.deleteItem('1'))
          .thenThrow(Exception('API Error'));

      // Act
      final result = await repository.deleteItem('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (_) => fail('Should return failure'),
      );
    });

    test('should delete locally when offline and local call succeeds',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.deleteItem('1'))
          .thenAnswer((_) async => true);

      // Act
      final result = await repository.deleteItem('1');

      // Assert
      expect(result, const Right(true));
      verifyNever(() => mockRemoteDatasource.deleteItem(any()));
      verify(() => mockLocalDatasource.deleteItem('1')).called(1);
    });

    test(
        'should return Left(LocalDatabaseFailure) when offline and local call fails',
        () async {
      // Arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      when(() => mockLocalDatasource.deleteItem('1'))
          .thenAnswer((_) async => false);

      // Act
      final result = await repository.deleteItem('1');

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<LocalDatabaseFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('uploadPhoto', () {
    test('should return photo URL when online and upload succeeds', () async {
      // Arrange
      final mockFile = MockFile();
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.uploadPhoto(mockFile))
          .thenAnswer((_) async => 'https://example.com/photo.jpg');

      // Act
      final result = await repository.uploadPhoto(mockFile);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return URL'),
        (url) => expect(url, 'https://example.com/photo.jpg'),
      );
    });

    test('should return Left(ApiFailure) when online and upload fails',
        () async {
      // Arrange
      final mockFile = MockFile();
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.uploadPhoto(mockFile))
          .thenThrow(Exception('Upload Error'));

      // Act
      final result = await repository.uploadPhoto(mockFile);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (_) => fail('Should return failure'),
      );
    });

    test('should return Left(NetworkFailure) when offline', () async {
      // Arrange
      final mockFile = MockFile();
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.uploadPhoto(mockFile);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });

  group('uploadVideo', () {
    test('should return video URL when online and upload succeeds', () async {
      // Arrange
      final mockFile = MockFile();
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.uploadVideo(mockFile))
          .thenAnswer((_) async => 'https://example.com/video.mp4');

      // Act
      final result = await repository.uploadVideo(mockFile);

      // Assert
      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should return URL'),
        (url) => expect(url, 'https://example.com/video.mp4'),
      );
    });

    test('should return Left(ApiFailure) when online and upload fails',
        () async {
      // Arrange
      final mockFile = MockFile();
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.uploadVideo(mockFile))
          .thenThrow(Exception('Upload Error'));

      // Act
      final result = await repository.uploadVideo(mockFile);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<ApiFailure>()),
        (_) => fail('Should return failure'),
      );
    });

    test('should return Left(NetworkFailure) when offline', () async {
      // Arrange
      final mockFile = MockFile();
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      // Act
      final result = await repository.uploadVideo(mockFile);

      // Assert
      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('Should return failure'),
      );
    });
  });
}
