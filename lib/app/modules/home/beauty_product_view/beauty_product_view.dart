import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/home/home_controller.dart';
import 'package:tajer/app/modules/productList/controllers/product_controller.dart';
import '../header_view/header_view.dart';
import '../home_model.dart';

class BeautyProductCellView extends StatefulWidget {
  final List<HomeProduct> products;
  final Collection collection;

  const BeautyProductCellView({
    super.key,
    required this.products,
    required this.collection,
  });

  @override
  State<BeautyProductCellView> createState() => _BeautyProductCellViewState();
}

class _BeautyProductCellViewState extends State<BeautyProductCellView> {

  final controller = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Semantics(
      label: 'beauty_product_section',
      child: Container(
        key: const Key('beauty_product_root'),
        color: Color(0xFFFDCDD7),
        child: Column(
          key: const Key('beauty_product_column'),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderView(
              key: const Key('beauty_product_header'),
              titleHeader: "Flawless Makeup Picks",
              collection: widget.collection,
            ),
            SizedBox(height: 10,key: Key('beauty_product_spacing_header')),
            Container(
              key: const Key('beauty_product_bg_container'),
              decoration: BoxDecoration(
                // color: Colors.pink[100], // optional background color
                image: DecorationImage(
                  image: AssetImage("assets/images/BeautyBG.png"),
                  fit: BoxFit.fitWidth, // cover, contain, fill, etc.
                  alignment: Alignment.bottomCenter,
                ),
              ),
              height: screenWidth - 130,
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: SizedBox(
                child: ListView.builder(
                  key: const Key('beauty_product_list'),
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    final product = widget.products[index];
                    final provider = NetworkImage(product.productImageUrl ?? "");
                    return Semantics(
                      label:
                      'beauty_product_${product.productName}_$index',
                      button: true,
                      child: GestureDetector(
                        key: Key('beauty_product_tap_$index'),
                            
                        child: Padding(
                          key: Key(
                              'beauty_product_padding_$index'),
                          padding: EdgeInsets.only(
                            top: index.isOdd ? 0 : 50,
                            // odd → top padding
                            bottom: index.isEven ? 0 : 50,
                            // even → bottom padding
                            right: 10,
                            left: 10,
                          ),
                          child: SizedBox(
                            key: Key(
                                'beauty_product_item_$index'),
                            width: screenWidth / 3 - 20,
                            child: Column(
                              key: Key(
                                  'beauty_product_column_$index'),
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  key: Key(
                                      'beauty_product_image_wrapper_$index'),
                                  width: screenWidth / 3 - 30,
                                  height: screenWidth / 3,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xFFFBBECB),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(15),
                                      ),
                                    ),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Positioned(
                                          bottom: 0,
                                          child: Image.asset(
                                            key: Key(
                                                'beauty_product_shadow_$index'),
                                            "assets/images/ShadowPink.png",
                                            width: screenWidth / 4,
                                            // adjust for proportion
                                            height: 40,
                                            color: Colors.pink.withValues(
                                              alpha: 0.7,
                                            ),
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                        // Main image
                                        Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Semantics(
                                            label:
                                            'beauty_product_image_${product.productName}_$index',
                                            child: Image(
                                              key: Key(
                                                  'beauty_product_image_$index'),
                                              image: provider,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4,key: Key(
                                    'beauty_product_spacing_1')),
                                Semantics(
                                  label:
                                  'beauty_product_name_${product.productName}_$index',
                                  child: Text(
                                    key: Key(
                                        'beauty_product_name_$index'),
                                    product.productName ?? "",
                                    maxLines: 2,
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: "Nunito",
                                    ),
                                    overflow: TextOverflow.visible,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 4,key: Key(
                                    'beauty_product_spacing_2'),),
                                Semantics(
                                  label:
                                  'beauty_product_price_${product.selprodPrice}_$index',
                                  child: Text(
                                    key: Key(
                                        'beauty_product_price_$index'),
                                    product.selprodPrice ?? "",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      fontFamily: "Nunito",
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        onTap: () {
                          controller.goToProductDetailView(
                            product.selprodId ?? "",
                            product.productName ?? "",
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
