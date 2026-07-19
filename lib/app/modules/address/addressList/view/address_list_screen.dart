import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import '../../../../../../utils/app_colors.dart';
import '../../../../../../utils/app_strings.dart';
import '../controller/address_controller.dart';

class AddressListScreen extends StatelessWidget {
   AddressListScreen({super.key});

  final AddressController controller =
  Get.put(AddressController(), permanent: true);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: AppColors.white,
        title: Text(
          AppStrings.appAddresses.tr,
          style: TextStyle(
            fontSize: 20,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            final comeFromCart = (Get.arguments != null && Get.arguments is Map)
                ? Get.arguments["comeFromCart"] ?? "0"
                : "0";
             // Get.back(result: comeFromCart);
            Navigator.of(context).pop(comeFromCart);
          },
        ),
      ),
      body: Obx(() {
        // if (controller.isLoading.value) {
        //   // 🌀 Show loader while fetching data
        //   return const Center(
        //     child: CircularProgressIndicator(color: Colors.black),
        //   );
        // }

        if (controller.addresses.isEmpty &&
            controller.isLoading.value == false) {
          // 📭 Show empty state
          debugPrint("in this block");
          return Center(
            child: Text(
              AppStrings.app_no_address_found.tr,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // ✅ Show address list
        return Container(
          color: AppColors.colorAccountBackground,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.all(10.0),
                // child: Text(
                //   AppStrings.appDeliverTo.toUpperCase().tr,
                //   style: TextStyle(
                //     fontFamily: 'Nunito',
                //     fontWeight: FontWeight.w600,
                //     fontSize: 16,
                //   ),
                // ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: controller.addresses.length,
                  itemBuilder: (context, index) {
                    final item = controller.addresses[index];

                    return Obx(() {
                      final selected = controller.selectedIndex.value == index;

                      return Material(
                        color: Colors.transparent,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            controller.selectAddress(item.addrId ?? "",item.addrIsDefault??"");
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selected
                                    ? Colors.black
                                    : Colors.grey.shade300,
                                width: selected ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [

                                /// --- Title + icons row ---
                                Row(
                                  children: [
                                    Icon(
                                      selected
                                          ? Icons.radio_button_checked
                                          : Icons.radio_button_off,
                                      color: Colors.black,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        item.addrName ?? 'No title',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 15,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        if (item.addrIsDefault != "1")
                                          IconButton(
                                            icon: SvgPicture.asset(
                                              "assets/icons/ic_delete.svg",
                                              width: 30,
                                              height: 30,
                                            ),
                                            padding: EdgeInsets.zero,
                                            visualDensity:
                                            VisualDensity.compact,
                                            onPressed: () =>
                                                controller.deleteAddressDialog(
                                                  item,
                                                  Get.context!,
                                                ),
                                          ),
                                        const SizedBox(width: 4),
                                        IconButton(
                                          icon: SvgPicture.asset(
                                            "assets/icons/ic_edit.svg",
                                            width: 30,
                                            height: 30,
                                          ),
                                          padding: EdgeInsets.zero,
                                          visualDensity: VisualDensity.compact,
                                          onPressed: () =>
                                              controller.editAddress(index),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 4),

                                /// --- Name ---
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 30),
                                //   child: Text(
                                //     item.addrName ?? '',
                                //     style: const TextStyle(
                                //       fontWeight: FontWeight.w600,
                                //       fontSize: 13,
                                //     ),
                                //   ),
                                // ),

                                // const SizedBox(height: 4),

                                /// --- Address ---
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(
                                    (item.addrAddress2 == null ||
                                        item.addrAddress2!.isEmpty)
                                        ? (item.addrAddress1 ?? '')
                                        : '${item.addrAddress1}, ${item
                                        .addrAddress2},',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                      height: 1.3,
                                    ),
                                  ),
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${item.stateName}, ${item
                                            .countryName},",
                                        style: const TextStyle(
                                          fontFamily: "Nunito",
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "${item.addrZip ?? ""},",
                                        style: const TextStyle(
                                          fontFamily: "Nunito",
                                          fontSize: 12,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                const SizedBox(height: 10),

                                /// --- Phone and title ---
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: [

                                    /// --- Tag (if exists) ---
                                    Padding(
                                      padding: const EdgeInsets.only(left: 30),
                                      child: Builder(
                                        builder: (_) {
                                          final dcode = item.addrPhoneDcode;
                                          final phone = item.addrPhone ?? '';

                                          String displayPhone;

                                          if (dcode != null) {
                                            if (dcode.contains('-')) {
                                              final code = dcode.split('-');
                                              displayPhone =
                                              '${code[0]}-$phone';
                                            } else {
                                              displayPhone = '$dcode-$phone';
                                            }
                                          } else {
                                            displayPhone = phone;
                                          }

                                          return Text(
                                            displayPhone,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    if (item.addrTitle != null &&
                                        item.addrTitle!.isNotEmpty &&
                                        item.addrIsDefault != "1")
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 10,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: Text(
                                            item.addrTitle!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
                  },
                ),
              ),
            ],
          ),
        );
      }),

      /// --- Add Address Button ---
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 20),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: controller.addAddress,
          icon: const Icon(Icons.add),
          label:  Text(
            AppStrings.appAddAddress.toUpperCase().tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ),
      ),
    );
  }
}


class AddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddressController>(() => AddressController(),fenix: true);
  }
}