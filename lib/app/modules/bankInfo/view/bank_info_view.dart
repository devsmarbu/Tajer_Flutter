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
      SingleChildScrollView(
        child: Container(
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
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  color: AppColors.colorAccountBackground,
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Get.back(),
                      ),
                      Text(
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
                    child: Text(AppStrings.appSubmit.toUpperCase().tr),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
