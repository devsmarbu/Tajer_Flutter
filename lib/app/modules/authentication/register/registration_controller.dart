import 'dart:convert';

import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/events/app_analytics_service.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';
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
  final deeplinkEmail = ''.obs;

  // State
  final isLoading = false.obs;
  final isFormValid = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    passwordController.addListener(() {
      validatePassword(passwordController.text);
    });
    confirmPasswordController.addListener(() {
      validateConfirmPassword(confirmPasswordController.text);
    });
    nameController.addListener(() {
      validateName(nameController.text);
    });
    // userNameController.addListener(() {
    //   validateUserName(userNameController.text);
    // });
    emailController.addListener(() {
      validateEmail(emailController.text);
    });

    final args = Get.arguments;

    if (args != null && args["email"] != null) {
      deeplinkEmail.value = args["email"];
      debugPrint("✅ Prefilled Email: ${args["email"]}");
    }

  }

  // Name Validation
  void validateName(String value, {bool isSubmit = false}) {
    nameError.value = "";
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      if (isSubmit) {
        nameError.value = AppStrings.pleaseEnterName.tr;
      }
    }
    checkFormValid();
  }

  // Username Validation
  // void validateUserName(String value, {bool isSubmit = false}) {
  //   userNameError.value = "";
  //   if (value.trim().isEmpty) {
  //     if (isSubmit) {
  //       userNameError.value = AppStrings.pleaseEnterUserName.tr;
  //     }
  //   }
  //   checkFormValid();
  // }

  // Email Validation
  void validateEmail(String value, {bool isSubmit = false}) {
    emailError.value = "";
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      if (isSubmit) {
        emailError.value = AppStrings.emailCanNotBeEmpty.tr;
      }
    } else if (!GetUtils.isEmail(trimmed)) {
      emailError.value = AppStrings.pleaseEnterValidEmail.tr;
    }
    checkFormValid();
  }

  //  Password Validation
  void validatePassword(String value, {bool isSubmit = false}) {
    debugPrint("validatePassword called: $value");
    passwordError.value = "";
    final trimmed = value.trim();

    if (trimmed.isEmpty) {
      if (isSubmit) {
        passwordError.value = AppStrings.pleaseEnterPassword.tr;
      }
    } else {
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
    // checkFormValid();
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
    // checkFormValid();
  }

  bool validateCheckTerms() {
    if (isCheckTerms.value == false) {
      Get.snackbar("Signup", "Please select terms");
      return false;
    }

    return true;
    // checkFormValid();
  }

  // Confirm Password Validation
  void validateConfirmPassword(String value, {bool isSubmit = false}) {
    confirmPasswordError.value = "";
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      if (isSubmit) {
        confirmPasswordError.value = AppStrings.pleaseEnterConfirmPassword.tr;
      }
    } else if (trimmed.length < 6) {
      confirmPasswordError.value = AppStrings.pleaseMustBe6Character.tr;
    } else if (trimmed != passwordController.text.trim()) {
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
        // userNameController.text.trim().isNotEmpty &&
        emailController.text.trim().isNotEmpty &&
        passwordController.text.trim().isNotEmpty &&
        confirmPasswordController.text.trim().isNotEmpty &&
        isCheckTerms.value;
  }

  void goToLogin() {
    Get.toNamed(AppRoutes.login);
    Get.toNamed(
      AppRoutes.login,
      arguments: {
        "email": deeplinkEmail.value,
      },
    );
  }

  // Manual validation before signup
  bool validateAll() {
    validateName(nameController.text, isSubmit: true);
    // validateUserName(userNameController.text, isSubmit: true);
    validateEmail(emailController.text, isSubmit: true);
    validatePassword(passwordController.text, isSubmit: true);
    validateConfirmPassword(confirmPasswordController.text, isSubmit: true);

    return nameError.value.isEmpty &&
        userNameError.value.isEmpty &&
        emailError.value.isEmpty &&
        passwordError.value.isEmpty &&
        confirmPasswordError.value.isEmpty;
       // && isCheckTerms.value == true;
  }

  // Signup
  void signUp() {
    if (validateAll() && validateCheckTerms()) {
      signUpUser();
    }
    // else {
    //   Get.snackbar(
    //     "Error",
    //     "Please fix the errors before continuing",
    //     snackPosition: SnackPosition.BOTTOM,
    //     backgroundColor: Colors.red,
    //     colorText: Colors.white,
    //   );
    // }
  }

  Future<void> signUpUser() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        isLoading.value = true;

        final response = await _apiClient.getSignUpUser(
          nameController.text,
          // userNameController.text,
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
            //controllerSocial.saveLoginData(loginData);
            AppAnalyticsService.register();
            // Get.showSnackbar(
            //   GetSnackBar(
            //     message: common.msg,
            //     backgroundColor: Colors.black87,
            //     duration: Duration(seconds: 2),
            //     snackPosition: SnackPosition.TOP,
            //     margin: EdgeInsets.all(12),
            //     borderRadius: 8,
            //     isDismissible: true,
            //   ),
            // );

            Get.offAllNamed(AppRoutes.registrationSuccessScreen);

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
