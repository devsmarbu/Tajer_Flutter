import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/wish_list/wish_list_items_view/wish_list_item_controller.dart';
import '../../Cart/MainCartView.dart';
import '../../product_detail/select_size/select_size_controller.dart';
import '../../product_detail/select_size/select_size_view.dart';

class WishListItemsView extends StatefulWidget {
  const WishListItemsView({super.key});

  @override
  State<WishListItemsView> createState() => _WishListItemsViewState();
}

class _WishListItemsViewState extends State<WishListItemsView> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WishListItemController());
    final width = MediaQuery.of(context).size.width;
    final bool isFolded = width <= 400;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        elevation: 0,
        title: Text(
          controller.wishlistTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontFamily: "Nunito",
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: Colors.black));
        }

        if (controller.products.isEmpty) {
          return const Center(
            child: EmptyCartWidget(
              imagePath: 'assets/images/no_data_image.png',
              message: 'No Wishlist items',
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: GridView.builder(
            itemCount: controller.products.length,
            physics: const BouncingScrollPhysics(),
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: isFolded ? 0.52 : 0.6, // Perfect aspect ratio
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (context, index) {
              return _buildProductCard(controller, index);
            },
          ),
        );
      }),
    );
  }

  Widget _buildProductCard(WishListItemController controller, int index) {
    final item = controller.products[index];

    return Semantics(
      label: "wishlist_item_$index",
      child: InkWell(
        key: ValueKey("wishlist_items_$index"),
        onTap: () => controller.goToProductDetailView(item.selprodId ?? '', item.selprodTitle ?? ''),
        child: Container(
          key: ValueKey("wishlist_container_$index"),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------------- IMAGE ----------------
              Semantics(
                label: "wishlist_image_$index",
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(14),
                    topRight: Radius.circular(14),
                  ),
                  child: Container(
                    height: 180,
                    width: double.infinity,
                    color: Colors.grey[100],
                    child: Image.network(
                      key: ValueKey("wishlist_image_network_$index"),
                      item.productImageUrl ?? "",
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ),

              // ⬇️ This part should expand equally for all items
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // TITLE
                      Semantics(
                        label: "wishlist_title_$index",
                        child: Text(
                          key: ValueKey("wishlist_title_text_$index"),
                          item.selprodTitle ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            fontFamily: "Nunito",
                          ),
                        ),
                      ),

                      const SizedBox(height: 6),

                      // PRICE
                      Semantics(
                        label: "wishlist_price_$index",
                        child: Text(
                          key: ValueKey("wishlist_price_text_$index"),
                          item.selprodPrice ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ---------------- DIVIDER + FIXED FOOTER ----------------
              const Divider(height: 1, thickness: 1),

              SizedBox(
                height: 50, // always fixed height
                child: Row(
                  children: [
                    Expanded(
                      child: Semantics(
                        label: "wishlist_remove_btn_$index",
                        button: true,
                        child: IconButton(
                          key: ValueKey("wishlist_remove_btn_$index"),
                          splashRadius: 22,
                          onPressed: () => controller.addRemoveToWishlist(
                              item.selprodId ?? "", "0", "0"),
                          icon: Image.asset(
                            "assets/images/red_heart.png",
                            height: 22,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                    Container(width: 1, height: 24, color: Colors.grey[300]),
                    Expanded(
                      child: Semantics(
                        label: "wishlist_add_to_cart_btn_$index",
                        button: true,
                        child: IconButton(
                          key: ValueKey("wishlist_add_to_cart_btn_$index"),
                          splashRadius: 22,
                          onPressed: () {
                            // final sizeController = Get.put(SelectSizeController(item.selprodId ?? ''));
                            // sizeController.addToCart(item.selprodId ?? '',item.selprodTitle ?? '',item.selprodPrice ?? '',directAddedToCart: '1');
                        
                            final options = item.productOptions;
                        
                            debugPrint("product_options: ${jsonEncode(options)}");
                        
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
                                  price: item.selprodPrice ?? "",
                                  productId:
                                  firstOptionValues.first.selprodId ?? "",
                                  productOptions: options,
                                  currencyCode:
                                  controller.currencySymbol.value,
                                  productName: item.productName ?? "",
                                  isSizeChartAvailable: '',
                                ),
                              );
                            } else {
                              Get.put(
                                SelectSizeController(item.selprodId ?? ""),
                              ).addToCart(
                                  item.selprodId ?? "",
                                  item.productName ?? '',
                                  item.selprodPrice ?? '',
                                  directAddedToCart: '1'
                              );
                            }
                          },
                          icon: Image.asset(
                            "assets/images/cartIcon.png",
                            height: 22,
                            color: Colors.black,
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