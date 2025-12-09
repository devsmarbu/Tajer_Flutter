import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/home/home_model.dart';
import 'package:tajer/app/modules/product_detail/product_detail_view.dart';

class ProductCard extends StatelessWidget {
  final HomeProduct product; // Accepts HomeProduct, Product, or similar models
  final bool isVertical;
  final VoidCallback? onAddToCart;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.isVertical = true,
    this.onAddToCart,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final imageProvider = NetworkImage(product.productImageUrl ?? "");

    final double itemWidth = isVertical
        ? (Get.width / 2) - 10 // two-column grid
        : 160; // fixed for horizontal

    return InkWell(
      onTap: onTap ??
              () {
            // Default behavior → open product detail
            Get.to(() => ProductDetailView(titleHeader: "Product Detail"),
                arguments: {
                  'productId': product.selprodId ?? "",
                  'productName': product.productName ?? ""
                });
          },
      child: Container(
        width: itemWidth,
        margin: isVertical
            ? const EdgeInsets.all(0)
            : const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
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
            // ✅ Product Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10),
                topRight: Radius.circular(10),
              ),
              child: Stack(
                children: [
                  Image(
                    height: 200,
                    width: itemWidth,
                    image: imageProvider,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 200,
                      width: itemWidth,
                      color: Colors.grey[200],
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.grey),
                    ),
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return Container(
                        height: 200,
                        width: itemWidth,
                        color: Colors.grey[200],
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(strokeWidth: 2),
                      );
                    },
                  ),
                  // ✅ Add to Cart Button
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: SizedBox(
                      width: 37,
                      height: 37,
                      child: TextButton(
                        onPressed: onAddToCart ,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
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
            SizedBox(height: 10),
            // ✅ Product Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                product.brandName ?? "",
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  fontFamily: "Nunito",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              child: Text(
                product.productName ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  fontFamily: "Nunito",
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              child: Text(
                product.selprodPrice ?? "",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  fontFamily: "Nunito",
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}