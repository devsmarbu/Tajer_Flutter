// pages/product_list_page.dart
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import '../../../../../utils/app_colors.dart';
import '../../../../utils/app_strings.dart';
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
  final ProductController controller = Get.put(ProductController());

  bool showScrollToTop = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    /// 📌 FAB visibility listener
    _scrollController.addListener(() {
      if (_scrollController.offset > 800 && !showScrollToTop) {
        setState(() => showScrollToTop = true);
      } else if (_scrollController.offset <= 800 && showScrollToTop) {
        setState(() => showScrollToTop = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.colorAccountBackground,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(spacing: 10,children: [
              Text(
                controller.titleHeader,
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.black1,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w600,
                ),
              ),
              // RIGHT SIDE: Small image thumbnail (only when available)
              if (Get.parameters["imagePath"] != null &&
                  Get.parameters["imagePath"]!.isNotEmpty)
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black, // borderColor
                      width: 1,            // borderWidth
                    ),
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
                )
            ]),
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
                MaterialPageRoute(
                  builder: (context) => SearchView(), // Your dynamic search page
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          /// CART ICON WITH COUNT
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

      body: Stack(
        children: [
          /// 🔥 PRODUCT LIST
          Obx(() {
            if (controller.isLoading.value && controller.page == 1) {
              return const Center(child: CircularProgressIndicator());
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
                        (scrollInfo.metrics.maxScrollExtent * 0.9)) {
                  controller.loadMoreProducts();
                }
                return false;
              },

              child: GridView.builder(
                controller: _scrollController,
                // 🔥 REQUIRED for FAB visibility
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(10, 12, 10, 80),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.61,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: controller.products.length + 1,
                // include loader
                itemBuilder: (context, index) {
                  if (index == controller.products.length) {
                    return controller.isLoading.value
                        ? const Center(child: CircularProgressIndicator())
                        : const SizedBox.shrink();
                  }

                  final product = controller.products[index];

                  return ProductCard(
                    product: product,
                    isVertical: true,
                    onAddToCart: () {
                      final options = product.productOptions;

                      if (options != null &&
                          options.isNotEmpty &&
                          options.first.values != null) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (_) => SelectSizeView(
                            price: product.selprodPrice ?? "",
                            productId: product.productId ?? "",
                            productOptions: options.first.values!,
                            currencyCode:
                                controller.productData.value?.currencySymbol ??
                                "\$", productName: product.productName ?? "",
                          ),
                        );
                      } else {
                        Get.put(
                          SelectSizeController(product.selprodId ?? ""),
                        ).addToCart(product.selprodId ?? "",product.productName ?? '',product.selprodPrice ?? '');
                      }
                    },
                  );
                },
              ),
            );
          }),

          /// FILTER/SORT BAR (BOTTOM FIXED)
          Positioned(
            left: 0,
            right: 0,
            bottom: 20,
            child: Center(
              child: FilterSortBar(categoryId: controller.prodCatId, brandId: controller.brandId),
            ),
          ),
        ],
      ),

      /// 🔥 FAB VISIBLE AFTER SCROLL DOWN
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
