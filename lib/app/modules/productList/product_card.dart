import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:tajer/app/modules/home/home_model.dart';
import 'package:tajer/app/modules/productList/controllers/product_controller.dart';
import 'package:tajer/app/modules/product_detail/product_detail_view.dart';

import '../../../utils/pref_store.dart';
import '../../core/constants/app_constants.dart';
import '../authentication/login/login_screen.dart';
import '../home/home_controller.dart';
import '../product_detail/shop_detail_view/shop_detail_controller.dart';
import '../product_detail/wishlist_names_view/wishlist_names_view.dart';

class ProductCard extends StatelessWidget {
  final HomeProduct product;
  final bool isVertical;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;
  final List<Color> colorList;
  final String productIndex;

  const ProductCard({
    super.key,
    required this.product,
    this.isVertical = true,
    this.onAddToCart,
    this.onTap,
    required this.colorList,
    required this.productIndex,
  });

  @override
  Widget build(BuildContext context) {
    final imageProvider = NetworkImage(product.productImageUrl ?? "");
    RxString isInAnyWishlist = (product.is_in_any_wishlist ?? '0').obs;
    final tag = Get.parameters['uniqueId'];
    final controller = Get.put(ProductController(), tag: tag);
    final shopController = Get.put(ShopDetailController());

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = constraints.maxWidth;

        return InkWell(
          onTap:
              onTap ??
              () {
                Get.to(
                  () => ProductDetailView(titleHeader: "Product Detail"),
                  arguments: {
                    'productId': product.selprodId ?? "",
                    'productName': product.productName ?? "",
                  },
                );
              },
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Container(
            margin: isVertical
                ? const EdgeInsets.all(6)
                : const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 4),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ✅ Responsive Image
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(18),
                  ),
                  child: Stack(
                    children: [
                      AspectRatio(
                        aspectRatio: 1, // 👈 Square image (Fold-safe)
                        child: Image(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            color: Colors.grey[200],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),

                      /// ❤️ FAVORITE BUTTON
                      Positioned(
                        top: 10,
                        right: 10,
                        child: GestureDetector(
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
                                    productIndex,
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
                                isInAnyWishlist.value = result.toString();
                                if (Get.currentRoute.startsWith(AppRoutes.shopDetailView)) {
                                  shopController.updateFav(
                                    isInAnyWishlist.value,
                                    productIndex,
                                  );
                                }
                                if (Get.currentRoute.startsWith(AppRoutes.productListPage)) {
                                  controller.updateFav(
                                    isInAnyWishlist.value,
                                    productIndex,
                                  );
                                }
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
                              color: Colors.white.withOpacity(0.50),
                              // 👈 translucent white
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

                                /// +MORE COUNT after 2 items
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

                      /// Add to cart
                      Positioned(
                        bottom: 12,
                        right: 12,
                        child: SizedBox(
                          width: 36,
                          height: 36,
                          child: Semantics(
                            label: 'add_to_cart_button_$productIndex',
                            button: true,
                            enabled: true,
                            child: IconButton(
                              key: Key('addToCart_$productIndex'),
                              padding: EdgeInsets.zero,
                              onPressed: onAddToCart,
                              icon: Container(
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
                      ),
                    ],
                  ),
                ),

                /// ✅ Product Info (Flexible-safe)
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 6,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.brandName ?? "",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Nunito',color: Colors.black54
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product.productName ?? "",
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Nunito'
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          product.selprodPrice ?? "",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Nunito'
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis, // 👈 critical
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
