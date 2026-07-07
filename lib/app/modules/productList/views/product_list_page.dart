// pages/product_list_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/marque_label.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../../Cart/MainCartView.dart';
import '../../home/home_controller.dart';
import '../../product_detail/search_view/search_view.dart';
import '../../product_detail/select_size/select_size_controller.dart';
import '../../product_detail/select_size/select_size_view.dart';
import '../controllers/product_controller.dart';
import '../product_card.dart';
import 'filter_sort_bar.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late final ProductController controller;

  bool showScrollToTop = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    final tag = Get.parameters['uniqueId'];
    controller = Get.put(ProductController(), tag: tag);
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 800 && !showScrollToTop) {
        setState(() => showScrollToTop = true);
      } else if (_scrollController.offset <= 800 && showScrollToTop) {
        setState(() => showScrollToTop = false);
      }
    });
  }

  @override
  void dispose() {
    final tag = Get.parameters['uniqueId'];
    Get.delete<ProductController>(tag: tag);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isFolded = width <= 400;

    return Scaffold(
      backgroundColor: AppColors.colorAccountBackground,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 TITLE ROW (FIXED OVERFLOW)
            Row(
              children: [
                Expanded(
                  child: Text(
                    controller.titleHeader,
                    maxLines: isFolded ? 1 : 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.black1,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),


                /// RIGHT IMAGE (OPTIONAL)
                if (Get.parameters["imagePath"] != null &&
                    Get.parameters["imagePath"]!.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.file(
                        File(Get.parameters["imagePath"]!),
                        width: 24,
                        height: 24,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
              ],
            ),

            /// ITEM COUNT
            Obx(
              () => Text(
                '${controller.productData.value?.recordCount ?? "0"} ${AppStrings.app_items.tr}',
                style: const TextStyle(
                  fontFamily: "Nunito",
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SearchView()),
              );
            },
          ),
          const SizedBox(width: 5),

          /// CART ICON
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 15),
            child: GestureDetector(
              onTap: () {
                Get.back();
                Get.toNamed(AppRoutes.cartPage);
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/images/cartIcon.png",
                    height: 25,
                    color: Colors.black,
                  ),
                  Obx(() {
                    if (cartItemCounts.value.toIntSafe() > 0) {
                      return Positioned(
                        top: -6,
                        right: -8,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Text(
                            cartItemCounts.value.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),

      body: Column(
        children: [
          /// 🔥 PROMO MARQUEE (FIXED – NOT SCROLLABLE)
          if (PrefStore().loadString(AppConstants.promoBannerEnabled) == "1")
            SizedBox(
              height: 30,
              width: double.infinity,
              child:
                  (PrefStore().loadString(AppConstants.promoBannerText) ?? '')
                      .marqueeLabel(),
            ),

          /// PRODUCT LIST
          Expanded(
            child: Stack(
              children: [
                Obx(() {
                  if (controller.isLoading.value && controller.page == 1) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.black),
                    );
                  }

                  if (controller.products.isEmpty) {
                    return Center(
                      child: EmptyCartWidget(
                        imagePath: 'assets/images/no_data_image.png',
                        message: AppStrings.appNoDataFound.tr,
                      ),
                    );
                  }

                  return NotificationListener<ScrollNotification>(
                    onNotification: (scrollInfo) {
                      if (!controller.isLoading.value &&
                          controller.hasMore.value &&
                          scrollInfo.metrics.pixels >=
                              scrollInfo.metrics.maxScrollExtent * 0.9) {
                        controller.loadMoreProducts();
                      }
                      return false;
                    },
                    child: GridView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.fromLTRB(10, 12, 10, 80),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: isFolded ? 0.62 : 0.68,
                      ),
                      itemCount:
                          controller.products.length,
                      itemBuilder: (context, index) {
                        if (index == controller.products.length) {
                          return controller.isLoading.value
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.black,
                                  ),
                                )
                              : const SizedBox.shrink();
                        }
                        final product = controller.products[index];

                        // 👇 Extract colors for THIS product only
                        List<Color> colorList = [];

                        if (product.productOptions != null) {
                          for (var option in product.productOptions!) {
                            if (option.optionIsColor == "1") {
                              for (var value in option.values ?? []) {
                                final hexCode = value.optionvalueColorCode;

                                if (hexCode != null && hexCode.isNotEmpty) {
                                  try {
                                    final cleanedHex = hexCode.replaceAll("#", "");

                                    // Add full opacity if only 6 characters
                                    final formattedHex =
                                    cleanedHex.length == 6 ? "FF$cleanedHex" : cleanedHex;

                                    final color =
                                    Color(int.parse(formattedHex, radix: 16));

                                    colorList.add(color);
                                  } catch (e) {
                                    debugPrint("Invalid color code: $hexCode");
                                  }
                                }
                              }
                            }
                          }
                        }

                        return ProductCard(
                          product: product,
                          isVertical: true,
                          colorList: colorList,
                          onAddToCart: () {
                            final options = product.productOptions;

                            if (options != null &&
                                options.isNotEmpty &&
                                options.first.values != null &&
                                options.first.values!.isNotEmpty) {
                              final firstOptionValues = options.first.values!;

                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (_) => SelectSizeView(
                                  price: product.selprodPrice ?? "",
                                  productId:
                                      firstOptionValues.first.selprodId ?? "",
                                  productOptions: options,
                                  currencyCode:
                                      controller
                                          .productData
                                          .value
                                          ?.currencySymbol ??
                                      "\$",
                                  productName: product.productName ?? "",
                                  isSizeChartAvailable: '',
                                ),
                              );
                            } else {
                              Get.put(
                                SelectSizeController(product.selprodId ?? ""),
                              ).addToCart(
                                product.selprodId ?? "",
                                product.productName ?? '',
                                product.selprodPrice ?? '',
                                directAddedToCart: '1'
                              );
                            }
                          }, productIndex: index.toString(),
                        );
                      },
                    ),
                  );
                }),

                /// FILTER BAR (still floating)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 20,
                  child: Center(
                    child: FilterSortBar(
                      categoryId: controller.prodCatId,
                      brandId: controller.brandId,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      /// SCROLL TO TOP FAB
      floatingActionButton: showScrollToTop
          ? Padding(
              padding: EdgeInsets.only(bottom: Platform.isIOS ? 40 : 0),
              child: FloatingActionButton.small(
                backgroundColor: Colors.black,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
