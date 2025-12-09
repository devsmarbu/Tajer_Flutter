import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../common/widgets/common_text_field.dart';
import '../../../common/widgets/phone_field.dart';
import '../../../utils/app_colors.dart';
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
            Obx(() => controller.profileImage.value != null
                ? ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text(AppStrings.appRemove.toUpperCase().tr,
                  style: TextStyle(color: Colors.red)),
              onTap: () {
                controller.removePic();
                Navigator.pop(context);
              },
            )
                : const SizedBox.shrink()),
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
        backgroundColor: AppColors.black1,
        title: Text(
          AppStrings.appEditProfile.toUpperCase().tr,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Get.back(),
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
                          child: const Icon(Icons.edit,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ---------------- Name ----------------
              CommonTextField(
                label: AppStrings.appLabelName.toUpperCase().tr,
                controller: controller.nameController,
                hint: "Enter name",
                backgroundColor: AppColors.colorAccountBackground,
              ),
              const SizedBox(height: 16),

              // ---------------- Email ----------------
              CommonTextField(
                label: AppStrings.appEmail.toUpperCase().tr,
                controller: controller.emailController,
                hint:  AppStrings.appEmail.toUpperCase().tr,
                backgroundColor: AppColors.colorAccountBackground,
              ),
              const SizedBox(height: 16),

              // ---------------- Phone ----------------
              PhoneField(
                controller: controller.phoneController,
                errorText: controller.phoneError,
                selectedCountryCode: controller.selectedCountryCode,
                backgroundColor: AppColors.colorAccountBackground,
                onChanged: (val) {
                  controller.phoneError.value =
                  val.isEmpty ? "Phone number required" : "";
                },
              ),
              const SizedBox(height: 16),

              // ---------------- DOB ----------------
              GestureDetector(
                onTap: () => controller.pickDate(context),
                child: AbsorbPointer(
                  child: CommonTextField(
                    label: "${AppStrings.appHintDateOfBirth.toUpperCase().tr}*",
                    controller: controller.dobController,
                    backgroundColor: AppColors.colorAccountBackground,
                    hint: "Select Date",
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

              DropdownButtonFormField<CountryItem>(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.colorAccountBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: controller.selectedCountry.value,
                isExpanded: true,
                items: controller.countryList
                    .map(
                      (c) => DropdownMenuItem(
                    value: c,
                    child: Text(c.name ?? ''),
                  ),
                )
                    .toList(),
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
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        fontFamily: "Nunito",
                      ),
                    ),
                    const SizedBox(height: 10),
                    // if (controller.isStateLoading.value)
                    //   const Center(child: CircularProgressIndicator())
                    // else
                      DropdownButtonFormField<StateItem>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.colorAccountBackground,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        value: controller.selectedState.value,
                        isExpanded: true,
                        items: controller.stateList
                            .map(
                              (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.name ?? ''),
                          ),
                        )
                            .toList(),
                        onChanged: (val) {
                          controller.selectedState.value = val;
                        },
                      ),
                  ],
                );
              }),
              const SizedBox(height: 32),

              // ---------------- Update Button ----------------
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.black1,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: controller.updateProfile,
                  child: Text(
                    AppStrings.appUpdate.toUpperCase().tr,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
