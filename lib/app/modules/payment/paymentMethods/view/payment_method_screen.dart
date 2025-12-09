import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';

import '../../../../../utils/app_colors.dart';
import '../../../wallet/myWallet/models/payout_plugin.dart';
import '../controller/payment_method_controller.dart';

class PaymentMethodsScreen extends StatelessWidget {
  PaymentMethodsScreen({super.key});

  // PaymentMethodController
  final controller = Get.put(PaymentMethodController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        title: Text(
          AppStrings.appPaymentMethod.toUpperCase().tr,
          style: const TextStyle(
            fontSize: 18,
            color: AppColors.black1,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        elevation: 0.3,
      ),
      backgroundColor: AppColors.colorAccountBackground,

      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            if (controller.canUseWalletForPayment.value == "1")
              _walletSection(),

            const SizedBox(height: 10),

            Obx(() {
              return Container(
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.paymentMethods.length,
                  separatorBuilder: (_, __) =>
                      Divider(height: 1, color: Colors.grey.shade300),
                  itemBuilder: (context, index) {
                    final item = controller.paymentMethods[index];
                    return _paymentListItem(item.pluginName ?? "", item);
                  },
                ),
              );
            }),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (controller.isWalletSelected.value==false && controller.selectedMethod.value==null) {
                    Get.snackbar("Warning", "Please select a payment method");
                  } else {
                    controller.handleConfirmOrder();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  AppStrings.appPayAmount.toUpperCase().tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---------- PAYMENT LIST ITEM ----------
  // ---------- LIST ITEM WIDGET ----------
  Widget _paymentListItem(String label, PayoutPlugin item) {
    return Obx(() {
      return InkWell(
        onTap: () {
          controller.isWalletSelected.value = false;
          controller.selectedMethod.value = item;
          if(controller.displayUserWalletBalance.value.isNotEmpty){
            controller.walletGiftSelection();
          }

        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Radio<PayoutPlugin>(
                value: item,
                groupValue: controller.selectedMethod.value,
                onChanged: (value) {
                  controller.isWalletSelected.value = false;   // unselect wallet
                  controller.selectedMethod.value = value;
                },
                activeColor: Colors.black,
              ),

              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  color: AppColors.black1,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }


  // ---------- WALLET SECTION ----------
  Widget _walletSection() {
    return GestureDetector(
      onTap: () {
        controller.isWalletSelected.value = !controller.isWalletSelected.value;

        if (controller.isWalletSelected.value == true) {
          controller.selectedMethod.value = null;   // unselect cards
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.account_balance_wallet_outlined,
                size: 22, color: Colors.black),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.appWallet.toUpperCase().tr,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Nunito",
                        color: AppColors.black1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${AppStrings.appAvailableBalance.toUpperCase().tr} ${controller.displayUserWalletBalance}",
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: "Nunito",
                        color: AppColors.black1),
                  ),
                ],
              ),
            ),

            Obx(() => Checkbox(
              value: controller.isWalletSelected.value,
              onChanged: (value) {
                controller.isWalletSelected.value = value!;
                if (value == true) {
                  controller.selectedMethod.value = null;
                }
                controller.walletGiftSelection();
              },
              activeColor: Colors.black,
            )),
          ],
        ),
      ),
    );
  }
}
