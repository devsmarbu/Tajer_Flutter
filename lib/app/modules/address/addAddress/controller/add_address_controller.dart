import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/address/addAddress/models/country_data.dart';
import 'package:tajer/app/modules/address/addAddress/models/state_item.dart';
import 'package:tajer/utils/common_data.dart';
import '../../../../../../utils/app_strings.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../utils/app_loader.dart';
import '../../../../../utils/base_response.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../change_phone_number/change_phone_controller.dart';
import '../../../orders/orderDetail/models/address.dart';
import '../../address_api_client.dart';
import '../models/country_item.dart';

class AddAddressController extends GetxController with AddressApiClient, AppLoader {

  // -------------------- Text Controllers --------------------
  final nameController = TextEditingController();
  final cityController = TextEditingController();
  final addressLine1Controller = TextEditingController();
  final addressLine2Controller = TextEditingController();
  final postalCodeController = TextEditingController();
  final zoneController = TextEditingController();
  final streetController = TextEditingController();
  final buildingNoController = TextEditingController();
  final unitNoController = TextEditingController();
  final phoneController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  // -------------------- Reactive Error Strings --------------------
  final nameError = ''.obs;
  final cityError = ''.obs;
  final addressLine1Error = ''.obs;
  final addressLine2Error = ''.obs;
  final postalCodeError = ''.obs;
  final zoneError = ''.obs;
  final streetError = ''.obs;
  final buildingNoError = ''.obs;
  final unitError = ''.obs;
  final phoneError = ''.obs;
  final countryError = ''.obs;
  final stateError = ''.obs;
  final otpError = ''.obs;
  final isPhoneValid = false.obs;
  final isOtpShow = false.obs;
  final addId = ''.obs;

  // -------------------- Phone Country Code --------------------
  final selectedCountryCode = getDialCodeFromISO(getDeviceISO()).obs;

  // -------------------- Country / State --------------------
  var countryList = <CountryItem>[].obs;
  var stateList = <StateItem>[].obs;

  var selectedCountry = Rxn<CountryItem>();
  var selectedState = Rxn<StateItem>();

  // For backend IDs (if needed)
  String addCountryId = "";
  String addStateId = "";
  RxString addressIsDefault = "0".obs;
  Map<String, String> verifiedNumbers = {};

  // -------------------- Other Fields --------------------
  final selectedLabel = 'Home'.obs; // Address label
  final isDefault = false.obs; // Default checkbox

  // -------------------- Form Key --------------------
  final formKey = GlobalKey<FormState>();
 // init
  @override
  void onInit() {
    super.onInit();
    // Receive verified numbers map from previous screen
    final args = Get.arguments;

    if (args != null && args['verifiedNumbers'] != null) {
      verifiedNumbers = Map<String, String>.from(args['verifiedNumbers']);
    }
    if (args != null && args['addressIsDefault'] != null) {
      addressIsDefault.value = args["addressIsDefault"].toString();
    }

    if (args != null && args['addressDetail'] != null) {
      final address = args?["addressDetail"] as Address?;
      updateAddress(address!);
    }
    else {
      selectedCountryCode.value = getDialCodeFromISO(getDeviceISO());
    }

    // 🔹 Listen whenever country code changes
    ever(selectedCountryCode, (code) {
      validatePhone(phoneController.text);
    });

    getCountryList();
  }

  
  void updateAddress(Address address){
    nameController.text=address.addrName.toString();
    cityController.text=address.addrCity.toString();
    addressLine1Controller.text=address.addrAddress1.toString();
    addressLine2Controller.text=address.addrAddress2.toString();
    postalCodeController.text=address.addrZip.toString();
    zoneController.text=address.addrZone.toString();
    streetController.text=address.addrStreet.toString();
    buildingNoController.text=address.addrBuildingNo.toString();
    unitNoController.text=address.addrUnitNo.toString();
    phoneController.text=address.addrPhone.toString();
    validatePhone(phoneController.text);
    // If the backend stores the dial code (e.g. "+91" or "91"), use it.
    if (address.addrPhoneDcode != "") {
      selectedCountryCode.value = (address.addrPhoneDcode ?? "+91").split('-')[0];
    }
    selectedLabel.value=address.addrTitle.toString();
    addId.value=address.addrId.toString();

    addCountryId = address.addrCountryId?.toString() ?? "";
    addStateId = address.addrStateId?.toString() ?? "";
    if (countryList.isNotEmpty && addCountryId.isNotEmpty) {
      final matches = countryList.where((c) => c.id?.toString() == addCountryId).toList();
      if (matches.isNotEmpty) {
        selectedCountry.value = matches.first;
        // load states for this country
        getStateList(matches.first.id?.toString() ?? "");
      }
    }

  }
  // ----
  //---------------- Validation Methods --------------------
  void validateName(String value) {
    nameError.value = value.trim().isEmpty ? AppStrings.appPleaseEnterYourName.tr : '';
  }

  void validateCity(String value) {
    cityError.value = value.trim().isEmpty ? AppStrings.app_city_error.tr : '';
  }

  void validateAddressLine1(String value) {
    addressLine1Error.value =
    value.trim().isEmpty ? AppStrings.app_addressline1_error.tr : '';
  }

  void validatePostalCode(String value) {
    postalCodeError.value =
    value.trim().isEmpty ? AppStrings.app_error_postal_code.tr : '';
  }

  void validateZone(String value) {
    zoneError.value = value.trim().isEmpty ? AppStrings.app_error_zone.tr : '';
  }

  void validateStreet(String value) {
    streetError.value =
    value.trim().isEmpty ? AppStrings.app_error_street.tr : '';
  }

  void validateBuildingNo(String value) {
    buildingNoError.value =
    value.trim().isEmpty ? AppStrings.app_error_building_no.tr : '';
  }

  void validateUnitNo(String value) {
    unitError.value = value.trim().isEmpty ? AppStrings.app_error_unit_no.tr : '';
  }


  /// Replace the existing validatePhone(...) with this:
  void validatePhone(String value) {
    final trimmed = value.trim();

    // Always clear any phone error (we don't want validation errors shown).
    phoneError.value = '';
    int requiredLength = getPhoneLength(selectedCountryCode.value);
    // Build full number for verification check
    String fullPhone = selectedCountryCode.contains('-')
        ? selectedCountryCode.split('-')[0] + trimmed
        : selectedCountryCode + trimmed;
    // CASE 1 → Already verified → hide button
    if (verifiedNumbers.containsKey(fullPhone)) {
      isPhoneValid.value = false;  // hide/disable button
      isOtpShow.value = false;
      Get.snackbar(AppConstants.appName, AppStrings.app_phone_number_already_verified.toUpperCase().tr);
      return;
    }

    // Show Verify button only when user typed 10 or more characters.
    // Otherwise hide/disable it.
    if (trimmed.length == requiredLength) {
      isPhoneValid.value = true;
    } else {
      isPhoneValid.value = false;
    }
  }


  void validateOtp(String value) {
    if (value.isEmpty) {
      otpError.value = AppStrings.app_error_valid_otp.tr;
    //  Get.snackbar(AppConstants.appName, "Please select country");
    } else {
      otpError.value = "";
    }
  }

  void validateCountry(String value) {
    if (value.isEmpty) {
      countryError.value = "Please select country";
   //   Get.snackbar(AppConstants.appName, "Please select country");
    } else {
      countryError.value = "";
    }
  }

  void validateState(String value) {
    if (value.isEmpty) {
      stateError.value = "Please select state name";
   //   Get.snackbar(AppConstants.appName, "Please select state name");
    } else {
      stateError.value = "";
    }
  }


  // -------------------- Save Address --------------------
  void saveAddress() {
    // Validate all fields
    validateName(nameController.text);
    validateCity(cityController.text);
    validateCountry(selectedCountry.value?.name??"");
    validateState(selectedState.value?.name??"");
    validateAddressLine1(addressLine1Controller.text);
    validatePostalCode(postalCodeController.text);
    validateZone(zoneController.text);
    validateStreet(streetController.text);
    validateBuildingNo(buildingNoController.text);
    validateUnitNo(unitNoController.text);
    // validatePhone(phoneController.text);


    if (_isFormValid()) {
      final isDefaultValue = isDefault.value ? '1' : '0';

      // Assign backend IDs for demo
      addStateId = selectedState.value!.id.toString();

      addAddress(
        selectedLabel.value,
        nameController.text,
        addressLine1Controller.text,
        addressLine2Controller.text,
        addCountryId,
        addStateId,
        cityController.text,
        postalCodeController.text,
        phoneController.text,
        addId.value,
        isDefaultValue,
        selectedCountryCode.value,
        zoneController.text,
        streetController.text,
        buildingNoController.text,
        unitNoController.text,
        otpController.text,
      );
    } else {
      Get.snackbar(
        "Error",
        "Please fill all required fields",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade400,
        colorText: Colors.white,
      );
    }
  }

  bool _isFormValid() {
    printFormErrors();
    return nameError.value.isEmpty &&
        cityError.value.isEmpty &&
        addressLine1Error.value.isEmpty &&
        postalCodeError.value.isEmpty &&
        zoneError.value.isEmpty &&
        streetError.value.isEmpty &&
        buildingNoError.value.isEmpty &&
        unitError.value.isEmpty &&
        phoneError.value.isEmpty &&
        countryError.value.isEmpty &&
        stateError.value.isEmpty;
  }

  bool isNumberVerified(String fullPhone) {
    return verifiedNumbers.containsKey(fullPhone);
  }

  void printFormErrors() {
    final Map<String, String> errors = {
      "Name": nameError.value,
      "City": cityError.value,
      "Address Line 1": addressLine1Error.value,
      "Postal Code": postalCodeError.value,
      "Zone": zoneError.value,
      "Street": streetError.value,
      "Building No": buildingNoError.value,
      "Unit": unitError.value,
      "Phone": phoneError.value,
      "Country": countryError.value,
      "State": stateError.value,
    };

    errors.forEach((field, errorMsg) {
      if (errorMsg.isNotEmpty) {
        debugPrint("$field error → $errorMsg");
      }
    });
  }
  // -------------------- Dispose --------------------
  @override
  void onClose() {
    nameController.dispose();
    cityController.dispose();
    addressLine1Controller.dispose();
    addressLine2Controller.dispose();
    postalCodeController.dispose();
    zoneController.dispose();
    streetController.dispose();
    buildingNoController.dispose();
    unitNoController.dispose();
    phoneController.dispose();
    super.onClose();
  }

  Future<void> addAddress(
      String addressTitle,
      String addressName,
      String addressLine1,
      String addressLine2,
      String addCountryId,
      String addStateId,
      String addCity,
      String addZip,
      String addPhone,
      String addId,
      String isDefault,
      String addPhoneDcode,
      String addZone,
      String addStreet,
      String addBuildingNo,
      String addUnitNo,
      String addPhoneOtp,
      ) async {
    if (!await AppFunction.isInternetAvailable()) {
      AppDialog.showMessage("No internet connection. Please try again later.");
      return;
    }

    final context = Get.overlayContext ?? Get.context;

    if (context == null) {
      debugPrint("⚠️ Context not available for loader");
      return;
    }

    showLoader(context); // ✅ Always show before try

    try {
      final response = await setUpAddress(
        addressTitle,
        addressName,
        addressLine1,
        addressLine2,
        addCountryId,
        addStateId,
        addCity,
        addZip,
        addPhone,
        addId,
        isDefault,
        addPhoneDcode,
        addZone,
        addStreet,
        addBuildingNo,
        addUnitNo,
        addPhoneOtp,
      );

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final addressData = BaseResponse<CommonData>.fromJson(
        body,
        fromJsonT: (data) => CommonData.fromJson(data),
      );

      hideLoader(context);

      if (addressData.responseCode == "200" &&
          addressData.status == AppConstants.SUCCESS) {
        Future.delayed(const Duration(milliseconds: 300), () {
          Get.back(result: true);
          Get.snackbar(
            AppConstants.appName,
            addressData.msg,
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
          );
        });
      } else {
        AppDialog.showMessage(addressData.msg);
      }
    } catch (e, st) {
      debugPrint('❌ Exception in addAddress: $e\n$st');
      hideLoader(context); // ✅ Always close loader
      AppDialog.showMessage("Something went wrong. Please try again.");
    }
  }


  // -------------------- Add Address API --------------------
  Future<void> getCountryList() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        showLoader(Get.context!);

        final response = await getCountryListApi();

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final data = BaseResponse<CountryData>.fromJson(
          body,
          fromJsonT: (data) => CountryData.fromJson(data),
        );

        if (data.responseCode == "200") {

          countryList.assignAll(data.data?.countries as Iterable<CountryItem>);
          // If we have an address country id (from updateAddress), pick its instance from the loaded list
          if (addCountryId.isNotEmpty) {
            final matches = countryList.where((c) => c.id?.toString() == addCountryId).toList();
            if (matches.isNotEmpty) {
              selectedCountry.value = matches.first;
              // Ensure we request states for that country so states list is populated
              // and selectedState can be set later from addStateId
              await getStateList(matches.first.id?.toString() ?? "");
            }
          }
        } else {
          AppDialog.showMessage(data.msg);
        }
      } catch (e) {
        print('❌ Exception in addAddress: $e');
      } finally {
        hideLoader(Get.context!);
      }
    }
  }

  // -------------------- Get State API --------------------
  Future<void> getStateList(String id) async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        showLoader(Get.context!);

        final response = await getStateListApi(id);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final data = BaseResponse<CountryData>.fromJson(
          body,
          fromJsonT: (data) => CountryData.fromJson(data),
        );

        if (data.responseCode == "200") {

          stateList.assignAll(data.data?.states as Iterable<StateItem>);
          // If addStateId is present (from updateAddress), select its instance
          if (addStateId.isNotEmpty) {
            final matches = stateList.where((s) => s.id?.toString() == addStateId).toList();
            if (matches.isNotEmpty) {
              selectedState.value = matches.first;
            }
          }
        } else {
          AppDialog.showMessage(data.msg);
        }
      } catch (e) {
        print('❌ Exception in addAddress: $e');
      } finally {
        hideLoader(Get.context!);
      }
    }
  }

  int getPhoneLength(String dialCode) {
    debugPrint("check dial code...."+dialCode);
    switch (dialCode) {
      case "+974": // Qatar
      case "+968": // Oman
      case "+965": // Kuwait
      case "+973": // Bahrain
        return 8;

      case "+966": // Saudi
      case "+971": // UAE
        return 9;

      default:
        return 10; // fallback (India etc.)
    }
  }

  void onCountryCodeChanged(String code) {
    selectedCountryCode.value = code;

    // Re-validate current phone number
    validatePhone(phoneController.text);
  }

  // -------------------- Add State API --------------------
  Future<void> verifyPhone() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        showLoader(Get.context!);

        final response = await verifyPhoneCodeApi(selectedCountryCode.value,phoneController.text);

        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final data = BaseResponse<CommonData>.fromJson(
          body,
          fromJsonT: (data) => CommonData.fromJson(data),
        );

        if (data.isVerified == "0") {
          isOtpShow.value=true;
          phoneError.value = "";
        } else {
          AppDialog.showMessage(data.msg);
        }
      } catch (e) {
        print('❌ Exception in addAddress: $e');
      } finally {
        hideLoader(Get.context!);
      }
    }
  }
}
