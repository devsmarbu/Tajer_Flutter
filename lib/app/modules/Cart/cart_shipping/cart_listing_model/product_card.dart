import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/alert.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/core/constants/app_labels.dart';
import 'package:tajer/utils/app_strings.dart';

import 'cart_listing_model.dart';

class CartItemCard extends StatelessWidget {
  final Available item;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onSaveForLater;
  final VoidCallback? onRemove;
  final VoidCallback? onComment;
  final VoidCallback? onFavTap;

  const CartItemCard({
    super.key,
    required this.item,
    this.onIncrease,
    this.onDecrease,
    this.onSaveForLater,
    this.onRemove,
    this.onComment,
    this.onFavTap,
  });

  @override
  Widget build(BuildContext context) {
    String option = "";
    final optionName = item.options?.isNotEmpty == true
        ? item.options!.first.optionName
        : "";
    final optionValue = item.options?.isNotEmpty == true
        ? item.options!.first.optionValueName
        : "";
    if ((optionName != "") && (optionValue != "")) {
      option = "$optionName: $optionValue";
    }
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// --- Product Info Row ---
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 15, 5, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.isDeliverable == "0")
                  SizedBox(
                    height: 40,
                    child: Text(
                      item.notDelevryReason ?? "",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Nunito",
                        color: Colors.red,
                      ),
                    ),
                  ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.imageUrl ?? "",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          width: 90,
                          height: 90,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image_not_supported),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.selprodTitle ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          if (option != "")
                            Text(
                              option,
                              style: TextStyle(
                                color: Colors.grey[800],
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w500,
                                fontSize: 11,
                              ),
                            ),
                          Text(
                            "Sold By: ${item.shopName}",
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 4),
                          InkWell(
                            onTap: onComment,
                            child: Text(
                              "${AppStrings.appAddComment.toUpperCase().tr} +",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                decoration: TextDecoration.underline,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    IconButton(
                      onPressed: onFavTap,
                      icon: Image.asset(
                        "assets/images/heart.png",
                        height: 22,
                        width: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// --- Qty + Price ---
          Padding(
            padding: const EdgeInsets.fromLTRB(3, 5, 15, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: onDecrease,
                      icon: _qtyBtn("assets/images/decrease.png"),
                    ),
                    Text(
                      "${item.quantity}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "Nunito",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: onIncrease,
                      icon: _qtyBtn("assets/images/increase.png"),
                    ),
                  ],
                ),
                Text(
                  "${item.selprodPrice}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: Colors.black12),

          /// --- Save For Later + Remove ---
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _footerBtn(
                AppStrings.appSaveForLater.toUpperCase().tr,
                "assets/images/save_for_later.png",
                onSaveForLater,
              ),
              Container(height: 42, width: 1, color: Colors.black12),
              _footerBtn(AppStrings.appRemove.toUpperCase().tr, "assets/images/bin.png", onRemove),
            ],
          ),
        ],
      ),
    );
  }

  /// helpers
  Widget _qtyBtn(String img) => Container(
    padding: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black38, width: 1),
      borderRadius: BorderRadius.circular(5),
    ),
    child: Image.asset(img, height: 14, width: 14, fit: BoxFit.contain),
  );

  Widget _footerBtn(String title, String icon, VoidCallback? onTap) {
    return SizedBox(
      width: 140,
      child: TextButton.icon(
        onPressed: onTap,
        icon: Image.asset(icon, height: 16),
        label: Text(
          title,
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 12,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
