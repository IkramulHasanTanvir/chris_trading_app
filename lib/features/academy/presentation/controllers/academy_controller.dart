import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/features/academy/data/models/academy_video_model.dart';
import 'package:flutter_task/features/academy/domain/services/academy_service.dart';
import 'package:get/get.dart';

class AcademyController extends GetxController {
  final AcademyService _service;

  AcademyController({required AcademyService service}) : _service = service;

  static AcademyController get to => Get.find();

  final _loadingState = LoadingState.initial.obs;
  final _errorMessage = ''.obs;
  final _categories = <AcademyCategory>[].obs;
  final _videos = <AcademyVideo>[].obs;
  final _allDemoVideos = <AcademyVideo>[];
  final _selectedCategoryId = ''.obs;
  bool _usingDemo = false;

  LoadingState get loadingState => _loadingState.value;
  String get errorMessage => _errorMessage.value;
  List<AcademyCategory> get categories => _categories;
  List<AcademyVideo> get videos => _videos;
  String get selectedCategoryId => _selectedCategoryId.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData({bool showLoader = true}) async {
    if (showLoader) _loadingState.value = LoadingState.loading;
    _errorMessage.value = '';
    try {
      final cats = await _service.fetchCategories();
      _usingDemo = false;
      _categories.assignAll(cats);

      if (_selectedCategoryId.value.isEmpty && cats.isNotEmpty) {
        _selectedCategoryId.value = cats.first.id;
      }

      await _loadVideos();
      _loadingState.value = LoadingState.loaded;
    } on AppException catch (e) {
      _errorMessage.value = e.message;
      _seedDemoContent();
      _loadingState.value = LoadingState.loaded;
    } catch (e) {
      _errorMessage.value = e.toString();
      _seedDemoContent();
      _loadingState.value = LoadingState.loaded;
    }
  }

  Future<void> selectCategory(String categoryId) async {
    if (_selectedCategoryId.value == categoryId) return;
    _selectedCategoryId.value = categoryId;

    if (_usingDemo) {
      _videos.assignAll(
        _allDemoVideos.where((v) => v.categoryId == categoryId).toList(),
      );
      return;
    }

    _loadingState.value = LoadingState.loading;
    try {
      await _loadVideos();
      _loadingState.value = LoadingState.loaded;
    } on AppException catch (e) {
      _errorMessage.value = e.message;
      _loadingState.value = LoadingState.error;
    } catch (e) {
      _errorMessage.value = e.toString();
      _loadingState.value = LoadingState.error;
    }
  }

  Future<void> _loadVideos() async {
    final categoryId = _selectedCategoryId.value.isEmpty
        ? null
        : _selectedCategoryId.value;
    final list = await _service.fetchVideos(categoryId: categoryId);
    _videos.assignAll(list);
  }

  void _seedDemoContent() {
    _usingDemo = true;
    _categories.assignAll(const [
      AcademyCategory(id: 'forex', name: 'Forex'),
      AcademyCategory(id: 'crypto', name: 'Crypto'),
      AcademyCategory(id: 'risk', name: 'Risk Management'),
    ]);
    _allDemoVideos
      ..clear()
      ..addAll(const [
        AcademyVideo(
          id: '1',
          title: 'Forex Basics for Beginners',
          description: 'Learn the fundamentals of forex trading.',
          categoryId: 'forex',
          categoryName: 'Forex',
          youtubeUrl: 'https://www.youtube.com/watch?v=aqz-KE-bpKQ',
        ),
        AcademyVideo(
          id: '2',
          title: 'Reading Price Action',
          description: 'Understand candles, structure, and setups.',
          categoryId: 'forex',
          categoryName: 'Forex',
          youtubeUrl: 'https://www.youtube.com/watch?v=iik25wqIuFo',
        ),
        AcademyVideo(
          id: '3',
          title: 'Crypto Market Structure',
          description: 'How crypto markets move and what to watch.',
          categoryId: 'crypto',
          categoryName: 'Crypto',
          youtubeUrl: 'https://www.youtube.com/watch?v=YB-8JEo_0bI',
        ),
        AcademyVideo(
          id: '4',
          title: 'Position Sizing & Risk',
          description: 'Protect your capital with proper risk rules.',
          categoryId: 'risk',
          categoryName: 'Risk Management',
          youtubeUrl: 'https://www.youtube.com/watch?v=GXz5agcO8vk',
        ),
      ]);
    _selectedCategoryId.value = 'forex';
    _videos.assignAll(
      _allDemoVideos.where((v) => v.categoryId == 'forex').toList(),
    );
  }
}
