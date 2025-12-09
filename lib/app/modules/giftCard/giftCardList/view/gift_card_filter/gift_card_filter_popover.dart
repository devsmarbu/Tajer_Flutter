import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/utils/app_colors.dart';
import 'package:tajer/utils/app_strings.dart';

class GiftCardFilterPopover extends StatefulWidget {
  final RxList<String> statusList;
  final RxList<String> statusPaymentList;

  const GiftCardFilterPopover({
    super.key,
    required this.statusList,
    required this.statusPaymentList,
  });

  @override
  State<GiftCardFilterPopover> createState() => _GiftCardFilterPopoverState();
}

class _GiftCardFilterPopoverState extends State<GiftCardFilterPopover> {
  final TextEditingController searchController = TextEditingController();

  String? selectedStatus;
  String? selectedPaymentStatus;

  @override
  Widget build(BuildContext context) {
    final List<String> statusOptions = widget.statusList;
    final List<String> paymentStatusOptions = widget.statusPaymentList;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Stack(
        alignment: Alignment.center,
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(color: Colors.transparent),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.appApplyFilters.toUpperCase().tr,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          fontFamily: "Nunito",
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            Get.back(result: {
                              "keyword": searchController.text,
                              "status": selectedStatus ?? "",
                              "paymentStatus": selectedPaymentStatus ?? "",
                            });
                          },
                        icon: const Icon(Icons.close, color: Colors.black, size: 26),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search By Receiver Name , Email Or Code",
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      filled: true,
                      fillColor: Colors.grey.shade100,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    hint: Text(AppStrings.appSelectStatus.toUpperCase().tr),
                    items: statusOptions
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    onChanged: (value) => setState(() => selectedStatus = value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  DropdownButtonFormField<String>(
                    value: selectedPaymentStatus,
                    hint: const Text("Select Payment Status"),
                    items: paymentStatusOptions
                        .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                        .toList(),
                    onChanged: (value) => setState(() => selectedPaymentStatus = value),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              selectedStatus = null;
                              selectedPaymentStatus = null;
                              searchController.clear();
                            });

                            Get.back(result: {
                              "clearAll": true,
                              "keyword": "",
                              "status": "",
                              "paymentStatus": "",
                            });
                          },
                          child: Text(AppStrings.app_clear_all,
                              style: TextStyle(color: AppColors.black1,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w600)),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // VALIDATION
                            if (searchController.text.isEmpty &&
                                selectedStatus == null &&
                                selectedPaymentStatus == null) {
                              Get.snackbar(
                                "Validation Error",
                                "Please select at least one filter or enter a keyword",
                                snackPosition: SnackPosition.BOTTOM,
                              );
                              return; // stop here
                            }

                            // All good → pass filter data
                            Get.back(result: {
                              "clearAll": false,
                              "keyword": searchController.text,
                              "status": selectedStatus ?? "",
                              "paymentStatus": selectedPaymentStatus ?? "",
                            });
                          },
                          child: Text(AppStrings.appApply.toUpperCase().tr,
                          style: TextStyle(color: AppColors.black1,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
