import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/app/modules/home/home_model.dart';

import '../../../core/routes/app_routes.dart';
import '../header_view/header_view.dart';

class ShopListView extends StatefulWidget {
  final Collection? collection;

  ShopListView({super.key, required this.collection});

  @override
  State<ShopListView> createState() => _ShopListViewState();
}

class _ShopListViewState extends State<ShopListView> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: Colors.grey.withValues(alpha: 0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeaderView(
            titleHeader: widget.collection?.collectionName ?? "",
            collection: widget.collection,
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: SizedBox(
              height: screenWidth - 20, // 👈 fix the GridView height
              child: GridView.builder(
                cacheExtent: 200,
                scrollDirection: Axis.horizontal,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 rows
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                  childAspectRatio: 1, // keep square
                ),
                itemCount: widget.collection?.shops?.length ?? 0,
                itemBuilder: (context, index) {
                  final provider = NetworkImage(
                    widget.collection?.shops?[index].shopLogo ?? "",
                  );
                  final column = index ~/ 2;
                  debugPrint("$index");
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        AppRoutes.shopDetailView,
                        arguments: {"shopId": widget.collection?.shops?[index].shopId, "shopUserId": widget.collection?.shops?[index].shopUserId},
                      );
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: column.isOdd ? 0.0 : 0.0,
                        right: column.isOdd ? 0.0 : 0.0,
                        top: column.isOdd ? 20.0 : 0.0,
                        bottom: column.isOdd ? 0.0 : 20.0,
                      ),
                      // padding: EdgeInsets.fromLTRB(column == 1 ? 0.0 : 0.0,column == 1 ? 15.0 : 0.0,column == 1 ? 0.0 : 0.0,column == 1 ? 15.0 : 0.0),
                      // padding: EdgeInsets.fromLTRB(0,20,0,20),
                      child: SizedBox(
                        // width: 300, // 👈 give each child a fixed width
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(0),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    // 👈 set your radius here
                                    child: Image(
                                      image: provider,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              right: 10,
                              // stretches horizontally
                              bottom: 0,
                              // optional, if you want it at the bottom
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                ),
                                // start & end padding
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: const BorderRadius.only(
                                    bottomLeft: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                  ),
                                ),
                                height: 35,
                                alignment: Alignment.centerLeft,
                                // text alignment
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Shop Now",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Image.asset(
                                      "assets/images/forward_arrow.png",
                                      height: 18,
                                      width: 25,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
