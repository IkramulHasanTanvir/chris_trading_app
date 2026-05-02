import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/features/profile/data/models/user_response_model.dart';
import 'package:flutter_task/features/profile/domain/services/profile_services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController {
  final ProfileService _service;

  static ProfileController get to => Get.find();

  ProfileController({
    required ProfileService service,
  }) : _service = service;

  // ─── Controllers ─────────────────────────────────────────────────
  final nameController = TextEditingController();
  final emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;


  final RxString _imageUrl = ''.obs;
  final Rx<File?> _selectedImage = Rx<File?>(null);
  String get imageUrl => _imageUrl.value;
  File? get selectedImage => _selectedImage.value;


  // ─── State ────────────────────────────────────────────────────────
  final _loadingState = LoadingState.initial.obs;
  final _updateState = LoadingState.initial.obs;
  final _imageState = LoadingState.initial.obs;
  final _errorMessage = ''.obs;

  LoadingState get loadingState => _loadingState.value;

  LoadingState get updateState => _updateState.value;
  LoadingState get imageState => _imageState.value;


  String get errorMessage => _errorMessage.value;

  // ─── Data ─────────────────────────────────────────────────────────
  final _userData = Rxn<UserResponseModel>();

  UserResponseModel? get userData => _userData.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  // ─── Load Profile ─────────────────────────────────────────────────
  Future<void> loadData() async {
    try {
      _errorMessage.value = '';

      final hasCache = _service.hasCache();
      if (hasCache) {
        final cached = _service.getCachedData();
        _userData.value = cached;
        _populateControllers(cached);
        _loadingState.value = LoadingState.loaded;
      } else {
        _loadingState.value = LoadingState.loading;
      }

      final fresh = await _service.fetchUserData();
      _userData.value = fresh;
      _populateControllers(fresh);
      _loadingState.value = LoadingState.loaded;
    } catch (e) {
      if (!_service.hasCache()) {
        _loadingState.value = LoadingState.error;
        _errorMessage.value = e.errorMessage;
      }
    }
  }

  void _populateControllers(UserResponseModel? data) {
    if (data == null) return;
    nameController.text = data.name ?? '';
    emailController.text = data.email ?? '';
    _imageUrl.value = data.userProfileUrl ?? '';
  }

  Future<void> retry() async => await loadData();

  // ─── Update Profile ───────────────────────────────────────────────
  Future<void> updateProfile() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      _updateState.value = LoadingState.loading;

      await _service.updateProfile(
        name: nameController.text,
        imageUrl: _imageUrl.value,
      );

      _updateState.value = LoadingState.loaded;

      await loadData();
      Get.back(canPop: true);
      ToastMessageHelper.show('Profile updated successfully');

    } catch (e) {
      _updateState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }


  Future<void> onImagePicked(XFile file) async {
    if (file.path.isNotEmpty) {
      _selectedImage.value = File(file.path);
      await uploadImage();
    } else {
      print("Image path is empty!");
    }
  }
  Future<void> uploadImage() async {
    if(selectedImage == null) return;
    try{
      _imageState.value = LoadingState.loading;
      final imageUrl = await _service.uploadImage(selectedImage!);
      _imageState.value = LoadingState.loaded;
      _imageUrl.value = imageUrl;
    }catch(e){
      _imageState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    super.onClose();
  }
}
