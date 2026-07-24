import 'package:flutter/foundation.dart';
import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/features/academy/data/models/academy_video_model.dart';

class AcademyRepository {
  final ApiService _apiService;

  AcademyRepository({required ApiService apiService})
      : _apiService = apiService;

  Future<List<AcademyCategory>> getCategories() async {
    try {
      final response = await _apiService.get(ApiConstants.academyCategories);
      final list = response.data['data'] as List? ?? [];
      return list
          .map((e) => AcademyCategory.fromJson(e as Map<String, dynamic>))
          .where((e) => e.id.isNotEmpty && e.name.isNotEmpty)
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Academy categories error: $e');
      throw UnknownException(e.toString());
    }
  }

  Future<List<AcademyVideo>> getVideos({String? categoryId}) async {
    try {
      final response = await _apiService.get(
        ApiConstants.academyVideos(categoryId: categoryId),
      );
      final list = response.data['data'] as List? ?? [];
      return list
          .map((e) => AcademyVideo.fromJson(e as Map<String, dynamic>))
          .where((e) => e.id.isNotEmpty && e.youtubeUrl.isNotEmpty)
          .toList();
    } on AppException {
      rethrow;
    } catch (e) {
      debugPrint('Academy videos error: $e');
      throw UnknownException(e.toString());
    }
  }
}
