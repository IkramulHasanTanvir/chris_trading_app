import 'package:get/get.dart';
import '../services/api_service.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';
import '../services/storage_service.dart';

class DependencyInjection {
  DependencyInjection._();

  static Future<void> init() async {
    // ─────────────────────────────
    // 1. Connectivity Service
    // ─────────────────────────────
    final connectivityService = ConnectivityService();
    Get.put<ConnectivityService>(connectivityService, permanent: true);
    connectivityService.listenAndNotify();

    // ─────────────────────────────
    // 2. API Service
    // ─────────────────────────────
    final apiService = ApiService();
    apiService.init(connectivityService);
    Get.put<ApiService>(apiService, permanent: true);

    // ─────────────────────────────
    // 3. Cache Service
    // ─────────────────────────────
    Get.put<CacheService>(CacheService(), permanent: true);

    // ─────────────────────────────
    // 4. Storage Service (ASYNC SAFE)
    // ─────────────────────────────
    await Get.putAsync<StorageService>(() async {
      final storage = StorageService();
      await storage.init();
      return storage;
    });
  }

  // ─────────────────────────────
  // GLOBAL CLEANUP (logout etc.)
  // ─────────────────────────────
  static void clear() {
    Get.deleteAll(force: true);
  }
}
