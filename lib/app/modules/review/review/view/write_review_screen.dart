import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tajer/utils/app_params.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../../utils/app_colors.dart';
import '../controller/review_controller.dart';

class WriteReviewScreen extends StatelessWidget {
  final ReviewController controller = Get.put(ReviewController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.appWriteAReview.toUpperCase().tr,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Nunito',
            color: Colors.black,
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ---------------------- TOP WHITE PADDED AREA ----------------------
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.appAddYourProductPhotos.toUpperCase().tr,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          AppStrings.appStandAChanceToGetFeatured
                              .toUpperCase()
                              .tr,
                          style: const TextStyle(
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            color: Colors.black54,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),

                  GestureDetector(
                    onTap: () => _showImagePickerOptions(context),
                    child: Obx(() {
                      return Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: controller.selectedImages.isEmpty
                            ? const Icon(Icons.camera_alt, color: Colors.green)
                            : const Icon(Icons.camera_alt, color: Colors.green),
                      );
                    }),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ------------------ HORIZONTAL IMAGE LIST -------------------
            Obx(() {

              if (controller.selectedImages.isEmpty) {
                return SizedBox.shrink(); // HIDE COMPLETELY
              }


              return SizedBox(
                height: 90,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.selectedImages.length, // FIXED
                  itemBuilder: (context, index) {
                    // ADD BUTTON
                    if (index == controller.selectedImages.length) {
                      return GestureDetector(
                        onTap: () => _showImagePickerOptions(context),
                        child: Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green.shade100,
                          ),
                          child: const Icon(Icons.camera_alt,
                              color: Colors.green),
                        ),
                      );
                    }

                    // IMAGE ITEM WITH CROSS BUTTON
                    return Stack(
                      clipBehavior: Clip.none, // IMPORTANT FOR OVERFLOW
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              image:
                              FileImage(controller.selectedImages[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Positioned(
                          top: -4,
                          right: -3,
                          child: GestureDetector(
                            onTap: () => controller.removeImage(index),
                            child: Container(
                              height: 22,
                              width: 22,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 20),

            // ---------------------- FULL WIDTH GRAY DIVIDER ----------------------
            Container(
              width: double.infinity,
              height: 20,
              color: AppColors.colorAccountBackground,
            ),

            const SizedBox(height: 20),

            // ---------------------- BOTTOM PADDED WHITE AREA ----------------------
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Title Field
                  Text(
                    AppStrings.appTitle.toUpperCase().tr,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15,
                      color: AppColors.black1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextField(
                    onChanged: controller.title,
                    decoration: InputDecoration(
                      hintText: AppStrings.appPleaseEnterYourTitle
                          .toUpperCase()
                          .tr,
                      enabledBorder: const UnderlineInputBorder(),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Description Field
                  Text(
                    AppStrings.appDescription.toUpperCase().tr,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 15,
                      color: AppColors.black1,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextField(
                    maxLines: 4,
                    onChanged: controller.description,
                    decoration: InputDecoration(
                      hintText: AppStrings.appWriteYourExperience.tr,
                      enabledBorder: UnderlineInputBorder(),
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// Agreement Checkbox
                  Obx(
                        () => Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Checkbox(
                          value: controller.isAgreed.value,
                          onChanged: (val) {
                            controller.isAgreed.value = val!;
                          },
                        ),
                        Expanded(
                          child: Text(
                            AppStrings.appIAgreeThatMyReviewIncludingMyName
                                .toUpperCase()
                                .tr,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 13,
                              color: AppColors.black1,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Colors.black),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () => Get.back(),
                          child: Text(
                            AppStrings.appCancel.toUpperCase().tr,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.black1,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            AppStrings.appSubmit.toUpperCase().tr,
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          onPressed: () {
                            if (controller.title.value.isEmpty) {
                              Get.snackbar("Error",
                                  AppStrings.app_error_title.toUpperCase().tr);
                              return;
                            }
                            if (controller.description.value.isEmpty) {
                              Get.snackbar("Error",
                                  AppStrings.app_error_description.toUpperCase().tr);
                              return;
                            }
                            if (!controller.isAgreed.value) {
                              Get.snackbar("Error",
                                  "Please accept the agreement");
                              return;
                            }
                            controller.submitOrderFeedback(controller.orderFeedbackData.value);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------- IMAGE PICKER BOTTOM SHEET --------------------------
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

            // REMOVE ALL
            // Obx(() => controller.selectedImages.isNotEmpty
            //     ? ListTile(
            //   leading: const Icon(Icons.delete_outline, color: Colors.red),
            //   title: Text(
            //     AppStrings.appRemove.toUpperCase().tr,
            //     style: const TextStyle(color: Colors.red),
            //   ),
            //   onTap: () {
            //     controller.selectedImages.clear();
            //     Navigator.pop(context);
            //   },
            // )
            //     : const SizedBox.shrink(),
            // ),

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
}
