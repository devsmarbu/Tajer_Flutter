import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajer/app/modules/product_detail/select_size/select_size_controller.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../authentication/login/login_screen.dart';
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
              ? Container(
                  color:
                      widget.collection.appColor, // collection_app_color_code
                  child: SizedBox(
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
                    childAspectRatio: 0.57,
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
        borderRadius: BorderRadius.circular(12),
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
            borderRadius: BorderRadius.circular(13),
            border: Border.all(color: const Color(0xFFE2E2E2), width: 1.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// IMAGE SECTION
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                child: Stack(
                  children: [
                    Semantics(
                      label: 'Image of ${product.productName}',
                      image: true,
                      child: Image(
                        key: ValueKey('product_image_${product.selprodId}'),
                        height: widget.scrollDirection == Axis.horizontal
                            ? 180
                            : 190,
                        width: itemWidth,
                        image: provider,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            height: widget.scrollDirection == Axis.horizontal
                                ? 180
                                : 190,
                            color: Colors.grey[200],
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Colors.black,
                              ),
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: widget.scrollDirection == Axis.horizontal
                                ? 180
                                : 190,
                            color: Colors.grey[200],
                            child: const Icon(Icons.error, color: Colors.red),
                          );
                        },
                      ),
                    ),

                    /// ❤️ FAVORITE BUTTON
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Semantics(
                        label: isInAnyWishlist.value == '0'
                            ? 'Add to wishlist'
                            : 'Remove from wishlist',
                        button: true,
                        child: GestureDetector(
                          key: ValueKey('wishlist_btn_${product.selprodId}'),
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
                              final result = await controller
                                  .addRemoveToWishlist(
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
                                barrierColor: Colors.black.withValues(
                                  alpha: 0.4,
                                ),
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
                                debugPrint(
                                  widget.collection.collectionId ?? '',
                                );
                                isInAnyWishlist.value = result.toString();
                                controller.updateFav(
                                  isInAnyWishlist.value,
                                  widget.collection.collectionId ?? '',
                                  index.toString(),
                                );
                              }
                            }
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: const BoxDecoration(
                              color: Color(0xFFEDEDED),
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(12),
                                bottomLeft: Radius.circular(12),
                              ),
                            ),
                            child: Center(
                              child: Obx(
                                () => Icon(
                                  isInAnyWishlist.value == '0'
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  size: 22,
                                  color: isInAnyWishlist.value == '0'
                                      ? Colors.black54
                                      : const Color(0xFFFE6B6B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),

                    /// ✅ COLOR VARIANTS OVERLAPPING
                    if (colorList.isNotEmpty)
                      Positioned(
                        bottom: 12,
                        left: 12,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ...List.generate(
                              colorList.length > 3 ? 3 : colorList.length,
                              (idx) {
                                return Align(
                                  widthFactor: 0.65,
                                  child: Container(
                                    width: 26,
                                    height: 26,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: colorList[idx],
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 1.5,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (colorList.length > 3)
                              Align(
                                widthFactor: 0.65,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFFEDEDED),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "+${colorList.length - 3}",
                                      style: const TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              /// DETAILS SECTION
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          /// BRAND
                          Text(
                            key: ValueKey('brand_${product.selprodId}'),
                            (product.brandName ?? "").toUpperCase(),
                            style: const TextStyle(
                              fontSize: 7,
                              fontWeight: FontWeight.w600,
                              fontFamily: "Nunito",
                              color: Colors.black54,
                              letterSpacing: 0.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),

                          /// PRODUCT NAME
                          Text(
                            key: ValueKey('name_${product.selprodId}'),
                            (product.productName ?? "").toUpperCase(),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 9,
                              fontFamily: "Nunito",
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),

                          /// PRICE
                          Text(
                            key: ValueKey('price_${product.selprodId}'),
                            product.selprodPrice ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 13,
                              fontFamily: "Nunito",
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 2),

                    /// CART BUTTON
                    Semantics(
                      label: 'Add ${product.productName} to cart',
                      button: true,
                      child: GestureDetector(
                        key: ValueKey('add_to_cart_${product.selprodId}'),
                        onTap: () {
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
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1E1E),
                            // Dark charcoal/black
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              "assets/icons/ic_cart_new.svg",
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
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
