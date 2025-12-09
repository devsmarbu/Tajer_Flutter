import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/base_response.dart';
import '../../../core/constants/app_constants.dart';
import '../../../data/service/authentication_api_client.dart';
import '../login/login_data.dart';

class ForgotPasswordController extends GetxController{

  final _apiClient = AuthenticationApiClient();
  late RxBool isEmail = true.obs;
  ForgotPasswordController({required this.isEmail});

  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  final emailError = ''.obs;
  final phoneError = ''.obs;
  final isFormValid = false.obs;
  final selectedCountryCode = "+91".obs;
  final isLoading = false.obs;

  void validateEmail(String value) {

    emailError.value = "";

    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      emailError.value = AppStrings.emailCanNotBeEmpty.tr;
    } else if (!GetUtils.isEmail(trimmed)) {
      emailError.value = "Please enter valid email address";
    }

    checkFormValid();
  }

  void validatePhone(String value) {
    if (value.trim().length < 10) {
      phoneError.value = "Please enter valid phone number";
    } else {
      phoneError.value = "";
    }
    checkFormValid();
  }

  void checkFormValid() {
    if (isEmail.value) {
      isFormValid.value =
          emailError.isEmpty &&
              emailController.text.isNotEmpty;
    } else {
      isFormValid.value =
          phoneError.isEmpty &&
              phoneController.text.isNotEmpty;
    }
  }

  void togglePhoneEmail() {
    isEmail.value ? isEmail.value=false:isEmail.value=true;
  }

  void proceed(){
    if (isEmail.value) {
      validateEmail(emailController.text);
      if (emailError.value.isNotEmpty) return;
    } else {
      validatePhone(phoneController.text);
      if (phoneError.value.isNotEmpty) return;
    }

    if (!isFormValid.value) return;

    forgotPassword(Get.context);
  }

  Future<void> forgotPassword(BuildContext? context) async {
    try {
      isLoading.value = true;
      final response =await _apiClient.forgotPassword(emailController.text,0,"","","");

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final common = BaseResponse<LoginData>.fromJson(
        body,
        fromJsonT: (data) => LoginData.fromJson(data),
      );

      if(common.responseCode=="200"){

        if(common.status==AppConstants.SUCCESS){
          AppDialog.showMessage(common.msg);
        }
        else{
          AppDialog.showMessage(common.msg);
        }

      }else{
        AppDialog.showMessage(common.msg);

      }

    } catch (e) {
      print('❌ Exception in fetchSplashScreenData: $e');
      //errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }


}