import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../common/widgets/common_text_field.dart';
import '../../../common/widgets/phone_field.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_params.dart';
import '../../../utils/pref_store.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../edit_profile/edit_profile_controller.dart';
import '../address/addAddress/models/country_item.dart';
import '../address/addAddress/models/state_item.dart';

class EditProfileView extends StatelessWidget {
  EditProfileView({super.key});

  final EditProfileController controller = Get.put(EditProfileController());

  void _showImagePickerOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: Text(AppStrings.appCamera.toUpperCase().tr),
              onTap: () {
                controller.pickImage(ImageSource.camera);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(AppStrings.appGallery.toUpperCase().tr),
              onTap: () {
                controller.pickImage(ImageSource.gallery);
                Navigator.pop(context);
              },
            ),
            Obx(
              () => controller.profileImage.value != null
                  ? ListTile(
                      leading: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      title: Text(
                        AppStrings.appRemove.toUpperCase().tr,
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Nunito',
                        ),
                      ),
                      onTap: () {
                        controller.removePic();
                        Navigator.pop(context);
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            ListTile(
              leading: const Icon(Icons.close),
              title: Text(AppStrings.appCancel.toUpperCase().tr),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        titleSpacing: 0,
        leading: InkWell(
          onTap: () => Get.back(),
          child: const Icon(Icons.arrow_back),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appEditProfile.toUpperCase().tr,
              style: const TextStyle(
                fontFamily: "Nunito",
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.black1,
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        // if (controller.countryList.isEmpty) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- Profile Image ----------------
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 45,
                      backgroundImage: controller.profileImage.value != null
                          ? FileImage(controller.profileImage.value!)
                          : (controller.networkImage != null &&
                                controller.networkImage!.isNotEmpty)
                          ? NetworkImage(controller.networkImage!)
                          : const AssetImage("assets/images/userProfile.jpeg")
                                as ImageProvider,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showImagePickerOptions(context),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.edit,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ---------------- Name ----------------
              // CommonTextField(
              //   label: AppStrings.appLabelName.toUpperCase().tr,
              //   controller: controller.nameController,
              //   hint: "Enter name",
              //   backgroundColor: AppColors.colorAccountBackground,
              // ),
              // const SizedBox(height: 16),

              // ---------------- Email ----------------
              CommonTextField(
                label: AppStrings.appEmail.toUpperCase().tr,
                controller: controller.emailController,
                hint: AppStrings.appEmail.toUpperCase().tr,
                backgroundColor: AppColors.white,
                readOnly: true,
                actionText: AppStrings.appUpdate.toUpperCase().tr,
                onActionTap: () {
                  Get.toNamed(AppRoutes.changeEmail);
                },
              ),
              const SizedBox(height: 16),

              // ---------------- Phone ----------------
              if (PrefStore().loadString(AppConstants.phoneSectionEnabled) == '1')
               PhoneField(
                  actionText: AppStrings.appUpdate.toUpperCase().tr,
                  controller: controller.phoneController,
                  errorText: controller.phoneError,
                  selectedCountryCode: controller.selectedCountryCode,
                  backgroundColor: AppColors.white,
                  onChanged: (val) {
                    controller.phoneError.value = val.isEmpty
                        ? "Phone number required"
                        : "";
                  },
                  onActionTap: () async {
                    final result = await Get.toNamed(
                      AppRoutes.updatePhoneNumber,
                      arguments: {
                        AppParams.title: AppStrings.appUpdatePhone
                            .toUpperCase()
                            .tr,
                        AppParams.isUpdate: true,
                        "phone": controller.phoneController.text,
                        "countryCode": controller.selectedCountryCode.value,
                      },
                    );

                    if (result != null) {
                     // await controller.getProfileInfo();

                      Get.back(result: result); // forward message to Account
                    }
                  },
                  isEnabled: false,
                ),
              if (PrefStore().loadString(AppConstants.phoneSectionEnabled) ==
                  '1')
                const SizedBox(height: 16),

              // ---------------- DOB ----------------
              GestureDetector(
                onTap: () => controller.pickDate(context),
                child: AbsorbPointer(
                  child: CommonTextField(
                    label: "${AppStrings.appHintDateOfBirth.toUpperCase().tr}*",
                    controller: controller.dobController,
                    backgroundColor: AppColors.white,
                    hint: AppStrings.appSelectDate.toUpperCase().tr,
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ---------------- Country ----------------
              Text(
                "${AppStrings.appCountry.toUpperCase().tr}*",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  fontFamily: "Nunito",
                ),
              ),
              const SizedBox(height: 10),

              DropdownSearch<CountryItem>(
                selectedItem: controller.selectedCountry.value,
                items: controller.countryList,
                itemAsString: (CountryItem? c) => c?.name ?? "",
                popupProps:  PopupProps.bottomSheet(
                  showSearchBox: true,
                  searchFieldProps: TextFieldProps(
                    decoration: InputDecoration(hintText: AppStrings.appSearch.toUpperCase().tr),
                  ),
                ),
                dropdownDecoratorProps: DropDownDecoratorProps(
                  dropdownSearchDecoration: InputDecoration(
                    filled: true,
                    hintText: AppStrings.appSelectCountry.toUpperCase().tr,
                    fillColor: AppColors.white,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.dashboardBgd,
                      ), // default color
                    ),

                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(
                        color: AppColors.dashboardBgd,
                      ), // focused color
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                onChanged: (val) async {
                  controller.selectedCountry.value = val;
                  controller.selectedState.value = null;

                  if (val != null) {
                    await controller.getStateList(val.id ?? "");
                  }
                },
              ),

              const SizedBox(height: 16),

              // ---------------- State ----------------
              Obx(() {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${AppStrings.appState.toUpperCase().tr}*",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: "Nunito",
                      ),
                    ),
                    const SizedBox(height: 10),

                    DropdownSearch<StateItem>(
                      enabled: controller.selectedCountry.value != null,
                      selectedItem: controller.selectedState.value,
                      items: controller.stateList,
                      itemAsString: (StateItem? s) => s?.name ?? "",

                      popupProps:  PopupProps.bottomSheet(
                        showSearchBox: true,
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            hintText: AppStrings.appSearch.toUpperCase().tr,
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),

                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.dashboardBgd,
                            ), // default color
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: AppColors.dashboardBgd,
                            ), // focused color
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          hintText: AppStrings.appSelectState.toUpperCase().tr
                        ),
                      ),

                      onChanged: (val) {
                        controller.selectedState.value = val;
                      },
                    ),
                  ],
                );
              }),

              const SizedBox(height: 32),

              // ---------------- Update Button ----------------
              Obx(() {
                final isEnabled = controller.isChanged.value;

                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnabled
                          ? AppColors.black1
                          : AppColors.black1.withOpacity(0.4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: isEnabled ? 2 : 0,
                    ),
                    onPressed: isEnabled ? controller.updateProfile : null,
                    child: Text(
                      AppStrings.appUpdate.toUpperCase().tr,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontFamily: 'Nunito',
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        );
      }),
    );
  }
}
