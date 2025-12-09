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
    return Container(
      color: Color(0xFFFDCDD7),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderView(
            titleHeader: "Flawless Makeup Picks",
            collection: widget.collection,
          ),
          SizedBox(height: 10),
          Container(
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
                scrollDirection: Axis.horizontal,
                itemCount: widget.products.length,
                itemBuilder: (context, index) {
                  final product = widget.products[index];
                  final provider = NetworkImage(product.productImageUrl ?? "");
                  return GestureDetector(

                    child: Padding(
                      padding: EdgeInsets.only(
                        top: index.isOdd ? 0 : 50,
                        // odd → top padding
                        bottom: index.isEven ? 0 : 50,
                        // even → bottom padding
                        right: 10,
                        left: 10,
                      ),
                      child: SizedBox(
                        width: screenWidth / 3 - 20,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
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
                                      child: Image(
                                        image: provider,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
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
                            SizedBox(height: 4),
                            Text(
                              product.selprodPrice ?? "",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Nunito",
                              ),
                              textAlign: TextAlign.center,
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
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
