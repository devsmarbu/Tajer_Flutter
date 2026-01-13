import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_labels.dart';
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
          height: 350,
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          color: Colors.grey.withValues(alpha: 0.08),
          child: GridView.builder(
            cacheExtent: 200,
            scrollDirection: Axis.horizontal,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 columns
              crossAxisSpacing: 0,
              mainAxisSpacing: 10,
              childAspectRatio: 1.2,
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
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none, // 👈 allows image to go outside
                  children: [
                    // Background white card
                    Container(
                      width: 140,
                      height: 125,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ), // rounded corners
                      ),
                      margin: const EdgeInsets.only(top: 30),
                      // space for image overlap
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              // Brand name + price column
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.selprodTitle ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 10,
                                        fontFamily: "Nunito",
                                      ),
                                      textAlign: TextAlign.start,
                                      maxLines: 2,
                                      // softWrap: false,
                                       overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      product.selprodPrice ?? "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                        fontSize: 11,
                                        fontFamily: "Nunito",
                                      ),
                                      maxLines: 1,
                                      softWrap: false,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                              // Spacer(),
                              SizedBox(
                                width: 35,
                                height: 35,
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
                                            productId: product.productId ?? "",
                                            productOptions: firstOptionValues,
                                            currencyCode:
                                                widget.currencyCode, productName: product.productName ?? '',
                                          ),
                                        );
                                      } else {
                                        debugPrint("⚠️ No option values found");
                                      }
                                    } else {
                                      final sizeController = Get.put(SelectSizeController(product.selprodId ?? ""));
                                      sizeController.addToCart(product.selprodId ?? "",product.productName ?? '',product.selprodPrice ?? '');
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    // remove default padding
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
                                          color: Colors.black12,
                                          blurRadius: 6,
                                          offset: Offset(0, 1),
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
                            ],
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                            height: 110,
                            width: 90,
                            image: provider,
                            fit: BoxFit.fitWidth,
                          ),
                          Transform.translate(
                            offset: Offset(0, -30), // 👈 move upward by 8px
                            child: Image.asset(
                              "assets/images/PerfumeShadow.png",
                              width: 80,
                              height: 40,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
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
