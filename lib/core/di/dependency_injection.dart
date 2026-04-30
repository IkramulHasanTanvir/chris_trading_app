import 'package:flutter_task/features/auth/data/repositories/auth_repository.dart';
import 'package:flutter_task/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_task/features/auth/domain/services/auth_services.dart';
import 'package:flutter_task/features/auth/presentation/controller/auth_controller.dart';
import 'package:flutter_task/features/profile/data/repositories/profile_repository.dart';
import 'package:flutter_task/features/profile/domain/services/profile_services.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
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


    // ─────────────────────────────
    // 3. Cache Service
    // ─────────────────────────────
    Get.put<CacheService>(CacheService(), permanent: true);


    // ─────────────────────────────
    // 2. API Service
    // ─────────────────────────────
    final apiService = ApiService();
    apiService.init(connectivityService, Get.find<CacheService>());
    Get.put<ApiService>(apiService, permanent: true);


    // ─────────────────────────────
    // 4. Storage Service (ASYNC SAFE)
    // ─────────────────────────────
    await Get.putAsync<StorageService>(() async {
      final storage = StorageService();
      await storage.init();
      return storage;
    });

    // ✅ Auth — permanent
    Get.put<AuthRepository>(
      AuthRepositoryImpl(
        apiService: Get.find<ApiService>(),
        cacheService: Get.find<CacheService>(),
      ),
      permanent: true,
    );

    Get.put<AuthService>(
      AuthService(repository: Get.find<AuthRepository>()),
      permanent: true,
    );

    Get.put<AuthController>(
      AuthController(authService: Get.find<AuthService>()),
      permanent: true,
    );

    Get.lazyPut<ProfileRepository>(
          () => ProfileRepository(
        apiService: Get.find<ApiService>(),
        cacheService: Get.find<CacheService>(),
      ),
      fenix: true,
    );

    Get.lazyPut<ProfileService>(
          () => ProfileService(repository: Get.find<ProfileRepository>()),
      fenix: true,
    );

    Get.lazyPut<ProfileController>(
          () => ProfileController(service: Get.find<ProfileService>()),
      fenix: true,
    );
  }

  // ─────────────────────────────
  // GLOBAL CLEANUP (logout etc.)
  // ─────────────────────────────
  static void clear() {
    Get.deleteAll(force: true);
  }
}
