import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/app_loader.dart';
import '../../../../utils/base_response.dart';
import '../../../../utils/common_data.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/service/account_api_client.dart';

class ChangeEmailController extends GetxController with AccountApiClient,AppLoader {
  // Text controllers
  final newEmailController = TextEditingController();
 // final confirmEmailController = TextEditingController();
  final passwordController = TextEditingController();

  final pref=PrefStore();

  // Reactive error messages
  final newEmailError = ''.obs;
 // final confirmEmailError = ''.obs;
  final passwordError = ''.obs;

  // Password visibility toggle
  final isPasswordVisible = false.obs;
  var isFormValid = false.obs;
  var isEmailSent = false.obs;

  // Form key
  final formKey = GlobalKey<FormState>();


  @override
  void onInit() {
    super.onInit();
    newEmailController.addListener(validateFormLive);
   // confirmEmailController.addListener(validateFormLive);
    passwordController.addListener(validateFormLive);
  }
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void validateFormLive() {
    final newEmail = newEmailController.text.trim();
 //   final confirmEmail = confirmEmailController.text.trim();
    final password = passwordController.text.trim();

    isFormValid.value =
        GetUtils.isEmail(newEmail) &&
           // (confirmEmail == newEmail && confirmEmail.isNotEmpty) &&
            password.isNotEmpty &&
            password.length >= 6;
  }

  void validateAndSubmit() {
    newEmailError.value = '';
   // confirmEmailError.value = '';
    passwordError.value = '';

    final newEmail = newEmailController.text.trim();
    //final confirmEmail = confirmEmailController.text.trim();
    final password = passwordController.text.trim();

    bool isValid = true;

    if (!GetUtils.isEmail(newEmail)) {
      newEmailError.value = 'Enter a valid email';
      isValid = false;
    }

    // if (confirmEmail != newEmail || confirmEmail.isEmpty) {
    //   confirmEmailError.value = 'Emails do not match';
    //   isValid = false;
    // }

    if (password.isEmpty || password.length < 6) {
      passwordError.value = 'Enter a valid password';
      isValid = false;
    }

    if (isValid) {
      onSubmit();
    }
  }

  /// Validate and submit the request
  void onSubmit() async {

    try {
      showLoader(Get.context!);

      final response = await changeEmailApi(
          newEmailController.text.trim(),
          newEmailController.text.trim(),
          passwordController.text.trim()
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
          // await pref.saveString(AppConstants.userEmail, newEmailController.text.trim());
          // Get.back();
          // await Future.delayed(const Duration(milliseconds: 300));
          isEmailSent.value=true;
         // Get.snackbar(AppConstants.appName, apiResponse.msg);
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
    newEmailController.dispose();
   // confirmEmailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
