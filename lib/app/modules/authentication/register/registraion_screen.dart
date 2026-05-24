import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:tajer/app/modules/authentication/register/registration_controller.dart';
import 'package:tajer/app/modules/authentication/socialController/social_controller.dart';
import '../../../../common/widgets/common_loader.dart';
import '../../../../common/widgets/common_text_field.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import 'package:flutter/gestures.dart';

class RegistraionScreen extends StatelessWidget {
  const RegistraionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());
    final controllerSocial = Get.put(SocialController());

    return Scaffold(
      key: const Key("registration_screen"),
      backgroundColor: AppColors.white,
      appBar: AppBar(
        key: const Key("registration_appbar"),
        backgroundColor: AppColors.white,
        titleSpacing: 0,
        leading: InkWell(
          key: const Key("back_button"),
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              key: const Key("registration_title"),
              AppStrings.createAnAccount.toUpperCase().tr,
              style: const TextStyle(
                fontFamily: "Nunito",
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black1,
              ),
            ),
            // Text(
            //   AppStrings.letsCreateYourAccount.toUpperCase().tr,
            //   key: const Key("registration_subtitle"),
            //   style: const TextStyle(
            //     fontFamily: "Nunito",
            //     fontSize: 12,
            //     fontWeight: FontWeight.w300,
            //     color: AppColors.colorTitle2,
            //   ),
            // ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              key: const Key("registration_scroll"),
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                top: 10,
                bottom: 10,
              ),
              child: Container(
                color: AppColors.white,
                child: Column(
                  key: const Key("registration_column"),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Conditionally show Email + Password OR Phone
                    Column(
                      children: [
                        //Name field
                        Obx(
                          () => Semantics(
                            label: 'name_field',
                            textField: true,
                            child: CommonTextField(
                              key: const Key("name_field"),
                              label: AppStrings.appLabelName.toUpperCase().tr,
                              hint: AppStrings.pleaseEnterYourName
                                  .toUpperCase()
                                  .tr,
                              controller: controller.nameController,
                              errorText: controller.nameError.value.isNotEmpty
                                  ? controller.nameError.value
                                  : null,
                              keyboardType: TextInputType.name,
                              onChanged: controller.validateName,
                            ),
                          ),
                        ),
                        // const SizedBox(height: 20),

                        // UserName field
                        // Obx(
                        //   () => Semantics(
                        //     label: 'username_field',
                        //     textField: true,
                        //     child: CommonTextField(
                        //       key: const Key("username_field"),
                        //       label: AppStrings.appUsername.toUpperCase().tr,
                        //       hint: AppStrings.pleaseEnterYourUserName
                        //           .toUpperCase()
                        //           .tr,
                        //       controller: controller.userNameController,
                        //       errorText:
                        //           controller.userNameError.value.isNotEmpty
                        //           ? controller.userNameError.value
                        //           : null,
                        //       keyboardType: TextInputType.name,
                        //       onChanged: controller.validateUserName,
                        //     ),
                        //   ),
                        // ),
                        const SizedBox(height: 20),

                        // Email Field
                        Obx(
                          () => Semantics(
                            label: 'email_field',
                            textField: true,
                            child: CommonTextField(
                              key: const Key("email_field"),
                              label: AppStrings.appEmail.toUpperCase().tr,
                              hint: AppStrings.pleaseEnterEmail
                                  .toUpperCase()
                                  .tr,
                              controller: controller.emailController,
                              errorText: controller.emailError.value.isNotEmpty
                                  ? controller.emailError.value
                                  : null,
                              keyboardType: TextInputType.emailAddress,
                              onChanged: controller.validateEmail,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        Obx(
                          () => Semantics(
                            label: 'password_field',
                            textField: true,
                            child: CommonTextField(
                              key: const Key("password_field"),
                              label: AppStrings.appPassword.toUpperCase().tr,
                              hint: AppStrings.appEnterYourPassword
                                  .toUpperCase()
                                  .tr,
                              controller: controller.passwordController,
                              errorText:
                                  controller.passwordError.value.isNotEmpty
                                  ? controller.passwordError.value
                                  : null,
                              obscureText: true,
                              onChanged: controller.validatePassword,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Confirm Password Field
                        Obx(
                          () => Semantics(
                            label: 'confirm_password_field',
                            textField: true,
                            child: CommonTextField(
                              key: const Key("confirm_password_field"),
                              label: AppStrings.confirmPassword.tr,
                              hint: AppStrings.appPleaseEnterYourConfirmPassword
                                  .toUpperCase()
                                  .tr,
                              controller: controller.confirmPasswordController,
                              errorText:
                                  controller
                                      .confirmPasswordError
                                      .value
                                      .isNotEmpty
                                  ? controller.confirmPasswordError.value
                                  : null,
                              obscureText: true,
                              onChanged: controller.validateConfirmPassword,
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Obx(
                          () => Semantics(
                            label: 'terms_checkbox',
                            toggled: controller.isCheckTerms.value,
                            child: CheckboxListTile(
                              key: const Key("terms_checkbox"),
                              activeColor: AppColors.black1,
                              checkColor: Colors.white,
                              tileColor: Colors.transparent,
                              contentPadding: EdgeInsets.zero,
                              visualDensity: const VisualDensity(
                                horizontal: -4,
                                vertical: -4,
                              ),
                              // 👈 reduces spacing
                              dense: true,
                              controlAffinity: ListTileControlAffinity.leading,
                              value: controller.isCheckTerms.value,
                              onChanged: (value) {
                                controller.isCheckTerms.value = value!;
                                controller.checkFormValid();
                              },
                              title: RichText(
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontFamily: "Nunito",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300,
                                    color: AppColors.black1,
                                  ),
                                  children: [
                                    TextSpan(text: "I agree to the "),
                                    TextSpan(
                                      text: "APP_TERMS".tr,
                                      style: const TextStyle(
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Open Terms
                                          debugPrint('APP_TERMS'.tr);
                                          // Get.to(() => TermsAndConditionsScreen());
                                          // or launch URL
                                        },
                                    ),
                                    TextSpan(text: " and "),
                                    TextSpan(
                                      text: "APP_PRIVACY_POLICY".tr,
                                      style: const TextStyle(
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black,
                                        decoration: TextDecoration.underline,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          // Open Privacy Policy
                                          debugPrint('privacy policy');
                                          // Get.to(() => PrivacyPolicyScreen());
                                          // or launch URL
                                        },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    /// Login Button
                    const SizedBox(height: 20),
                    Semantics(
                      label: 'continue_button',
                      button: true,
                      child: Obx(
                        () => SizedBox(
                          key: const Key("continue_button"),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.signUp,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: controller.isFormValid.value
                                  ? AppColors.black1
                                  : Colors.grey.shade400,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              key: const Key("continue_button_text"),
                              AppStrings.appCreateAccount.toUpperCase().tr,
                              style: const TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 16,
                                fontWeight: FontWeight.w700, // Bold
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // /// OR Divider
                    // Row(
                    //   children: [
                    //     const Expanded(child: Divider(color: AppColors.grey)),
                    //     Padding(
                    //       padding: const EdgeInsets.symmetric(horizontal: 8),
                    //       child: Text(
                    //         AppStrings.app_or.toUpperCase().tr,
                    //         style: const TextStyle(
                    //           fontFamily: "Nunito",
                    //           fontWeight: FontWeight.w400, // Regular
                    //           fontSize: 12,
                    //           color: AppColors.grey,
                    //         ),
                    //       ),
                    //     ),
                    //     const Expanded(child: Divider(color: AppColors.grey)),
                    //   ],
                    // ),

                    /// Login With
                    //  const SizedBox(height: 20),
                    Semantics(
                      label: 'login_with_text',
                      child: Center(
                        child: Text(
                          "${AppStrings.app_or.toUpperCase().tr} ${AppStrings.loginWith.tr}",
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.colorTitle2,
                          ),
                        ),
                      ),
                    ),

                    /// Social Buttons
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Semantics(
                          label: 'google_signup_button',
                          button: true,
                          child: GestureDetector(
                            key: const Key("google_signup_button"),
                            onTap: () {
                              controllerSocial.loginWithGoogle();
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.colorAccountBackground,
                              radius: 25,
                              child: SvgPicture.asset(
                                "assets/icons/ic_google.svg",
                                height: 24,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        if (!GetPlatform.isAndroid)
                          GestureDetector(
                            onTap: () {
                              controllerSocial.loginWithApple();
                            },
                            child: CircleAvatar(
                              backgroundColor: AppColors.colorAccountBackground,
                              radius: 25,
                              child: SvgPicture.asset(
                                "assets/icons/ic_apple.svg",
                                height: 24,
                              ),
                            ),
                          ),
                      ],
                    ),

                    /// Bottom Register
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.grey)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          key: const Key("already_account_text"),
                          AppStrings.alreadyHaveAnAccount.toUpperCase().tr,
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w400, // Regular
                            fontSize: 12,
                          ),
                        ),
                        SizedBox(width: 10),
                        TextButton(
                          key: const Key("login_button"),
                          onPressed: controller.goToLogin,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            AppStrings.login.toUpperCase().tr,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700,
                              // Bold
                              fontSize: 12,
                              color: AppColors.black1,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    // Obx(() {
                    //   if (controller.deeplinkEmail.value.isNotEmpty) {
                    //     return infoBox(controller);
                    //   } else {
                    //     return SizedBox();
                    //   }
                    // })

                  ],
                ),
              ),
            ),
          ),

          /// Loader Overlay
          Obx(() => CommonLoader(isLoading: controller.isLoading.value)),
        ],
      ),
    );
  }

  Widget infoBox(RegistrationController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFDFF5EA), // light green bg
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF8ED1B2), // green border
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title
          Text(
            AppStrings.APP_EMPLOYEE_WORK_EMAIL_VERIFIED.tr,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B4332),
            ),
          ),

          const SizedBox(height: 6),

          /// Email
          Text(
            controller.deeplinkEmail.value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1B4332),
            ),
          ),

          const SizedBox(height: 6),

          /// Description
          Text(
            AppStrings.APP_REGISTER_WITH_PERSONAL_EMAIL_TO_ACTIVATE_EMPLOYEE_BENEFITS.tr,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF1B4332),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
