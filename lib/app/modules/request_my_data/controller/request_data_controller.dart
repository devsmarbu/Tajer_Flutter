import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/account_api_client.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../../common/functions/app_function.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/app_loader.dart';
import '../../../../utils/app_params.dart';
import '../../../../utils/base_response.dart';
import '../../../../utils/common_data.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';

class RequestDataController extends GetxController with AccountApiClient,AppLoader {

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  RxBool isLoading = false.obs;
  final pref =PrefStore();

  @override
  void onInit() {
    super.onInit();
    nameController.text = "test";
    emailController.text = "testuser@yopmail.com";

    nameController.text=pref.loadString(AppConstants.userName)??"";
    emailController.text=pref.loadString(AppConstants.userEmail)??"";
  }

  /// Validate and submit the request
  void onSubmit() async {

    if (!await validateSection()) return;

    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection. Please try again.");
      return;
    }


    // ====== API CALL ======
    try {
      showLoader(Get.context!);

      final response = await setUpRequestDataApi(
        nameController.text.trim(),
        emailController.text.trim(),
        messageController.text.trim()
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
      print('❌ Exception in submitBankInfo: $e');
      AppDialog.showMessage("An error occurred. Please try again.");
    }


  }

  /// ✅ Validation helper
  Future<bool> validateSection() async {
    if (nameController.text.trim().isEmpty) {
      AppDialog.showMessage("Please enter bank username");
      return false;
    }
    if (emailController.text.trim().isEmpty) {
      AppDialog.showMessage("Please enter email");
      return false;
    }
    if (messageController.text.trim().isEmpty) {
      AppDialog.showMessage("Please enter message");
      return false;
    }
    return true;
  }

  void navigateToWebView(String title, String url) {
    debugPrint("requestdataurl:::----"+url);
    Get.toNamed(AppRoutes.webViewScreen, arguments: {
      AppParams.title: title,
      AppParams.webViewUrl: url,
    });
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.onClose();
  }
}
