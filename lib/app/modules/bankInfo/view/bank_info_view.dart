import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/Account/controller/account_controller.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../common/widgets/common_text_field.dart';
import '../../../../utils/app_colors.dart';
import '../controller/bank_info_controller.dart';

class BankInfoView {
  static void show(AccountController accountController) {
    final controller = Get.put(BankInfoController(accountController));

    Get.bottomSheet(
      Semantics(
        label: "bank_info_bottom_sheet",
        child: SingleChildScrollView(
          child: Container(
            key: const ValueKey("bank_info_container"),
            decoration: const BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ===== Header =====
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  child: Container(
                    key: const ValueKey("bank_info_header"),
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    color: AppColors.colorAccountBackground,
                    child: Row(
                      children: [
                        Semantics(
                          label: "close_bank_info",
                          button: true,
                          child: IconButton(
                            key: const ValueKey("btn_close_bank_info"),
                            icon: const Icon(Icons.close),
                            onPressed: () => Get.back(),
                          ),
                        ),
                        Text(
                          key: const ValueKey("text_bank_info_title"),
                          AppStrings.appBankInfo.toUpperCase().tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        
                // ===== Form Fields =====
                Container(
                  key: const ValueKey("bank_info_form"),
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: Column(
                    spacing: 20,
                    children: [
                      CommonTextField(
                        label: "",
                        hint: AppStrings.appCaptionBankName.toUpperCase().tr,
                        backgroundColor: AppColors.colorAccountBackground,
                        controller: controller.bankNameController,
                      ),
                      CommonTextField(
                        label: "",
                        hint: AppStrings.appCaptionAccountHolderName.toUpperCase().tr,
                        backgroundColor: AppColors.colorAccountBackground,
                        controller: controller.accountHolderNameController,
                      ),
                      CommonTextField(
                        label: "",
                        hint: AppStrings.appCaptionAccountNumber.toUpperCase().tr,
                        backgroundColor: AppColors.colorAccountBackground,
                        controller: controller.accountNumberController,
                      ),
                      CommonTextField(
                        label: "",
                        hint: AppStrings.appCaptionIfscCode.toUpperCase().tr,
                        backgroundColor: AppColors.colorAccountBackground,
                        controller: controller.ifscSwiftController,
                      ),
                      CommonTextField(
                        label: "",
                        hint: AppStrings.appCaptionBankAddress.toUpperCase().tr,
                        backgroundColor: AppColors.colorAccountBackground,
                        maxLines: 3,
                        controller: controller.bankAddressController,
                      ),
                    ],
                  ),
                ),
        
                // ===== Submit Button =====
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Semantics(
                      label: "submit_bank_info",
                      button: true,
                      key: const ValueKey("btn_submit_bank_info"),
                      child: ElevatedButton(
                        onPressed: controller.submitBankInfo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 10,
                          ),
                        ),
                        child: Text(AppStrings.appSubmit.toUpperCase().tr,key: const ValueKey("text_submit_bank_info"),),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
