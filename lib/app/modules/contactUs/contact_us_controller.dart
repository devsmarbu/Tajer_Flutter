import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/account_api_client.dart';
import 'package:tajer/app/modules/change_phone_number/change_phone_controller.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/common_data.dart';
import '../../../common/functions/app_function.dart';
import '../../../common/widgets/app_dialog.dart';
import '../../../utils/base_response.dart';

class ContactUsController extends GetxController
    with AccountApiClient, AppLoader {
  // --- Text Controllers ---
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final messageController = TextEditingController();

  // --- Reactive Variables ---
  var isAgreed = false.obs;
  var selectedCountryCode = "+91".obs; // default India

  // --- Reactive Error Strings ---
  final nameError = ''.obs;
  final emailError = ''.obs;
  final phoneError = ''.obs;
  final messageError = ''.obs;
  final agreeError = ''.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    selectedCountryCode.value = getDialCodeFromISO(getDeviceISO());
  }

  /// --- Validation Methods ---
  void validateName(String value) {
    nameError.value = value.trim().isEmpty ? "APP_PLEASE_ENTER_YOUR_NAME".tr : "";
  }

  void validateEmail(String value) {
    if (value.trim().isEmpty) {
      emailError.value = "Please enter your email";
    } else if (!GetUtils.isEmail(value.trim())) {
      emailError.value = "Please enter a valid email address";
    } else {
      emailError.value = "";
    }
  }

  void validatePhone(String value) {
    if (value.trim().isEmpty) {
      phoneError.value = "Please enter your phone number";
    } else if (value.trim().length < 6) {
      phoneError.value = "Please enter a valid phone number";
    } else {
      phoneError.value = "";
    }
  }

  void validateMessage(String value) {
    messageError.value = value.trim().isEmpty ? "Please enter your message" : "";
  }

  void validateAgreement(bool value) {
    agreeError.value =
    value ? "" : "You must agree to the Terms & Conditions";
  }

  /// --- Submit Handler ---
  void submitForm() {
    validateName(nameController.text);
    validateEmail(emailController.text);
    validatePhone(phoneController.text);
  //  validateMessage(messageController.text);
    validateAgreement(isAgreed.value);

    // Check for any remaining errors
    if (nameError.value.isNotEmpty ||
        emailError.value.isNotEmpty ||
        phoneError.value.isNotEmpty ||
        messageError.value.isNotEmpty ||
        agreeError.value.isNotEmpty) {
      Get.snackbar("Error", "Please fix all highlighted errors",
          snackPosition: SnackPosition.BOTTOM);
      return;
    }

    contactUs();
  }

  void toggleAgreement(bool? value) {
    isAgreed.value = value ?? false;
    validateAgreement(isAgreed.value);
  }

  Future<void> contactUs() async {

    if(await AppFunction.isInternetAvailable()){
      try {
        showLoader(Get.context!);

        final response =await contactUsApi(nameController.text,emailController.text,phoneController.text,selectedCountryCode.value,messageController.text,"1");

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final responseData = BaseResponse<CommonData>.fromJson(
          body,
          fromJsonT: (data) => CommonData.fromJson(data),
        );

        hideLoader(Get.context!);
        AppDialog.showMessage(responseData.msg);

      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
        // errorMessage.value = e.toString();
      } finally {
        hideLoader(Get.context!);
      }
    }

  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
