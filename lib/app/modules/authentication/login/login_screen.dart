import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/authentication/socialController/social_controller.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../../common/widgets/common_loader.dart';
import '../../../../common/widgets/common_text_field.dart';
import '../../../../common/widgets/phone_field.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart' show AppStrings;
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  final bool isEmail;
  final bool isBottomSheet;

  const LoginScreen({
    super.key,
    this.isEmail = true,
    this.isBottomSheet = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEmail = Get.arguments?["isEmail"] ?? true;

    final controller = Get.put(LoginController(isEmail: isEmail.obs));
    final controllerSocial = Get.put(SocialController());

    final content = Scaffold(
      key: const Key("login_screen"),
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,

      appBar: AppBar(
        key: const Key("login_appbar"),
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        leading: Padding(
          padding: EdgeInsets.only(top: 10),
          child: Semantics(
            label: 'back_button',
            button: true,
            child: IconButton(
              key: const Key("back_button"),
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back),
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),

            Semantics(
              label: 'welcome_title',
              child: Text(
                AppStrings.appWelcomeBack.toUpperCase().tr,
                key: const Key("welcome_title"),
                style: const TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.black1,
                ),
              ),
            ),
          ],
        ),
      ),

      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              key: const Key("login_scroll"),
              padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
              child: Container(
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// EMAIL / PHONE
                    Obx(() {
                      if (controller.isEmail.value) {
                        return Column(
                          key: const Key("email_login_section"),
                          children: [
                            AutofillGroup(
                              child: Column(
                                children: [

                                  Semantics(
                                    label: 'email_field',
                                    textField: true,
                                    child: CommonTextField(
                                      key: const Key("email_field"),
                                      label: AppStrings.appEmail.toUpperCase().tr,
                                      hint: AppStrings.pleaseEnterEmail.toUpperCase().tr,
                                      controller: controller.emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      autofillHints: const [
                                        AutofillHints.username,
                                      ],
                                      textInputAction: TextInputAction.next,
                                      errorText:
                                      controller.emailError.value.isNotEmpty
                                          ? controller.emailError.value
                                          : null,
                                      onChanged: controller.validateEmail,
                                    ),
                                  ),

                                  const SizedBox(height: 20),

                                  Semantics(
                                    label: 'password_field',
                                    textField: true,
                                    child: CommonTextField(
                                      key: const Key("password_field"),
                                      label: AppStrings.appPassword.toUpperCase().tr,
                                      hint: AppStrings.appPassword.toUpperCase().tr,
                                      controller: controller.passwordController,
                                      autofillHints: const [
                                        AutofillHints.password,
                                      ],
                                      textInputAction: TextInputAction.done,
                                      obscureText: true,
                                      errorText:
                                      controller.passwordError.value.isNotEmpty
                                          ? controller.passwordError.value
                                          : null,
                                      onChanged: controller.validatePassword,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      } else {
                        return Semantics(
                          label: 'phone_field',
                          textField: true,
                          child: PhoneField(
                            key: const Key("phone_field"),
                            controller: controller.phoneController,
                            errorText: controller.phoneError,
                            selectedCountryCode: controller.selectedCountryCode,
                            onChanged: controller.validatePhone,
                          ),
                        );
                      }
                    }),

                    /// FORGOT PASSWORD
                    Obx(() {
                      if (controller.isEmail.value) {
                        return Align(
                          alignment: Alignment.centerRight,
                          child: Semantics(
                            label: 'forgot_password_button',
                            button: true,
                            child: TextButton(
                              key: const Key("forgot_password_button"),
                              onPressed: controller.resetPassword,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(20, 20),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                AppStrings.forgotPassword.toUpperCase().tr,
                                style: const TextStyle(
                                  fontFamily: "Nunito",
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: AppColors.black1,
                                ),
                              ),
                            ),
                          ),
                        );
                      } else {
                        return const SizedBox(height: 10);
                      }
                    }),

                    /// LOGIN BUTTON
                    const SizedBox(height: 20),
                    Semantics(
                      label: 'login_button',
                      button: true,
                      child:
                      Obx(() {
                        return SizedBox(
                          key: const Key("login_button"),
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: controller.login,
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
                              AppStrings.signIn.toUpperCase().tr,
                              style: const TextStyle(
                                fontFamily: "Nunito",
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        );
                      })
                    ),

                    /// TOGGLE BUTTON
                    const SizedBox(height: 10),
                    if (PrefStore().loadString(
                      AppConstants.confSigninWithPhoneEnable,
                    ) ==
                        '1')
                      Semantics(
                        label: 'toggle_login_mode_button',
                        button: true,
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            key: const Key("toggle_login_mode_button"),
                            onPressed: controller.continueWithPhone,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.colorButtonFade,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Obx(() {
                              return Text(
                                controller.isEmail.value
                                    ? AppStrings.continueWithPhoneNumber
                                    .toUpperCase()
                                    .tr
                                    : AppStrings.continueWithEmail
                                    .toUpperCase()
                                    .tr,
                                style: const TextStyle(
                                  fontFamily: "Nunito",
                                  fontSize: 14,
                                  color: AppColors.black1,
                                  fontWeight: FontWeight.w700,
                                ),
                              );
                            }),
                          ),
                        ),
                      ),

                    /// LOGIN WITH TEXT
                    const SizedBox(height: 10),
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

                    /// SOCIAL BUTTONS
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Semantics(
                          label: 'google_login_button',
                          button: true,
                          child: GestureDetector(
                            key: const Key("google_login_button"),
                            onTap: () {
                              controllerSocial.loginWithGoogle();
                            },
                            child: CircleAvatar(
                              backgroundColor:
                              AppColors.colorAccountBackground,
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
                          Semantics(
                            label: 'apple_login_button',
                            button: true,
                            child: GestureDetector(
                              key: const Key("apple_login_button"),
                              onTap: () {
                                controllerSocial.loginWithApple();
                              },
                              child: CircleAvatar(
                                backgroundColor:
                                AppColors.colorAccountBackground,
                                radius: 25,
                                child: SvgPicture.asset(
                                  "assets/icons/ic_apple.svg",
                                  height: 24,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),

                    /// REGISTER
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
                        Semantics(
                          label: 'register_text',
                          child: Text(
                            AppStrings.app_don_t_you_have_an_account
                                .toUpperCase()
                                .tr,
                            style: const TextStyle(
                              fontFamily: "Nunito",
                              color: AppColors.colorTitleSignup,
                              fontWeight: FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),

                        SizedBox(width: 20),

                        Semantics(
                          label: 'register_button',
                          button: true,
                          child: TextButton(
                            key: const Key("register_button"),
                            onPressed: controller.goToRegister,
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size(0, 0),
                              tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              AppStrings.appCreateAccount.toUpperCase().tr,
                              style: const TextStyle(
                                decoration: TextDecoration.underline,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.black1,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 10),
                    // Obx(() {
                    //   debugPrint("✅ Prefilled Email: ${controller.deeplinkEmail.value}");
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

          /// LOADER
          Obx(() => CommonLoader(
            key: const Key("loader"),
            isLoading: controller.isLoading.value,
          )),
        ],
      ),
    );

    if (isBottomSheet == true) {
      return Material(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(top: 120),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20),
              topLeft: Radius.circular(20),
            ),
            child: content,
          ),
        ),
      );
    }

    return content;
  }

  // Widget infoBox(LoginController controller) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  //     decoration: BoxDecoration(
  //       color: const Color(0xFFDFF5EA), // light green bg
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(
  //         color: const Color(0xFF8ED1B2), // green border
  //         width: 1,
  //       ),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         /// Title
  //         Text(
  //           AppStrings.APP_EMPLOYEE_WORK_EMAIL_VERIFIED.tr,
  //           style: const TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.w600,
  //             color: Color(0xFF1B4332),
  //           ),
  //         ),
  //
  //         const SizedBox(height: 6),
  //
  //         /// Email
  //         Text(
  //           controller.deeplinkEmail.value,
  //           style: const TextStyle(
  //             fontSize: 15,
  //             fontWeight: FontWeight.w500,
  //             color: Color(0xFF1B4332),
  //           ),
  //         ),
  //
  //         const SizedBox(height: 6),
  //
  //         /// Description
  //         Text(
  //           AppStrings.APP_REGISTER_WITH_PERSONAL_EMAIL_TO_ACTIVATE_EMPLOYEE_BENEFITS.tr,
  //           style: const TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w400,
  //             color: Color(0xFF1B4332),
  //             height: 1.4,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
