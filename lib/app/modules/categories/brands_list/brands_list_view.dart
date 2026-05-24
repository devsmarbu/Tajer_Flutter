import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../utils/app_colors.dart';
import 'brand_controller.dart';
import 'brand_tile.dart';

class BrandsListView extends StatefulWidget {
  final String index;
  final String? title;

  const BrandsListView({super.key, required this.index, this.title});

  @override
  State<BrandsListView> createState() => _BrandListViewState();
}

class _BrandListViewState extends State<BrandsListView> {
  late BrandController controller;

  bool showScrollToTop = false; // 📍 FAB visibility flag
  final ScrollController _scrollController =
      ScrollController(); // Scroll controller

  @override
  void initState() {
    super.initState();

    controller = Get.put(BrandController(), tag: widget.index);

    /// 📍 Scroll listener for FAB control
    _scrollController.addListener(() {
      if (_scrollController.offset > 800 && !showScrollToTop) {
        setState(() => showScrollToTop = true);
      } else if (_scrollController.offset <= 800 && showScrollToTop) {
        setState(() => showScrollToTop = false);
      }
    });

    _loadData();
  }

  void _loadData() {
    final controller = Get.find<BrandController>(tag: widget.index);

    if (widget.index == "1") {
      controller.fetchBrandList();
    } else if (widget.index == "2") {
      controller.fetchShopList();
    } else if (widget.index == "3") {
      controller.fetchOurFavBrandList();
    } else if (widget.index == "4") {
      controller.fetchOurShopList();
    }
  }

  @override
  void didUpdateWidget(covariant BrandsListView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.index != widget.index) _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,

      appBar: (widget.title != null && widget.title!.isNotEmpty)
          ? AppBar(
              scrolledUnderElevation: 0,
              title: Text(
                widget.title ?? "",
                style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.black1,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w600,
                ),
              ),
              backgroundColor: AppColors.white,
              centerTitle: true,
              elevation: 0.5,
              iconTheme: const IconThemeData(color: Colors.black),
            )
          : null,

      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: Colors.black));
          }

          final width = MediaQuery.of(context).size.width;

          final bool isFolded = width <= 400;

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollInfo) {
              if ((widget.index == "2") &&
                  scrollInfo.metrics.pixels >=
                      scrollInfo.metrics.maxScrollExtent - 100 &&
                  !controller.isMoreLoading.value) {
                controller.loadMoreShops();
              }
              return false;
            },

            child: GridView.builder(
              controller: _scrollController, // 📍 Required for FAB detection
              itemCount: (widget.index == "1" || widget.index == "3")
                  ? controller.brandList.length
                  : controller.shopList.length,
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: isFolded ? 0.68 :0.7,
              ),
              itemBuilder: (context, index) {
                if ((widget.index == "1") || (widget.index == "3")) {
                  if (controller.brandList.isEmpty) {
                    return const Center(child: Text("No data found"));
                  }
                  final brand = controller.brandList[index];
                  return BrandTile(
                    displayItem: DisplayItem(
                      id: brand.brandId ?? "",
                      name: brand.brandName ?? "",
                      image: brand.brandImage ?? "",
                      isBrand: "1",
                    ),
                  );
                } else {
                  if (controller.shopList.isEmpty) {
                    return const Center(child: Text("No data found"));
                  }
                  final shop = controller.shopList[index];
                  return BrandTile(
                    displayItem: DisplayItem(
                      id: shop.shopId ?? "",
                      name: shop.shopName ?? "",
                      image: shop.shopLogo ?? "",
                      isBrand: "0",
                      shopUserID: shop.shopUserId,
                    ),
                  );
                }
              },
            ),
          );
        }),
      ),

      /// 📍 Floating Scroll to Top Button
      floatingActionButton: showScrollToTop
          ? Padding(
              padding: EdgeInsets.only(bottom: Platform.isIOS ? 40 : 0),
              child: FloatingActionButton.small(
                backgroundColor: Colors.black,
                onPressed: () {
                  _scrollController.animateTo(
                    0,
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeOut,
                  );
                },
                child: const Icon(
                  Icons.arrow_upward,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            )
          : null,
    );
  }
}
