import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide Value;
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/modules/product_detail/select_size/select_size_controller.dart';
import 'package:tajer/utils/app_colors.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../home/home_model.dart';
import '../productSizeInfo/size_chart_screen.dart';
import '../product_detail_model.dart';
import '../product_detail_view.dart';

class SelectSizeView extends StatefulWidget {
  final List<ProductOptions>? productOptions;
  final String price;
  final String productName;
  final String productId;
  final String currencyCode;
  final String isSizeChartAvailable;

  const SelectSizeView({
    super.key,
    required this.productOptions,
    required this.price,
    required this.productId,
    required this.currencyCode,
    required this.productName,
    required this.isSizeChartAvailable,
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
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Container(
        key: Key("select_size_view"),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          key: Key("select_size_column"),
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              key: Key("select_size_list"),
              padding: EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.vertical,
              itemCount: controller.productOptions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, outerIndex) {
                final productOption = controller.productOptions[outerIndex];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            productOption.optionName ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          if ((controller.isSizeChartAvailable) == "1" &&
                              productOption.optionIsColor == "0")
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  barrierColor: Colors.black87,
                                  // dark background
                                  builder: (_) => SizeChartScreen(
                                    productId: controller.productId,
                                    productOptions: productOption.values ?? [],
                                    productName: widget.productName,
                                    productPrice: widget.price,
                                  ),
                                  //     SizeChartOverlay(
                                  //   imageUrl: datum?.sizeChartImage ?? "",
                                  // ),
                                );
                              },
                              child: Text(
                                (PrefStore().loadString(
                                  AppConstants.languageCode,
                                ) ==
                                    "AR")
                                    ? "مخطط الحجم"
                                    : "Size Chart",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: "Nunito",
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: productOption.optionIsColor == "0" ? 40 : 130,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: productOption.values?.length ?? 0,
                          itemBuilder: (context, index) {
                            final value = productOption.values?[index];
                            debugPrint("checkProductImageUrl: ${value?.productImageUrl}");
                            if (productOption.optionIsColor == "0") {
                              int stockValue = ((value?.stock ?? "0")
                                  .toIntSafe());

                              return GestureDetector(
                                onTap: () async {
                                  if (stockValue > 0 &&
                                      (value?.isSelected ?? "0") == "0") {
                                    debugPrint(
                                      "🟢 Selected option: ${value?.optionvalueName}",
                                    );
                                    controller.productId =
                                        value?.selprodId ?? "";
                                    await controller.fetchProductDetail();
                                  }
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    children: [
                                      Opacity(
                                        opacity: stockValue > 0 ? 1 : 0.4,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            right: 8,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 8,
                                          ),
                                          constraints: const BoxConstraints(
                                            minWidth: 40,
                                          ),
                                          decoration: BoxDecoration(
                                            color: value?.isSelected == "1"
                                                ? Colors.black
                                                : Colors.white,
                                            border: Border.all(
                                              color: Colors.black,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              value?.optionvalueName ?? "",
                                              style: TextStyle(
                                                color: value?.isSelected == "1"
                                                    ? Colors.white
                                                    : Colors.black,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: "Nunito",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),

                                      if (stockValue == 0)
                                        Positioned.fill(
                                          child: CustomPaint(
                                            painter: DiagonalCrossPainter(),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              );
                            } else {
                              return GestureDetector(
                                key: Key(
                                  "selected_option_${value?.optionvalueName}",
                                ),
                                onTap: () async {
                                  if ((value?.isSelected ?? "0") == "0") {
                                    controller.productId =
                                        value?.selprodId ?? "";
                                    await controller.fetchProductDetail();
                                  }
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(right: 16),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 120,
                                        height: 120,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            16,
                                          ),
                                          border: Border.all(
                                            color: value?.isSelected == "1"
                                                ? Colors.black
                                                : Colors.grey.shade300,
                                            width: value?.isSelected == "1"
                                                ? 2
                                                : 1,
                                          ),
                                        ),
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.circular(15),
                                                child: (value?.productImageUrl != null && value!.productImageUrl!.isNotEmpty)
                                                    ? CachedNetworkImage(
                                                        imageUrl: value.productImageUrl??"",
                                                        fit: BoxFit.cover,
                                                        placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                                                        errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported),
                                                      )
                                                    : (controller.fallbackImageUrl.value.isNotEmpty)
                                                        ? CachedNetworkImage(
                                                            imageUrl: controller.fallbackImageUrl.value,
                                                            fit: BoxFit.cover,
                                                            placeholder: (_, __) => const Center(child: CircularProgressIndicator()),
                                                            errorWidget: (_, __, ___) => const Icon(Icons.image_not_supported),
                                                          )
                                                        : const Center(
                                                            child: Icon(Icons.image, size: 50, color: Colors.grey),
                                                          ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 8,
                                              right: 8,
                                              child: Container(
                                                width: 24,
                                                height: 24,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                  border: Border.all(
                                                    color: value?.optionvalueColorCode?.hexToColor ?? Colors.transparent,
                                                    width: 1,
                                                  ),
                                                ),
                                                padding: const EdgeInsets.all(2),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: value?.optionvalueColorCode?.hexToColor ?? Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      // const SizedBox(height: 8),
                                      //
                                      // Text(
                                      //   value?.optionvalueName ?? "",
                                      //   style: TextStyle(
                                      //     fontSize: 12,
                                      //     fontWeight: value?.isSelected == "1"
                                      //         ? FontWeight.w600
                                      //         : FontWeight.w400,
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                              // return GestureDetector(
                              //   key: Key("selected_option_${value?.optionvalueName}"),
                              //   onTap: () async {
                              //     if ((value?.isSelected ?? "0") == "0") {
                              //       debugPrint(
                              //         "🟢 Selected option: ${value?.optionvalueName}",
                              //       );
                              //       controller.productId = value?.selprodId ?? "";
                              //       await controller.fetchProductDetail();
                              //     }
                              //   },
                              //   child: AnimatedScale(
                              //     scale: value?.isSelected == "1" ? 1.15 : 1.0,
                              //     duration: const Duration(milliseconds: 200),
                              //     curve: Curves.easeOut,
                              //     child: Container(
                              //       margin: const EdgeInsets.all(0),
                              //       width: 56,
                              //       height: 56,
                              //       decoration: BoxDecoration(
                              //         shape: BoxShape.circle,
                              //         border: Border.all(
                              //           color: value?.isSelected == "1"
                              //               ? Colors.black
                              //               : Colors.grey.shade400,
                              //           width: value?.isSelected == "1"
                              //               ? 2.5
                              //               : 1,
                              //         ),
                              //       ),
                              //       child: Center(
                              //         child: Container(
                              //           width: value?.isSelected == "1"
                              //               ? 26
                              //               : 46,
                              //           height: value?.isSelected == "1"
                              //               ? 26
                              //               : 46,
                              //           decoration: BoxDecoration(
                              //             shape: BoxShape.circle,
                              //             color:
                              //                 value
                              //                     ?.optionvalueColorCode
                              //                     ?.hexToColor ??
                              //                 Colors.transparent,
                              //             border: Border.all(
                              //               color: Colors.white,
                              //               width: 1,
                              //             ),
                              //             boxShadow: value?.isSelected == "1"
                              //                 ? [
                              //                     BoxShadow(
                              //                       color: Colors.black
                              //                           .withValues(alpha: 0.2),
                              //                       blurRadius: 6,
                              //                       spreadRadius: 1,
                              //                       offset: const Offset(0, 2),
                              //                     ),
                              //                   ]
                              //                 : [],
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
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
                        key: Key("add_to_cart_button"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20),
                        ),
                        onPressed:
                        controller.isLoading.value ||
                            controller.inStock.value != "1"
                            ? null
                            : () {
                          controller.addToCart(
                            controller.productId,
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
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    Get.delete<SelectSizeController>(tag: widget.productId);
    super.dispose();
  }
}
