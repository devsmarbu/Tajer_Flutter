import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';

import '../../../common/widgets/app_dialog.dart';
import '../../../utils/app_loader.dart';
import '../../../utils/base_response.dart';
import '../../../utils/common_data.dart';
import '../../core/constants/app_constants.dart';
import '../../data/service/account_api_client.dart';

class ChangePasswordController extends GetxController with AccountApiClient,AppLoader {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable error texts
  var currentPasswordError = ''.obs;
  var newPasswordError = ''.obs;
  var confirmPasswordError = ''.obs;

  @override
  void onInit() {
    super.onInit();

    // 👇 Clear errors live when user types
    currentPasswordController.addListener(() {
      if (currentPasswordError.isNotEmpty) currentPasswordError.value = '';
    });

    newPasswordController.addListener(() {
      if (newPasswordError.isNotEmpty) newPasswordError.value = '';
    });

    confirmPasswordController.addListener(() {
      if (confirmPasswordError.isNotEmpty) confirmPasswordError.value = '';
    });
  }

  /// ✅ Validate all fields before submission
  bool validateForm() {
    bool isValid = true;

    // Reset errors
    currentPasswordError.value = '';
    newPasswordError.value = '';
    confirmPasswordError.value = '';

    // Current password validation
    if (currentPasswordController.text.trim().isEmpty) {
      currentPasswordError.value = AppStrings.appPleaseEnterYourCurrentPassword.tr;
      isValid = false;
    }

    // New password validation
    if (newPasswordController.text.trim().isEmpty) {
      newPasswordError.value = AppStrings.appEnterYourNewPassword.tr;
      isValid = false;
    } else if (newPasswordController.text.length < 8) {
      newPasswordError.value = AppStrings.pleaseMustBe6Character.tr;
      isValid = false;
    }

    // Confirm password validation
    if (confirmPasswordController.text.trim().isEmpty) {
      confirmPasswordError.value = AppStrings.pleaseEnterConfirmPassword.tr;
      isValid = false;
    } else if (confirmPasswordController.text != newPasswordController.text) {
      confirmPasswordError.value = AppStrings.confirmPasswordDoesNotMatch.tr;
      isValid = false;
    }

    return isValid;
  }

  /// ✅ Mock function to simulate password update
  void updatePassword() {
    if (validateForm()) {
      onSubmit();
    }
  }

  /// Validate and submit the request
  void onSubmit() async {

    try {
      showLoader(Get.context!);

      final response = await updatePasswordApi(
          currentPasswordController.text.trim(),
          newPasswordController.text.trim(),
          confirmPasswordController.text.trim()
      );

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final apiResponse = BaseResponse<CommonData>.fromJson(
        body,
        fromJsonT: (data) => CommonData.fromJson(data),
      );

      hideLoader(Get.context!);

      if (apiResponse.responseCode == "200") {
        if (apiResponse.status == AppConstants.SUCCESS) {
          Get.snackbar(AppConstants.appName, apiResponse.msg);
        } else {
          AppDialog.showMessage(apiResponse.msg);
        }
      } else {
        AppDialog.showMessage(apiResponse.msg);
      }
    } catch (e) {
      hideLoader(Get.context!);
      AppDialog.showMessage("An error occurred. Please try again.");
    }


  }

  @override
  void onClose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}