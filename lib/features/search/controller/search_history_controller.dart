import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:get/get.dart';

class SearchHistoryController extends GetxController {
  SearchHistoryController({required CacheService cacheService})
      : _cacheService = cacheService;

  final CacheService _cacheService;

  static SearchHistoryController get to => Get.find();

  final int _maxItems = 10;

  final RxList<String> history = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadHistory();
  }

  void _loadHistory() {
    final saved = _cacheService.get<List>(
      AppConstants.searchHistoryKey,
      defaultValue: [],
    );
    history.assignAll(saved?.cast<String>() ?? []);
  }

  Future<void> addQuery(String query) async {
    final q = query.trim();
    if (q.isEmpty) return;

    history.remove(q);
    history.insert(0, q);
    if (history.length > _maxItems) {
      history.removeRange(_maxItems, history.length);
    }

    await _cacheService.put(AppConstants.searchHistoryKey, history.toList());
  }

  Future<void> removeQuery(String query) async {
    history.remove(query);
    await _cacheService.put(AppConstants.searchHistoryKey, history.toList());
  }

  Future<void> clearAll() async {
    history.clear();
    await _cacheService.delete(AppConstants.searchHistoryKey);
  }
}
