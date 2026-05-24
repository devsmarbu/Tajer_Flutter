import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../home/header_view/header_view.dart';
import '../cart_shipping/cart_listing_model/cart_listing_model.dart';

class AddressView extends StatelessWidget {
  final bool isSelected;
  final IngAddress? address;
  final VoidCallback? onEdit;
  final VoidCallback? onLabelTap;

  const AddressView({
    super.key,
    this.isSelected = false,
    this.onEdit,
    this.onLabelTap,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    final dcode = address?.addrPhoneDcode;
    final phone = address?.addrPhone ?? '';

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

    return Column(
      key: Key("address_view"),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderView(
          titleHeader: "APP_SHIPPING_DETAILS".tr,
          hideSeeAll: true,
          isHomeHeader: false,
        ),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.fromLTRB(12, 0, 12, 10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Radio Button
                    Radio<bool>(
                      value: true,
                      groupValue: isSelected,
                      onChanged: (_) {}, // You can add callback here
                      activeColor: Colors.black,
                    ),

                    const SizedBox(width: 0),

                    // Address Information
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10),
                          Text(
                            address?.addrName ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              fontFamily: "Nunito",
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${address?.addrAddress1 ?? ""},",
                            style: const TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${address?.addrAddress2 ?? ""},",
                            style: const TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${address?.stateName}, ${address?.countryName},",
                            style: const TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            "${address?.addrZip ?? ""},",
                            style: const TextStyle(
                              fontFamily: "Nunito",
                              fontSize: 12,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Edit Icon Button
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: Colors.black,
                      ),
                      splashRadius: 20,
                    ),

                    // Label Button/Chip
                    GestureDetector(
                      onTap: onLabelTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 0,
                          vertical: 6,
                        ),
                        // decoration: BoxDecoration(
                        //   color: Colors.grey.shade300,
                        //   borderRadius: BorderRadius.circular(20),
                        // ),
                        // child: Text(
                        //   label,
                        //   style: const TextStyle(
                        //     fontSize: 12,
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.black87,
                        //   ),
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(47, 0, 15, 10),
                  child: Row(
                    children: [
                      Text(
                        displayPhone,
                        style: const TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.fromLTRB(7, 7, 7, 7),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          address?.addrTitle ?? "",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
