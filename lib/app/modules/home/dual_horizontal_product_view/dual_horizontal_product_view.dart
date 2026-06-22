import 'package:flutter/material.dart';
import 'package:tajer/app/modules/product_detail/select_size/select_size_controller.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../authentication/login/login_screen.dart';
import '../../productList/models/product.dart';
import '../../product_detail/product_detail_controller.dart';
import '../../product_detail/select_size/select_size_view.dart';
import '../../product_detail/wishlist_names_view/wishlist_names_view.dart';
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
    required this.collection,
    this.currencyCode,
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
            key: const ValueKey('vertical_product_grid'),
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
    final product = widget.products[index];
    RxString isInAnyWishlist =
        (widget.products[index].is_in_any_wishlist ?? '0').obs;

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
                final formattedHex = cleanedHex.length == 6
                    ? "FF$cleanedHex"
                    : cleanedHex;

                final color = Color(int.parse(formattedHex, radix: 16));
                colorList.add(color);
              } catch (e) {
                debugPrint("Invalid color code: $hexCode");
              }
            }
          }
        }
      }
    }

    final double itemWidth = isVertical ? (Get.width / 2) - 18 : 180;

    return Semantics(
      label: 'Product ${product.productName}',
      hint: 'Tap to view product details',
      button: true,
      child: InkWell(
        key: ValueKey('product_item_${product.selprodId}_$index'),
        borderRadius: BorderRadius.circular(18),
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          controller.goToProductDetailView(
            product.selprodId ?? "",
            product.productName ?? "",
          );
        },
        child: Container(
          width: itemWidth,
          margin: isVertical
              ? EdgeInsets.zero
              : const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE SECTION
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
                child: Stack(
                  children: [
                    Semantics(
                      label: 'Image of ${product.productName}',
                      image: true,
                      child: Image(
                        key: ValueKey('product_image_${product.selprodId}'),
                        height: widget.scrollDirection == Axis.horizontal
                            ? 190
                            : 210,
                        width: itemWidth,
                        image: provider,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: 210,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(color: Colors.black),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 210,
                            color: Colors.grey[200],
                            child: const Icon(Icons.error, color: Colors.red),
                          );
                        },
                      ),
                    ),
      
                    /// ❤️ FAVORITE BUTTON
                    Positioned(
                      top: 10,
                      right: 10,
                      child: Semantics(
                        label: isInAnyWishlist.value == '0'
                            ? 'Add to wishlist'
                            : 'Remove from wishlist',
                        button: true,
                        child: GestureDetector(
                          key: ValueKey(
                              'wishlist_btn_${product.selprodId}'),
                          onTap: () async {
                            debugPrint("Favorite tapped");
                            if ((PrefStore().loadString(
                                      AppConstants.sessionToken,
                                    ) ??
                                    "") ==
                                "") {
                              Get.bottomSheet(
                                LoginScreen(isEmail: true, isBottomSheet: true),
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                              );
                            } else if (isInAnyWishlist.value != "0") {
                              
                              final result = await controller.addRemoveToWishlist(
                                product.selprodId ?? '',
                                "0",
                                "0",
                                widget.collection.collectionId ?? '',
                                index.toString(),
                              );
                              isInAnyWishlist.value = result.toString();
                            } else {
                              final result = await showGeneralDialog(
                                context: context,
                                barrierLabel: "Wishlist",
                                barrierDismissible: true,
                                barrierColor: Colors.black.withValues(alpha: 0.4),
                                transitionDuration: const Duration(
                                  milliseconds: 300,
                                ),
                                pageBuilder: (_, __, ___) =>
                                    WishlistNamesViewPopOver(
                                      productId: product.selprodId ?? '',
                                    ),
                                transitionBuilder: (_, anim, __, child) {
                                  return SlideTransition(
                                    position:
                                        Tween(
                                          begin: const Offset(0, 1),
                                          end: Offset.zero,
                                        ).animate(
                                          CurvedAnimation(
                                            parent: anim,
                                            curve: Curves.easeOut,
                                          ),
                                        ),
                                    child: child,
                                  );
                                },
                              );
                              if (result != null) {
                                debugPrint(index.toString());
                                debugPrint(widget.collection.collectionId ?? '');
                                isInAnyWishlist.value = result.toString();
                                controller.updateFav(isInAnyWishlist.value, widget.collection.collectionId ?? '', index.toString());
                              }
                            }
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.95),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.10),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Obx(() => Icon(
                              isInAnyWishlist.value == '0'
                                  ? Icons.favorite_border
                                  : Icons.favorite,
                              size: 20,
                              color: isInAnyWishlist.value == '0'
                                  ? Colors.black
                                  : Colors.red,
                            )),
                          ),
                        ),
                      ),
                    ),
      
                    /// ✅ COLOR VARIANTS
                    if (colorList.isNotEmpty)
                      Positioned(
                        bottom: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 4),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ...colorList.take(2).map((color) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  width: 14,
                                  height: 14,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: color,
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1,
                                    ),
                                  ),
                                );
                              }).toList(),
      
                              if (colorList.length > 2)
                                Text(
                                  "+${colorList.length - 2}",
                                  style: const TextStyle(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
      
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: Semantics(
                        label:
                        'Add ${product.productName} to cart',
                        button: true,
                        child: GestureDetector(
                          key: ValueKey(
                              'add_to_cart_${product.selprodId}'),
                          onTap: () {
                            debugPrint("Add to cart tapped");
                            final options = product.productOptions;
                              
                            if (options != null && options.isNotEmpty) {
                              final firstOptionValues = options.first.values ?? [];
                              
                              if (firstOptionValues.isNotEmpty) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  backgroundColor: Colors.transparent,
                                  builder: (context) => SelectSizeView(
                                    price: product.selprodPrice ?? "",
                                    productId:
                                        firstOptionValues.first.selprodId ?? "",
                                    productOptions: options,
                                    currencyCode:
                                        product.selprodPrice?.replaceAll(
                                          RegExp(r'[0-9.]'),
                                          '',
                                        ) ??
                                        "\$",
                                    productName: product.selprodTitle ?? '',
                                    isSizeChartAvailable: '',
                                  ),
                                );
                              } else {
                                final sizeController = Get.put(
                                  SelectSizeController(product.selprodId ?? ''),
                                );
                                sizeController.addToCart(
                                  product.selprodId ?? '',
                                  product.selprodTitle ?? '',
                                  product.selprodPrice ?? '',
                                  directAddedToCart: '1',
                                );
                              }
                            } else {
                              final sizeController = Get.put(
                                SelectSizeController(product.selprodId ?? ''),
                              );
                              sizeController.addToCart(
                                product.selprodId ?? '',
                                product.selprodTitle ?? '',
                                product.selprodPrice ?? '',
                                directAddedToCart: '1',
                              );
                            }
                          },
                          child: Container(
                            width: 35,
                            height: 35,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.12),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.black,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      
              const SizedBox(height: 10),
      
              /// BRAND
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  key: ValueKey('brand_${product.selprodId}'),
                  product.brandName ?? "",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    fontFamily: "Nunito",
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
      
              const SizedBox(height: 4),
      
              /// PRODUCT NAME
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  key: ValueKey('name_${product.selprodId}'),
                  product.productName ?? "",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                    fontFamily: "Nunito",
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
      
              /// PRICE + CART
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        key: ValueKey('price_${product.selprodId}'),
                        product.selprodPrice ?? "",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          fontFamily: "Nunito",
                        ),
                        maxLines: 1,
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
    );
  }
}
