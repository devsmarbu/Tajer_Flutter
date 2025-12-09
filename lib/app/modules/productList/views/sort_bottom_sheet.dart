import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_strings.dart';

class SortBottomSheet extends StatelessWidget {
  const SortBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      'APP_POPULAR'.tr,
      'APP_PRICE_LOW_TO_HIGH'.tr,
      'APP_PRICE_HIGH_TO_LOW'.tr,
    ];

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [

        /// MAIN BOTTOM SHEET AREA
        Container(
          margin: const EdgeInsets.only(top: 40), // space for close button
          padding: const EdgeInsets.only(top: 20, bottom: 20),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              /// Header Row
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.app_sort_by.tr,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(result: {"sortKey": ""}),
                      child: Text(
                        AppStrings.app_reset.tr,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 1),

              /// Sort Options List
              ...options.map((option) => ListTile(
                title: Text(option),
                onTap: () {
                  int index = options.indexOf(option);
                  String sortKey = index == 0
                      ? "popularity_desc"
                      : index == 1
                      ? "price_asc"
                      : "price_desc";

                  Get.back(result: {"sortKey": sortKey});
                },
              ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),

        /// CIRCULAR CLOSE BUTTON
        Positioned(
          top: 0,
          child: Container(
            height: 42,
            width: 42,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  spreadRadius: 1,
                  color: Colors.black.withOpacity(0.25),
                )
              ],
            ),
            child: IconButton(
              icon: const Icon(Icons.close, size: 22, color: Colors.black),
              onPressed: () => Get.back(),
            ),
          ),
        ),
      ],
    );
  }
}
