import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/giftCard/gift_card_api_client.dart';
import 'package:tajer/app/modules/payment/paymentMethods/model/payment_methods_data.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/common_data.dart';
import '../../../../../../utils/app_strings.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/app_params.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/routes/app_routes.dart';

class AddGiftCardController extends GetxController with AppLoader, GiftCardApiClient {
  final amountController = TextEditingController();
  final receiverNameController = TextEditingController();
  final receiverEmailController = TextEditingController();

  final amountError = ''.obs;
  final receiverNameError = ''.obs;
  final receiverEmailError = ''.obs;

  var isLoading = false.obs;

  // -------------------- Validation Methods --------------------
  void validateAmount(String value) {
    amountError.value =
    value.trim().isEmpty ? AppStrings.app_error_enter_amount : '';
  }

  void validateReceiverName(String value) {
    receiverNameError.value =
    value.trim().isEmpty ? AppStrings.app_error_enter_receiver_name : '';
  }

  void validateReceiverEmail(String value) {
    receiverEmailError.value =
    value.trim().isEmpty ? AppStrings.app_error_enter_receiver_email : '';
  }

  bool _isFormValid() {
    validateAmount(amountController.text);
    validateReceiverName(receiverNameController.text);
    validateReceiverEmail(receiverEmailController.text);

    return amountError.value.isEmpty &&
        receiverNameError.value.isEmpty &&
        receiverEmailError.value.isEmpty;
  }

  // -------------------- Save (Local Simulation) --------------------
  void saveGiftCard() async {
    if (!_isFormValid()) {
      return;
    }

    setUpGiftCard();

   // AppDialog.showMessage('Gift card added successfully');
  }

  // -------------------- Add Gift Card API --------------------
  Future<void> setUpGiftCard() async {
    if (!_isFormValid()) return;

    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection.");
      return;
    }

    try {
      showLoader(Get.context!);

      final response = await setUpGiftCardApi(
        amountController.text.trim(),
        receiverNameController.text.trim(),
        receiverEmailController.text.trim(),
      );

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<PaymentMethodsData>.fromJson(
        body,
        fromJsonT: (data) => PaymentMethodsData.fromJson(data),
      );

      hideLoader(Get.context!);

      // ✅ Handle success or failure
      if (data.responseCode == "200") {

        final paymentData=data.data;
        Future.delayed(const Duration(milliseconds: 100), () {
          Get.toNamed(
            AppRoutes.paymentMethods,
            arguments: {
              AppParams.orderId: paymentData?.orderId.toString(),
              AppParams.orderType: paymentData?.orderType.toString(),
              AppParams.canUseWalletForPayment: paymentData?.canUseWalletForPayment.toString(),
              AppParams.displayUserWalletBalance: paymentData?.displayUserWalletBalance.toString(),
              AppParams.userWalletBalance: paymentData?.userWalletBalance.toString(),
              AppParams.orderNetAmount: paymentData?.orderNetAmount.toString(),
              AppParams.paymentMethods: paymentData?.paymentMethods,
            },
          );
        });
      } else {
        Future.delayed(const Duration(milliseconds: 100), () {
          AppDialog.showMessage(data.msg ?? "Something went wrong");
        });
      }
    } catch (e) {
      hideLoader(Get.context!);
      AppDialog.showMessage("Error occurred while setting up gift card.");
      print('❌ Exception in setUpGiftCard: $e');
    }
  }

  @override
  void onClose() {
    amountController.dispose();
    receiverNameController.dispose();
    receiverEmailController.dispose();
    super.onClose();
  }
}
