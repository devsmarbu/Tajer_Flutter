import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:tajer/app/modules/authentication/socialController/social_controller.dart';
import 'package:tajer/app/modules/authentication/splash/controller/splash_controller.dart';
import 'package:tajer/common/functions/app_function.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/base_response.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/service/authentication_api_client.dart';
import '../../otp_verification_screen/view/otp_verification_screen.dart';
import 'login_data.dart';
import 'package:firebase_analytics/firebase_analytics.dart';


class LoginController extends GetxController {

  final pref = PrefStore();
  late RxBool isEmail = true.obs;

  LoginController({required this.isEmail});
  final controllerSocial = Get.put(SocialController());

  final _apiClient = AuthenticationApiClient();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  final emailError = ''.obs;
  final phoneError = ''.obs;
  final passwordError = ''.obs;
  final isLoading = false.obs;

  final isFormValid = false.obs;
  final selectedCountryCode = "+91-in".obs;

  String deviceType = Platform.isAndroid ? "1" : "0";



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

  void validatePhone(String value) {
    if (value.trim().length < 10) {
      phoneError.value = "Please enter valid phone number";
    } else {
      phoneError.value = "";
    }
    checkFormValid();
  }

  void validatePassword(String value) {
    if (value.trim().isEmpty) {
      passwordError.value = AppStrings.pleaseEnterPassword.tr;
    }
    // if (value.trim().length < 6) {
    //   passwordError.value = "Password must be at least 6 characters";
    // }
    else {
      passwordError.value = "";
    }
    checkFormValid();
  }

  void checkFormValid() {
    if (isEmail.value) {
      isFormValid.value =
          emailError.isEmpty &&
              passwordError.isEmpty &&
              emailController.text.isNotEmpty &&
              passwordController.text.isNotEmpty;
    } else {
      isFormValid.value =
          phoneError.isEmpty &&
              passwordError.isEmpty &&
              phoneController.text.isNotEmpty &&
              passwordController.text.isNotEmpty;
    }
  }

  void resetPassword() {
    Get.toNamed(AppRoutes.forgotPassword, arguments: {"isEmail": true});
  }

  void continueWithPhone() {
    isEmail.value ? isEmail.value=false:isEmail.value=true;
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.signUp);
  }

  /// 🔹 Check all fields manually on login button
  bool validateAll() {
    if (isEmail.value) {
      validateEmail(emailController.text);
      validatePassword(passwordController.text);
      return emailError.isEmpty &&
          passwordError.isEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty;
    } else {
      validatePhone(phoneController.text);
      //validatePassword(passwordController.text);
      return phoneError.isEmpty &&
          phoneController.text.isNotEmpty;
    }
  }

  void login(){
    if (validateAll()) {
      isEmail.value ? loginUser():loginUserWithOtp();

    } else {
      Get.snackbar(
        "Error",
        "Please fix the errors before login",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> loginUser() async {
    if(await AppFunction.isInternetAvailable()){
      try {
        isLoading.value = true;

        final response =await _apiClient.loginUser(
          emailController.text,
          passwordController.text,
          AppConstants.buyerUserType,
          "",
        );


        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final common = BaseResponse<LoginData>.fromJson(
          body,
          fromJsonT: (data) => LoginData.fromJson(data),
        );

        if(common.responseCode=="200"){
          if(common.status==AppConstants.SUCCESS){
            controllerSocial.saveLoginData(common.data);
            final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
            await analytics.logLogin(loginMethod: 'email');
           // await saveLoginData(common.data);
          }
          // else if (common.status == AppConstants.WARNING && common.notVerified != null) {
          //
          // }
          else{
            // errorMessage.value = common.msg;
            AppDialog.showMessage(common.msg);
          }

        }else{
          // errorMessage.value = common.msg;
          AppDialog.showMessage(common.msg);
        }


      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
        // errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }

  }


  Future<void> loginUserWithOtp() async {
    if(await AppFunction.isInternetAvailable()){
      try {
        isLoading.value = true;
        final response = await _apiClient.loginUserWithOtp(selectedCountryCode.value, phoneController.text, AppConstants.ERROR);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final common = BaseResponse<LoginData>.fromJson(
          body,
          fromJsonT: (data) => LoginData.fromJson(data),
        );

        if(common.responseCode=="200"){

          if(common.status==AppConstants.SUCCESS){

            Get.to(() => ConfirmPhoneOtpView(
              dCode: selectedCountryCode.value ,
              phoneNumber: phoneController.text,
              userId:common.data?.userId??"" ,
              isUpdate: false,
            ));

            // Get.toNamed(AppRoutes.otpVerification,arguments:{
            //   phoneNumber: selectedCountryCode.value+phoneController.text,
            // });
          }
          else{
            // errorMessage.value = common.msg;
            AppDialog.showMessage(common.msg);
          }

        }else if(common.responseCode=="404"){
          // errorMessage.value = common.msg;
          showRegisterDialog(Get.context!,"Your phone does not exist. Do you want to Register ?");

        }else {
          AppDialog.showMessage(common.msg);
        }


      } catch (e) {
        print('❌ Exception in fetchSplashScreenData: $e');
        // errorMessage.value = e.toString();
      } finally {
        isLoading.value = false;
      }
    }

  }



  void showRegisterDialog(BuildContext context,String message) {
    showDialog(
      context: context,
      barrierDismissible: false, // prevents dismiss on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          content: Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          actionsAlignment: MainAxisAlignment.end,
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
              },
              child: const Text(
                AppStrings.app_cancel,
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Nunito',
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(width: 10),
            TextButton(
              onPressed: () {
                Get.back();
                // Navigate to register screen or perform any action
                Get.toNamed(AppRoutes.signUp);
              },
              child: const Text(
                AppStrings.app_click_here,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

}