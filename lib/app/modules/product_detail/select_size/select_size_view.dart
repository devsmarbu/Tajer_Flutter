import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/app/modules/product_detail/select_size/select_size_controller.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../home/home_model.dart';

class SelectSizeView extends StatefulWidget {
  final List<Value>? productOptions;
  final String price;
  final String productName;
  final String productId;
  final String currencyCode;

  const SelectSizeView({
    super.key,
    required this.productOptions,
    required this.price,
    required this.productId,
    required this.currencyCode,
    required this.productName,
  });

  @override
  State<SelectSizeView> createState() => _SelectSizeSheetState();
}

class _SelectSizeSheetState extends State<SelectSizeView> {
  String? selectedSize;
  String? selectedSizePrice;
  String? selectedSizeProductId;
  late SelectSizeController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.put(
      SelectSizeController(widget.productId),
      tag: widget.productId,
    );
    selectedSizePrice = widget.price.replaceAll(RegExp(r'[A-Za-z]'), '');

    setState(() {
      selectedSize = widget.productOptions?.first.optionvalueName ?? "";
      selectedSizePrice = widget.productOptions?.first.theprice ?? "";
      selectedSizeProductId = widget.productOptions?.first.selprodId ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.appSelectSize.toUpperCase().tr,
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Nunito",
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 30),

          /// Size buttons
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: (widget.productOptions ?? []).map((size) {
                final isSelected = selectedSize == size.optionvalueName;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedSize = size.optionvalueName ?? "";
                        selectedSizePrice = size.theprice ?? "";
                        selectedSizeProductId = size.selprodId ?? "";
                      });
                      controller.productId = size.selprodId ?? "";
                      controller.fetchProductDetail();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Colors.black
                            : const Color(0xFFF5F4F9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        size.optionvalueName ?? "",
                        style: TextStyle(
                          fontSize: 16,
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 30),

          /// Price and Add to Cart Row
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Text(
                      "${widget.currencyCode}${selectedSizePrice ?? ""}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Nunito",
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Obx(() {
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                    onPressed: controller.isLoading.value || controller.inStock.value != "1"
                        ? null
                        : () {
                      controller.addToCart(
                        selectedSizeProductId ?? "",
                        widget.productName,
                        selectedSizePrice ?? widget.price,
                      );
                    },
                    child: controller.isLoading.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Obx(
                            () => Text(
                              controller.inStock.value == "1"
                                  ? AppStrings.appAddToCart.tr
                                  : AppStrings.appSoldOut.tr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 5),
        ],
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<SelectSizeController>(tag: widget.productId);
    super.dispose();
  }
}
