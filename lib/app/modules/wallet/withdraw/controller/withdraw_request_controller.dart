import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/wallet/wallet_api_client.dart';
import 'package:tajer/utils/app_loader.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/app_params.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/base_response.dart';
import '../../../../../utils/common_data.dart';
import '../../../../core/constants/app_constants.dart';

class WithdrawRequestController extends GetxController with WalletApiClient, AppLoader {
  final amountController = TextEditingController();
  final bankNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final accountHolderController = TextEditingController();
  final ifscController = TextEditingController();
  final bankAddressController = TextEditingController();
  final otherInfoController = TextEditingController();
  final emailController = TextEditingController();
  final paypalIdController = TextEditingController();

  final amountError = ''.obs;
  final bankNameError = ''.obs;
  final accountNumberError = ''.obs;
  final accountHolderNameError = ''.obs;
  final ifscCodeError = ''.obs;
  final bankAddressError = ''.obs;
  final otherInfoError = ''.obs;
  final emailError = ''.obs;
  final paypalIdError = ''.obs;

  /// Make reactive
  final withdrawType = ''.obs;
  final walletBalance = ''.obs;
  final displayUserBalance = ''.obs;
  final currencySymbol = ''.obs;


  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args is Map && args[AppParams.withdrawType] != null) {
      withdrawType.value = args[AppParams.withdrawType].toString();
      displayUserBalance.value = args[AppParams.displayUserBalance].toString();
      currencySymbol.value = args[AppParams.currencySymbol].toString();
      debugPrint("✅ Withdraw type set in onInit: ${withdrawType.value}");
    }
  }

  // 🔹 Called manually from the widget after creation
  // void setWithdrawType(String type) {
  //   withdrawType.value = type;
  //   debugPrint("✅ Withdraw type set to: ${withdrawType.value}");
  // }

  // --- Validation Methods ---
  void validateAmount(String value) =>
      amountError.value = value.trim().isEmpty ? AppStrings.app_error_enter_amount : "";

  void validatePaypalId(String value) =>
      paypalIdError.value = value.trim().isEmpty ? AppStrings.app_error_paypal_id : "";

  void validateEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) {
      emailError.value = AppStrings.emailCanNotBeEmpty.tr;
    } else if (!GetUtils.isEmail(trimmed)) {
      emailError.value = "Please enter a valid email address";
    } else {
      emailError.value = "";
    }
  }

  void validateBankName(String value) =>
      bankNameError.value = value.trim().isEmpty ? AppStrings.app_error_enter_bank_name : "";

  void validateAccountNumber(String value) =>
      accountNumberError.value = value.trim().isEmpty ? AppStrings.app_error_enter_account_number : "";

  void validateAccountHolderName(String value) =>
      accountHolderNameError.value = value.trim().isEmpty ? AppStrings.app_error_enter_account_holder_name : "";

  void validateIfscCode(String value) =>
      ifscCodeError.value = value.trim().isEmpty ? AppStrings.app_error_enter_ifsc_code : "";

  void validateBankAddress(String value) =>
      bankAddressError.value = value.trim().isEmpty ? AppStrings.app_error_enter_bank_address : "";

  void validateOtherInfo(String value) =>
      otherInfoError.value = value.trim().isEmpty ? AppStrings.app_error_enter_other_info : "";

  // --- Submit ---
  void submitRequest() {
    validateAmount(amountController.text);
    if (withdrawType.value == AppParams.bankWithdraw) {
      validateBankName(bankNameController.text);
      validateAccountNumber(accountNumberController.text);
      validateAccountHolderName(accountHolderController.text);
      validateIfscCode(ifscController.text);
      validateBankAddress(bankAddressController.text);
      validateOtherInfo(otherInfoController.text);
    } else if (withdrawType.value == AppParams.paypalWithdraw) {
      validateEmail(emailController.text);
      validatePaypalId(paypalIdController.text);
    }

    if (_hasValidationErrors()) {
      Get.snackbar('Error', 'Please fix validation errors',
          snackPosition: SnackPosition.BOTTOM);
      return;
    }
    setUpRequestWithdrawal();
  }

  bool _hasValidationErrors() {
    return [
      amountError,
      bankNameError,
      accountNumberError,
      accountHolderNameError,
      ifscCodeError,
      bankAddressError,
      otherInfoError,
      emailError,
      paypalIdError
    ].any((rx) => rx.value.isNotEmpty);
  }

  Future<void> setUpRequestWithdrawal() async {
    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection");
      return;
    }

    try {
      showLoader(Get.context!);
      final response = withdrawType.value == AppParams.bankWithdraw
          ? await setUpRequestWithdrawalApi(
        amountController.text.trim(),
        bankNameController.text.trim(),
        ifscController.text.trim(),
        accountHolderController.text.trim(),
        accountNumberController.text.trim(),
        bankAddressController.text.trim(),
        otherInfoController.text.trim(),
      )
          : await paypalPayoutSetUpApi(
        emailController.text.trim(),
        paypalIdController.text.trim(),
        amountController.text.trim(),
      );

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<CommonData>.fromJson(
        body,
        fromJsonT: (jsonData) => CommonData.fromJson(jsonData),
      );

      if (data.responseCode == "200" && data.status == AppConstants.SUCCESS) {
        AppDialog.showMessage(data.msg ?? "Withdrawal request submitted successfully");
      } else {
        AppDialog.showMessage(data.msg ?? "Something went wrong");
      }
    } catch (e, stack) {
      debugPrint('❌ Exception in setUpRequestWithdrawal: $e');
      debugPrint(stack.toString());
      AppDialog.showMessage("An error occurred. Please try again later.");
    } finally {
      hideLoader(Get.context!);
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    accountHolderController.dispose();
    ifscController.dispose();
    bankAddressController.dispose();
    otherInfoController.dispose();
    emailController.dispose();
    paypalIdController.dispose();
    super.onClose();
  }
}
