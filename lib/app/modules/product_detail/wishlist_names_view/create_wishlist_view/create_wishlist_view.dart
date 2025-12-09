import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/utils/app_strings.dart';

import '../../../../../common/widgets/common_text_field.dart';

class CreateWishlistPopover extends StatelessWidget {

  final TextEditingController titleController = TextEditingController();
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.5), // transparent overlay
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Tap outside to dismiss
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.transparent),
          ),

          // Popover bottom sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 30, 16, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.appCreateWishlist.toUpperCase().tr,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Nunito"
                      ),
                    ),
                    SizedBox(height: 15),
                    CommonTextField(
                      maxLines: 1,
                      label: "",
                      hint: AppStrings.appListName.toUpperCase().tr, controller: titleController,backgroundColor: Colors.grey[200],
                    ),
                    const SizedBox(height: 20),

                    // Submit Button
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          final name = titleController.text.trim();
                          debugPrint(
                              "List created: ${titleController.text} - ${commentController.text}");
                          Get.back(result: name);
                        },
                        child: Text(
                          AppStrings.appCreate.toUpperCase().tr,
                          style: TextStyle(
                            fontFamily: "Nunito",
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Floating Close Button
          Positioned(
            bottom: MediaQuery.of(context).size.height * 0.23,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black26, blurRadius: 6, offset: Offset(0, 2))
                ],
              ),
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, size: 28, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}