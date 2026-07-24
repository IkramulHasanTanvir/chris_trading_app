import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      _isDarkMode.value = stored ?? true;
      _applySystemUi();
    } catch (_) {
      _isDarkMode.value = true;
    }
  }

  void _applySystemUi() {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            _isDarkMode.value ? Brightness.light : Brightness.dark,
        statusBarBrightness:
            _isDarkMode.value ? Brightness.dark : Brightness.light,
        systemNavigationBarColor:
            _isDarkMode.value ? const Color(0xFF191826) : Colors.white,
        systemNavigationBarIconBrightness:
            _isDarkMode.value ? Brightness.light : Brightness.dark,
      ),
    );
  }

  Future<void> setDarkMode(bool value) async {
    _isDarkMode.value = value;
    _applySystemUi();
    Get.changeThemeMode(value ? ThemeMode.dark : ThemeMode.light);
    // Force every screen using AppColors getters to rebuild.
    Get.forceAppUpdate();
    try {
      if (Get.isRegistered<StorageService>()) {
        await Get.find<StorageService>().setBool(StorageKeys.isDarkMode, value);
      }
    } catch (_) {}
  }

  Future<void> toggle() => setDarkMode(!_isDarkMode.value);
}
