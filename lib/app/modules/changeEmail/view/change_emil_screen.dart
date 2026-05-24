import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/common_text_field.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../controller/change_email_controller.dart';

class ChangeEmailScreen extends StatelessWidget {
  ChangeEmailScreen({super.key});

  final controller = Get.put(ChangeEmailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white  ,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          AppStrings.appUpdateEmail.toUpperCase().tr,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: Obx((){
        return controller.isEmailSent.value ? getSuccessView():getEmailForm();
      })

    );
  }

  Widget getSuccessView(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/img_verify_email_done.png",
            height: 180,
          ),
          const SizedBox(height: 24),
          const Text(
            "Verification email sent!",
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget getEmailForm(){
   return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // New Email Field
          CommonTextField(
            label: AppStrings.appCaptionNewEmail.toUpperCase().tr,
            hint: AppStrings.appCaptionNewEmail.toUpperCase().tr,
            controller: controller.newEmailController,
            keyboardType: TextInputType.emailAddress,
            backgroundColor: AppColors.white,
            errorText: controller.newEmailError.value,
            onChanged: (value) {
              if (controller.newEmailError.isNotEmpty) {
                controller.newEmailError.value = '';
              }
            },
          ),
          const SizedBox(height: 10),

          // Confirm New Email Field
          // CommonTextField(
          //   label: "",
          //   hint: AppStrings.appPleaseEnterConfirmEmail.toUpperCase().tr,
          //   controller: controller.confirmEmailController,
          //   keyboardType: TextInputType.emailAddress,
          //   backgroundColor: AppColors.colorAccountBackground,
          //   errorText: controller.confirmEmailError.value,
          //   onChanged: (value) {
          //     if (controller.confirmEmailError.isNotEmpty) {
          //       controller.confirmEmailError.value = '';
          //     }
          //   },
          // ),
          // const SizedBox(height: 30),

          // Password Field
          CommonTextField(
            label: AppStrings.appPassword.toUpperCase().tr,
            hint: AppStrings.appPassword.toUpperCase().tr,
            controller: controller.passwordController,
            obscureText: !controller.isPasswordVisible.value,
            suffixIcon: IconButton(
              icon: Icon(
                controller.isPasswordVisible.value
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: Colors.black54,
              ),
              onPressed: controller.togglePasswordVisibility,
            ),
            backgroundColor: AppColors.white,
            errorText: controller.passwordError.value,
            onChanged: (value) {
              if (controller.passwordError.isNotEmpty) {
                controller.passwordError.value = '';
              }
            },
          ),
          const SizedBox(height: 40),

          // Submit Button
          Obx(() {
            final isEnabled = controller.isFormValid.value;

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isEnabled ? controller.validateAndSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  isEnabled ? Colors.black : Colors.black.withOpacity(0.4),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: isEnabled ? 2 : 0,
                ),
                child: Text(
                  AppStrings.appSubmit.toUpperCase().tr,
                  style: const TextStyle(
                    fontSize: 16,
                    fontFamily: 'Nunito',
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          }),
        ],
      )),
    );
  }
}