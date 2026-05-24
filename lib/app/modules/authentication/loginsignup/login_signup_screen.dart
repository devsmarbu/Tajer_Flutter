import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors.dart';

import '../../../../../utils/app_strings.dart';
import 'login_signup_controller.dart';

class LoginSignupScreen extends StatelessWidget {
  final LoginSignupController controller = Get.put(LoginSignupController());

  LoginSignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const Key("login_signup_screen"),
      backgroundColor: AppColors.black1,
      body: Stack(
        children: [
          /// Background Image (optional if you want)
          // Positioned.fill(
          //   child: Semantics(
          //     label: 'background_image',
          //     image: true,
          //     child: Image.asset(
          //       "assets/images/ic_splash.png",
          //       key: const Key("background_image"),
          //       fit: BoxFit.cover,
          //     ),
          //   ),
          // ),

          /// Center Content
          Positioned.fill(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).padding.top + 60),

                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        /// Logo
                        Semantics(
                          label: 'app_logo',
                          image: true,
                          child: Image.asset(
                            "assets/images/app_logo.png",
                            key: const Key("app_logo"),
                            height: 110,
                            width: 110,
                          ),
                        ),

                        const SizedBox(height: 16),

                        /// Title Text
                        Semantics(
                          label: 'app_tagline',
                          child: Text(
                            AppStrings.appShopSmartShopBig.tr,
                            key: const Key("app_tagline_text"),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 200),
              ],
            ),
          ),

          /// Bottom Controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              key: const Key("bottom_controls"),
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                key: const Key("login_signup_column"),
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Sign Up Button (only one in your new UI)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10),
                    child: Row(
                      key: const Key("auth_buttons_row"),
                      children: [
                        Expanded(
                          child: Semantics(
                            label: 'sign_up_button',
                            button: true,
                            child: GestureDetector(
                              key: const Key("sign_up_button"),
                              onTap: controller.signUpClick,
                              child: Container(
                                height: 48,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.colorButtonLoginSignup,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  AppStrings.appCreateAccount
                                      .toUpperCase()
                                      .tr,
                                  key: const Key("sign_up_text"),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Nunito',
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.black1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// Already have account + Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Semantics(
                        label: 'already_have_account_text',
                        child: Text(
                          AppStrings.alreadyHaveAnAccount
                              .toUpperCase()
                              .tr,
                          key: const Key("already_have_account_text"),
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            color: AppColors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),

                      Semantics(
                        label: 'login_button',
                        button: true,
                        child: TextButton(
                          key: const Key("login_button"),
                          onPressed: controller.goToLogin,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            AppStrings.login.toUpperCase().tr,
                            key: const Key("login_text"),
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),

          /// Skip Button (Top Right)
          Positioned(
            top: 50,
            right: 20,
            child: Semantics(
              label: 'skip_button',
              button: true,
              child: GestureDetector(
                key: const Key("skip_button"),
                onTap: controller.skipClick,
                child: Text(
                  AppStrings.skipForNow.toUpperCase().tr,
                  key: const Key("skip_text"),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}