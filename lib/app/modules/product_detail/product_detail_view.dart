import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart' hide Value;
import 'package:marquee/marquee.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/modules/product_detail/productSizeInfo/size_chart_screen.dart';
import 'package:tajer/app/modules/product_detail/product_detail_model.dart'
    hide Value;
import 'package:tajer/app/modules/product_detail/product_images/fullscreen_product_images.dart';
import 'package:tajer/app/modules/product_detail/select_size/select_size_controller.dart';
import 'package:tajer/app/modules/product_detail/select_size/select_size_view.dart';
import 'package:tajer/marque_label.dart';
import 'package:tajer/utils/app_colors.dart';
import 'package:tajer/utils/app_strings.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../Extensions/expandable_text.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../modules/home/dual_horizontal_product_view/dual_horizontal_product_view.dart';
import '../../modules/product_detail/product_detail_controller.dart';
import '../../modules/product_detail/product_images/product_images.dart';
import '../../modules/product_detail/report_form/report_form_view.dart';
import '../../modules/product_detail/share_activity/share_activity_view.dart';
import '../../modules/product_detail/wishlist_names_view/wishlist_names_view.dart';
import '../authentication/login/login_screen.dart';
import '../home/home_model.dart';
import '../navigation/bottom_navigation.dart';
import '../productList/product_card.dart';

class Policy {
  final Image? policyImage;
  final String? policyText;

  Policy({this.policyImage, this.policyText});
}

class ProductDetailView extends StatefulWidget {
  final String? titleHeader;

  const ProductDetailView({super.key, this.titleHeader});

  @override
  State<ProductDetailView> createState() => _ProductDetailViewState();
}

class _ProductDetailViewState extends State<ProductDetailView> with SingleTickerProviderStateMixin {
  late final ProductDetailController controller;
  late final String controllerTag;
  final ScrollController _scrollController = ScrollController();
  bool isExpanded = false;
  bool showFloatingBar = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    
    final args = Get.arguments as Map<String, dynamic>?;
    controllerTag = args?['controllerTag']?.toString() ?? UniqueKey().toString();
    controller = Get.put(ProductDetailController(), tag: controllerTag);

    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600), // duration of 3 shakes
    );

    _shakeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -8), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: -8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -8, end: 8), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8, end: 0), weight: 1),

    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));

    // If the controller hasn't been pre-loaded, load it now
    if (controller.productSections.isEmpty) {
      if (args != null && args['productId'] != null) {
        controller.loadOtherProduct(
          args['productId'].toString(),
          args['productName']?.toString() ?? "",
        );
      }
    }

    _startAutoShake();

    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !showFloatingBar) {
        setState(() => showFloatingBar = true);
      } else if (_scrollController.offset < 200 && showFloatingBar) {
        setState(() => showFloatingBar = false);
      }
    });
  }

  @override
  void dispose() {
    Get.delete<ProductDetailController>(tag: controllerTag);
    _shakeController.dispose();
    _scrollController.dispose();
    super.dispose();
  }


  void _startAutoShake() {
    ever(controller.inStock, (value) {
      if (value == '1') {
        _shakeController.forward(from: 0);
      } else {
        _shakeController.stop();
      }
    });
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 3));
      if (!mounted) return false;

      await _shakeController.forward(from: 0);
      return true; // keep looping
    });
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back),
        ),

        title: Obx(() {
          return Text(
            controller.productName.value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              fontFamily: "Nunito",
              color: Colors.black,
              overflow: TextOverflow.ellipsis,
            ),
          );
        }),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 30),
            onPressed: controller.goToSearchView,
          ),

          Padding(
            padding: const EdgeInsetsDirectional.only(end: 15),
            child: GestureDetector(
              onTap: () {
                // Get.back();
                // controller.goToMainCartPage();
                debugPrint(Get.previousRoute);
                if ((Get.previousRoute == AppRoutes.bottomNavigation) && (Get.find<BottomNavController>().currentIndex.value == 3)) {
                  debugPrint('this is if block');
                  Get.back();
                } else {
                  debugPrint('this is else block');
                  controller.goToMainCartPage();
                }
              },
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    "assets/images/cartIcon.png",
                    height: 25,
                    color: Colors.black,
                  ),
                  Obx(() {
                    if (cartItemCounts.value.toIntSafe() > 0) {
                      return Positioned(
                        top: -6,
                        right: -8,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red,
                          ),
                          child: Text(
                            cartItemCounts.value.toString(),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.productSections.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.black),
          );
        }
        final productData = controller.productSections;

        return Stack(
          children: [
            Column(
              children: [
                /// 🔥 Marquee Label
                (PrefStore().loadString(AppConstants.promoBannerText)??'').marqueeLabel(),
                /// 🔥 Your List
                Expanded(
                  child: ListView(
                    controller: _scrollController,
                    children: [
                      ...List.generate(
                        productData.length,
                            (index) =>
                            _buildSection(productData[index], index),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (controller.isLoading.value)
              AbsorbPointer(
                absorbing: true,
                child: Container(
                  color: Colors.black.withValues(alpha: 0.15),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.black),
                  ),
                ),
              ),
          ],
        );
      }),
      bottomNavigationBar: SafeArea(
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
        color: Colors.white,
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: Obx(() {
            bool hasBoxContent = controller.productSections.any(
                  (e) => e.type == ProductDetailType.boxContent.apiValue,
            );

            final List<BoxContent> items = hasBoxContent
                ? controller.productSections
                .firstWhere(
                  (e) =>
              e.type ==
                  ProductDetailType.boxContent.apiValue,
            )
                .content
                ?.boxContent ??
                <BoxContent>[]
                : <BoxContent>[];

            bool allSelectedInStock = true;

            for (final item in items) {
              // if no selection → treat as not in stock
              if (item.currentOptionValues == null ||
                  item.currentOptionValues!.isEmpty) {
                allSelectedInStock = true;
                break;
              }

              final selected = item.currentOptionValues!.first;

              if (selected.inStock != "1") {
                allSelectedInStock = false;
                break; // ❌ one false is enough
              }
            }

            debugPrint("all selected: $allSelectedInStock");

            if (hasBoxContent == false) {
              if (controller.inStock.value == '') {
                return const SizedBox.shrink();
              }
              return Obx(() =>
                  AnimatedBuilder(
                    animation: _shakeAnimation,
                    builder: (context, child) {
                      final shouldShake = controller.inStock.value == '1';
                      return Transform.translate(
                        offset: Offset(shouldShake ? _shakeAnimation.value : 0, 0),
                        child: child,
                      );
                    },
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.inStock.value == '1'
                            ? Colors.black
                            : Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: controller.inStock.value == '1'
                          ? () {
                        final productId = controller.selProductId;
                        final productName = controller.productName.value;
                        final productPrice = controller.productPrice.value;

                        final sizeController =
                        Get.put(SelectSizeController(productId));

                        sizeController.addToCart(
                          productId,
                          productName,
                          productPrice,
                          selProdIdsForBoxContent:
                          controller.selectedSelProdIdForBoxContent,
                          directAddedToCart: '1'
                        );
                      } : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.shopping_bag_outlined,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            controller.inStock.value == '1'
                                ? AppStrings.appAddToCart.tr
                                : AppStrings.appSoldOut.tr,
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Nunito",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ));
            } else {
              return ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: allSelectedInStock == true
                      ? Colors.black
                      : Colors.grey[400],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  final productId = controller.selProductId;
                  final productName = controller.productName.value;
                  final productPrice = controller.productPrice.value;
                  final sizeController = Get.put(
                    SelectSizeController(productId),
                  );
                  sizeController.addToCart(
                    productId,
                    productName,
                    productPrice,
                    selProdIdsForBoxContent:
                    controller.selectedSelProdIdForBoxContent,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.shopping_bag_outlined,
                      color: Colors.white,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      allSelectedInStock == true
                          ? AppStrings.appAddToCart.tr
                          : AppStrings.appSoldOut.tr,
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: "Nunito",
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
        ),
      ),
    ),
      floatingActionButton: showFloatingBar
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
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSection(Datum? datum, int index) {
    Widget sectionWidget;

    switch (datum?.customType) {
      case ProductDetailType.productImages:
      // TODO: Handle this case.
        final productImages = datum?.content?.productImagesArr ?? [];
        sectionWidget = SizedBox(
          height: 440,
          child: Stack(
            children: [
              GestureDetector(
                onTap: () {
                  // debugPrint("tappped");
                  Get.to(
                        () => FullScreenProductImagesView(
                      images: productImages,
                      isFullScreen: true,
                    ),
                  );
                },
                child: ProductImagesView(
                  onColorChanged: (Color p1) {},
                  images: productImages,
                  isFullScreen: false,
                ),
              ),
              Positioned(
                height: 30,
                width: 80,
                top: 20,
                right: 5,
                child: Row(
                  spacing: 5,
                  children: [
                    _buildCircleIconButton(
                      icon: Icons.share,
                      onPressed: () {
                        debugPrint("Share tapped");
                        // ShareProductUtil.shareProduct(
                        //   context: context, // <-- REQUIRED for iOS 16+
                        //   productUrl: controller.productUrl.value ,
                        //   productTitle: controller.productTitle.value,
                        //   productDescription: controller.productDescription.value,
                        //   imageUrl: controller.imageURL.value
                        // );
                        ShareProductUtil.shareProduct(
                          context: context,
                          productUrl: controller.productUrl.value,
                          productTitle: controller.productTitle.value,
                          // assetImagePath: "assets/images/app_logo.png",
                        );
                      },
                    ),
                    const SizedBox(height: 10),
                    Obx(
                          () => _buildCircleIconButton(
                        icon: controller.isInAnyWishlist.value != "0"
                            ? Icons.favorite
                            : Icons.favorite_border,
                        onPressed: () async {
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
                          } else if (controller.isInAnyWishlist.value != "0") {
                            final result = await controller.addRemoveToWishlist(
                              controller.productId,
                              "0",
                              "0",
                            );
                            controller.isInAnyWishlist.value = result
                                .toString();
                          } else {
                            final result = await showGeneralDialog(
                              context: context,
                              barrierLabel: "Wishlist",
                              barrierDismissible: true,
                              barrierColor: Colors.black.withValues(alpha: 0.4),
                              transitionDuration: const Duration(
                                milliseconds: 300,
                              ),
                              pageBuilder: (_, __, ___) =>
                                  WishlistNamesViewPopOver(
                                    productId: controller.productId,
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
                              controller.isInAnyWishlist.value = result
                                  .toString();
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                height: 30,
                width: 30,
                bottom: 40,
                right: 16,
                child: _buildCircleIconButton(
                  imagePath: "assets/images/ladybug.png",
                  onPressed: () {
                    debugPrint("this is report button");
                    print(datum?.content?.productDetail);
                    showGeneralDialog(
                      context: context,
                      barrierLabel: "Report Form",
                      barrierDismissible: true,
                      barrierColor: Colors.black.withValues(alpha: 0.4),
                      transitionDuration: const Duration(milliseconds: 300),
                      pageBuilder: (_, __, ___) => ReportFormPopover(
                        productName: "Varia - Purple Pleated Cape Dress",
                        selprodId: controller.selProductId,
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
                  },
                ),
              ),
            ],
          ),
        );
      case ProductDetailType.productDetail:
      // TODO: Handle this case.
        final productDetail = datum?.content?.productDetail;
        final productBadge = (productDetail?.badges?.isNotEmpty ?? false)
            ? productDetail?.badges!.first.url
            : null;

        sectionWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                spacing: 5,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    productDetail?.brandName ?? "",
                    style: TextStyle(
                      fontSize: 13,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    productDetail?.selprodTitle ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '(${productDetail?.selprodConditionTitle ?? ""})',
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (productBadge != null)
                    Image(
                      image: NetworkImage(productBadge),
                      height: 30,
                      width: 30,
                      fit: BoxFit.contain,
                    ),
                  Text(
                    productDetail?.selprodPrice ?? "",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width,
              height: 5,
              child: Container(color: Colors.grey[200]),
            ),
          ],
        );
      case ProductDetailType.productOption:
      // TODO: Handle this case.
        final productOptions = datum?.content?.optionRows;

        sectionWidget = Column(
          children: [
            SizedBox(
              height: (datum?.content?.optionRows?.length ?? 0) * 100.0,
              // or a calculated height
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10),
                scrollDirection: Axis.vertical,
                itemCount: productOptions?.length ?? 0,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, outerIndex) {
                  final productOption = productOptions?[outerIndex];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              productOption?.optionName ?? "",
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if ((datum?.isSizeChartAvailable ?? "0") == "1" && productOption?.optionIsColor == "0")
                              GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    barrierColor: Colors.black87,
                                    // dark background
                                    builder: (_) => SizeChartScreen(
                                      productId: controller.selProductId,
                                      productOptions:
                                      productOption?.values ?? [],
                                      productName: controller.productName.value,
                                      productPrice:
                                      controller.productPrice.value,
                                    ),
                                    //     SizeChartOverlay(
                                    //   imageUrl: datum?.sizeChartImage ?? "",
                                    // ),
                                  );
                                },
                                child: Text(
                                  (PrefStore().loadString(
                                    AppConstants.languageCode,
                                  ) ==
                                      "AR")
                                      ? "مخطط الحجم"
                                      : "Size Chart",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontSize: 14,
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          height: 40, // height of inner horizontal list
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: productOption?.values?.length ?? 0,
                            itemBuilder: (context, index) {
                              final value = productOption?.values?[index];
                              if (productOption?.optionIsColor == "0") {
                                int stockValue = ((value?.stock ?? "0").toIntSafe());

                                return GestureDetector(
                                  onTap: () async {
                                    if (stockValue > 0 && (value?.isSelected ?? "0") == "0") {
                                      debugPrint("🟢 Selected option: ${value?.optionvalueName}");
                                      await controller.updateProductOption(value?.selprodId ?? "");
                                    }
                                  },
                                  child: ClipRRect( // 🔒 ADD THIS
                                    borderRadius: BorderRadius.circular(10),
                                    child: Stack(
                                      children: [
                                        Opacity(
                                          opacity: stockValue > 0 ? 1 : 0.4,
                                          child: Container(
                                            margin: const EdgeInsets.only(right: 8),
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                            constraints: const BoxConstraints(minWidth: 40),
                                            decoration: BoxDecoration(
                                              color: value?.isSelected == "1"
                                                  ? Colors.black
                                                  : Colors.white,
                                              border: Border.all(color: Colors.black),
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: Center(
                                              child: Text(
                                                value?.optionvalueName ?? "",
                                                style: TextStyle(
                                                  color: value?.isSelected == "1"
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Nunito",
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                        if (stockValue == 0)
                                          Positioned.fill(
                                            child: CustomPaint(
                                              painter: DiagonalCrossPainter(),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              else {
                                int stockValue = ((value?.stock ?? "0").toIntSafe());
                                Color circleColor = value?.optionvalueColorCode?.hexToColor ?? Colors.transparent;
                                Color lineColor = circleColor.computeLuminance() > 0.5 ? Colors.black38 : Colors.white;
                                
                                return GestureDetector(
                                  onTap: () async {
                                    if (stockValue > 0 && (value?.isSelected ?? "0") == "0") {
                                      debugPrint("🟢 Selected option: ${value?.optionvalueName}");
                                      await controller.updateProductOption(value?.selprodId ?? "");
                                    }
                                  },
                                  child: AnimatedScale(
                                    scale: value?.isSelected == "1" ? 1.15 : 1.0,
                                    duration: const Duration(milliseconds: 200),
                                    curve: Curves.easeOut,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(0),
                                          width: 56,
                                          height: 56,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: value?.isSelected == "1"
                                                  ? Colors.black
                                                  : Colors.grey.shade400,
                                              width: value?.isSelected == "1" ? 2.5 : 1,
                                            ),
                                          ),
                                          child: Center(
                                            child: Container(
                                              width: value?.isSelected == "1" ? 26 : 46,
                                              height: value?.isSelected == "1" ? 26 : 46,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: circleColor,
                                                border: Border.all(color: Colors.white, width: 1),
                                                boxShadow: value?.isSelected == "1"
                                                    ? [
                                                  BoxShadow(
                                                    color: Colors.black.withValues(alpha: 0.2),
                                                    blurRadius: 6,
                                                    spreadRadius: 1,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ]
                                                    : [],
                                              ),
                                              clipBehavior: Clip.hardEdge,
                                              child: stockValue == 0
                                                  ? Center(
                                                child: Transform.rotate(
                                                  angle: -0.785398,
                                                  child: Container(
                                                    width: 60,
                                                    height: 1.5,
                                                    color: lineColor,
                                                  ),
                                                ),
                                              )
                                                  : null,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: Get.width,
              height: 5,
              child: Container(color: Colors.grey[200]),
            ),
          ],
        );

      case ProductDetailType.productSpecifications:
        sectionWidget = SizedBox(
          width: Get.width,
          height: 5,
          child: Container(color: Colors.grey[200]),
        );

      case ProductDetailType.volumeDiscount:
      // TODO: Handle this case.
        sectionWidget = SizedBox(
          width: Get.width,
          height: 5,
          child: Container(color: Colors.grey[200]),
        );
      case ProductDetailType.productDescription:
      // TODO: Handle this case.
      // sectionWidget = SizedBox(
      //   width: Get.width,
      //   height: 5,
      //   child: Container(color: Colors.grey[300]),
      // );
        final description = datum?.content?.description ?? "";

        sectionWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    datum?.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Nunito",
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: _isHtml(description)
                        ? Html(
                      data: description,
                      style: {
                        "*": Style(
                          fontFamily: "Nunito",
                          fontSize: FontSize(14),
                          color: Colors.black87,
                          lineHeight: LineHeight.number(1.5),
                        ),
                        "p": Style(margin: Margins.only(bottom: 8)),
                      },
                    )
                        : ExpandableText(
                      text: description,
                      trimLines: 4,
                      style: const TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontFamily: "Nunito",
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width,
              height: 5,
              child: Container(color: Colors.grey[200]),
            ),
          ],
        );

      case ProductDetailType.productPolicies:
      // TODO: Handle this case.
        final productSpecifications = datum?.content?.productPolicies;
        // TODO: Handle this case.
        sectionWidget = Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: productSpecifications?.length ?? 0,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final productSpec = productSpecifications?[index];
                  return Row(
                    spacing: 10,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                        width: 20,
                        child: Image(
                          image: NetworkImage(
                            AppConstants.imageBaseURLPath +
                                (productSpec?.icon ?? ""),
                          ),
                        ),
                      ),
                      Text(
                        productSpec?.title ?? "",
                        style: TextStyle(
                          fontFamily: "Nunito",
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            SizedBox(
              width: Get.width,
              height: 5,
              child: Container(color: Colors.grey[200]),
            ),
          ],
        );

      case ProductDetailType.banner:
      // TODO: Handle this case.
        sectionWidget = SizedBox(
          width: Get.width,
          height: 5,
          child: Container(color: Colors.grey[200]),
        );
      case ProductDetailType.similarProducts:
      // TODO: Handle this case.
        sectionWidget = SizedBox(
          width: Get.width,
          height: 5,
          child: Container(color: Colors.grey[200]),
        );
      case ProductDetailType.recommendedProducts:
        final products = datum?.content?.recommendedProduct ?? [];

        // Calculate dynamic height automatically by letting GridView shrinkWrap
        sectionWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if ((datum?.title ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  datum!.title!,
                  style: const TextStyle(
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = 2;
                final rowCount = (products.length / crossAxisCount).ceil();
                final itemHeight =
                    (constraints.maxWidth / crossAxisCount / 0.635) - 33;

                final totalHeight = (rowCount * itemHeight);

                final width = MediaQuery.of(context).size.width;

                final bool isFolded = width <= 400;
                return SizedBox(
                  height: totalHeight, // ✅ dynamic height calculation
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 12,
                    ),
                    gridDelegate:
                    SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      // height > width
                      childAspectRatio: isFolded ? 0.62:0.68,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {

                      // 👇 Extract colors for THIS product only
                      List<Color> colorList = [];

                      if (products[index].productOptions != null) {
                        for (var option in products[index].productOptions!) {
                          if (option.optionIsColor == "1") {
                            for (var value in option.values ?? []) {
                              final hexCode = value.optionvalueColorCode;

                              if (hexCode != null && hexCode.isNotEmpty) {
                                try {
                                  final cleanedHex = hexCode.replaceAll("#", "");

                                  // Add full opacity if only 6 characters
                                  final formattedHex =
                                  cleanedHex.length == 6 ? "FF$cleanedHex" : cleanedHex;

                                  final color =
                                  Color(int.parse(formattedHex, radix: 16));

                                  colorList.add(color);
                                } catch (e) {
                                  debugPrint("Invalid color code: $hexCode");
                                }
                              }
                            }
                          }
                        }
                      }

                      return ProductCard(
                        product: products[index],
                        isVertical: true,
                        colorList: colorList,
                        onAddToCart: () {
                          debugPrint("Add to cart tapped");
                          final options = products[index].productOptions;
                          if (options != null && options.isNotEmpty) {
                            final firstOptionValues =
                                options.first.values ?? [];
                            if (firstOptionValues.isNotEmpty) {
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                backgroundColor: Colors.transparent,
                                builder: (context) => SelectSizeView(
                                  price: products[index].selprodPrice ?? "",
                                  productId: firstOptionValues.first.selprodId ?? "",
                                  productOptions: options,
                                  currencyCode:
                                  PrefStore().loadString(
                                    AppConstants.currencySymbol,
                                  ) ??
                                      "\$",
                                  productName:
                                  products[index].productName ?? '', isSizeChartAvailable: '',
                                ),
                              );
                            } else {
                              debugPrint("⚠️ No option values found");
                            }
                          } else {
                            final sizeController = Get.put(
                              SelectSizeController(
                                products[index].selprodId ?? "",
                              ),
                            );
                            sizeController.addToCart(
                              products[index].selprodId ?? "",
                              products[index].productName ?? '',
                              products[index].selprodPrice ?? '',
                              directAddedToCart: '1'
                            );
                          }
                        },
                        onTap: () {
                          controller.loadOtherProduct(
                            products[index].selprodId ?? "",
                            products[index].productName ?? "",
                          );
                        }, productIndex: index.toString(),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        );
        break;
      case ProductDetailType.buyTogether:
      // TODO: Handle this case.
        sectionWidget = SizedBox(
          width: Get.width,
          height: 5,
          child: Container(color: Colors.grey[200]),
        );
      case ProductDetailType.shop:
      // TODO: Handle this case.
        final productShop = datum?.content?.shop;

        sectionWidget = Column(
          spacing: 5,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "APP_SOLD_BY".tr,
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(-10, 0),
                    child: TextButton(
                      onPressed: () {
                        controller.goToShopDetailView(
                          productShop?.shopId ?? "",
                          productShop?.shopUserId ?? "",
                        );
                      },
                      child: Text(
                        productShop?.shopName ?? "",
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                  if ((productShop?.shopTotalReviews.toIntSafe() ?? 0) > 0)
                    Row(
                      spacing: 10,
                      children: [
                        Row(
                          spacing: 5,
                          children: [
                            Text(
                              productShop?.shopRating ?? "0",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Image.asset(
                              "assets/images/star.png",
                              width: 15,
                              height: 15,
                            ),
                          ],
                        ),
                        Container(width: 1, height: 20, color: Colors.black),
                        Text(
                          "${productShop?.shopTotalReviews ?? 0} ${AppStrings.appShopReviews.tr}",
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: "Nunito",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 15),
                  SizedBox(
                    width: Get.width - 32,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.black, width: 1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        // your onTap logic here
                        controller.goToAskAQuestionView(
                          productShop?.shopId ?? "",
                          productShop?.shopName ?? "",
                          controller.selProductId,
                          controller.productName.value
                        );
                      },
                      child: Text(
                        "APP_ASK_A_QUESTIONS".tr,
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Nunito",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: Get.width,
              height: 5,
              child: Container(color: Colors.grey[200]),
            ),
          ],
        );

      case ProductDetailType.reviews:
      // TODO: Handle this case.
        sectionWidget = SizedBox(
          width: Get.width,
          height: 5,
          child: Container(color: Colors.grey[200]),
        );
      case ProductDetailType.previewFiles:
      // TODO: Handle this case.
        sectionWidget = SizedBox(
          width: Get.width,
          height: 5,
          child: Container(color: Colors.grey[200]),
        );
      case ProductDetailType.unknown:
      // TODO: Handle this case.
        sectionWidget = SizedBox(
          width: Get.width,
          height: 5,
          child: Container(color: Colors.grey[200]),
        );
      case null:
      // TODO: Handle this case.
        sectionWidget = SizedBox(
          width: Get.width,
          height: 5,
          child: Container(color: Colors.grey[200]),
        );
      case ProductDetailType.modelMesurement:
      // TODO: Handle this case.
        final modelMeasurement = datum?.content?.modelMeasurement;

        sectionWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    datum?.title ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontFamily: "Nunito",
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 15),
                  ...(modelMeasurement ?? []).map((item) {
                    final measurements = item.adjectives
                        ?.map((a) => "${a.value}: ${a.extra}")
                        .join(", ");

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: "${item.title} – ",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Nunito",
                                fontSize: 14,
                              ),
                            ),
                            TextSpan(
                              text: measurements ?? "",
                              style: const TextStyle(
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Nunito",
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
            SizedBox(
              width: Get.width,
              height: 5,
              child: Container(color: Colors.grey[200]),
            ),
          ],
        );
      case ProductDetailType.boxContent:
        final boxItems = datum?.content?.boxContent ?? [];

        sectionWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
              child: Text(
                datum?.title ?? "Box contents",
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontFamily: "Nunito",
                  fontSize: 16,
                ),
              ),
            ),

            ListView.separated(
              itemCount: boxItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) =>
                  Divider(height: 35, thickness: 1, color: Colors.grey[100]),
              itemBuilder: (context, outerIndex) {
                final item = boxItems[outerIndex];

                return Column(
                  children: [
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          // 👇 handle tap
                          debugPrint("Tapped box item: ${item.selprodTitle}");

                          controller.loadOtherProduct(
                            item.selprodId ?? "",
                            item.selprodTitle ?? "",
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: item.image != null
                                      ? Image.network(
                                    AppConstants.imageBaseURLPath +
                                        item.imageURL!,
                                    fit: BoxFit.contain,
                                  )
                                      : const Icon(Icons.image_not_supported),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.selprodTitle ?? "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: "Nunito",
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      "${PrefStore().loadString(AppConstants.currencySymbol)}${item.selprodPrice ?? ""}",
                                      style: const TextStyle(
                                        fontFamily: "Nunito",
                                        fontSize: 17,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (item.hasVariants == "1")
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (item.availableVariants?.isNotEmpty == true &&
                                      item
                                          .availableVariants!
                                          .first
                                          .optionValues
                                          .isNotEmpty)
                                      ? item
                                      .availableVariants!
                                      .first
                                      .optionValues
                                      .first
                                      .optionName ??
                                      ""
                                      : "",
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontFamily: "Nunito",
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                if ((item.hasSizechart ?? "0") == "1")
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        barrierColor: Colors.black87,
                                        // dark background
                                        builder: (_) => SizeChartScreen(
                                          productId: item.selprodId ?? "0",
                                          productOptions: [],
                                          productName:
                                          controller.productName.value,
                                          productPrice:
                                          controller.productPrice.value,
                                        ),
                                        //     SizeChartOverlay(
                                        //   imageUrl: datum?.sizeChartImage ?? "",
                                        // ),
                                      );
                                    },
                                    child: Text(
                                      (PrefStore().loadString(
                                        AppConstants.languageCode,
                                      ) ==
                                          "AR")
                                          ? "مخطط الحجم"
                                          : "Size Chart",
                                      style: const TextStyle(
                                        color: Colors.blue,
                                        fontSize: 14,
                                        fontFamily: "Nunito",
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              height: 40, // height of inner horizontal list
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: item.availableVariants?.length ?? 0,
                                itemBuilder: (context, index) {
                                  final value = item
                                      .availableVariants?[index]
                                      .optionValues
                                      .first;
                                  return GestureDetector(
                                    onTap: () async {
                                      if (item
                                          .currentOptionValues
                                          ?.first
                                          .optionvalueId !=
                                          value?.optionvalueId) {
                                        debugPrint(
                                          "🟢 Selected option: ${value?.optionvalueName}",
                                        );

                                        final selectedVariant =
                                        item.availableVariants![index];
                                        final selectedOption =
                                            selectedVariant.optionValues.first;
                                        final selectedInStock =
                                            selectedVariant.inStock;

                                        debugPrint(
                                          "is in stock: $selectedInStock",
                                        );
                                        // 🔁 Replace current_option_values with tapped one
                                        item.currentOptionValues = [
                                          selectedOption,
                                        ];
                                        item
                                            .currentOptionValues
                                            ?.first
                                            .inStock =
                                            selectedInStock;
                                        controller
                                            .selectedSelProdIdForBoxContent?[outerIndex] =
                                            item
                                                .currentOptionValues
                                                ?.first
                                                .selprodoptionSelprodId ??
                                                "";
                                        debugPrint(
                                          "selected product box content ids ${controller.selectedSelProdIdForBoxContent}",
                                        );
                                        controller.productSections.refresh();
                                      }
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.only(right: 8),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      constraints: const BoxConstraints(
                                        minWidth:
                                        40, // ✅ minimum width set here
                                      ),
                                      decoration: BoxDecoration(
                                        color:
                                        (item
                                            .currentOptionValues
                                            ?.first
                                            .optionvalueId ==
                                            value?.optionvalueId)
                                            ? Colors.black
                                            : Colors.white,
                                        border: Border.all(color: Colors.black),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Center(
                                        child: Text(
                                          value?.optionvalueName ?? "",
                                          style: TextStyle(
                                            color:
                                            (item
                                                .currentOptionValues
                                                ?.first
                                                .optionvalueId ==
                                                value?.optionvalueId)
                                                ? Colors.white
                                                : Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: "Nunito",
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),

            const SizedBox(height: 20),
            Container(height: 5, color: Colors.grey[200]),
          ],
        );
        break;
    }

    return sectionWidget;
  }

  bool _isHtml(String text) {
    final htmlRegex = RegExp(r'<[^>]+>');
    return htmlRegex.hasMatch(text);
  }

  Widget _buildCircleIconButton({
    IconData? icon,
    String? imagePath,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 30,
      height: 30,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white70,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: imagePath != null
            ? Image.asset(
          imagePath,
          width: 15,
          height: 15,
          color: Colors.black87, // optional tint
        )
            : Icon(icon, color: Colors.black87, size: 15),
      ),
    );
  }
}


class DiagonalCrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    // Draw diagonal inside bounds
    canvas.drawLine(
      Offset(size.width - 10, 5),
      Offset(0, size.height ),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
