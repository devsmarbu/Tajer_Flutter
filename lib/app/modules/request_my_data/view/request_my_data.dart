import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/utils/app_params.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../common/widgets/common_text_field.dart';
import '../../../../utils/app_colors.dart';
import '../controller/request_data_controller.dart';

class RequestMyData extends StatelessWidget {
  RequestMyData({super.key});

  //request conteroller
  final RequestDataController controller = Get.put(RequestDataController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          AppStrings.appRequestData.toUpperCase().tr,
          style: TextStyle(
            fontFamily: "Nunito",
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Obx(
              () => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.appRequestInfo.toUpperCase().tr,
                      style: TextStyle(
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Non-editable Name
                    AbsorbPointer(
                      child: CommonTextField(
                        label: AppStrings.appLabelName.toUpperCase().tr,
                        hint:  AppStrings.appLabelName.toUpperCase().tr,
                        controller: controller.nameController,
                        backgroundColor: AppColors.colorAccountBackground,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Non-editable Email
                    AbsorbPointer(
                      child: CommonTextField(
                        label:  AppStrings.appEmail.toUpperCase().tr,
                        hint: AppStrings.appEmail.toUpperCase().tr,
                        controller: controller.emailController,
                        backgroundColor: AppColors.colorAccountBackground,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Editable Message Field
                    CommonTextField(
                      label: AppStrings.appWriteYourMessage.toUpperCase().tr,
                      hint: AppStrings.appWriteYourMessage.toUpperCase().tr,
                      controller: controller.messageController,
                      maxLines: 7,
                      backgroundColor: AppColors.colorAccountBackground,
                    ),
                    const SizedBox(height: 12),

                    // GDPR Policy Link
                    RichText(
                      text: TextSpan(
                        text: AppStrings.appClickHere.toUpperCase().tr,
                        style: const TextStyle(
                          fontFamily: "Nunito",
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                           final url="${AppConstants.imageBaseURLPath}/privacy-policies?appuser=1&lang_id=${controller.pref.loadString(AppConstants.siteLangId)}&currency_id=${controller.pref.loadString(AppConstants.currencyId)}";
                            controller.navigateToWebView(AppStrings.appRequestData.toUpperCase().tr, url);
                          },
                        children: [
                          TextSpan(
                            text: AppStrings.appAgreePrivacy.toUpperCase().tr,
                            style: TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: controller.onSubmit,
                        child: controller.isLoading.value
                            ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                            : Text(
                          AppStrings.appSubmit.toUpperCase().tr,
                          style: TextStyle(
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
