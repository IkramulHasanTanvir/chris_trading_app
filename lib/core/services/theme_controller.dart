import 'package:flutter/material.dart';
import 'package:flutter_task/core/services/storage_service.dart';
import 'package:get/get.dart';

/// Persists theme preference so it survives app updates / restarts.
class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _isDarkMode = true.obs;
  bool get isDarkMode => _isDarkMode.value;
  ThemeMode get themeMode =>
      _isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  @override
  void onInit() {
    super.onInit();
    _load();
  }

  void _load() {
    try {
      if (!Get.isRegistered<StorageService>()) return;
      final stored = Get.find<StorageService>().getBool(StorageKeys.isDarkMode);
      // App default is dark; only override when user explicitly saved a value.
      _isDarkMode.value = stored ?? true;
    } catch (_) {
      _isDarkMode.value = true;
    }
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode.value = value;
    try {
      if (Get.isRegistered<StorageService>()) {
        await Get.find<StorageService>().setBool(StorageKeys.isDarkMode, value);
      }
    } catch (_) {}
  }

  Future<void> toggle() => setDarkMode(!_isDarkMode.value);
}
