import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/account_api_client.dart';
import 'package:tajer/utils/app_loader.dart';
import '../../../../common/functions/app_function.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/base_response.dart';
import '../../../../utils/common_data.dart';
import '../../../core/constants/app_constants.dart';
import '../../Account/controller/account_controller.dart';

class BankInfoController extends GetxController
    with AccountApiClient, AppLoader {

  final AccountController accountController;

  BankInfoController(this.accountController);

  final bankNameController = TextEditingController();
  final accountHolderNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscSwiftController = TextEditingController();
  final bankAddressController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    // ✅ Pre-fill from profile data
    final bankInfo = accountController.profileDataa?.bankInfo;
    if (bankInfo != null) {
      bankNameController.text = bankInfo.ubBankName ?? '';
      accountHolderNameController.text = bankInfo.ubAccountHolderName ?? '';
      accountNumberController.text = bankInfo.ubAccountNumber ?? '';
      ifscSwiftController.text = bankInfo.ubIfscSwiftCode ?? '';
      bankAddressController.text = bankInfo.ubBankAddress ?? '';
    }
  }


  /// ✅ Validate and submit data
  Future<void> submitBankInfo() async {
    // ====== VALIDATION SECTION ======
    if (!await validateSection()) return;

    // ====== NETWORK CHECK ======
    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection. Please try again.");
      return;
    }

    // ====== API CALL ======
    try {
      showLoader(Get.context!);

      final response = await updateBankInfoApi(
        bankNameController.text.trim(),
        accountHolderNameController.text.trim(),
        accountNumberController.text.trim(),
        ifscSwiftController.text.trim(),
        bankAddressController.text.trim(),
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
          Get.back();
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
    if (bankNameController.text.trim().isEmpty) {
      AppDialog.showMessage("Please enter bank name");
      return false;
    }
    if (accountHolderNameController.text.trim().isEmpty) {
      AppDialog.showMessage("Please enter account holder name");
      return false;
    }
    if (accountNumberController.text.trim().isEmpty) {
      AppDialog.showMessage("Please enter account number");
      return false;
    }
    if (!RegExp(r'^\d{6,18}$').hasMatch(accountNumberController.text.trim())) {
      AppDialog.showMessage("Please enter a valid account number");
      return false;
    }
    if (ifscSwiftController.text.trim().isEmpty) {
      AppDialog.showMessage("Please enter IFSC/Swift code");
      return false;
    }
    if (bankAddressController.text.trim().isEmpty) {
      AppDialog.showMessage("Please enter bank address");
      return false;
    }
    return true;
  }

  @override
  void onClose() {
    bankNameController.dispose();
    accountHolderNameController.dispose();
    accountNumberController.dispose();
    ifscSwiftController.dispose();
    bankAddressController.dispose();
    super.onClose();
  }
}
