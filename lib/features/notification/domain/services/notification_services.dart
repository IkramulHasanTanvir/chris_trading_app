// import 'dart:io';
//
// import 'package:flutter_task/core/exceptions/app_exceptions.dart';
// import 'package:flutter_task/features/profile/data/models/user_response_model.dart';
// import 'package:flutter_task/features/profile/data/repositories/profile_repository.dart';
//
// class ProfileService {
//   final ProfileRepository _repository;
//
//   ProfileService({required ProfileRepository repository})
//       : _repository = repository;
//
//   Future<UserResponseModel> fetchUserData() async {
//     try {
//       return await _repository.getUserData();
//     } on AppException {
//       final cached = _repository.getCachedUserData();
//       if (cached != null) return cached;
//       rethrow;
//     } catch (e) {
//       throw UnknownException(e.toString());
//     }
//   }
//
//   Future<void> updateProfile({
//     required String name,
//     required String imageUrl,
//   }) async {
//     try {
//       await _repository.updateProfile(name, imageUrl);
//     } on AppException {
//       rethrow;
//     } catch (e) {
//       throw UnknownException(e.toString());
//     }
//   }
//
//
//   Future<String> uploadImage(File file) async {
//     try {
//       return await _repository.uploadImage(file);
//     } on AppException {
//       rethrow;
//     } catch (e) {
//       throw UnknownException(e.toString());
//     }
//   }
//
//   bool hasCache() {
//     return _repository.hasCache();
//   }
//
//   UserResponseModel? getCachedData() {
//     return _repository.getCachedUserData();
//   }
// }