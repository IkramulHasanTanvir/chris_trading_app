import 'dart:io';

import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/features/profile/data/models/badge_model.dart';
import 'package:flutter_task/features/profile/data/models/user_response_model.dart';
import 'package:flutter_task/features/profile/data/repositories/profile_repository.dart';

class ProfileService {
  final ProfileRepository _repository;

  ProfileService({required ProfileRepository repository})
      : _repository = repository;

  
  Future<void> fetchAllProfileData() async {
    try {
      await Future.wait([
        _repository.getUserData(),
        _repository.getBadge(),
      ]);
    } on AppException {
      if (!hasCache()) {
        rethrow;
      }
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> updateProfile({
     String? name,
     String? imageUrl,
    String? referral,
  }) async {
    try {
      await _repository.updateProfile(name, imageUrl,referral);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }


  Future<String> uploadImage(File file) async {
    try {
      return await _repository.uploadImage(file);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  Future<void> deleteUser(String userID) async{
    try {
      await _repository.deleteUser(userID);
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }}

  bool hasCache() {
    return _repository.hasCache();
  }

  ProfileScreenData getCachedData() {
    return ProfileScreenData(
      badge: _repository.getCachedBadge(),
      user: _repository.getCachedUserData(),
    );
  }
}

class ProfileScreenData {
  final BadgeModel? badge;
  final UserResponseModel? user;

  ProfileScreenData({
    required this.badge,
    required this.user,
  });
}
