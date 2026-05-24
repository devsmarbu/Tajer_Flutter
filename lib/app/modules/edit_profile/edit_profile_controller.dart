import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/data/service/account_api_client.dart';
import 'package:tajer/app/modules/Account/models/profile_data.dart';
import 'package:tajer/utils/common_data.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../common/functions/app_function.dart';
import '../../../common/widgets/app_dialog.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_loader.dart';
import '../../../utils/base_response.dart';
import '../address/addAddress/models/country_data.dart';
import '../address/addAddress/models/country_item.dart';
import '../address/addAddress/models/state_item.dart';
import '../address/address_api_client.dart';

class EditProfileController extends GetxController
    with AddressApiClient, AppLoader, AccountApiClient {

  final pref = PrefStore();

  // ---------------- Controllers ----------------
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();
  // Initial values snapshot
  late String initialName;
  late String initialEmail;
  late String initialPhone;
  late String initialDob;
  String? initialCountryId;
  String? initialStateId;

  var isChanged = false.obs;
  var isDataLoaded = false;

  // ---------------- Reactive Variables ----------------
  var selectedCountryCode = "+974".obs;
  var phoneError = "".obs;

  var profileImage = Rx<File?>(null);
  String? networkImage; // for API image

  var countryList = <CountryItem>[].obs;
  var stateList = <StateItem>[].obs;

  var selectedCountry = Rxn<CountryItem>();
  var selectedState = Rxn<StateItem>();

  ProfileData? profileData;

  // =====================================================
  // INIT
  // =====================================================

  @override
  void onInit() {
    super.onInit();

    nameController.addListener(checkIfChanged);
    emailController.addListener(checkIfChanged);
    phoneController.addListener(checkIfChanged);
    dobController.addListener(checkIfChanged);

    ever(selectedCountry, (_) => checkIfChanged());
    ever(selectedState, (_) => checkIfChanged());
    loadInitialData();
  }

  void checkIfChanged() {
    if (!isDataLoaded) return;

    isChanged.value =
        nameController.text != initialName ||
            emailController.text != initialEmail ||
            phoneController.text != initialPhone ||
            dobController.text != initialDob ||
            selectedCountry.value?.id != initialCountryId ||
            selectedState.value?.id != initialStateId;
  }

  // =====================================================
  // LOAD PROFILE + COUNTRY + STATE
  // =====================================================

  Future<void> loadInitialData() async {
    if (!await AppFunction.isInternetAvailable()) return;

    try {
      showLoader(Get.context!);

      await getProfileInfo();
      await getCountryList();

    } catch (e) {
      print("❌ loadInitialData error: $e");
    } finally {
      hideLoader(Get.context!);
    }
  }

  // =====================================================
  // GET PROFILE
  // =====================================================

  Future<void> getProfileInfo() async {
    final token = await pref.loadString(AppConstants.sessionToken);
    final response = await getProfileInfoApi(token ?? "");

    dynamic body = response.data;
    if (body is String) body = json.decode(body);

    final baseResponse = BaseResponse<ProfileData>.fromJson(
      body,
      fromJsonT: (data) => ProfileData.fromJson(data),
    );

    if (baseResponse.responseCode == "200") {
      profileData = baseResponse.data;

      final personal = profileData?.personalInfo;

      // ---- Prefill Text Fields ----
      nameController.text = personal?.userName ?? '';
      emailController.text = personal?.credentialEmail ?? '';
      phoneController.text = personal?.userPhone ?? '';
      dobController.text = personal?.userDob ?? '';

      initialName = nameController.text;
      initialEmail = emailController.text;
      initialPhone = phoneController.text;
      initialDob = dobController.text;

      // ---- Prefill Country Code ----
      if (personal?.userPhoneDcode != null &&
          personal!.userPhoneDcode.isNotEmpty) {

        final fullCode = personal.userPhoneDcode;

        // Split by '-' and take first part
        selectedCountryCode.value = fullCode.split('-').first;

      } else {
        selectedCountryCode.value = "+91";
      }

      // ---- Prefill Image ----
      networkImage = personal?.userImage;

    } else {
      AppDialog.showMessage(baseResponse.msg);
    }
  }

  // =====================================================
  // COUNTRY LIST
  // =====================================================

  Future<void> getCountryList() async {
    final response = await getCountryListApi();

    dynamic body = response.data;
    if (body is String) body = json.decode(body);

    final data = BaseResponse<CountryData>.fromJson(
      body,
      fromJsonT: (data) => CountryData.fromJson(data),
    );

    if (data.responseCode == "200") {
      countryList.assignAll(data.data?.countries ?? []);

      final savedCountryName =
      profileData?.personalInfo?.countryName?.toLowerCase();

      if (savedCountryName != null) {
        selectedCountry.value = countryList.firstWhereOrNull(
              (c) => c.name?.toLowerCase() == savedCountryName,
        );
      }else {
        selectedCountry.value = null; // ✅ IMPORTANT
      }

      if (selectedCountry.value != null) {
        await getStateList(selectedCountry.value!.id ?? "");
      }

      initialCountryId = selectedCountry.value?.id;
      isDataLoaded = true;
      checkIfChanged();

    } else {
      AppDialog.showMessage(data.msg);
    }
  }

  // =====================================================
  // STATE LIST
  // =====================================================

  Future<void> getStateList(String countryId) async {
    final response = await getStateListApi(countryId);

    dynamic body = response.data;
    if (body is String) body = json.decode(body);

    final data = BaseResponse<CountryData>.fromJson(
      body,
      fromJsonT: (data) => CountryData.fromJson(data),
    );

    if (data.responseCode == "200") {
      stateList.assignAll(data.data?.states ?? []);

      final savedStateName =
      profileData?.personalInfo?.stateName?.toLowerCase();

      if (savedStateName != null) {
        selectedState.value = stateList.firstWhereOrNull(
              (s) => s.name?.toLowerCase() == savedStateName,
        );
      }else {
        selectedState.value = null; // ✅ IMPORTANT
      }

      initialStateId = selectedState.value?.id;

    } else {
      AppDialog.showMessage(data.msg);
    }
  }

  // =====================================================
  // PICK IMAGE
  // =====================================================

  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);

    if (picked != null) {
      profileImage.value = File(picked.path);
      await uploadImage();
    }
  }

  // =====================================================
  // UPDATE PROFILE
  // =====================================================

  void updateProfile() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Name cannot be empty");
      return;
    }

    if (!GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar("Error", "Enter valid email");
      return;
    }

    if (dobController.text.isEmpty) {
      Get.snackbar("Error", "Select Date of Birth");
      return;
    }

    if (selectedCountry.value == null) {
      Get.snackbar("Error", "Select Country");
      return;
    }

    if (selectedState.value == null) {
      Get.snackbar("Error", "Select State");
      return;
    }

    editProfile();
  }

  // =====================================================
  // EDIT PROFILE API
  // =====================================================

  Future<void> editProfile() async {
    if (!await AppFunction.isInternetAvailable()) return;

    try {
      showLoader(Get.context!);

      final response = await updateProfileApi(
        selectedCountry.value!.id.toString(),
        selectedState.value!.id.toString(),
        nameController.text.trim(),
        phoneController.text.trim(),
        selectedState.value!.name.toString(),
        "",
        "",
        "",
        dobController.text.trim(),
        selectedCountryCode.value,
      );

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<CommonData>.fromJson(
        body,
        fromJsonT: (data) => CommonData.fromJson(data),
      );

      hideLoader(Get.context!);

      if (data.responseCode == "200") {
        AppDialog.showMessage(data.msg ?? "Profile Updated");
      } else {
        AppDialog.showMessage(data.msg ?? "Something went wrong");
      }

    } catch (e) {
      hideLoader(Get.context!);
      print("❌ editProfile error: $e");
      AppDialog.showMessage("Something went wrong");
    }
  }


  // =====================================================
  // UPLOAD IMAGE
  // =====================================================

  Future<void> uploadImage() async {
    if (!await AppFunction.isInternetAvailable()) return;
    if (profileImage.value == null) return;

    try {
      showLoader(Get.context!);

      final token = await pref.loadString(AppConstants.sessionToken);

      final response = await uploadProfilePic(
        file: profileImage.value!,
        token: token ?? "",
      );

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<CommonData>.fromJson(
        body,
        fromJsonT: (data) => CommonData.fromJson(data),
      );

      AppDialog.showMessage(data.msg);

    } catch (e) {
      print("❌ uploadImage error: $e");
    } finally {
      hideLoader(Get.context!);
    }
  }

  // =====================================================
// REMOVE PROFILE IMAGE
// =====================================================

  Future<void> removePic() async {
    if (!await AppFunction.isInternetAvailable()) return;

    try {
      showLoader(Get.context!);

      final response = await removeProfilePic();

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<CommonData>.fromJson(
        body,
        fromJsonT: (data) => CommonData.fromJson(data),
      );

      if (data.responseCode == "200") {
        // Clear both local + network image
        profileImage.value = null;
        networkImage = null;
      }

      AppDialog.showMessage(data.msg);

    } catch (e) {
      print("❌ removePic error: $e");
    } finally {
      hideLoader(Get.context!);
    }
  }


  // =====================================================
// PICK DATE
// =====================================================

  Future<void> pickDate(BuildContext context) async {
    DateTime initialDate;
    if (dobController.text.isNotEmpty &&
        dobController.text != "0000-00-00") {
      initialDate = DateTime.tryParse(dobController.text) ??
          DateTime(2000, 1, 1);
    } else {
      initialDate = DateTime(2000, 1, 1); // fallback
    }


    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.black1,
              onPrimary: Colors.white,
              onSurface: AppColors.black1,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      dobController.text =
      "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
    }
  }


  // =====================================================
  // CLEANUP
  // =====================================================

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.onClose();
  }
}

