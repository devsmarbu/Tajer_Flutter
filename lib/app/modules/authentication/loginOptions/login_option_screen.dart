import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/authentication/socialController/social_controller.dart';
import 'package:tajer/utils/app_strings.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../../../utils/app_colors.dart';
import 'login_option_controller.dart';

class LoginOptionScreen extends StatelessWidget {
  final LoginOptionController controller = Get.put(LoginOptionController());
  final controllerSocial = Get.put(SocialController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("login_option_screen"),
      backgroundColor: AppColors.white,
      appBar: AppBar(
        key: const Key("login_option_appbar"),
        backgroundColor: AppColors.white,
        leading: const BackButton(key: Key("back_button")),
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
        key: const Key("login_option_body"),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            const SizedBox(height: 30),

            // Logo
            Semantics(
              label: 'app_logo',
              image: true,
              child: Center(
                child: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.asset('assets/images/app_icon_new.png'),
                ),
              ),
            ),

            const SizedBox(height: 40),

            Semantics(
              label: 'google_login_button',
              button: true,
              child: _buildLoginButton(
                key: const Key("google_login_button"),
                assetPath: 'assets/images/google_logo.png',
                label: AppStrings.appLoginWithGoogle.toUpperCase().tr,
                onTap: controllerSocial.loginWithGoogle,
              ),
            ),

            const SizedBox(height: 16),

            /// Phone Login
              if (PrefStore().loadString(AppConstants.confSigninWithPhoneEnable) == '1')
                Semantics(
                  label: 'phone_login_button',
                  button: true,
                  child: _buildLoginButton(
                    key: const Key("phone_login_button"),
                    assetPath: 'assets/images/phone.png',
                    label: AppStrings.appSignInWithPhone.toUpperCase().tr,
                    onTap: controller.signInWithPhone,
                  ),
                ),

            if (PrefStore().loadString(AppConstants.confSigninWithPhoneEnable) == '1')
            const SizedBox(height: 16),


            /// Email Login
            Semantics(
              label: 'email_login_button',
              button: true,
              child: _buildLoginButton(
                key: const Key("email_login_button"),
                assetPath: 'assets/images/email.png',
                label: AppStrings.appSignInWithEmail.toUpperCase().tr,
                onTap: controller.signInWithEmail,
              ),
            ),

            const SizedBox(height: 30),

            // Missing: "Don't have an account?"
            Semantics(
              label: 'no_account_text',
              child: Text(
                key: const Key("no_account_text"),
                AppStrings.app_don_t_you_have_an_account.toUpperCase().tr,
                style: TextStyle(fontSize: 14),
              ),
            ),

            const SizedBox(height: 10),

            // Forgot Password / Register Now Links
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Semantics(
                  label: 'forgot_password_button',
                  button: true,
                  child: TextButton(
                    key: const Key("forgot_password_button"),
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
                ),
                Semantics(
                  label: 'register_now_button',
                  button: true,
                  child: TextButton(
                    onPressed: controller.registerNow,
                    child: Text(
                      key: const Key("register_now_button"),
                      AppStrings.appRegisterNow.toUpperCase().tr,
                      style: TextStyle(
                        fontFamily: "nunito",
                          fontWeight: FontWeight.w400,
                        color: AppColors.black1,
                          decoration: TextDecoration.underline
                      ),
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
    required Key key,
    required String assetPath,
    required String label,
    required VoidCallback onTap,
    double borderRadius = 10.0,
  }) {
    return InkWell(
      key: key,
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
              key: Key("${key.toString()}_icon"),
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
                  key: Key("${key.toString()}_text"),
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
