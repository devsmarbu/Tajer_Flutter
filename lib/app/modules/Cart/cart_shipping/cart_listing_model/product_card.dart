import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/alert.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/core/constants/app_labels.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/regular_products/regular_product_controller.dart';
import 'package:tajer/utils/app_strings.dart';

import '../../../product_detail/product_detail_model.dart';
import '../../../product_detail/product_detail_view.dart';
import '../../../product_detail/product_images/fullscreen_product_images.dart';
import 'cart_listing_model.dart';
import 'package:flutter/services.dart';

class OptionModel {
  final String title;
  final String optionIsColor;

  OptionModel({required this.title, required this.optionIsColor});

  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      title: json['title'] ?? '',
      optionIsColor: json['optionIsColor'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'title': title, 'optionIsColor': optionIsColor};
  }
}

class CartItemCard extends StatefulWidget {
  final Available item;
  final VoidCallback? onIncrease;
  final VoidCallback? onDecrease;
  final VoidCallback? onSaveForLater;
  final VoidCallback? onRemove;
  final VoidCallback? onComment;
  final VoidCallback? onFavTap;
  final RegularProductController? controller;

  const CartItemCard({
    super.key,
    required this.item,
    this.onIncrease,
    this.onDecrease,
    this.onSaveForLater,
    this.onRemove,
    this.onComment,
    this.onFavTap,
    this.controller,
  });

  @override
  State<CartItemCard> createState() => _CartItemCardState();

  }

  class _CartItemCardState extends State<CartItemCard> {

  late TextEditingController qtyController;

  @override
  void initState() {
  super.initState();

  qtyController = TextEditingController(
  text: widget.item.quantity ?? "1",
  );
  }

  @override
  void didUpdateWidget(covariant CartItemCard oldWidget) {
  super.didUpdateWidget(oldWidget);

  if (oldWidget.item.quantity != widget.item.quantity) {
  qtyController.text = widget.item.quantity ?? "1";
  }
  }

  @override
  void dispose() {
  qtyController.dispose();
  super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    List<OptionModel>? options = [];

    item.options?.forEach((item) {
      final optionName = item.optionName ?? '';
      final optionValue = item.optionValueName ?? '';
      if ((optionName != "") && (optionValue != "")) {
        final option = "$optionName: $optionValue";
        options.add(
          OptionModel(title: option, optionIsColor: item.optionIsColor ?? ''),
        );
      }
    });

    return InkWell(
      onTap: () {
        Get.to(
              () => ProductDetailView(titleHeader: "Product Detail"),
          arguments: {
            'productId': item.selprodId ?? "",
            'productName': item.productName ?? "",
          },
        );
        debugPrint('this is selprodId');
        debugPrint('${item.selprodId}');
        debugPrint('this is productName');
        debugPrint('${item.productName}');
      },
      child: Card(
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
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              // 👈 left align
                              children: options.map((option) {
                                return Text(
                                  option.title,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w500,
                                    fontSize: 11,
                                  ),
                                );
                              }).toList(),
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
                              onTap: widget.onComment,
                              child: Text(
                                "${AppStrings.appAddComment.toUpperCase().tr}+",
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
                        onPressed: widget.onFavTap,
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
                        onPressed: widget.onDecrease,
                        icon: _qtyBtn("assets/images/decrease.png"),
                      ),
                      SizedBox(
                        width: 30,
                        child: TextField(
                          focusNode: FocusNode(),
                          controller: qtyController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          textAlign: TextAlign.center,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                            // trigger submission logic to keep existing behavior
                            final value = qtyController.text;
                          },
                          onSubmitted: (value) async {
                            // Keep existing onSubmitted for safety, delegate to onEditingComplete handling
                            final qty = int.tryParse(value) ?? 1;
                            if (qty < 1) {
                              showAlertMessage(
                                context,
                                title: AppLabels.APP_NAME,
                                message: "Minimum order quantity is 1.",
                              );
                              qtyController.text = item.quantity ?? "1";
                              return;
                            }
                            if (widget.controller != null) {
                              final success = await widget.controller!.productQuantityUpdate(item.key ?? "", qty.toString());
                              if (!success) {
                                qtyController.text = item.quantity ?? "1";
                              }
                            }
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: widget.onIncrease,
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
                  widget.onSaveForLater,
                ),
                Container(height: 42, width: 1, color: Colors.black12),
                _footerBtn(
                  AppStrings.appRemove.toUpperCase().tr,
                  "assets/images/bin.png",
                  widget.onRemove,
                ),
              ],
            ),
          ],
        ),
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
