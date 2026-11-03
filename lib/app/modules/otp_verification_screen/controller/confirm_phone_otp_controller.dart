import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/functions/app_function.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/base_response.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/events/app_analytics_service.dart';
import '../../../data/service/authentication_api_client.dart';
import '../../authentication/login/login_data.dart';

class ConfirmPhoneOtpController extends GetxController {
  final String phoneNumber;
  final TextEditingController otpController = TextEditingController();

  final pref = PrefStore();
  late Timer _timer;
  var remainingSeconds = 59.obs;
  var userID = ''.obs;
  var isLoading = false.obs;
  var isUpdate = false.obs;
  var dCode = ''.obs;
  var isEmail = false.obs;
  final _apiClient = AuthenticationApiClient();

  ConfirmPhoneOtpController(this.phoneNumber, {bool isEmail = false}) {
    this.isEmail.value = isEmail;
  }

  @override
  void onInit() {
    super.onInit();
    _startCountdown();
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer.cancel();
      }
    });
  }

  void resendOtp() {
    if (remainingSeconds.value == 0) {
      remainingSeconds.value = 59;
      _startCountdown();
      if (isEmail.value) {
        resendEmailOtpApi();
      } else {
        resendOtpApi();
      }
    }
  }

  void verifyOtp() {
    if (otpController.text.length < 4) {
      Get.snackbar("Invalid OTP", "Please enter the 4-digit verification code",
          snackPosition: SnackPosition.TOP);
      return;
    }
    if (isEmail.value) {
      verifyEmailOtpApi();
    } else {
      verifyOtpApi();
    }
  }

  Future<void> verifyEmailOtpApi() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.loginWithOtpApi(
        username: phoneNumber,
        otp: otpController.text.trim(),
        userType: 1,
      );

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final common = BaseResponse<LoginData>.fromJson(
        body,
        fromJsonT: (data) => LoginData.fromJson(data),
      );

      if (common.responseCode == "200") {
        if (common.status == AppConstants.SUCCESS) {
          await saveLoginData(common.data);
        } else {
          AppDialog.showMessage(common.msg);
        }
      } else {
        AppDialog.showMessage(common.msg);
      }
    } catch (e) {
      print('❌ Exception in verifyEmailOtpApi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> resendEmailOtpApi() async {
    try {
      isLoading.value = true;

      final response = await _apiClient.getEmailLoginOtp(phoneNumber);

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final common = BaseResponse<LoginData>.fromJson(
        body,
        fromJsonT: (data) => LoginData.fromJson(data),
      );

      if (common.responseCode == "200") {
        if (common.status == AppConstants.SUCCESS) {
          Get.snackbar(AppConstants.appName, common.msg.isNotEmpty ? common.msg : "OTP resent successfully");
        } else {
          AppDialog.showMessage(common.msg);
        }
      } else {
        AppDialog.showMessage(common.msg);
      }
    } catch (e) {
      print('❌ Exception in resendEmailOtpApi: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOtpApi() async {
    try {
      isLoading.value = true;
      final flag=  isUpdate.value ? 1 : 0 ;

      final response =await _apiClient.verifyOtp(otpController.text.trim(),userID.value,0,flag.toString(),"0");


      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final common = BaseResponse<LoginData>.fromJson(
        body,
        fromJsonT: (data) => LoginData.fromJson(data),
      );

      if(common.responseCode=="200"){
        if(common.status==AppConstants.SUCCESS){

          saveLoginData(common.data);
         // print("OTP verification success");

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
      isLoading.value = false;
    }
  }

  Future<void> resendOtpApi() async {
    try {
      isLoading.value = true;


      final response =
      await _apiClient.resendOtp(userID.value);


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
      print('❌ Exception in fetchSplashScreenData: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveLoginData(LoginData? data) async {
    await pref.saveString(AppConstants.sessionToken, data?.token ?? "");
    await pref.saveString(AppConstants.userId, data?.userId ?? "");
    await pref.saveString(AppConstants.userName, data?.userName ?? "");
    await pref.saveString(AppConstants.userEmail, data?.credentialEmail ?? "");
    await pref.saveString(AppConstants.userPhone, data?.userPhone ?? "");
    await pref.saveString(AppConstants.userDialCode, data?.userPhoneDcode ?? "");
    await pref.saveString(AppConstants.userImage, data?.userImage ?? "");

    await pref.saveString(
      AppConstants.loginData,
      jsonEncode(data?.toJson()),
    );

    String fcmToken = pref.loadString(AppConstants.fcmToken) ?? "";
    if (fcmToken == "") {
      fcmToken = await AppFunction.saveFcmToken(pref);
    }
    _apiClient.saveFirebaseTokenApi(
      fcmToken,
      Platform.isAndroid ? "1" : "0",
      AppConstants.buyerUserType,
    );

    AppAnalyticsService.login();
    Get.offAllNamed(AppRoutes.bottomNavigation);
  }

  @override
  void onClose() {
    _timer.cancel();
    otpController.dispose();
    super.onClose();
  }
}
