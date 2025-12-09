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

class RegistraionScreen extends StatelessWidget {
  const RegistraionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());
    final controllerSocial = Get.put(SocialController());

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.createAnAccount.toUpperCase().tr,
              style: const TextStyle(
                fontFamily: "Nunito",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.black1,
              ),
            ),
            Text(
              AppStrings.letsCreateYourAccount.toUpperCase().tr,
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
                    /// Conditionally show Email + Password OR Phone
                    Column(
                      children: [
                        //Name field
                        Obx(
                          () => CommonTextField(
                            label: AppStrings.appLabelName.toUpperCase().tr,
                            hint: AppStrings.pleaseEnterYourName.toUpperCase().tr,
                            controller: controller.nameController,
                            errorText: controller.nameError.value.isNotEmpty
                                ? controller.nameError.value
                                : null,
                            keyboardType: TextInputType.name,
                            onChanged: controller.validateName,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // UserName field
                        Obx(
                          () => CommonTextField(
                            label: AppStrings.appUsername.toUpperCase().tr,
                            hint: AppStrings.pleaseEnterYourUserName.toUpperCase().tr,
                            controller: controller.userNameController,
                            errorText: controller.userNameError.value.isNotEmpty
                                ? controller.userNameError.value
                                : null,
                            keyboardType: TextInputType.name,
                            onChanged: controller.validateUserName,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Email Field
                        Obx(
                          () => CommonTextField(
                            label: AppStrings.appEmail.toUpperCase().tr,
                            hint: AppStrings.pleaseEnterEmail.toUpperCase().tr,
                            controller: controller.emailController,
                            errorText: controller.emailError.value.isNotEmpty
                                ? controller.emailError.value
                                : null,
                            keyboardType: TextInputType.emailAddress,
                            onChanged: controller.validateEmail,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Password Field
                        Obx(
                          () => CommonTextField(
                            label: AppStrings.appPassword.toUpperCase().tr,
                            hint: AppStrings.appEnterYourPassword.toUpperCase().tr,
                            controller: controller.passwordController,
                            errorText: controller.passwordError.value.isNotEmpty
                                ? controller.passwordError.value
                                : null,
                            obscureText: true,
                            onChanged: controller.validatePassword,
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Confirm Password Field
                        Obx(
                          () => CommonTextField(
                            label: AppStrings.confirmPassword.tr,
                            hint: AppStrings.appPleaseEnterYourConfirmPassword.toUpperCase().tr,
                            controller: controller.confirmPasswordController,
                            errorText:
                                controller.confirmPasswordError.value.isNotEmpty
                                ? controller.confirmPasswordError.value
                                : null,
                            obscureText: true,
                            onChanged: controller.validateConfirmPassword,
                          ),
                        ),
                        Obx(
                              () => CheckboxListTile(
                                checkColor: AppColors.black,
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                    AppStrings.appAgreeTermsConditions.toUpperCase().tr,
                                  style: TextStyle(
                                    fontFamily: "Nunito",
                                    fontSize: 14,
                                    fontWeight: FontWeight.w300
                                  ),
                                ),
                                value: controller.isCheckTerms.value,
                                controlAffinity: ListTileControlAffinity.leading,
                                onChanged: (value) {
                                  controller.isCheckTerms.value = value!;
                                },
                              ),
                        )
                      ],
                    ),

                    /// Login Button
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.signUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black1,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          AppStrings.appContinue.toUpperCase().tr,
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontSize: 16,
                            fontWeight: FontWeight.w700, // Bold
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    /// OR Divider
                    Row(
                      children: [
                        const Expanded(child: Divider(color: AppColors.grey)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
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
                        const Expanded(child: Divider(color: AppColors.grey)),
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
                          onTap: (){
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
                        const SizedBox(width: 12),
                        if(!GetPlatform.isAndroid)
                        GestureDetector(
                          onTap: (){
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.alreadyHaveAnAccount.toUpperCase().tr,
                          style: const TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w400, // Regular
                            fontSize: 12,
                          ),
                        ),
                        TextButton(
                          onPressed: controller.goToLogin,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            AppStrings.signIn.toUpperCase().tr,
                            style: const TextStyle(
                              decoration: TextDecoration.underline,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w700, // Bold
                              fontSize: 12,
                              color: AppColors.black1,
                            ),
                          ),
                        ),
                      ],
                    )
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
}
