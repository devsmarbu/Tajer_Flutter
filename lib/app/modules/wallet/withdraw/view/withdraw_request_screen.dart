import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_params.dart';
import '../../../../../common/widgets/common_text_field.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_strings.dart';
import '../controller/withdraw_request_controller.dart';

class WithdrawRequestScreen extends StatelessWidget {
  WithdrawRequestScreen({Key? key}) : super(key: key);

  final WithdrawRequestController controller = Get.put(WithdrawRequestController());

  @override
  Widget build(BuildContext context) {
    debugPrint("Withdraw type in UI: ${controller.withdrawType.value}");

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        title: Text(
          AppStrings.appBtnWithdraw.toUpperCase().tr,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.black1,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 24),
            child: Column(
              children: [
                Text(
                  controller.currencySymbol+controller.walletBalance.value,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                    fontSize: 28,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  AppStrings.appAvailableBalance.toUpperCase().tr,
                  style: TextStyle(
                    color: Colors.white70,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color(0xFFF5F5F5),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appFillInformation.toUpperCase().tr,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Amount field (reactive error)
                    Obx(() => CommonTextField(
                      label: "${AppStrings.appHintAmount.toUpperCase().tr}(\$)",
                      hint: AppStrings.appHintAmount.toUpperCase().tr,
                      controller: controller.amountController,
                      errorText: controller.amountError.value.isNotEmpty
                          ? controller.amountError.value
                          : null,
                      keyboardType: TextInputType.number,
                      onChanged: controller.validateAmount,
                    )),

                    // ✅ Reactive PayPal Section
                    Obx(() {
                      debugPrint("Rendering PayPal section for ${controller.withdrawType.value}");
                      if (controller.withdrawType.value == AppParams.paypalWithdraw) {
                        return Column(
                          children: [
                            CommonTextField(
                              label: AppStrings.appEmail.toUpperCase().tr,
                              hint: AppStrings.app_error_email,
                              controller: controller.emailController,
                              errorText: controller.emailError.value.isNotEmpty
                                  ? controller.emailError.value
                                  : null,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: controller.validateEmail,
                            ),
                            CommonTextField(
                              label: AppStrings.app_paypal_id,
                              hint: AppStrings.app_error_paypal_id,
                              controller: controller.paypalIdController,
                              errorText: controller.paypalIdError.value.isNotEmpty
                                  ? controller.paypalIdError.value
                                  : null,
                              onChanged: controller.validatePaypalId,
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),

                    // ✅ Reactive Bank Section
                    Obx(() {
                      debugPrint("Rendering Bank section for ${controller.withdrawType.value}");
                      if (controller.withdrawType.value == AppParams.bankWithdraw) {
                        return Column(
                          children: [
                            CommonTextField(
                              label: AppStrings.appCaptionBankName.toUpperCase().tr,
                              hint: AppStrings.appCaptionBankName.toUpperCase().tr,
                              controller: controller.bankNameController,
                              errorText: controller.bankNameError.value.isNotEmpty
                                  ? controller.bankNameError.value
                                  : null,
                              onChanged: controller.validateBankName,
                            ),
                            CommonTextField(
                              label: AppStrings.appCaptionAccountNumber.toUpperCase().tr,
                              hint: AppStrings.appCaptionAccountNumber.toUpperCase().tr,
                              controller: controller.accountNumberController,
                              errorText: controller.accountNumberError.value.isNotEmpty
                                  ? controller.accountNumberError.value
                                  : null,
                              onChanged: controller.validateAccountNumber,
                            ),
                            CommonTextField(
                              label: AppStrings.appCaptionAccountHolderName.toUpperCase().tr,
                              hint: AppStrings.appCaptionAccountHolderName.toUpperCase().tr,
                              controller: controller.accountHolderController,
                              errorText: controller.accountHolderNameError.value.isNotEmpty
                                  ? controller.accountHolderNameError.value
                                  : null,
                              onChanged: controller.validateAccountHolderName,
                            ),
                            CommonTextField(
                              label: AppStrings.appCaptionIfscCode.toUpperCase().tr,
                              hint: AppStrings.appCaptionIfscCode.toUpperCase().tr,
                              controller: controller.ifscController,
                              errorText: controller.ifscCodeError.value.isNotEmpty
                                  ? controller.ifscCodeError.value
                                  : null,
                              onChanged: controller.validateIfscCode,
                            ),
                            CommonTextField(
                              label: AppStrings.appCaptionBankAddress.toUpperCase().tr,
                              hint: AppStrings.appCaptionBankAddress.toUpperCase().tr,
                              controller: controller.bankAddressController,
                              errorText: controller.bankAddressError.value.isNotEmpty
                                  ? controller.bankAddressError.value
                                  : null,
                              onChanged: controller.validateBankAddress,
                            ),
                            CommonTextField(
                              label: AppStrings.appCaptionOtherInfo.toUpperCase().tr,
                              hint: AppStrings.appCaptionOtherInfo.toUpperCase().tr,
                              controller: controller.otherInfoController,
                              errorText: controller.otherInfoError.value.isNotEmpty
                                  ? controller.otherInfoError.value
                                  : null,
                              onChanged: controller.validateOtherInfo,
                            ),
                          ],
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: ElevatedButton(
            onPressed: controller.submitRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              AppStrings.appSubmit.toUpperCase().tr,
              style: TextStyle(
                color: Colors.white,
                fontFamily: "Nunito",
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
