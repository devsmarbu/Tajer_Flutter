import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/address/addAddress/models/custom_country.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../translations/localization_service.dart';
import '../../utils/app_colors.dart';
import '../controller/country_controller.dart';

class PhoneField extends StatelessWidget {
  final TextEditingController controller;
  final RxString? errorText;
  final RxString selectedCountryCode;
  final Function(String)? onChanged;
  final Color? backgroundColor;
  final double? fontSize;
  final bool isEnabled;

  final String? actionText;
  final VoidCallback? onActionTap;

  // ✅ Single controller instance
  final CountryController controllerCountry =
      Get.isRegistered<CountryController>()
      ? Get.find<CountryController>()
      : Get.put(CountryController());

  PhoneField({
    super.key,
    required this.controller,
    required this.selectedCountryCode,
    required this.onChanged,
    this.errorText,
    this.backgroundColor = Colors.white,
    this.fontSize,
    this.isEnabled = true,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {

    return Obx(() {
      final hasError = errorText != null && errorText!.value.isNotEmpty;

      CustomCountry? selectedCountry;
      try {
        selectedCountry = controllerCountry.countries.firstWhere(
              (c) => c.dialCode == selectedCountryCode.value,
        );
      } catch (e) {
        selectedCountry = null;
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((AppStrings.appPhoneNumber.isNotEmpty) || (actionText ?? '').isNotEmpty)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.appPhoneNumber.toUpperCase().tr,
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  ),
                ),

                if ((actionText ?? '').isNotEmpty)
                  GestureDetector(
                    onTap: onActionTap,
                    child: Text(
                      actionText!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                      ),
                    ),
                  ),
              ],
            ),
          const SizedBox(height: 6),

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
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: IgnorePointer(
                    ignoring: !isEnabled,
                    child: SizedBox(
                      height: 50,
                      child: GestureDetector(
                        onTap: () {
                          if (!isEnabled) return;

                          showCountryPicker(context, (country) {
                            selectedCountryCode.value = country.dialCode;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          height: 50,
                          child: Row(
                            children: [
                              Text(
                                selectedCountry?.flag ?? "🌍",
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 6),
                              Obx(() => Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  selectedCountryCode.value,
                                  textAlign: TextAlign.left,
                                ),
                              )),
                              const Icon(Icons.arrow_drop_down),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: TextField(
                    controller: controller,
                    onChanged: onChanged,
                    enabled: isEnabled,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: AppStrings.appPleaseEnterPhoneNumber
                          .toUpperCase()
                          .tr,
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

  void showCountryPicker(
    BuildContext context,
    Function(CustomCountry) onSelect,
  ) {
    final TextEditingController searchController = TextEditingController();
    final RxString searchText = "".obs;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // ✅ IMPORTANT
      backgroundColor: Colors.transparent, // optional (for rounded corners look)
      builder: (_) {
        return Obx(() {
          final lang =
              LocalizationService.to.appLocale.value.languageCode;

          final List<CustomCountry> filtered = controllerCountry.countries
              .where((c) {
            final query =
            searchText.value.toLowerCase().replaceAll('+', '');

            return c.getName(lang).toLowerCase().contains(query) ||
                c.dialCode.replaceAll('+', '').contains(query) ||
                c.code.toLowerCase().contains(query);
          })
              .toList();

          return DraggableScrollableSheet(
            initialChildSize: 0.95, // ✅ almost full screen
            minChildSize: 0.5,
            maxChildSize: 0.95,
            expand: false,
            builder: (_, scrollController) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Column(
                  children: [
                    const SizedBox(height: 12),

                    // drag handle
                    Container(
                      height: 4,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // 🔍 Search
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: TextField(
                        controller: searchController,
                        decoration: InputDecoration(
                          hintText: AppStrings.appSearch.toUpperCase().tr,
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          searchText.value = value;
                        },
                      ),
                    ),

                    // 📋 LIST (IMPORTANT CHANGE)
                    Expanded(
                      child: controllerCountry.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : filtered.isEmpty
                          ? const Center(child: Text("No countries found"))
                          : ListView.builder(
                        controller: scrollController, // ✅ IMPORTANT
                        itemCount: filtered.length,
                        itemBuilder: (_, index) {
                          final country = filtered[index];

                          return ListTile(
                            leading: Text(country.flag,
                                style: const TextStyle(fontSize: 22)),
                            title: Text(country.getName(lang)),
                            trailing: Directionality(textDirection: TextDirection.ltr, child: Text(country.dialCode)),
                            onTap: () {
                              onSelect(country);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        });
      },
    );
  }
}
