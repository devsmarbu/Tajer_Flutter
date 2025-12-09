import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/authentication/socialController/social_controller.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../../utils/app_colors.dart';
import 'login_option_controller.dart';

class LoginOptionScreen extends StatelessWidget {
  final LoginOptionController controller = Get.put(LoginOptionController());
  final controllerSocial = Get.put(SocialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        leading: const BackButton(),
        centerTitle: true,
        title: const Text('Sign In to your Tajer - تاجر account.',
          style: TextStyle(
              color: AppColors.black1,
            fontSize: 14,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w400,
          )
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Logo
            Center(
              child: SizedBox(
                width: 80,
                height: 80,
                child: Image.asset('assets/images/app_logo.png'),
              ),
            ),

            const SizedBox(height: 40),

            _buildLoginButton(
              assetPath: 'assets/images/google_logo.png',
              label: AppStrings.appLoginWithGoogle.toUpperCase().tr,
              onTap: controllerSocial.loginWithGoogle,
            ),

            const SizedBox(height: 16),

            _buildLoginButton(
              assetPath: 'assets/images/phone.png',
              label: AppStrings.appSignInWithPhone.toUpperCase().tr,
              onTap: controller.signInWithPhone,
            ),

            const SizedBox(height: 16),

            _buildLoginButton(
              assetPath: 'assets/images/email.png',
              label: AppStrings.appSignInWithEmail.toUpperCase().tr,
              onTap: controller.signInWithEmail,
            ),

            const SizedBox(height: 30),

            // Missing: "Don't have an account?"
            Text(
              AppStrings.app_don_t_you_have_an_account.toUpperCase().tr,
              style: TextStyle(fontSize: 14),
            ),

            const SizedBox(height: 10),

            // Forgot Password / Register Now Links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: controller.forgotPassword,
                  child: Text(
                    AppStrings.appForgotPass.toUpperCase().tr,
                    style: TextStyle(
                        color: AppColors.black1,
                        fontFamily: "nunito",
                        fontWeight: FontWeight.w400,
                        decoration: TextDecoration.underline

                    ),
                  ),
                ),
                TextButton(
                  onPressed: controller.registerNow,
                  child: Text(
                    AppStrings.appRegisterNow.toUpperCase().tr,
                    style: TextStyle(
                      fontFamily: "nunito",
                        fontWeight: FontWeight.w400,
                      color: AppColors.black1,
                        decoration: TextDecoration.underline
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildLoginButton({
    required String assetPath,
    required String label,
    required VoidCallback onTap,
    double borderRadius = 10.0,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            // 🔹 PNG Icon from asset
            Image.asset(
              assetPath,
              width: 24,
              height: 24,
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 12),

            // 🔹 Centered label text
            Expanded(
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.black1,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
