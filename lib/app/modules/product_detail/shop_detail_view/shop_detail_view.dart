import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/app/Extensions/image_color_utils.dart';
import 'package:tajer/app/modules/product_detail/shop_detail_view/reviews_view/review_list_view.dart';
import 'package:tajer/app/modules/product_detail/shop_detail_view/shop_detail_controller.dart';
import 'package:tajer/utils/app_strings.dart';

import '../../../../../utils/app_colors.dart';
import '../../Cart/MainCartView.dart';
import '../../home/dual_horizontal_product_view/dual_horizontal_product_view.dart';
import '../../productList/controllers/product_controller.dart';
import '../../productList/product_card.dart';
import '../ask_question_view/ask_question_view.dart';
import '../select_size/select_size_controller.dart';
import '../select_size/select_size_view.dart';

class ShopDetailPage extends StatefulWidget {
  const ShopDetailPage({super.key});

  @override
  State<ShopDetailPage> createState() => _ShopDetailPageState();
}

class _ShopDetailPageState extends State<ShopDetailPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final controller = Get.put(ShopDetailController());
  bool showFloatingBar = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    controller.loadShopDetail();

    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !showFloatingBar) {
        setState(() => showFloatingBar = true);
      } else if (_scrollController.offset < 200 && showFloatingBar) {
        setState(() => showFloatingBar = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(scrolledUnderElevation: 0, backgroundColor: Colors.white),
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            // ---- Collapsing Shop Header ----
            Obx(() {
              return SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: false,
                floating: false,
                snap: false,
                toolbarHeight: 0,
                expandedHeight:
                (controller
                    .shopDetail
                    .value
                    ?.data
                    ?.shop
                    ?.badges
                    ?.isNotEmpty ??
                    false)
                    ? 340
                    : 285,
                // full height when expanded
                collapsedHeight: 0,
                // folds to zero height
                backgroundColor: AppColors.white,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: _buildShopHeader(),
                ),
              );
            }),
            // ---- Pinned TabBar ----
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: _tabController,
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.black,
                  indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(width: 2.0, color: Colors.black87),
                    // 👈 thickness
                    insets: EdgeInsets.symmetric(
                      horizontal: 40.0,
                    ), // 👈 controls width
                  ),
                  tabs: [
                    Tab(
                      icon: Image.asset("assets/images/menu.png"),
                      height: 25,
                    ),
                    Tab(
                      icon: Image.asset("assets/images/sale.png"),
                      height: 25,
                    ),
                    Tab(
                      icon: Image.asset(
                        "assets/images/shop_star.png",
                        height: 30,
                      ),
                    ),
                    Tab(
                      icon: Image.asset("assets/images/mail.png", height: 20),
                    ),
                    Tab(
                      icon: Image.asset(
                        "assets/images/shop_policy.png",
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildProductTab(),
            // const Center(child: Text("About Section")),
            const Center(
              child: EmptyCartWidget(
                imagePath: "assets/images/no_data_image.png",
                message: "No data found",
                imageSize: 200,
              ),
            ),
            ReviewListView(reviewList: controller.reviews),
            Obx(() {
              return AskQuestionPageView(
                showAppBar: false,
                shopId: controller.shopDetail.value?.data?.shop?.shopId ?? "",
                shopName: controller.shopDetail.value?.data?.shop?.shopName ??
                    "",
              );
            }
            ),
            const Center(
              child: EmptyCartWidget(
                imagePath: "assets/images/no_data_image.png",
                message: "No data found",
                imageSize: 200,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: showFloatingBar
          ? FloatingActionButton.small(
        backgroundColor: Colors.black,
        onPressed: () {
          _scrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
          );
        },
        child: const Icon(Icons.arrow_upward, color: Colors.white,size: 18,),
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  // --- SHOP HEADER (Collapsible Section) ---
  Widget _buildShopHeader() {
    return Obx(() {
      final shopDetail = controller.shopDetail.value?.data;
      return Container(
        color: AppColors.lightGrey.withValues(alpha: 0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      color: Colors.grey[100], // 👈 background color here
                      height: 70,
                      width: 70,
                      child: Image.network(
                        shopDetail?.shop?.shopLogo ?? "",
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Container(
                              color: Colors.grey[200],
                              child: const Icon(
                                Icons.store_mall_directory,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),
                      ).withDefaultError(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    spacing: 0,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shopDetail?.shop?.shopName ?? "",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Nunito",
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            shopDetail?.shop?.rating ?? "",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontFamily: "Nunito",
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          Icon(Icons.star, color: Colors.amber, size: 18),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${shopDetail?.shop?.shopStateName ?? ""},${shopDetail
                            ?.shop?.shopCountryName ?? ""}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black54,
                          fontFamily: "Nunito",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (shopDetail?.shop?.badges?.isNotEmpty ?? false)
                    Stack(
                      children: [
                        Container(
                          height: 50,
                          width: Get.width,
                          decoration: BoxDecoration(
                            color: AppColors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          top: 10,
                          child: Image(
                            height: 30,
                            width: 30,
                            image: NetworkImage(
                              shopDetail?.shop?.badges?.first.url ?? "",
                            ),
                            fit: BoxFit.cover,
                          ).withDefaultError(),
                        ),
                      ],
                    ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Center(
                      child: Image(
                        image: NetworkImage(shopDetail?.shop?.shopBanner ?? ""),
                        width: Get.width,
                        fit: BoxFit.cover,
                        height: 180,
                      ).withDefaultError(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // --- PRODUCT TAB (Your Existing Product View) ---
  Widget _buildProductTab() {
    return Obx(() {
      // Handle empty state
      // if (controller.products.isEmpty && !controller.isLoading.value) {
      //   return EmptyCartWidget(
      //     imagePath: "assets/images/no_data_image.png",
      //     message: AppStrings.appNoDataFound.tr,
      //   );
      // }

      return GridView.builder(
        // ✅ Don't use shrinkWrap with large lists (hurts performance)
        physics: const AlwaysScrollableScrollPhysics(),
        cacheExtent: 200,
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.fromLTRB(10, 12, 10, 80),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.61,
          crossAxisSpacing: 12.0,
          mainAxisSpacing: 12.0,
        ),
        itemCount: controller.products.length + 1,
        // ✅ Add +1 for loader
        itemBuilder: (context, index) {
          // ✅ Show loader when last index is reached
          if (index == controller.products.length) {
            return controller.isLoading.value
                ? const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: CircularProgressIndicator(),
              ),
            )
                : const SizedBox.shrink();
          }
          return Obx(() {
            return ProductCard(
              product: controller.products[index],
              isVertical: true,
              onAddToCart: ()  {
                final options = controller.products[index].productOptions;
                if (options != null && options.isNotEmpty) {
                  final firstOptionValues =
                      options.first.values ?? [];
                  if (firstOptionValues.isNotEmpty) {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => SelectSizeView(
                        price: controller.products[index].selprodPrice ?? "",
                        productId: controller.products[index].productId ?? "",
                        productOptions: firstOptionValues,
                        currencyCode: controller.products[index].selprodPrice?.replaceAll(RegExp(r'[0-9.]'), '') ?? "\$",
                      ),
                    );
                  } else {
                    final sizeController = Get.put(SelectSizeController(controller.products[index].selprodId ?? ''));
                    sizeController.addToCart(controller.products[index].selprodId ?? '');
                  }
                } else {
                  final sizeController = Get.put(SelectSizeController(controller.products[index].selprodId ?? ''));
                  sizeController.addToCart(controller.products[index].selprodId ?? '');
                }
              },
            );
          });
        },
      );
    });
  }
}

// --- Custom Delegate to Pin TabBar ---
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;

  _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context,
      double shrinkOffset,
      bool overlapsContent,) {
    return Container(color: Colors.white, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
