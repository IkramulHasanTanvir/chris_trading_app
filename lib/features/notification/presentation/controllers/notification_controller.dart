// import 'package:flutter/material.dart';
// import 'package:flutter_task/core/enums/loading_state.dart';
// import 'package:flutter_task/core/extensions/app_extension.dart';
// import 'package:flutter_task/core/helpers/toast_message_helper.dart';
// import 'package:flutter_task/features/profile/data/models/user_response_model.dart';
// import 'package:flutter_task/features/profile/domain/services/profile_services.dart';
// import 'package:get/get.dart';
//
// class ProfileController extends GetxController {
//   final ProfileService _service;
//
//   static ProfileController get to => Get.find();
//
//   ProfileController({required ProfileService service}) : _service = service;
//
//   // ─── Controllers ─────────────────────────────────────────────────
//   final nameController = TextEditingController();
//   final _formKey = GlobalKey<FormState>();
//   GlobalKey<FormState> get formKey => _formKey;
//
//   // ─── State ────────────────────────────────────────────────────────
//   final _loadingState = LoadingState.initial.obs;
//   final _updateState = LoadingState.initial.obs;
//   final _errorMessage = ''.obs;
//
//   LoadingState get loadingState => _loadingState.value;
//   LoadingState get updateState => _updateState.value;
//   String get errorMessage => _errorMessage.value;
//
//   // ─── Data ─────────────────────────────────────────────────────────
//   final _userData = Rxn<UserResponseModel>();
//   final _selectedImageUrl = ''.obs;
//
//   UserResponseModel? get userData => _userData.value;
//   String get selectedImageUrl => _selectedImageUrl.value;
//
//   // ─── Helper Methods ───────────────────────────────────────────────
//   void setImageUrl(String url) {
//     _selectedImageUrl.value = url;
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadData();
//   }
//
//   // ─── Load Profile ─────────────────────────────────────────────────
//   Future<void> loadData() async {
//     try {
//       _errorMessage.value = '';
//
//       final hasCache = _service.hasCache();
//       if (hasCache) {
//         final cached = _service.getCachedData();
//         _userData.value = cached;
//         _loadingState.value = LoadingState.loaded;
//       } else {
//         _loadingState.value = LoadingState.loading;
//       }
//
//       final fresh = await _service.fetchUserData();
//       _userData.value = fresh;
//       _populateFields(fresh);
//       _loadingState.value = LoadingState.loaded;
//     } catch (e) {
//       if (!_service.hasCache()) {
//         _loadingState.value = LoadingState.error;
//         _errorMessage.value = e.errorMessage;
//       }
//     }
//   }
//
//   void _populateFields(UserResponseModel user) {
//     nameController.text = user.name ?? '';
//     _selectedImageUrl.value = user.userProfileUrl ?? '';
//   }
//
//   Future<void> retry() async => await loadData();
//
//   // ─── Update Profile ───────────────────────────────────────────────
//   Future<void> updateProfile() async {
//     if (!_formKey.currentState!.validate()) return;
//     try {
//       _updateState.value = LoadingState.loading;
//
//       await _service.updateProfile(
//         name: nameController.text,
//         imageUrl: _selectedImageUrl.value,
//       );
//
//       _updateState.value = LoadingState.loaded;
//       ToastMessageHelper.show('Profile updated successfully');
//
//       await loadData();
//       Get.back(canPop: true);
//     } catch (e) {
//       _updateState.value = LoadingState.error;
//       ToastMessageHelper.show(e.errorMessage);
//     }
//   }
//
//   Future<void> uploadImage() async {
//
//   }
//
//   @override
//   void onClose() {
//     nameController.dispose();
//     super.onClose();
//   }
// }