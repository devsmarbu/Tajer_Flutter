import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/cart_listing_model/cart_listing_model.dart';

import '../../../../utils/app_strings.dart';
import '../../home/header_view/header_view.dart';

class SaveForLaterView extends StatelessWidget {
  final List<Available> cartItems;
  final Function(String selProducId,String quantity) onSelected; // ✅ callback
  final Function(Available cartItem) removeItem; // ✅ callback

  const SaveForLaterView({super.key, required this.cartItems, required this.onSelected, required this.removeItem});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (cartItems.isNotEmpty)
          HeaderView(
            titleHeader: "${AppStrings.appSaveForLater.toUpperCase().tr} (${cartItems.length})",
            hideSeeAll: true,
            isHomeHeader: false,
          ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min, // <-- makes height fit content
          children: cartItems.map((item) {
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
              margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- top row (image + info + icon) ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(8, 15, 5, 0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item.imageUrl ?? "",
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
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
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                                "${AppStrings.appSoldBy.toUpperCase().tr}: ${item.shopName}",
                                style: TextStyle(
                                  color: Colors.grey[800],
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(height: 4),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- quantity & price row ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(3, 5, 20, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          item.selprodPrice ?? "",
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

                  // --- action buttons row ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 140,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            onSelected(item.selprodId ?? "",item.quantity ?? "1");
                          },
                          icon: Image.asset(
                            "assets/images/save_for_later.png",
                            height: 16,
                          ),
                          label: Text(
                            AppStrings.appMoveToCart.toUpperCase().tr,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 42,
                        width: 1,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.black12),
                        ),
                      ),
                      SizedBox(
                        width: 140,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 40),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          onPressed: () {
                            removeItem(item);
                          },
                          icon: Image.asset(
                            "assets/images/bin.png",
                            height: 16,
                          ),
                          label: Text(
                            AppStrings.appRemove.toUpperCase().tr,
                            style: TextStyle(
                              color: Colors.black87,
                              fontSize: 12,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
