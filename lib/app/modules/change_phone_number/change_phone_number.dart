import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:tajer/app/modules/otp_verification_screen/controller/confirm_phone_otp_controller.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../common/widgets/phone_field.dart';
import '../../../utils/app_colors.dart';
import 'change_phone_controller.dart';

class UpdatePhoneNumberView extends StatelessWidget {
  const UpdatePhoneNumberView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ChangePhoneController());

    final screenWidth = MediaQuery.of(context).size.width;
    final boxWidth = (screenWidth - 40 /*padding*/ - 30 /*spacing*/) / 4;

    final defaultPinTheme = PinTheme(
      width: boxWidth,
      height: 55,
      textStyle: const TextStyle(
        fontSize: 20,
        fontFamily: 'Nunito',
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.dashboardBgd),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar:  AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          controller.title,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: const BackButton(color: Colors.black),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child:
              Obx((){
                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ✅ Only reactive inside PhoneField (not here)
                    PhoneField(
                      controller: controller.phoneController,
                      errorText: controller.phoneError,
                      selectedCountryCode: controller.selectedCountryCode,
                      backgroundColor: AppColors.white,
                      onChanged: (val) {
                        if (val.isNotEmpty) controller.phoneError.value = "";

                        final fullNumber =
                            "${controller.selectedCountryCode.value}${val.trim()}";

                        controller.isAlreadyVerified.value =
                            controller.verifiedNumbers.contains(fullNumber);
                      },
                    ),

                    const SizedBox(height: 20),

                    /// OTP SECTION
                    if (controller.isOtpSent.value) ...[
                      Text(AppStrings.appEnterOtp.toUpperCase().tr,style: const TextStyle(fontSize: 14,fontFamily: 'Nunito', fontWeight: FontWeight.w600)),

                      const SizedBox(height: 10),

                      Pinput(
                        length: 6,
                        controller: controller.otpController,
                        defaultPinTheme: defaultPinTheme,

                        focusedPinTheme: defaultPinTheme.copyWith(
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.dashboardBgd),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                          ),
                        ),

                        submittedPinTheme: defaultPinTheme,

                        showCursor: true,
                        keyboardType: TextInputType.number,

                        onCompleted: (pin) {
                          controller.isOtpFilled.value = true;
                        },

                        onChanged: (value) {
                          controller.isOtpFilled.value = value.length == 4;
                        },
                      ),

                      const SizedBox(height: 10),

                      /// ⏱ Timer / Resend
                      Obx(() {
                        final isExpired = controller.seconds.value == 0;

                        return GestureDetector(
                          onTap: isExpired ? controller.getOtpClick : null,
                          child: isExpired
                              ? Text(
                            AppStrings.appResendOtp.toUpperCase().tr,
                            style: TextStyle(
                              fontSize: 12,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          )
                              : RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontFamily: 'Nunito',
                              ),
                              children: [
                                TextSpan(text: AppStrings.appResendOtpIn.toUpperCase().tr),
                                TextSpan(
                                  text: "${controller.seconds.value}",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                      fontFamily: 'Nunito'
                                  ),
                                ),
                                const TextSpan(text: " secs",
                                    style: const TextStyle(fontWeight: FontWeight.w600,
                                      fontFamily: 'Nunito'
                                )),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 20),
                    ],

                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        onPressed: () {
                          if (!controller.isOtpSent.value) {
                            if (controller.isAlreadyVerified.value) {
                              controller.verifyOtpApi(""); // direct update
                            } else {
                              controller.getOtpClick();
                            }
                          } else if (controller.isOtpFilled.value) {
                            controller.verifyOtp();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.black1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          !controller.isOtpSent.value
                              ? controller.isAlreadyVerified.value
                              ? AppStrings.appUpdate.toUpperCase().tr
                              : AppStrings.appSendOtpToVerify.toUpperCase().tr
                              : controller.isOtpFilled.value
                              ? AppStrings.appConfirmOtp.toUpperCase().tr
                              : AppStrings.appOtpSent.toUpperCase().tr,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    infoBox()
                  ],
                );
              })
        ),
      ),
    );
  }

  Widget infoBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF86B3FF).withOpacity(0.2), // 20%
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF86B3FF),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.info_outline,
            size: 16,
            color: Color(0xFF86B3FF),
          ),
          const SizedBox(width: 8),

          Expanded(
            child: Text(
              AppStrings.appPleaseNoteChangingThisWill.toUpperCase().tr,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                height: 1.4,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
