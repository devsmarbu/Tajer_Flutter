import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../common/widgets/phone_field.dart';
import '../../../utils/app_colors.dart';
import 'change_phone_controller.dart';

class UpdatePhoneNumberView extends StatelessWidget {
  const UpdatePhoneNumberView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePhoneController());

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          controller.title,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                controller.isUpdate
                    ? AppStrings.app_please_enter_your_new_phone_number_a_verification_code_will_be_sent_to_the_new_number.toUpperCase().tr
                    : "Please enter your phone number to verify and update your account.",
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 30),

              // ✅ Only reactive inside PhoneField (not here)
              PhoneField(
                controller: controller.phoneController,
                errorText: controller.phoneError,
                selectedCountryCode: controller.selectedCountryCode,
                backgroundColor: AppColors.colorAccountBackground,
                onChanged: (val) {
                  if (val.isNotEmpty) controller.phoneError.value = "";
                },
              ),

              const SizedBox(height: 80),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: controller.getOtpClick,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    AppStrings.appGetOtp.toUpperCase().tr,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
