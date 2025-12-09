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
      body: Stack(
        children: [
          /// Background Image
          Positioned.fill(
            child: Image.asset(
              "assets/images/ic_splash.png",
              fit: BoxFit.cover,
            ),
          ),

          /// Bottom controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Sign In + Sign Up Row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Row(
                      children: [
                        /// Sign In
                        Expanded(
                          child: GestureDetector(
                            onTap: controller.signInClick,
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: AppColors.colorButtonLoginSignup,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppStrings.signIn.toUpperCase().tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.greyText,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(width: 10),

                        /// Sign Up
                        Expanded(
                          child: GestureDetector(
                            onTap: controller.signUpClick,
                            child: Container(
                              height: 48,
                              alignment: Alignment.center,
                              margin: const EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                color: AppColors.colorButtonLoginSignup,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                AppStrings.signUp.toUpperCase().tr,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: AppColors.greyText,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  /// Skip text
                  GestureDetector(
                    onTap: controller.skipClick,
                    child: Text(
                      AppStrings.skipForNow.toUpperCase().tr,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                        decorationThickness: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 20)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}