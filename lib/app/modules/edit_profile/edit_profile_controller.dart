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
  late ProfileData profileData;
  final pref = PrefStore();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();

  var selectedCountryCode = "+91".obs;
  var phoneError = "".obs;
  var profileImage = Rx<File?>(null);

  var countryList = <CountryItem>[].obs;
  var stateList = <StateItem>[].obs;

  var selectedCountry = Rxn<CountryItem>();
  var selectedState = Rxn<StateItem>();

  var isStateLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getProfileInfo(); // fetch data first
    getCountryList(); // load countries
  }

  /// -------------------- Get Country List --------------------
  Future<void> getCountryList() async {
    if (!await AppFunction.isInternetAvailable()) return;
    try {
      final response = await getCountryListApi();
      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<CountryData>.fromJson(
        body,
        fromJsonT: (data) => CountryData.fromJson(data),
      );

      if (data.responseCode == "200") {
        countryList.assignAll(data.data?.countries ?? []);

        final countryName = profileData.personalInfo?.countryName ?? '';
        if (countryName.isNotEmpty) {
          selectedCountry.value = countryList.firstWhereOrNull(
                (c) => c.name?.toLowerCase() == countryName.toLowerCase(),
          );
        }

        if (selectedCountry.value != null) {
          await getStateList(selectedCountry.value!.id ?? "");
        }
      } else {
        AppDialog.showMessage(data.msg);
      }
    } catch (e) {
      print('❌ Exception in getCountryList: $e');
    }
  }

  /// -------------------- Get State List --------------------
  Future<void> getStateList(String id) async {
    if (!await AppFunction.isInternetAvailable()) return;
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
        stateList.assignAll(data.data?.states ?? []);

        final stateName = profileData.personalInfo?.stateName ?? '';
        if (stateName.isNotEmpty) {
          selectedState.value = stateList.firstWhereOrNull(
                (s) => s.name?.toLowerCase() == stateName.toLowerCase(),
          );
        }
      } else {
        AppDialog.showMessage(data.msg);
      }
    } catch (e) {
      print('❌ Exception in getStateList: $e');
    } finally {
      hideLoader(Get.context!);
    }
  }

  /// -------------------- Pick Image --------------------
  Future<void> pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      profileImage.value = File(picked.path);
      await uploadImage();
    }
  }

  /// -------------------- Pick Date --------------------
  Future<void> pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
      DateTime.tryParse(dobController.text) ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.black1,
            onPrimary: Colors.white,
            onSurface: AppColors.black1,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      dobController.text =
      "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  /// -------------------- Validate and Update Profile --------------------
  void updateProfile() {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Name cannot be empty");
      return;
    }
    if (emailController.text.trim().isEmpty ||
        !GetUtils.isEmail(emailController.text.trim())) {
      Get.snackbar("Error", "Enter a valid email address");
      return;
    }
    if (dobController.text.trim().isEmpty) {
      Get.snackbar("Error", "Please select your date of birth");
      return;
    }
    if (selectedCountry.value == null) {
      Get.snackbar("Error", "Please select a country");
      return;
    }
    if (selectedState.value == null) {
      Get.snackbar("Error", "Please select a state");
      return;
    }

    editProfile();
  }

  /// -------------------- Edit Profile API --------------------
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
      AppDialog.showMessage(data.msg);
    } catch (e) {
      print('❌ Exception in editProfile: $e');
    } finally {
      hideLoader(Get.context!);
    }
  }

  /// -------------------- Upload Image API --------------------
  Future<void> uploadImage() async {
    if (!await AppFunction.isInternetAvailable()) return;
    if (profileImage.value == null) return;

    try {
      showLoader(Get.context!);
      final token = await pref.loadString(AppConstants.sessionToken);

      final response =
      await uploadProfilePic(file: profileImage.value!, token: token ?? "");

      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final data = BaseResponse<CommonData>.fromJson(
        body,
        fromJsonT: (data) => CommonData.fromJson(data),
      );
      hideLoader(Get.context!);
      AppDialog.showMessage(data.msg);
    } catch (e) {
      print('❌ Exception in uploadImage: $e');
    } finally {
      hideLoader(Get.context!);
    }
  }

  /// -------------------- Remove Image API --------------------
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

      hideLoader(Get.context!);
      if (data.responseCode == "200") {
        profileImage.value = null;
      }

      AppDialog.showMessage(data.msg);
    } catch (e) {
      print('❌ Exception in removePic: $e');
    } finally {
      hideLoader(Get.context!);
    }
  }

  /// -------------------- Get Profile Info API --------------------
  Future<void> getProfileInfo() async {
    if (!await AppFunction.isInternetAvailable()) return;

    try {
      showLoader(Get.context!);
      final token = await pref.loadString(AppConstants.sessionToken);

      final response = await getProfileInfoApi(token ?? "");
      dynamic body = response.data;
      if (body is String) body = json.decode(body);

      final baseResponse = BaseResponse<ProfileData>.fromJson(
        body,
        fromJsonT: (data) => ProfileData.fromJson(data),
      );

      if (baseResponse.responseCode == "200" &&
          baseResponse.status == AppConstants.SUCCESS) {
        profileData = baseResponse.data!;
        nameController.text = profileData.personalInfo?.userName ?? '';
        emailController.text = profileData.personalInfo?.credentialEmail ?? '';
        phoneController.text = profileData.personalInfo?.userPhone ?? '';
        dobController.text = profileData.personalInfo?.userDob ?? '';

        final userImage = profileData.personalInfo?.userImage;
        if (userImage != null && userImage.isNotEmpty) {
          profileImage.value = File(userImage);
        }
      } else {
        AppDialog.showMessage(baseResponse.msg);
      }
    } catch (e) {
      print('❌ Exception in getProfileInfo: $e');
    } finally {
      hideLoader(Get.context!);
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    dobController.dispose();
    super.onClose();
  }
}
