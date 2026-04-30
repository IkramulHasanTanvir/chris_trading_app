import 'package:flutter/material.dart';
import 'package:flutter_task/core/enums/loading_state.dart';
import 'package:flutter_task/core/extensions/app_extension.dart';
import 'package:flutter_task/core/helpers/toast_message_helper.dart';
import 'package:flutter_task/core/routes/app_routes.dart';
import 'package:flutter_task/features/profile/presentation/controllers/profile_controller.dart';
import 'package:flutter_task/features/two_factor/data/models/two_factor_model.dart';
import 'package:flutter_task/features/two_factor/domain/services/two_factor_services.dart';
import 'package:get/get.dart';

class TwoFactorController extends GetxController {
  final TwoFactorService _service;

  static TwoFactorController get to => Get.find();

  TwoFactorController({required TwoFactorService service}) : _service = service;

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final codeController = TextEditingController();
  final globalKey = GlobalKey<FormState>();
  final codeGlobalKey = GlobalKey<FormState>();


  final _setUpState = LoadingState.initial.obs;
  final _verifyState = LoadingState.initial.obs;
  final _disableState = LoadingState.initial.obs;

  final _twoFactorData = Rxn<TwoFactorModel>();

  TwoFactorModel? get twoFactorData => _twoFactorData.value;

  LoadingState get setUpState => _setUpState.value;

  LoadingState get verifyState => _verifyState.value;

  LoadingState get disableState => _disableState.value;

  Future<void> setUpTwoFactor() async {
    if (!globalKey.currentState!.validate()) return;
    try {
      _setUpState.value = LoadingState.loading;
      final response = await _service.getTwoFactorSet(passwordController.text);
      _twoFactorData.value = response;
      _setUpState.value = LoadingState.loaded;
      Get.toNamed(AppRoutes.twoFactorAuthScreen);
    } catch (e) {
      _setUpState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }

  Future<void> verifyTwoFactor() async {
    if (!codeGlobalKey.currentState!.validate()) return;

    try {
      _verifyState.value = LoadingState.loading;
      await _service.enableTwoFactor(codeController.text);

      _verifyState.value = LoadingState.loaded;
      await ProfileController.to.loadData();
      Get.back(canPop: true);
      Get.back(canPop: true);
      ToastMessageHelper.show('Two factor authentication verified');
      _twoFactorData.value = null;
    } catch (e) {
      _verifyState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }



  Future<void> disableTwoFactor() async {
    if (!codeGlobalKey.currentState!.validate()) return;
    try {
      _disableState.value = LoadingState.loading;
      await _service.disableTwoFactor(codeController.text);

      _disableState.value = LoadingState.loaded;
      await ProfileController.to.loadData();
      Get.back(canPop: true);
      ToastMessageHelper.show('Two factor authentication disabled');
    } catch (e) {
      _disableState.value = LoadingState.error;
      ToastMessageHelper.show(e.errorMessage);
    }
  }
}
