import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../../utils/app_colors.dart';
import '../../../common/widgets/common_text_field.dart';
import 'change_password_controller.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final controller = Get.put(ChangePasswordController());

  bool _isCurrentVisible = false;
  bool _isNewVisible = false;
  bool _isConfirmVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        title: Text(
          AppStrings.appChangePassword.toUpperCase().tr,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Obx(() => Column(
          children: [
            // Current Password
            CommonTextField(
              label: "",
              hint: AppStrings.appCurrentPassword.toUpperCase().tr,
              controller: controller.currentPasswordController,
              obscureText: !_isCurrentVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isCurrentVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _isCurrentVisible = !_isCurrentVisible;
                  });
                },
              ),
              errorText: controller.currentPasswordError.value,
              backgroundColor: AppColors.colorAccountBackground,
            ),
            const SizedBox(height: 30),

            // New Password
            CommonTextField(
              label: "",
              hint: AppStrings.appCaptionNewPassword.toUpperCase().tr,
              controller: controller.newPasswordController,
              obscureText: !_isNewVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isNewVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _isNewVisible = !_isNewVisible;
                  });
                },
              ),
              errorText: controller.newPasswordError.value,
              backgroundColor: AppColors.colorAccountBackground,
            ),
            const SizedBox(height: 30),

            // Confirm Password
            CommonTextField(
              label: "",
              hint: AppStrings.appConfirmPassword.toUpperCase().tr,
              controller: controller.confirmPasswordController,
              obscureText: !_isConfirmVisible,
              suffixIcon: IconButton(
                icon: Icon(
                  _isConfirmVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: Colors.black54,
                ),
                onPressed: () {
                  setState(() {
                    _isConfirmVisible = !_isConfirmVisible;
                  });
                },
              ),
              errorText: controller.confirmPasswordError.value,
              backgroundColor: AppColors.colorAccountBackground,
            ),
            const SizedBox(height: 40),

            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.updatePassword,
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
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}