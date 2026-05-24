import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../utils/app_colors.dart';

class EmployeeSuccessScreen extends StatelessWidget {
  const EmployeeSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final bool isEmployeeFlow =
        Get.arguments?["isEmployeeFlow"] == true;

    return Scaffold(
      key: const Key("registration_success_screen"),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              const Spacer(),

              /// Welcome Image
              Semantics(
                label: 'welcome_image',
                image: true,
                child: Image.asset(
                  'assets/images/img_welcome.png',
                  key: const Key("welcome_image"),
                  height: 180,
                  fit: BoxFit.contain,
                ),
              ),

              const SizedBox(height: 10),

              if (isEmployeeFlow) ...[
                Semantics(
                  label: 'employee_benifit_program',
                  child: Text(
                    AppStrings.APP_EMPLOYEE_BENEFITS_PROGRAMME.tr,
                    key: const Key("employee_benifit_program_text"),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),

                const SizedBox(height: 20),
              ],

              /// Title
              Semantics(
                label: 'success_title',
                child: Text(
                  AppStrings.APP_EMAIL_VERIFIED_SUCCESSFULLY.tr,
                  key: const Key("success_title"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              /// Subtitle
              Semantics(
                label: 'success_subtitle',
                child: Text(
                  AppStrings.APP_LOGIN_OR_SIGNUP_DISCOUNTS.tr,
                  key: const Key("success_subtitle"),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Nunito',
                    color: AppColors.colorTitle2,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Semantics(
                label: 'create_account_button',
                button: true,
                child:SizedBox(
                  key: const Key("create_account_button"),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (){
                      Get.offAllNamed(AppRoutes.signUp);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.black1,
                      foregroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      key: const Key("create_account_button_text"),
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

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.alreadyHaveAnAccount.toUpperCase().tr,
                    key: const Key("already_account_text"),
                    style: const TextStyle(
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(width: 10),

                  TextButton(
                    key: const Key("login_button"),
                    onPressed: () {
                      Get.offAllNamed(AppRoutes.login);
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      AppStrings.login.toUpperCase().tr,
                      style: const TextStyle(
                        decoration: TextDecoration.underline,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: AppColors.black1,
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}