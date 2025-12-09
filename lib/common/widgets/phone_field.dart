import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/change_phone_number/change_phone_controller.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../utils/app_colors.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final RxString? errorText; // ✅ Made optional
  final RxString selectedCountryCode;
  final Function(String)? onChanged;
  final Color? backgroundColor;
  final double? fontSize;

  const PhoneField({
    super.key,
    required this.controller,
    required this.selectedCountryCode,
    required this.onChanged,
    this.errorText, // ✅ optional
    this.backgroundColor = Colors.white,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final hasError = errorText != null && errorText!.value.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.appPhoneNumber.toUpperCase().tr,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          // ✅ Combined border container
          Container(
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: hasError ? AppColors.redColor1 : AppColors.dashboardBgd,
                width: hasError ? 1.5 : 1,
              ),
            ),
            child: Row(
              children: [
      // ✅ Country picker (no divider)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: CountryCodePicker(
                    initialSelection: selectedCountryCode.value, // default to India
                    favorite: const ['+91', '+1'],
                    showCountryOnly: false,
                    showOnlyCountryWhenClosed: false,
                    alignLeft: false,
                    padding: EdgeInsets.zero,
                    onChanged: (code) {
                      selectedCountryCode.value =
                      "${code.dialCode}";
                    },
                  ),
                ),

                // ✅ Expanded phone field
                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: AppStrings.appPleaseEnterPhoneNumber.toUpperCase().tr,
                      hintStyle: TextStyle(
                        color: AppColors.offWhite2,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w500,
                        fontSize: fontSize ?? 14,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 14,
                      ),
                      suffixIcon: hasError
                          ? Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          "assets/icons/ic_error.svg",
                          height: 16,
                          width: 16,
                        ),
                      )
                          : null,
                    ),
                    style: TextStyle(
                      color: AppColors.black1,
                      fontFamily: "Nunito",
                      fontSize: fontSize ?? 14.0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ✅ Optional error text
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                errorText!.value,
                style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
        ],
      );
    });
  }
}
