import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../utils/app_strings.dart';

mixin AppDialog {
  /// Show a simple message dialog (like Android native)
  static void showMessage(String message, {String? title}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),

              /// Title
              Text(
                title ?? AppStrings.appMessage.tr,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.black1,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 12),

              /// Message
              Text(
                message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontFamily: 'Nunito',
                  color: AppColors.black1,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 20),
              const Divider(height: 1),

              /// OK Button
              TextButton(
                  onPressed: () {
                    if (Get.isDialogOpen ?? false) {
                      //Get.back(closeOverlays: true);
                      Get.back();
                    }
                  },
                style: TextButton.styleFrom(
                  foregroundColor: Colors.black,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  AppStrings.appOk.toUpperCase().tr,
                  style: TextStyle(
                    color: AppColors.black1,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
