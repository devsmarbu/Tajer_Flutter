import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:tajer/app/core/constants/app_constants.dart';

import '../../../../../common/widgets/common_dropdown_field.dart';
import '../../../../../common/widgets/common_text_field.dart';
import '../../../../../common/widgets/phone_field.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_strings.dart';
import '../controller/add_address_controller.dart';
import '../models/country_item.dart';
import '../models/state_item.dart';

class AddNewAddressScreen extends StatelessWidget {
  const AddNewAddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AddAddressController());

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        title: Text(
          AppStrings.appAddAddress.toUpperCase().tr,
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: const BackButton(),
      ),
      body: Container(
        color: AppColors.colorAccountBackground,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --- Name ---
                Obx(
                  () => CommonTextField(
                    label: "${AppStrings.appLabelName.toUpperCase().tr}*",
                    hint: AppStrings.appPleaseEnterYourName.toUpperCase().tr,
                    controller: controller.nameController,
                    errorText: controller.nameError.value.isNotEmpty
                        ? controller.nameError.value
                        : null,
                    keyboardType: TextInputType.name,
                    onChanged: controller.validateName,
                  ),
                ),
                const SizedBox(height: 10),

                // --- City ---
                Obx(
                  () => CommonTextField(
                    label: "${AppStrings.appHintCity.toUpperCase().tr}*",
                    hint: AppStrings.appCityError.toUpperCase().tr,
                    controller: controller.cityController,
                    errorText: controller.cityError.value.isNotEmpty
                        ? controller.cityError.value
                        : null,
                    keyboardType: TextInputType.name,
                    onChanged: controller.validateCity,
                  ),
                ),

                const SizedBox(height: 10),

                // --- Country Dropdown ---
                Obx(
                  () => CommonDropdownField(
                    label: "${AppStrings.appSelectCountry.toUpperCase().tr}*",
                    hint: "${AppStrings.appSelectYourCountry.toUpperCase().tr}*",
                    countryList: controller.countryList.value,
                    stateList: const [],
                    value: controller.selectedCountry.value,
                    backgroundColor: AppColors.colorAccountBackground,
                    onChanged: (countryObject) {
                      if (countryObject == null) return;
                      if (countryObject is CountryItem) {
                        controller.selectedCountry.value = countryObject;
                        controller.selectedState.value = null;
                        controller.addCountryId = countryObject.id ?? "";
                        controller.stateList.clear();
                        controller.addStateId = '';
                        controller.getStateList(
                          countryObject.id?.toString() ?? '',
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 12),

                // --- State Dropdown ---
                Obx(
                  () => CommonDropdownField(
                    label: "${AppStrings.appSelectState.toUpperCase().tr}*",
                    hint: "${AppStrings.appSelectState.toUpperCase().tr}*",
                    countryList: const [],
                    stateList: controller.stateList.value,
                    value: controller.selectedState.value,
                    backgroundColor: AppColors.colorAccountBackground,
                    onChanged: (stateObject) {
                      if (stateObject == null) return;
                      if (stateObject is StateItem) {
                        controller.selectedState.value = stateObject;
                        controller.addStateId = stateObject.id ?? "";
                        controller.validateState(stateObject.name ?? '');
                      }
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // --- Address Line 1 ---
                Obx(
                  () => CommonTextField(
                    label: "${AppStrings.appAddressLine1.toUpperCase().tr}*",
                    hint: AppStrings.appAddressLine1Error.toUpperCase().tr,
                    controller: controller.addressLine1Controller,
                    errorText: controller.addressLine1Error.value.isNotEmpty
                        ? controller.addressLine1Error.value
                        : null,
                    keyboardType: TextInputType.name,
                    onChanged: controller.validateAddressLine1,
                  ),
                ),

                const SizedBox(height: 10),

                // --- Address Line 2 ---
                Obx(
                  () => CommonTextField(
                    label: AppStrings.appAddressLine2.toUpperCase().tr,
                    hint: AppStrings.appAddressLine2Error.toUpperCase().tr,
                    controller: controller.addressLine2Controller,
                    errorText: controller.addressLine2Error.value.isNotEmpty
                        ? controller.addressLine2Error.value
                        : null,
                    keyboardType: TextInputType.name,
                  ),
                ),

                const SizedBox(height: 10),

                // --- Postal Code ---
                Obx(
                  () => CommonTextField(
                    label: "${AppStrings.appPostalCode.toUpperCase().tr}*",
                    hint: AppStrings.appErrorPostalCode.toUpperCase().tr,
                    controller: controller.postalCodeController,
                    errorText: controller.postalCodeError.value.isNotEmpty
                        ? controller.postalCodeError.value
                        : null,
                    keyboardType: TextInputType.number,
                    onChanged: controller.validatePostalCode,
                  ),
                ),

                const SizedBox(height: 10),

                // --- Zone ---
                Obx(
                  () => CommonTextField(
                    label: "${AppStrings.appZone.toUpperCase().tr}*",
                    hint: AppStrings.appErrorZone.toUpperCase().tr,
                    controller: controller.zoneController,
                    errorText: controller.zoneError.value.isNotEmpty
                        ? controller.zoneError.value
                        : null,
                    keyboardType: TextInputType.name,
                    onChanged: controller.validateZone,
                  ),
                ),

                const SizedBox(height: 10),

                // --- Street ---
                Obx(
                  () => CommonTextField(
                    label: "${AppStrings.appStreet.toUpperCase().tr}*",
                    hint: AppStrings.appErrorStreet.toUpperCase().tr,
                    controller: controller.streetController,
                    errorText: controller.streetError.value.isNotEmpty
                        ? controller.streetError.value
                        : null,
                    keyboardType: TextInputType.name,
                    onChanged: controller.validateStreet,
                  ),
                ),

                const SizedBox(height: 10),

                // --- Building No ---
                Obx(
                  () => CommonTextField(
                    label: "${AppStrings.appBuildingNo.toUpperCase().tr}*",
                    hint: AppStrings.appErrorBuildingNo.toUpperCase().tr,
                    controller: controller.buildingNoController,
                    errorText: controller.buildingNoError.value.isNotEmpty
                        ? controller.buildingNoError.value
                        : null,
                    keyboardType: TextInputType.name,
                    onChanged: controller.validateBuildingNo,
                  ),
                ),

                const SizedBox(height: 10),

                // --- Unit No ---
                Obx(
                  () => CommonTextField(
                    label: "${AppStrings.appUnitNo.toUpperCase().tr}*",
                    hint: AppStrings.appErrorUnitNo.toUpperCase().tr,
                    controller: controller.unitNoController,
                    errorText: controller.unitError.value.isNotEmpty
                        ? controller.unitError.value
                        : null,
                    keyboardType: TextInputType.name,
                    onChanged: controller.validateUnitNo,
                  ),
                ),

                const SizedBox(height: 10),

                // --- Phone Field + Verify Button ---
                Obx(
                  () => Row(
                    crossAxisAlignment:
                    controller.phoneError.value.isEmpty
                        ? CrossAxisAlignment.center
                        : CrossAxisAlignment.start,
                    children: [
                      // ---- Phone Field ----
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PhoneField(
                              controller: controller.phoneController,
                              errorText: controller.phoneError,
                              selectedCountryCode:
                                  controller.selectedCountryCode,
                              onChanged: controller.validatePhone,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),

                      // ---- Verify Button ----
                      Obx(
                            () => Padding(
                          padding: const EdgeInsets.only(top: 25),
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: controller.isPhoneValid.value ? controller.verifyPhone : null, // disable if already verified
                              style: ElevatedButton.styleFrom(
                                backgroundColor: controller.isPhoneValid.value
                                    ? Colors.black // active button color
                                    : Colors.grey.shade300, // disabled color
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                              ),
                              child: Text(
                                AppStrings.app_verify.tr,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Obx(() {
                  if (!controller.isOtpShow.value) {
                    // Hide the OTP field when not required
                    return const SizedBox.shrink();
                  }

                  // Show OTP field when isOtpShow = true (isVerified == 0)
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonTextField(
                        label: "${AppStrings.appOtpVerification.toUpperCase().tr}*",
                        hint: AppStrings.appPleaseEnterValidOtp.toUpperCase().tr,
                        controller: controller.otpController,
                        errorText: controller.otpError.value.isNotEmpty
                            ? controller.otpError.value
                            : null,
                        keyboardType: TextInputType.number,
                        onChanged: controller.validateOtp,
                      ),
                      const SizedBox(height: 20),
                    ],
                  );
                }),

                const SizedBox(height: 20),
                // --- Address Label ---
                Text(
                  AppStrings.appAddressLabel.toUpperCase().tr,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Obx(
                  () => Row(
                    children: [
                      for (var label in [AppStrings.appHome.toUpperCase().tr, AppStrings.appWork.toUpperCase().tr, AppStrings.appOther.toUpperCase().tr])
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ChoiceChip(
                            label: Text(label),
                            selected: controller.selectedLabel.value == label,
                            onSelected: (value) {
                              controller.selectedLabel.value = label;
                            },
                          ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // --- Default Address Checkbox ---
                Obx(
                  () => CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(AppStrings.appMarkAsDefaultAddress.toUpperCase().tr),
                    value: controller.isDefault.value,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      controller.isDefault.value = value!;
                    },
                  ),
                ),

                const SizedBox(height: 20),

                // --- Save & Continue Button ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.saveAddress,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Text(
                      AppStrings.appSaveContinue.toUpperCase().tr,
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
