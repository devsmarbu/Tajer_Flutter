import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/authentication/socialController/social_controller.dart';
import '../../../../common/widgets/common_loader.dart';
import '../../../../common/widgets/common_text_field.dart';
import '../../../../common/widgets/phone_field.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart' show AppStrings;
import 'login_controller.dart';

class LoginScreen extends StatelessWidget {
  final bool isEmail;
  final bool isBottomSheet;


  const LoginScreen({super.key, this.isEmail = true,this.isBottomSheet = false});

  @override
  Widget build(BuildContext context) {
    final bool isEmail = Get.arguments?["isEmail"] ?? true;

    final controller = Get.put(LoginController(isEmail: isEmail.obs));
    final controllerSocial = Get.put(SocialController());

    final content =
    Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        leading: Padding(
          padding: EdgeInsets.only(top: 10),
          child: IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              AppStrings.welcomeToYokart.toUpperCase().tr,
              style: const TextStyle(
                fontFamily: "Nunito",
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.black1,
              ),
            ),
            Text(
              AppStrings.welcomeSubtitle.toUpperCase().tr,
              style: const TextStyle(
                fontFamily: "Nunito",
                fontSize: 12,
                fontWeight: FontWeight.w300,
                color: AppColors.colorTitle2,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Container(
                color: AppColors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    /// Conditionally show Email + Password OR Phone
                    Obx(() {
                      if (controller.isEmail.value) {
                        return Column(
                          children: [
                            AutofillGroup(child:Column(
                              children: [
                                CommonTextField(
                                  label: AppStrings.appEmail.toUpperCase().tr,
                                  hint: AppStrings.pleaseEnterEmail.toUpperCase().tr,
                                  controller: controller.emailController,
                                  autofillHints: const [AutofillHints.email,AutofillHints.password],
                                  errorText:
                                  controller.emailError.value.isNotEmpty
                                      ? controller.emailError.value
                                      : null,
                                  onChanged: controller.validateEmail,
                                ),
                                const SizedBox(height: 20),
                                CommonTextField(
                                  label: AppStrings.appPassword.toUpperCase().tr,
                                  hint: AppStrings.appEnterYourPassword.toUpperCase().tr,
                                  controller: controller.passwordController,
                                  autofillHints:const [AutofillHints.password],
                                  errorText:
                                  controller
                                      .passwordError
                                      .value
                                      .isNotEmpty
                                      ? controller.passwordError.value
                                      : null,
                                  // obscureText: true,
                                  onChanged: controller.validatePassword,
                                )
                              ],
                            ))
                          ],
                        );
                      } else {
                        return PhoneField(
                          controller: controller.phoneController,
                          errorText: controller.phoneError,
                          selectedCountryCode:
                          controller.selectedCountryCode,
                          onChanged: controller.validatePhone,
                        );
                      }
                    }),

                    Obx(() {
                      if (controller.isEmail.value) {
                        // Forgot Password Row
                        return Row(
                          children: [
                            TextButton(
                              onPressed: controller.resetPassword,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                // remove default horizontal padding
                                minimumSize: const Size(20, 20),
                                tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                AppStrings.forgotPassword.toUpperCase().tr,
                                style: const TextStyle(
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12,
                                  color: AppColors.colorTitle2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            TextButton(
                              onPressed: controller.resetPassword,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: const Size(20, 20),
                                tapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(
                                AppStrings.resetPassword.toUpperCase().tr,
                                style: const TextStyle(
                                  decoration: TextDecoration.underline,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w400,
                                  fontSize: 12,
                                  color: AppColors.black1,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else {
                        // Return an empty widget when not email login
                        return const SizedBox(height: 10);
                      }
                    }),

                    /// Login Button
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black1,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          AppStrings.signIn.toUpperCase().tr,
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 16,
                            fontWeight: FontWeight.w700, // Bold
                          ),
                        ),
                      ),
                    ),

                    /// OR Divider
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.continueWithPhone,
                        // or any handler
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.colorButtonFade,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Obx(() {
                          return Text(
                            controller.isEmail.value
                                ? AppStrings
                                .continueWithPhoneNumber.toUpperCase().tr
                                : AppStrings.continueWithEmail.toUpperCase().tr,
                            // Switch text based on condition
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

                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Divider(color: AppColors.grey),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                          ),
                          child: Text(
                            AppStrings.app_or.toUpperCase().tr,
                            style: const TextStyle(
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w400, // Regular
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Divider(color: AppColors.grey),
                        ),
                      ],
                    ),

                    /// Login With
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        AppStrings.loginWith.tr,
                        style: const TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 14,
                          fontWeight: FontWeight.w600, // SemiBold
                          color: AppColors.colorTitleSignup,
                        ),
                      ),
                    ),

                    /// Social Buttons
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
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
                        const SizedBox(width: 12),
                        if (!GetPlatform.isAndroid)
                          GestureDetector(
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
                      ],
                    ),

                    /// Bottom Register
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.app_don_t_you_have_an_account.toUpperCase().tr,
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w400, // Regular
                            fontSize: 12,
                          ),
                        ),
                        TextButton(
                          onPressed: controller.goToRegister,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            // remove default padding
                            minimumSize: Size(0, 0),
                            tapTargetSize:
                            MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            AppStrings.appJoin.toUpperCase().tr,
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
              child: content
          ),
        ),
      );
    }

    return content;


  }
}
