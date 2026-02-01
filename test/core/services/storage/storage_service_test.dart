import 'package:flutter_test/flutter_test.dart';
import 'package:lost_n_found/core/services/storage/storage_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late StorageService storageService;
  late MockSharedPreferences mockPrefs;

  setUp(() {
    mockPrefs = MockSharedPreferences();
    storageService = StorageService(prefs: mockPrefs);
  });

  const tKey = 'test_key';

  group('StorageService', () {
    group('String operations', () {
      const tStringValue = 'test_value';

      test('setString should save string value', () async {
        // Arrange
        when(() => mockPrefs.setString(tKey, tStringValue))
            .thenAnswer((_) async => true);

        // Act
        final result = await storageService.setString(tKey, tStringValue);

        // Assert
        expect(result, true);
        verify(() => mockPrefs.setString(tKey, tStringValue)).called(1);
      });

      test('getString should return string value when it exists', () {
        // Arrange
        when(() => mockPrefs.getString(tKey)).thenReturn(tStringValue);

        // Act
        final result = storageService.getString(tKey);

        // Assert
        expect(result, tStringValue);
        verify(() => mockPrefs.getString(tKey)).called(1);
      });

      test('getString should return null when key does not exist', () {
        // Arrange
        when(() => mockPrefs.getString(tKey)).thenReturn(null);

        // Act
        final result = storageService.getString(tKey);

        // Assert
        expect(result, isNull);
      });
    });

    group('Int operations', () {
      const tIntValue = 42;

      test('setInt should save int value', () async {
        // Arrange
        when(() => mockPrefs.setInt(tKey, tIntValue))
            .thenAnswer((_) async => true);

        // Act
        final result = await storageService.setInt(tKey, tIntValue);

        // Assert
        expect(result, true);
        verify(() => mockPrefs.setInt(tKey, tIntValue)).called(1);
      });

      test('getInt should return int value when it exists', () {
        // Arrange
        when(() => mockPrefs.getInt(tKey)).thenReturn(tIntValue);

        // Act
        final result = storageService.getInt(tKey);

        // Assert
        expect(result, tIntValue);
      });

      test('getInt should return null when key does not exist', () {
        // Arrange
        when(() => mockPrefs.getInt(tKey)).thenReturn(null);

        // Act
        final result = storageService.getInt(tKey);

        // Assert
        expect(result, isNull);
      });
    });

    group('Double operations', () {
      const tDoubleValue = 3.14;

      test('setDouble should save double value', () async {
        // Arrange
        when(() => mockPrefs.setDouble(tKey, tDoubleValue))
            .thenAnswer((_) async => true);

        // Act
        final result = await storageService.setDouble(tKey, tDoubleValue);

        // Assert
        expect(result, true);
        verify(() => mockPrefs.setDouble(tKey, tDoubleValue)).called(1);
      });

      test('getDouble should return double value when it exists', () {
        // Arrange
        when(() => mockPrefs.getDouble(tKey)).thenReturn(tDoubleValue);

        // Act
        final result = storageService.getDouble(tKey);

        // Assert
        expect(result, tDoubleValue);
      });

      test('getDouble should return null when key does not exist', () {
        // Arrange
        when(() => mockPrefs.getDouble(tKey)).thenReturn(null);

        // Act
        final result = storageService.getDouble(tKey);

        // Assert
        expect(result, isNull);
      });
    });

    group('Bool operations', () {
      const tBoolValue = true;

      test('setBool should save bool value', () async {
        // Arrange
        when(() => mockPrefs.setBool(tKey, tBoolValue))
            .thenAnswer((_) async => true);

        // Act
        final result = await storageService.setBool(tKey, tBoolValue);

        // Assert
        expect(result, true);
        verify(() => mockPrefs.setBool(tKey, tBoolValue)).called(1);
      });

      test('getBool should return bool value when it exists', () {
        // Arrange
        when(() => mockPrefs.getBool(tKey)).thenReturn(tBoolValue);

        // Act
        final result = storageService.getBool(tKey);

        // Assert
        expect(result, tBoolValue);
      });

      test('getBool should return null when key does not exist', () {
        // Arrange
        when(() => mockPrefs.getBool(tKey)).thenReturn(null);

        // Act
        final result = storageService.getBool(tKey);

        // Assert
        expect(result, isNull);
      });
    });

    group('StringList operations', () {
      final tStringList = ['item1', 'item2', 'item3'];

      test('setStringList should save string list', () async {
        // Arrange
        when(() => mockPrefs.setStringList(tKey, tStringList))
            .thenAnswer((_) async => true);

        // Act
        final result = await storageService.setStringList(tKey, tStringList);

        // Assert
        expect(result, true);
        verify(() => mockPrefs.setStringList(tKey, tStringList)).called(1);
      });

      test('getStringList should return list when it exists', () {
        // Arrange
        when(() => mockPrefs.getStringList(tKey)).thenReturn(tStringList);

        // Act
        final result = storageService.getStringList(tKey);

        // Assert
        expect(result, tStringList);
      });

      test('getStringList should return null when key does not exist', () {
        // Arrange
        when(() => mockPrefs.getStringList(tKey)).thenReturn(null);

        // Act
        final result = storageService.getStringList(tKey);

        // Assert
        expect(result, isNull);
      });

      test('setStringList should handle empty list', () async {
        // Arrange
        when(() => mockPrefs.setStringList(tKey, <String>[]))
            .thenAnswer((_) async => true);

        // Act
        final result = await storageService.setStringList(tKey, []);

        // Assert
        expect(result, true);
      });
    });

    group('remove', () {
      test('should remove key from SharedPreferences', () async {
        // Arrange
        when(() => mockPrefs.remove(tKey)).thenAnswer((_) async => true);

        // Act
        final result = await storageService.remove(tKey);

        // Assert
        expect(result, true);
        verify(() => mockPrefs.remove(tKey)).called(1);
      });
    });

    group('clear', () {
      test('should clear all SharedPreferences', () async {
        // Arrange
        when(() => mockPrefs.clear()).thenAnswer((_) async => true);

        // Act
        final result = await storageService.clear();

        // Assert
        expect(result, true);
        verify(() => mockPrefs.clear()).called(1);
      });
    });

    group('containsKey', () {
      test('should return true when key exists', () {
        // Arrange
        when(() => mockPrefs.containsKey(tKey)).thenReturn(true);

        // Act
        final result = storageService.containsKey(tKey);

        // Assert
        expect(result, true);
        verify(() => mockPrefs.containsKey(tKey)).called(1);
      });

      test('should return false when key does not exist', () {
        // Arrange
        when(() => mockPrefs.containsKey(tKey)).thenReturn(false);

        // Act
        final result = storageService.containsKey(tKey);

        // Assert
        expect(result, false);
      });
    });
  });
}
