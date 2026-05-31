import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../common/widgets/common_text_field.dart';
import '../../../../common/widgets/phone_field.dart';
import 'contact_us_controller.dart';

class ContactUsScreen extends StatelessWidget {
  final controller = Get.put(ContactUsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        leading: const BackButton(),
        title: Text(
          AppStrings.appContactUs.toUpperCase().tr,
          style: TextStyle(
            fontFamily: "Nunito",
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // --- Name Field ---
              CommonTextField(
                label: "",
                hint: AppStrings.appLabelName.toUpperCase().tr,
                controller: controller.nameController,
                backgroundColor: AppColors.colorAccountBackground,
                errorText: controller.nameError.value.isEmpty
                    ? null
                    : controller.nameError.value,
                onChanged: controller.validateName,
              ),

              // --- Email Field ---
              const SizedBox(height: 12),
              CommonTextField(
                label: "",
                hint: AppStrings.appEmail.toUpperCase().tr,
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                backgroundColor: AppColors.colorAccountBackground,
                errorText: controller.emailError.value.isEmpty
                    ? null
                    : controller.emailError.value,
                onChanged: controller.validateEmail,
              ),

              // --- Phone Field ---
              const SizedBox(height: 12),
              PhoneField(
                controller: controller.phoneController,
                selectedCountryCode: controller.selectedCountryCode,
                errorText: controller.phoneError,
                backgroundColor: AppColors.colorAccountBackground,
                onChanged: controller.validatePhone,
              ),

              // --- Message Field ---
              const SizedBox(height: 12),
              CommonTextField(
                label: "",
                hint: AppStrings.appWriteYourMessage.toUpperCase().tr,
                controller: controller.messageController,
                maxLines: 5,
                backgroundColor: AppColors.colorAccountBackground,
                errorText: controller.messageError.value.isEmpty
                    ? null
                    : controller.messageError.value,
                onChanged: controller.validateMessage,
              ),

              const SizedBox(height: 12),

              // --- Agreement Checkbox ---
              CheckboxListTile(
                title: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: "Nunito",
                      fontSize: 13,
                      color: Colors.black,
                    ),
                    children: [
                      TextSpan(text: "${AppStrings.appIAgreeToThe.toUpperCase().tr} "),

                      // --- Terms & Conditions clickable ---
                      TextSpan(
                        text: AppStrings.appTermCondition.toUpperCase().tr,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer(),
                        // ..onTap = () => controller.openTerms(),
                      ),

                      TextSpan(text: " ${"APP_AND".tr} "),

                      // --- Privacy Policy clickable ---
                      TextSpan(
                        text: AppStrings.appPrivacy.toUpperCase().tr,
                        style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue,
                        ),
                        recognizer: TapGestureRecognizer(

                        ),
                        // ..onTap = () => controller.openPrivacy(),

                      ),
                    ],
                  ),
                ),
                value: controller.isAgreed.value,
                onChanged: (val) => controller.isAgreed.value = val ?? false,
              ),

              const Spacer(),

              // --- Submit Button ---
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submitForm,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    AppStrings.appSubmit.toUpperCase().tr,
                    style: TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
