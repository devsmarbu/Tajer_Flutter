import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/wallet/myWallet/controller/wallet_controller.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../../common/widgets/common_text_field.dart';

class RedeemGiftCard extends StatelessWidget {
  final WalletController controller;
  final TextEditingController codeController = TextEditingController();

  RedeemGiftCard({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5), // Corrected: use withOpacity
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Tap outside to dismiss
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(color: Colors.transparent),
          ),

          // Popover bottom sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.appRedeemGiftCard.toUpperCase().tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        fontFamily: "Nunito",
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Code input field
                    CommonTextField(
                      controller: codeController,
                      maxLines: 1,
                      label: "",
                      hint: AppStrings.appEnterCode.toUpperCase().tr,
                      backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          final code = codeController.text.trim();
                          if (code.isEmpty) {
                            Get.snackbar("Error", "Please enter a gift card code.",
                                snackPosition: SnackPosition.BOTTOM);
                            return;
                          }

                          // TODO: Replace this with actual redeem API call
                          controller.redeemGiftCard(code);
                          Get.back();
                        },
                        child: const Text(
                          AppStrings.app_redeem,
                          style: TextStyle(
                            fontFamily: "Nunito",
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Close Button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.23,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: () => Get.back(),
                icon: const Icon(Icons.close, size: 28, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
