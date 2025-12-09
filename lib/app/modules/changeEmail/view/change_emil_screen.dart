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
          AppStrings.appChangeEmail.toUpperCase().tr,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: const BackButton(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // New Email Field
            CommonTextField(
              label: "",
              hint: AppStrings.appCaptionNewEmail.toUpperCase().tr,
              controller: controller.newEmailController,
              keyboardType: TextInputType.emailAddress,
              backgroundColor: AppColors.colorAccountBackground,
              errorText: controller.newEmailError.value,
              onChanged: (value) {
                if (controller.newEmailError.isNotEmpty) {
                  controller.newEmailError.value = '';
                }
              },
            ),
            const SizedBox(height: 30),

            // Confirm New Email Field
            CommonTextField(
              label: "",
              hint: AppStrings.appPleaseEnterConfirmEmail.toUpperCase().tr,
              controller: controller.confirmEmailController,
              keyboardType: TextInputType.emailAddress,
              backgroundColor: AppColors.colorAccountBackground,
              errorText: controller.confirmEmailError.value,
              onChanged: (value) {
                if (controller.confirmEmailError.isNotEmpty) {
                  controller.confirmEmailError.value = '';
                }
              },
            ),
            const SizedBox(height: 30),

            // Password Field
            CommonTextField(
              label: "",
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
              backgroundColor: AppColors.colorAccountBackground,
              errorText: controller.passwordError.value,
              onChanged: (value) {
                if (controller.passwordError.isNotEmpty) {
                  controller.passwordError.value = '';
                }
              },
            ),
            const SizedBox(height: 40),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.validateAndSubmit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppStrings.appSubmit.toUpperCase().tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}