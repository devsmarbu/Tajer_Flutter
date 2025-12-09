import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/routes/app_routes.dart';

import '../../../../../utils/app_params.dart';

class AddMoneyController extends GetxController {
  var selectedAmount = 0.0.obs;
  var amounts = [50.0, 100.0, 250.0, 500.0, 1000.0].obs;

  TextEditingController amountController = TextEditingController();


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
  /// Called when a chip is tapped
  void selectAmount(double amount) {
    selectedAmount.value = amount;
    amountController.text = amount.toStringAsFixed(2);
  }

  void addMoney() {
    final amount = amountController.text.trim();
    if (amount.isEmpty || amount == '0.00') {
      Get.snackbar("Error", "Please select an amount");
      return;
    }

    Get.toNamed(
      AppRoutes.paymentMethods,
      arguments: {
        AppParams.amount: amount,
      },
    );
  }

  @override
  void onClose() {
    amountController.dispose();
    super.onClose();
  }
}
