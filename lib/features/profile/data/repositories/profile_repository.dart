import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_task/core/constants/api_constants.dart';
import 'package:flutter_task/core/constants/app_constants.dart';
import 'package:flutter_task/core/exceptions/app_exceptions.dart';
import 'package:flutter_task/core/services/api_service.dart';
import 'package:flutter_task/core/services/cache_service.dart';
import 'package:flutter_task/features/profile/data/models/user_response_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfileRepository {
  final ApiService _apiService;
  final CacheService _cacheService;

  ProfileRepository({
    required ApiService apiService,
    required CacheService cacheService,
  }) : _apiService = apiService,
       _cacheService = cacheService;

  // ─── Profile Data ───────────────────────────────────────────────
  Future<UserResponseModel> getUserData() async {
    try {
      final response = await _apiService.get(ApiConstants.profile);
      final model = UserResponseModel.fromJson(
        response.data['data'] as Map<String, dynamic>,
      );
      await _cacheService.put(AppConstants.cacheUser, model.toJson());
      return model;
    } on AppException {
      final cached = getCachedUserData();
      if (cached != null) return cached;
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }

  UserResponseModel? getCachedUserData() {
    try {
      final json = _cacheService.get<Map<String, dynamic>>(
        AppConstants.cacheUser,
        defaultValue: null,
      );
      if (json == null) return null;
      return UserResponseModel.fromJson(json);
    } catch (e) {
      debugPrint('Error getting cached referral data: $e');
      return null;
    }
  }

  Future<void> updateProfile(String name, String imageUrl) async {
    try {
      await _apiService.patch(
        ApiConstants.profileUpdate,
        data: {"name": name, "userProfileUrl": imageUrl},
      );
      await getUserData();
    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }
  }


  Future<String> uploadImage(File file) async {

    final image = await MultipartFile.fromFile(file.path);
    try{
      final response = await _apiService.uploadFile(ApiConstants.imageUpload,file: image);
      return response.data['url'];

    } on AppException {
      rethrow;
    } catch (e) {
      throw UnknownException(e.toString());
    }

  }

  bool hasCache() {
    return _cacheService.containsKey(AppConstants.cacheUser);
  }


}
