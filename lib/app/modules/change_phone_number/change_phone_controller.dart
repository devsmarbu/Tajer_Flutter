import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/account_api_client.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../common/functions/app_function.dart';
import '../../../common/widgets/app_dialog.dart';
import '../../../utils/app_params.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/base_response.dart';
import '../../../utils/common_data.dart';
import '../../core/constants/app_constants.dart';
import '../../data/service/authentication_api_client.dart';
import '../address/address_api_client.dart';
import '../authentication/login/login_data.dart';

class ChangePhoneController extends GetxController with AddressApiClient,AccountApiClient,AppLoader {
  final TextEditingController phoneController = TextEditingController();
  final RxString phoneError = "".obs;
  final RxString selectedCountryCode = "+91".obs;
  final RxString selectedCountryISO = "IN".obs;
  final pref=PrefStore();
  final TextEditingController otpController = TextEditingController();
  final RxBool isAlreadyVerified = false.obs;
  // ✅ Arguments from navigation
  late final String title;
  late final bool isUpdate;

  final RxBool isOtpSent = false.obs;
  final RxBool isOtpFilled = false.obs;
  final RxList<String> otp = List.generate(4, (_) => "").obs;

  final RxInt seconds = 40.obs;
  Timer? timer;
  final _apiClient = AuthenticationApiClient();
  final RxSet<String> verifiedNumbers = <String>{}.obs;
  final RxBool isVerifiedLoaded = false.obs;

  // void onMainButtonClick() {
  //   if (!isOtpSent.value) {
  //     getOtpClick();
  //   } else if (isOtpFilled.value) {
  //    // verifyOtp(); // create this API call
  //   }
  // }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    title = args[AppParams.title] ?? AppStrings.app_change_phone_number;
    isUpdate = args[AppParams.isUpdate] ?? false;
    // debugPrint("user dial code ");
    // debugPrint(pref.loadString(AppConstants.userDialCode)??"");
    // if (pref.loadString(AppConstants.userDialCode) != "") {
    //   selectedCountryCode.value = pref.loadString(AppConstants.userDialCode)??"";
    // }

    // selectedCountryCode.value = getDialCodeFromISO(getDeviceISO());
    // phoneController.text = pref.loadString(AppConstants.userPhone) ?? "";

    phoneController.text =
        args["phone"] ??
            pref.loadString(AppConstants.userPhone) ??
            "";

    selectedCountryCode.value =
        args["countryCode"] ??
            pref.loadString(AppConstants.userDialCode) ??
            getDialCodeFromISO(getDeviceISO());

    otpController.addListener(() {
      isOtpFilled.value = otpController.text.length == 4;
    });
  }

  @override
  void onReady() {
    super.onReady();
    getVerifiedNumbers();
  }

  void checkIfVerified() {
    final fullNumber =
        "${selectedCountryCode.value}${phoneController.text.trim()}";

    isAlreadyVerified.value =
        verifiedNumbers.contains(fullNumber);

    debugPrint("Check Verified: $fullNumber -> ${isAlreadyVerified.value}");
  }

  void startTimer() {
    seconds.value = 40;
    timer?.cancel();

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (seconds.value == 0) {
        t.cancel();
      } else {
        seconds.value--;
      }
    });
  }

  ///  Validate input and send OTP
  void getOtpClick() {
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = "Please enter your phone number";
      return;
    }

    final fullNumber = "${selectedCountryCode.value}${phoneController.text.trim()}";

    final normalizedInput = normalizeNumber(fullNumber);

    debugPrint("------ DEBUG START ------");
    debugPrint("Full Number: $fullNumber");
    debugPrint("Normalized Input: $normalizedInput");
    debugPrint("VerifiedNumbers: $verifiedNumbers");

    if (verifiedNumbers.contains(fullNumber)) {
      verifyOtpApi("");
    }else{
      getOtp();
    }

  }

  void verifyOtp() {
    if (otpController.text.length < 6) {
      Get.snackbar("Invalid OTP", "Please enter the 6-digit verification code",
          snackPosition: SnackPosition.TOP);
      return;
    }
    verifyOtpApi(otpController.text.trim());
    // ✅ Simulate success
    // AppDialog.showMessage("Phone number verified successfully!");
  }

  Future<void> verifyOtpApi(String otp) async {
    try {
      showLoader(Get.context!);
     // final flag= 1;

     // final userId=pref.loadString(AppConstants.userId)??"";
      final response =await _apiClient.saveProfilePhoneNumber(selectedCountryCode.value,phoneController.text,otp);


      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final common = BaseResponse<LoginData>.fromJson(
        body,
        fromJsonT: (data) => LoginData.fromJson(data),
      );

      hideLoader(Get.context!);

      if(common.responseCode=="200"){
        if(common.status==AppConstants.SUCCESS){

          debugPrint("Otp verification done");
          Get.back(); // close OTP screen
          Get.back(result: common.msg);
        }
        else{
          AppDialog.showMessage(common.msg);
        }

      }else{
        AppDialog.showMessage(common.msg);
      }


    } catch (e) {
      print('❌ Exception in fetchSplashScreenData: $e');
    } finally {
      hideLoader(Get.context!);
    }
  }

  void resendOtp(){

    if (seconds.value == 0) {
      seconds.value = 40;
      startTimer();
      resendOtpApi();
      // Get.snackbar("OTP Resent", "Verification code sent again");
    }
  }

  /// Validate and submit the request
  void getOtp() async {

    try {
      showLoader(Get.context!);

      final response = await verifyPhoneGetOtp(phoneController.text,selectedCountryCode.value);

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<CommonData>.fromJson(
        body,
        fromJsonT: (data) => CommonData.fromJson(data),
      );
      hideLoader(Get.context!);
      if (data.isVerified == "0") {
        isOtpSent.value = true;
        startTimer();
      } else {
        AppDialog.showMessage(data.msg);
      }
    } catch (e) {
        hideLoader(Get.context!);
        AppDialog.showMessage("An error occurred. Please try again.");
      }


  }

  String normalizeNumber(String number) {
    return number.replaceAll(RegExp(r'[^0-9]'), '');
  }

  Future<void> getVerifiedNumbers() async {
    try {
      showLoader(Get.overlayContext!);

      final response = await _apiClient.getVerifiedNumbers();

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      debugPrint("FULL RESPONSE: $body");

      final numbersMap =
          body["verifiedNumber"] ??
              body["data"]?["verifiedNumber"] ??
              body["data"]?["verified_number"];

      verifiedNumbers.clear();

      if (numbersMap != null && numbersMap is Map) {
        verifiedNumbers.addAll(numbersMap.keys.cast<String>());
      }

      debugPrint("FINAL VERIFIED SET: $verifiedNumbers");

    } catch (e) {
      debugPrint('❌ Exception: $e');
    } finally {
      hideLoader(Get.overlayContext!);
    }
  }

  // Future<void> getOtp() async {
  //   if (await AppFunction.isInternetAvailable()) {
  //     try {
  //       showLoader(Get.context!);
  //
  //       final response = await verifyPhoneCodeApi(selectedCountryCode.value,phoneController.text);
  //
  //       dynamic body = response.data;
  //       if (body is String) body = json.decode(body);
  //
  //       final data = BaseResponse<CommonData>.fromJson(
  //         body,
  //         fromJsonT: (data) => CommonData.fromJson(data),
  //       );
  //
  //       if (data.isVerified == "0") {
  //         isOtpSent.value = true;
  //         startTimer();
  //       } else {
  //         AppDialog.showMessage(data.msg);
  //       }
  //     } catch (e) {
  //       print('❌ Exception in addAddress: $e');
  //     } finally {
  //       hideLoader(Get.context!);
  //     }
  //   }
  // }

  void updateOtp(int index, String value) {
    otp[index] = value;

    isOtpFilled.value = otp.every((e) => e.isNotEmpty);
  }

  Future<void> resendOtpApi() async {
    try {

      showLoader(Get.context!);
      final userId=pref.loadString(AppConstants.userId)??"";
      final response =
      await _apiClient.resendOtp(userId);


      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final common = BaseResponse<LoginData>.fromJson(
        body,
        fromJsonT: (data) => LoginData.fromJson(data),
      );

      if(common.responseCode=="200"){
        if(common.status==AppConstants.SUCCESS){

          Get.snackbar(AppConstants.appName, common.msg);
          //  print("OTP resend success");

        }
        else{
          AppDialog.showMessage(common.msg);
        }

      }else{
        AppDialog.showMessage(common.msg);
      }


    } catch (e) {
      debugPrint('❌ Exception in fetchSplashScreenData: $e');
    } finally {
      hideLoader(Get.context!);
    }
  }

  /// 🔹 Navigate to OTP screen
  // void goToOtpVerificationView() {
  //   final userId=pref.loadString(AppConstants.userId)??"";
  //   Get.to(() => ConfirmPhoneOtpView(
  //       dCode: selectedCountryCode.value.toString(),
  //       phoneNumber:phoneController.text.toString(),
  //       userId: userId,
  //     isUpdate: isUpdate,
  //   ));
  // }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}


String getDeviceISO() {
  final locale = Platform.localeName; // en_IN, ar_AE, en_US
  debugPrint("current locale");
  debugPrint(locale);
  final parts = locale.split("_");
  return parts.length > 1 ? parts.last : "US";
}


String getDialCodeFromISO(String isoCode) {
  final country = CountryCode.fromCountryCode(isoCode.toUpperCase());
  debugPrint('this is the country code ${country.dialCode}');
  return country.dialCode ?? "+1"; // fallback
}