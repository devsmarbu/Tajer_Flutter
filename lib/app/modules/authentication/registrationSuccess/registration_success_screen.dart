import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../utils/app_colors.dart';

class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("registration_success_screen"),
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            key: const Key("registration_success_body"),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              key: const Key("registration_success_column"),
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// ✅ Success Icon
                Semantics(
                  label: 'success_icon',
                  image: true,
                  child: Container(
                    key: const Key("success_icon_container"),
                    height: 90,
                    width: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.green, width: 3),
                    ),
                    child: const Icon(
                      Icons.check,
                      key: Key("success_icon"),
                      color: Colors.green,
                      size: 50,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// ✅ Title
                Semantics(
                  label: 'success_title',
                  child: Text(
                    AppStrings.APP_CONGRATULATIONS.tr,
                    key: const Key("success_title"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                /// ✅ Subtitle
                Semantics(
                  label: 'success_subtitle',
                  child: Text(
                    AppStrings
                        .APP_SUCCESS_USER_SIGN_UP_EMAIL_VERIFICATION_PENDING
                        .tr,
                    key: const Key("success_subtitle"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                /// ✅ Login Button
                Semantics(
                  label: 'login_button',
                  button: true,
                  child: SizedBox(
                    key: const Key("login_button_container"),
                    width: double.infinity,
                    child: ElevatedButton(
                      key: const Key("login_button"),
                      onPressed: () {
                        Get.offAllNamed(AppRoutes.login);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        AppStrings.APP_LOG_INTO_YOUR_ACCOUNT.tr,
                        key: const Key("login_button_text"),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}