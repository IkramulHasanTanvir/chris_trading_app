import 'package:hive_flutter/hive_flutter.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  static const String _boxName = 'appCache';
  Box? _box;

  Future<void> init() async {
    try {
      await Hive.initFlutter();
      _box = await Hive.openBox(_boxName);
    } catch (e) {
      // Offline / disk issues must not crash cold start.
      try {
        _box = await Hive.openBox(_boxName);
      } catch (_) {
        _box = null;
      }
    }
  }

  bool get isReady => _box != null && _box!.isOpen;

  Box get box {
    if (_box == null || !_box!.isOpen) {
      throw Exception('Cache service not initialized. Call init() first.');
    }
    return _box!;
  }

  Future<void> put(String key, dynamic value) async {
    if (!isReady) return;
    await box.put(key, value);
  }

  T? get<T>(String key, {T? defaultValue}) {
    if (!isReady) return defaultValue;
    try {
      return box.get(key, defaultValue: defaultValue) as T?;
    } catch (_) {
      return defaultValue;
    }
  }

  bool containsKey(String key) {
    if (!isReady) return false;
    try {
      return box.containsKey(key);
    } catch (_) {
      return false;
    }
  }

  Future<void> delete(String key) async {
    if (!isReady) return;
    await box.delete(key);
  }

  Future<void> clear() async {
    if (!isReady) return;
    await box.clear();
  }

  Future<void> dispose() async {
    await _box?.close();
    _box = null;
  }
}
