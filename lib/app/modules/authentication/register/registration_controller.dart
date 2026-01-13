import 'dart:convert';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../common/functions/app_function.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/base_response.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/service/authentication_api_client.dart';
import '../login/login_data.dart';
import '../socialController/social_controller.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class RegistrationController extends GetxController {
  final pref = PrefStore();
  final _apiClient = AuthenticationApiClient();
  var errorMessage = ''.obs;
  final isCheckTerms = false.obs;
  final controllerSocial = Get.put(SocialController());

  // Controllers
  final nameController = TextEditingController();
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Error Observables
  final nameError = ''.obs;
  final userNameError = ''.obs;
  final emailError = ''.obs;
  final passwordError = ''.obs;
  final confirmPasswordError = ''.obs;

  // State
  final isLoading = false.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    passwordController.addListener(() {
      validatePasswordWhenTyping(passwordController.text);
    });
    confirmPasswordController.addListener(() {
      validateConfirmPasswordWhenTyping(confirmPasswordController.text);
    });
  }

  // Name Validation
  void validateName(String value) {
    nameError.value = "";
    if (value.trim().isEmpty) {
      nameError.value = AppStrings.pleaseEnterName.tr;
    }
    checkFormValid();
  }

  // Username Validation
  void validateUserName(String value) {
    userNameError.value = "";
    if (value.trim().isEmpty) {
      userNameError.value = AppStrings.pleaseEnterUserName.tr;
    }
    checkFormValid();
  }

  // Email Validation
  void validateEmail(String value) {
    emailError.value = "";
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      emailError.value = AppStrings.emailCanNotBeEmpty.tr;
    } else if (!GetUtils.isEmail(trimmed)) {
      emailError.value = AppStrings.pleaseEnterValidEmail.tr;
    }
    checkFormValid();
  }

  //  Password Validation
  void validatePassword(String value) {
    debugPrint("validatePassword called: $value");
    passwordError.value = "";
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      passwordError.value = AppStrings.pleaseEnterPassword.tr;
    }
    if (trimmed.isNotEmpty) {
      if (trimmed.length < 8 ||
          !RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\]]').hasMatch(trimmed)) {
        passwordError.value = AppStrings.pleaseMustBe6Character.tr;
      }
    }
    checkFormValid();
  }

  void validatePasswordWhenTyping(String value) {
    passwordError.value = "";
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      if (trimmed.length < 8 ||
          !RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\]]').hasMatch(trimmed)) {
        passwordError.value = AppStrings.pleaseMustBe6Character.tr;
      } else {
        // 🔥 VALID — CLEAR ERROR DURING TYPING
        passwordError.value = "";
      }
    }
    checkFormValid();
  }

  void validateConfirmPasswordWhenTyping(String value) {
    confirmPasswordError.value = "";
    final trimmed = value.trim();
    if (trimmed.isNotEmpty) {
      if (trimmed.length < 8 ||
          !RegExp(r'[!@#$%^&*(),.?":{}|<>_\-+=/\\\[\]]').hasMatch(trimmed)) {
        confirmPasswordError.value = AppStrings.pleaseMustBe6Character.tr;
      } else {
        // 🔥 VALID — CLEAR ERROR DURING TYPING
        confirmPasswordError.value = "";
      }
    }
    checkFormValid();
  }

  void validateCheckTerms() {
    if (isCheckTerms.value == false) {
      Get.snackbar("Signup", "Please select terms");
    }
    // checkFormValid();
  }

  // Confirm Password Validation
  void validateConfirmPassword(String value) {
    confirmPasswordError.value = "";
    if (value.trim().isEmpty) {
      confirmPasswordError.value = AppStrings.pleaseEnterConfirmPassword.tr;
    } else if (value.trim().length < 6) {
      confirmPasswordError.value = AppStrings.pleaseMustBe6Character.tr;
    } else if (value.trim() != passwordController.text.trim()) {
      confirmPasswordError.value = AppStrings.confirmPasswordDoesNotMatch.tr;
    }
    checkFormValid();
  }

  // Enable button if all fields valid
  void checkFormValid() {
    isFormValid.value =
        nameError.value.isEmpty &&
        userNameError.value.isEmpty &&
        emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty &&
        nameController.text.trim().isNotEmpty &&
        userNameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty &&
        isCheckTerms.value;
  }

  void goToLogin() {
    Get.toNamed(AppRoutes.login);
  }

  // Manual validation before signup
  bool validateAll() {
    validateName(nameController.text);
    validateUserName(userNameController.text);
    validateEmail(emailController.text);
    validatePassword(passwordController.text);
    validateConfirmPassword(confirmPasswordController.text);
    validateCheckTerms();

    return nameError.value.isEmpty &&
        userNameError.value.isEmpty &&
        emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty &&
        isCheckTerms.value == true;
  }

  // Signup
  void signUp() {
    if (validateAll()) {
      signUpUser();
    } else {
      Get.snackbar(
        "Error",
        "Please fix the errors before continuing",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> signUpUser() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        isLoading.value = true;

        final response = await _apiClient.getSignUpUser(
          nameController.text,
          userNameController.text,
          emailController.text,
          passwordController.text,
          confirmPasswordController.text,
          0,
          1,
          "0",
          "",
          "",
          "",
          "",
        );
        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final common = BaseResponse<LoginData>.fromJson(
          body,
          fromJsonT: (data) => LoginData.fromJson(data),
        );

        if (common.responseCode == "200") {
          if (common.status == AppConstants.SUCCESS) {
            final loginData = common.data!;
            controllerSocial.saveLoginData(loginData);
            final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
            await analytics.logSignUp(signUpMethod: 'email');
            final facebookAppEvents = FacebookAppEvents();

            // if (loginData.userId != null && loginData.token==null || loginData.token=="") {
            //   Get.toNamed(AppRoutes.updatePhoneNumber);
            // }else{
            //   Get.toNamed(AppRoutes.login);
            // }
          } else {
            AppDialog.showMessage(common.msg);
          }
        } else {
          AppDialog.showMessage(common.msg);
        }
      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
        errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }
  }
}
