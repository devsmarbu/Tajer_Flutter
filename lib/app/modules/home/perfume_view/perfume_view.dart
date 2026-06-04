import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/home/home_controller.dart';
import 'package:tajer/app/modules/product_detail/select_size/select_size_controller.dart';
import '../../product_detail/select_size/select_size_view.dart';
import '../header_view/header_view.dart';
import '../home_model.dart';

class PerfumeCellView extends StatefulWidget {
  final String titleHeader;
  final String currencyCode;
  final List<HomeProduct> products;
  final Collection? collection;

  const PerfumeCellView({
    super.key,
    required this.titleHeader,
    required this.products,
    required this.collection,
    required this.currencyCode,
  });

  @override
  State<PerfumeCellView> createState() => _PerfumeCellViewState();
}

class _PerfumeCellViewState extends State<PerfumeCellView> {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderView(
          titleHeader: widget.titleHeader,
          collection: widget.collection,
        ),
        Container(
          height: 360,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          color: Colors.white,
          child: GridView.builder(
            cacheExtent: 200,
            scrollDirection: Axis.horizontal,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.28,
            ),
            itemCount: widget.products.length,
            itemBuilder: (context, index) {
              final product = widget.products[index];
              final provider = NetworkImage(product.productImageUrl ?? "");
              return GestureDetector(
                onTap: () {
                  controller.goToProductDetailView(
                    product.selprodId ?? "",
                    product.productName ?? "",
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /// CIRCLE IMAGE WITH OVERLAPPING CART
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: 105,
                          height: 105,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipOval(
                            child: Image(
                              image: provider,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey[100],
                                  child: const Center(
                                    child: SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                        strokeWidth: 2,
                                      ),
                                    ),
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  color: Colors.grey[200],
                                  child: const Icon(Icons.error_outline, size: 20, color: Colors.red),
                                );
                              },
                            ),
                          ),
                        ),
                        
                        /// CART BUTTON
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Semantics(
                            label: 'Add ${product.productName} to cart',
                            button: true,
                            child: GestureDetector(
                              key: ValueKey('perfume_add_to_cart_${product.selprodId}'),
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
                                        currencyCode: widget.currencyCode,
                                        productName: product.productName ?? '',
                                        isSizeChartAvailable: '',
                                      ),
                                    );
                                  } else {
                                    final sizeController = Get.put(
                                      SelectSizeController(product.selprodId ?? ''),
                                    );
                                    sizeController.addToCart(
                                      product.selprodId ?? '',
                                      product.productName ?? '',
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
                                    product.productName ?? '',
                                    product.selprodPrice ?? '',
                                    directAddedToCart: '1',
                                  );
                                }
                              },
                              child: Container(
                                width: 34,
                                height: 34,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1E1E1E), // Dark charcoal/black
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.white, width: 1.5),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    /// BRAND
                    Text(
                      key: ValueKey('perfume_brand_${product.selprodId}'),
                      (product.brandName ?? "").toUpperCase(),
                      style: const TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Nunito",
                        color: Colors.black54,
                        letterSpacing: 0.5,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    /// PRODUCT NAME
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        key: ValueKey('perfume_name_${product.selprodId}'),
                        (product.productName ?? "").toUpperCase(),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 10,
                          fontFamily: "Nunito",
                          height: 1.2,
                        ),
                        maxLines: 2,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2),
                    /// PRICE
                    Text(
                      key: ValueKey('perfume_price_${product.selprodId}'),
                      product.selprodPrice ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 12,
                        fontFamily: "Nunito",
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
