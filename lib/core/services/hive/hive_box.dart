import 'package:hive/hive.dart';

class HiveBox<T extends HiveObject> {
  final String boxName;

  HiveBox(this.boxName);

  Box<T> get _box => Hive.box<T>(boxName);

  Future<T> put(String key, T value) async {
    await _box.put(key, value);
    return value;
  }

  T? get(String key) => _box.get(key);

  List<T> getAll() => _box.values.toList();

  List<T> where(bool Function(T) test) => _box.values.where(test).toList();

  T? firstWhere(bool Function(T) test) {
    for (final value in _box.values) {
      if (test(value)) return value;
    }
    return null;
  }

  Future<bool> update(String key, T value) async {
    if (!_box.containsKey(key)) return false;
    await _box.put(key, value);
    return true;
  }

  Future<void> delete(String key) => _box.delete(key);

  Future<void> replaceAll(Map<String, T> entries) async {
    await _box.clear();
    if (entries.isNotEmpty) {
      await _box.putAll(entries);
    }
  }
}
