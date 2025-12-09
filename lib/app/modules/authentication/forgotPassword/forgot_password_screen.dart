import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../../../../utils/app_colors.dart';

import '../../../../common/widgets/common_loader.dart';
import '../../../../common/widgets/common_text_field.dart';
import '../../../../common/widgets/phone_field.dart';
import '../../../../../utils/app_strings.dart';
import 'forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final bool isEmail;
  const ForgotPasswordScreen({super.key, this.isEmail = true});

  @override
  Widget build(BuildContext context) {

    final controller = Get.put(ForgotPasswordController(isEmail: isEmail.obs));

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.forgotPassword.toUpperCase().tr,
              style: const TextStyle(
                fontFamily: "Nunito",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.black1,
              ),
            ),
            Text(
              maxLines: 2,
              AppStrings.enterYourEmailResetPassword.toUpperCase().tr,
              style: const TextStyle(
                fontFamily: "Nunito",
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: AppColors.colorTitle2,
              ),
            ),
          ],
        ),
      ),
        body: Stack(
          children: [
            SafeArea(
              child: Column(
                children: [
                  /// Scrollable Form
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          /// Conditionally show Email or Phone field
                          Obx(() {
                            if (controller.isEmail.value) {
                              return Column(
                                children: [
                                  CommonTextField(
                                    label: "Email",
                                    hint: "Enter your email",
                                    controller: controller.emailController,
                                    errorText: controller.emailError.value.isNotEmpty
                                        ? controller.emailError.value
                                        : null,
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: controller.validateEmail,
                                  ),
                                ],
                              );
                            } else {
                              return PhoneField(controller: controller.phoneController,
                                errorText: controller.phoneError,
                                selectedCountryCode: controller.selectedCountryCode,
                                onChanged: controller.validatePhone);
                            }
                          }),

                          // SizedBox(height: 10),
                          // Obx(() => Center(
                          //   child: TextButton(
                          //     onPressed: controller.togglePhoneEmail,
                          //     style: TextButton.styleFrom(
                          //       padding: EdgeInsets.zero,
                          //       minimumSize: const Size(20, 20),
                          //       tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //     ),
                          //     child: Text(
                          //       controller.isEmail.value
                          //           ? AppStrings.usePhoneNumberInstead
                          //           : AppStrings.useEmailInstead,
                          //       style: const TextStyle(
                          //         decoration: TextDecoration.underline,
                          //         fontFamily: "Nunito",
                          //         fontWeight: FontWeight.w300,
                          //         fontSize: 14,
                          //         color: AppColors.black1,
                          //       ),
                          //     ),
                          //   ),
                          // )
                          // ),
                        ],
                      ),
                    ),
                  ),


                  /// Fixed Login Button at Bottom
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.proceed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black1,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          AppStrings.appProceed.toUpperCase().tr,
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Loader Overlay
            Obx(() => CommonLoader(isLoading: controller.isLoading.value)),
          ],
        ),
    );
  }
}
