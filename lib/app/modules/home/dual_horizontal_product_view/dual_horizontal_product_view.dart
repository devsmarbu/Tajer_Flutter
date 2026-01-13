import 'package:flutter/material.dart';
import 'package:tajer/app/modules/product_detail/select_size/select_size_controller.dart';
import '../../productList/models/product.dart';
import '../../product_detail/select_size/select_size_view.dart';
import '../header_view/header_view.dart';
import '../home_controller.dart';
import 'package:get/get.dart';

import '../home_model.dart';

enum ScrollDirection { vertical, horizontal }

class DualHorizontalProductView extends StatefulWidget {
  // Remove the field initializer; make it a constructor parameter
  final List<HomeProduct> products;
  final String? titleHeader;
  final String? currencyCode;
  final Axis? scrollDirection;
  final double? height;
  final bool? wantHeader;
  final bool? scrollEnabled;
  final bool? isHomeHeader;
  final bool? isHideSeeAll;
  final String? prodCatId;
  final Collection collection;

  // Now the constructor can be const (if images is provided as const)
  const DualHorizontalProductView({
    super.key,
    this.height,
    this.titleHeader,
    this.scrollDirection,
    this.wantHeader,
    this.scrollEnabled,
    this.isHomeHeader,
    this.isHideSeeAll,
    required this.products,
    this.prodCatId,
    required this.collection, this.currencyCode,
  }); // Assign the parameter to the field

  @override
  State<DualHorizontalProductView> createState() =>
      _DualHorizontalProductViewState();
}

class _DualHorizontalProductViewState extends State<DualHorizontalProductView> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    // Determine direction with fallback
    final Axis direction = widget.scrollDirection ?? Axis.horizontal;
    final bool isVertical = direction == Axis.vertical;
    final bool isHorizontal = direction == Axis.horizontal;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Your header (unchanged)
          if (widget.wantHeader == true)
            HeaderView(
              titleHeader: widget.titleHeader ?? "",
              isHomeHeader: widget.isHomeHeader ?? true,
              hideSeeAll: widget.isHideSeeAll ?? false,
              prodCatId: widget.prodCatId ?? "0",
              collection: widget.collection,
            ),
          // Conditional scroller based on direction
          isHorizontal
              ? SizedBox(
                  height: widget.height,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    itemCount: widget.products.length,
                    itemBuilder: (context, index) {
                      return _buildProductItem(
                        context,
                        index,
                        isVertical: false,
                        controller: controller,
                      );
                    },
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  // ✅ Auto-expand height
                  physics: const NeverScrollableScrollPhysics(),
                  // ✅ No nested scroll
                  cacheExtent: 200,
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                    vertical: 12.0,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.61,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 12.0,
                  ),
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    return _buildProductItem(
                      context,
                      index,
                      isVertical: true,
                      controller: controller,
                    );
                  },
                ),
        ],
      ),
    );
  }

  // Extracted method for the product item (avoids code duplication)
  Widget _buildProductItem(
    BuildContext context,
    int index, {
    required bool isVertical,
    required HomeController controller,
  }) {
    final provider = NetworkImage(widget.products[index].productImageUrl ?? "");
    var product = widget.products[index];

    // Dynamic width based on direction (for vertical grid, it auto-fits with crossAxisCount)
    final double itemWidth = isVertical
        ? (Get.width / 2) -
              10 // Half screen minus margins for 2-column grid
        : 160; // Fixed for horizontal

    return InkWell(
      onTap: () {
        controller.goToProductDetailView(
          product.selprodId ?? "",
          product.productName ?? "",
        );
        // Get.to(() => ProductDetailView(titleHeader: "Product Detail")); // Uncomment if needed
      },
      child: Container(
        width: itemWidth,
        // Apply dynamic width
        margin: isVertical
            ? const EdgeInsets.all(
                0,
              ) // No extra margin in grid (handled by gridDelegate)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        // Margin for horizontal ListView
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 4,
              offset: Offset(0, 0),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with rounded top corners (unchanged, but width is now from container)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Stack(
                children: [
                  Image(
                    height: widget.scrollDirection == Axis.horizontal
                        ? 160
                        : 200,
                    // Fixed height for consistency
                    width: itemWidth,
                    // Use the dynamic width
                    image: provider,
                    fit: BoxFit.cover,
                    // Add loading/error handling (optional but recommended)
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[200],
                        child: const Icon(Icons.error, color: Colors.red),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: SizedBox(
                      width: 37,
                      height: 37,
                      child: TextButton(
                        onPressed: () {
                          debugPrint("Add to cart tapped");
                          final options = product.productOptions;
                          if (options != null && options.isNotEmpty) {
                            final firstOptionValues =
                                options.first.values ?? [];
                            if (firstOptionValues.isNotEmpty) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => SelectSizeView(
                                  price: product.selprodPrice ?? "",
                                  productId: firstOptionValues.first.selprodId ?? "",
                                  productOptions: firstOptionValues,
                                  currencyCode: product.selprodPrice?.replaceAll(RegExp(r'[0-9.]'), '') ?? "\$", productName: product.selprodTitle ?? '',
                                ),
                              );
                            } else {
                              final sizeController = Get.put(SelectSizeController(product.selprodId ?? ''));
                              sizeController.addToCart(product.selprodId ?? '',product.selprodTitle ?? '',product.selprodPrice ?? '');
                            }
                          } else {
                            final sizeController = Get.put(SelectSizeController(product.selprodId ?? ''));
                            sizeController.addToCart(product.selprodId ?? '',product.selprodTitle ?? '',product.selprodPrice ?? '');
                          }
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero, // remove default padding
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 6,
                                offset: Offset(0, 0),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Image.asset(
                              "assets/images/AddToCart.png",
                              fit: BoxFit.contain,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                product.brandName ?? "",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Nunito",
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                product.productName ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  fontFamily: "Nunito",
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Text(
                product.selprodPrice ?? "",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: "Nunito",
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
