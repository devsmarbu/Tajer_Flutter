import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/wish_list/wish_list_items_view/wish_list_item_controller.dart';
import '../../Cart/MainCartView.dart';

class WishListItemsView extends StatefulWidget {
  const WishListItemsView({super.key});

  @override
  State<WishListItemsView> createState() => _WishListItemsViewState();
}

class _WishListItemsViewState extends State<WishListItemsView> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(WishListItemController());

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
          return const Center(child: CircularProgressIndicator());
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
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.60, // Perfect aspect ratio
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

    return InkWell(
      onTap: () => controller.goToProductDetailView("", ""),
      child: Container(
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
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
              ),
              child: Container(
                height: 180,
                width: double.infinity,
                color: Colors.grey[100],
                child: Image.network(
                  item.productImageUrl ?? "",
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error),
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
                    Text(
                      item.selprodTitle ?? "",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        fontFamily: "Nunito",
                      ),
                    ),

                    const SizedBox(height: 6),

                    // PRICE
                    Text(
                      item.selprodPrice ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
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
                    child: IconButton(
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
                  Container(width: 1, height: 24, color: Colors.grey[300]),
                  Expanded(
                    child: IconButton(
                      splashRadius: 22,
                      onPressed: () {},
                      icon: Image.asset(
                        "assets/images/cartIcon.png",
                        height: 22,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}