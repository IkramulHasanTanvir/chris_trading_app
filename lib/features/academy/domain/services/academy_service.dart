import 'package:flutter_task/features/academy/data/models/academy_video_model.dart';
import 'package:flutter_task/features/academy/data/repositories/academy_repository.dart';

class AcademyService {
  final AcademyRepository _repository;

  AcademyService({required AcademyRepository repository})
      : _repository = repository;

  Future<List<AcademyCategory>> fetchCategories() {
    return _repository.getCategories();
  }

  Future<List<AcademyVideo>> fetchVideos({String? categoryId}) {
    return _repository.getVideos(categoryId: categoryId);
  }
}
