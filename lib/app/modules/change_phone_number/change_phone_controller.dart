import 'dart:convert';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/account_api_client.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../common/widgets/app_dialog.dart';
import '../../../utils/app_params.dart';
import '../../../utils/app_strings.dart';
import '../../../utils/base_response.dart';
import '../../../utils/common_data.dart';
import '../../core/constants/app_constants.dart';
import '../otp_verification_screen/view/otp_verification_screen.dart';

class ChangePhoneController extends GetxController with AccountApiClient,AppLoader {
  final TextEditingController phoneController = TextEditingController();
  final RxString phoneError = "".obs;
  final RxString selectedCountryCode = "+91".obs;
  final pref=PrefStore();

  // ✅ Arguments from navigation
  late final String title;
  late final bool isUpdate;


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
    selectedCountryCode.value = getDialCodeFromISO(getDeviceISO());
    phoneController.text = pref.loadString(AppConstants.userPhone) ?? "";
  }

  /// 🔹 Validate input and send OTP
  void getOtpClick() {
    if (phoneController.text.trim().isEmpty) {
      phoneError.value = "Please enter your phone number";
      return;
    }

    // Optional: add more validation (length, format, etc.)
    phoneError.value = "";

    getOtp();
  }

  /// Validate and submit the request
  void getOtp() async {

    try {
      showLoader(Get.context!);

      final response = isUpdate ? await getOtpApi("0",phoneController.text,selectedCountryCode.value,"2")
          :await getOtpApi("1",phoneController.text,selectedCountryCode.value,"1");

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final apiResponse = BaseResponse<CommonData>.fromJson(
        body,
        fromJsonT: (data) => CommonData.fromJson(data),
      );

      hideLoader(Get.context!);

      if (apiResponse.responseCode == "200") {
        if (apiResponse.status == AppConstants.SUCCESS) {
          goToOtpVerificationView();
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

  /// 🔹 Navigate to OTP screen
  void goToOtpVerificationView() {
    final userId=pref.loadString(AppConstants.userId)??"";
    Get.to(() => ConfirmPhoneOtpView(
        dCode: selectedCountryCode.value.toString(),
        phoneNumber:phoneController.text.toString(),
        userId: userId,
      isUpdate: isUpdate,
    ));
  }

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
  return country.dialCode ?? "+1"; // fallback
}