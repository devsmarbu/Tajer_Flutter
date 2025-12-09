import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/app_colors.dart';
import '../controller/confirm_phone_otp_controller.dart';

class ConfirmPhoneOtpView extends StatelessWidget {
  final String phoneNumber;
  final String dCode;
  final String userId;
  final bool isUpdate;

  const ConfirmPhoneOtpView({super.key,required this.dCode, required this.phoneNumber,required this.userId, required this.isUpdate});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConfirmPhoneOtpController(phoneNumber));
    controller.userID.value=userId;
    controller.isUpdate.value=isUpdate;
    controller.dCode.value=dCode;

    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text(
          AppStrings.app_confirm_your_number,
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "We have sent a verification code to\n${controller.dCode+controller.phoneNumber}",
              style: const TextStyle(
                fontSize: 15,
                fontFamily: "Nunito",
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 30),

            // 🔹 OTP Input
            Center(
              child: Pinput(
                length: 4,
                controller: controller.otpController,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: defaultPinTheme.copyWith(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.black1),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.white,
                  ),
                ),
                submittedPinTheme: defaultPinTheme,
                showCursor: true,
                keyboardType: TextInputType.number,
              ),
            ),

            const SizedBox(height: 20),

            // 🔹 Countdown
            Obx(() => Center(
              child: InkWell(
                onTap: controller.remainingSeconds.value == 0
                    ? controller.resendOtp
                    : null,
                child: Text(
                  controller.remainingSeconds.value > 0
                      ? "If you didn't receive code 00:${controller.remainingSeconds.value.toString().padLeft(2, '0')}"
                      : "Didn't receive code? Resend",
                  style: TextStyle(
                    color: controller.remainingSeconds.value == 0
                        ? AppColors.black1
                        : Colors.grey.shade600,
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    fontFamily: "Nunito",
                  ),
                ),
              ),
            )),

            const Spacer(),

            // 🔹 Next Button
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : controller.verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.black1,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  AppStrings.appNext.toUpperCase().tr,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
