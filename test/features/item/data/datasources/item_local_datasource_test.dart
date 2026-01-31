import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/services/hive/hive_service.dart';
import 'package:lost_n_found/features/item/data/datasources/local/item_local_datasource.dart';
import 'package:lost_n_found/features/item/data/models/item_hive_model.dart';
import 'package:mocktail/mocktail.dart';

class MockHiveService extends Mock implements HiveService {}

void main() {
  late ItemLocalDatasource datasource;
  late MockHiveService mockHiveService;

  setUp(() {
    mockHiveService = MockHiveService();
    datasource = ItemLocalDatasource(hiveService: mockHiveService);
  });

  final tItemHiveModel = ItemHiveModel(
    itemId: '1',
    reportedBy: 'user1',
    category: 'electronics',
    itemName: 'Test Item',
    description: 'Test Description',
    type: 'lost',
    location: 'Test Location',
  );

  final tItemHiveModelList = [
    ItemHiveModel(
      itemId: '1',
      reportedBy: 'user1',
      itemName: 'Lost Phone',
      type: 'lost',
      location: 'Library',
    ),
    ItemHiveModel(
      itemId: '2',
      reportedBy: 'user2',
      itemName: 'Found Keys',
      type: 'found',
      location: 'Cafeteria',
    ),
  ];

  group('createItem', () {
    test('should return true when item is created successfully', () async {
      // Arrange
      when(() => mockHiveService.createItem(tItemHiveModel))
          .thenAnswer((_) async => tItemHiveModel);

      // Act
      final result = await datasource.createItem(tItemHiveModel);

      // Assert
      expect(result, true);
      verify(() => mockHiveService.createItem(tItemHiveModel)).called(1);
    });

    test('should return false when hive service throws exception', () async {
      // Arrange
      when(() => mockHiveService.createItem(tItemHiveModel))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.createItem(tItemHiveModel);

      // Assert
      expect(result, false);
    });
  });

  group('deleteItem', () {
    test('should return true when item is deleted successfully', () async {
      // Arrange
      when(() => mockHiveService.deleteItem('1')).thenAnswer((_) async {});

      // Act
      final result = await datasource.deleteItem('1');

      // Assert
      expect(result, true);
      verify(() => mockHiveService.deleteItem('1')).called(1);
    });

    test('should return false when hive service throws exception', () async {
      // Arrange
      when(() => mockHiveService.deleteItem('1'))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.deleteItem('1');

      // Assert
      expect(result, false);
    });
  });

  group('getAllItems', () {
    test('should return list of items when successful', () async {
      // Arrange
      when(() => mockHiveService.getAllItems()).thenReturn(tItemHiveModelList);

      // Act
      final result = await datasource.getAllItems();

      // Assert
      expect(result, tItemHiveModelList);
      expect(result.length, 2);
      verify(() => mockHiveService.getAllItems()).called(1);
    });

    test('should return empty list when hive service throws exception',
        () async {
      // Arrange
      when(() => mockHiveService.getAllItems())
          .thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.getAllItems();

      // Assert
      expect(result, isEmpty);
    });
  });

  group('getItemById', () {
    test('should return item when found', () async {
      // Arrange
      when(() => mockHiveService.getItemById('1')).thenReturn(tItemHiveModel);

      // Act
      final result = await datasource.getItemById('1');

      // Assert
      expect(result, tItemHiveModel);
      verify(() => mockHiveService.getItemById('1')).called(1);
    });

    test('should return null when item not found', () async {
      // Arrange
      when(() => mockHiveService.getItemById('999')).thenReturn(null);

      // Act
      final result = await datasource.getItemById('999');

      // Assert
      expect(result, isNull);
    });

    test('should return null when hive service throws exception', () async {
      // Arrange
      when(() => mockHiveService.getItemById('1'))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.getItemById('1');

      // Assert
      expect(result, isNull);
    });
  });

  group('getItemsByUser', () {
    test('should return list of items for user', () async {
      // Arrange
      final userItems = [tItemHiveModelList[0]];
      when(() => mockHiveService.getItemsByUser('user1')).thenReturn(userItems);

      // Act
      final result = await datasource.getItemsByUser('user1');

      // Assert
      expect(result, userItems);
      expect(result.length, 1);
      verify(() => mockHiveService.getItemsByUser('user1')).called(1);
    });

    test('should return empty list when hive service throws exception',
        () async {
      // Arrange
      when(() => mockHiveService.getItemsByUser('user1'))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.getItemsByUser('user1');

      // Assert
      expect(result, isEmpty);
    });
  });

  group('getLostItems', () {
    test('should return list of lost items', () async {
      // Arrange
      final lostItems = [tItemHiveModelList[0]];
      when(() => mockHiveService.getLostItems()).thenReturn(lostItems);

      // Act
      final result = await datasource.getLostItems();

      // Assert
      expect(result, lostItems);
      expect(result.length, 1);
      expect(result[0].type, 'lost');
      verify(() => mockHiveService.getLostItems()).called(1);
    });

    test('should return empty list when hive service throws exception',
        () async {
      // Arrange
      when(() => mockHiveService.getLostItems())
          .thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.getLostItems();

      // Assert
      expect(result, isEmpty);
    });
  });

  group('getFoundItems', () {
    test('should return list of found items', () async {
      // Arrange
      final foundItems = [tItemHiveModelList[1]];
      when(() => mockHiveService.getFoundItems()).thenReturn(foundItems);

      // Act
      final result = await datasource.getFoundItems();

      // Assert
      expect(result, foundItems);
      expect(result.length, 1);
      expect(result[0].type, 'found');
      verify(() => mockHiveService.getFoundItems()).called(1);
    });

    test('should return empty list when hive service throws exception',
        () async {
      // Arrange
      when(() => mockHiveService.getFoundItems())
          .thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.getFoundItems();

      // Assert
      expect(result, isEmpty);
    });
  });

  group('getItemsByCategory', () {
    test('should return list of items for category', () async {
      // Arrange
      when(() => mockHiveService.getItemsByCategory('electronics'))
          .thenReturn([tItemHiveModel]);

      // Act
      final result = await datasource.getItemsByCategory('electronics');

      // Assert
      expect(result.length, 1);
      verify(() => mockHiveService.getItemsByCategory('electronics')).called(1);
    });

    test('should return empty list when hive service throws exception',
        () async {
      // Arrange
      when(() => mockHiveService.getItemsByCategory('electronics'))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.getItemsByCategory('electronics');

      // Assert
      expect(result, isEmpty);
    });
  });

  group('updateItem', () {
    test('should return true when item is updated successfully', () async {
      // Arrange
      when(() => mockHiveService.updateItem(tItemHiveModel))
          .thenAnswer((_) async => true);

      // Act
      final result = await datasource.updateItem(tItemHiveModel);

      // Assert
      expect(result, true);
      verify(() => mockHiveService.updateItem(tItemHiveModel)).called(1);
    });

    test('should return true even when hive service returns false (no exception)',
        () async {
      // Note: The datasource implementation returns true if no exception is thrown,
      // regardless of HiveService.updateItem's return value. This is the actual behavior.
      // Arrange
      when(() => mockHiveService.updateItem(tItemHiveModel))
          .thenAnswer((_) async => false);

      // Act
      final result = await datasource.updateItem(tItemHiveModel);

      // Assert
      expect(result, true);
    });

    test('should return false when hive service throws exception', () async {
      // Arrange
      when(() => mockHiveService.updateItem(tItemHiveModel))
          .thenThrow(Exception('Database error'));

      // Act
      final result = await datasource.updateItem(tItemHiveModel);

      // Assert
      expect(result, false);
    });
  });

  group('cacheAllItems', () {
    test('should call hive service cacheAllItems', () async {
      // Arrange
      when(() => mockHiveService.cacheAllItems(tItemHiveModelList))
          .thenAnswer((_) async {});

      // Act
      await datasource.cacheAllItems(tItemHiveModelList);

      // Assert
      verify(() => mockHiveService.cacheAllItems(tItemHiveModelList)).called(1);
    });
  });
}
