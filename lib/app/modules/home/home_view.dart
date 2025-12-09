import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/utils/app_strings.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../core/constants/app_constants.dart';
import '../../modules/Cart/MainCartView.dart';
import '../../modules/home/beauty_product_view/beauty_product_view.dart';
import '../../modules/home/category_view/category_view.dart';
import '../../modules/home/padded_banner_view/padded_banner_view.dart';
import '../../modules/home/reel_page_view/reel_page_view.dart';
import '../../modules/home/reel_view/reel_view.dart';
import '../../modules/home/search_view/search_view.dart';
import '../../modules/home/shop_list_view/shop_list_view.dart';
import 'banner_page_view/banner_page_view.dart';
import 'change_location_view/change_location_view.dart';
import 'change_location_view/country_model.dart';
import 'dual_banner_view/dual_banner_view.dart';
import 'dual_horizontal_product_view/dual_horizontal_product_view.dart';
import 'favorite_brand_view/favorite_brand_view.dart';
import 'home_controller.dart';
import 'home_model.dart';
import 'perfume_view/perfume_view.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../notifications/alerts/view/notification_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';

class HomeView extends StatefulWidget {
  final VoidCallback? onCartTap;

  const HomeView({super.key, this.onCartTap});

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  Color appBarColor = Colors.white; // default color
  final ScrollController _scrollController = ScrollController();
  final HomeController controller = Get.put(HomeController());
  bool showScrollToTop = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      // Load next page – already exists
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        controller.loadNextPage();
      }

      // 👇 Show float button when scrolled 800px+
      if (_scrollController.offset > 800) {
        if (!showScrollToTop) setState(() => showScrollToTop = true);
      } else {
        if (showScrollToTop) setState(() => showScrollToTop = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    // Optional: safely remove listeners or reset reactive updates
    if (Get.isRegistered<HomeController>()) {
      controller.isLoading.close();
    }

    super.dispose();
  }

  Widget buildAppBar(Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            color,
            // bottom color
            const Color(0xFFF7F7F7),
            // top color (slightly off-white for subtle gradient)
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Spacer(),
            Align(
              alignment: Alignment.bottomCenter,
              child: Image.asset(
                "assets/images/Tajer_Logo.png",
                height: 55,
                color: Colors.black54,
              ),
            ),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(() => NotificationScreen());
                      },
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Image.asset(
                          "assets/images/notification.png",
                          height: 28,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // pref.loadString(AppConstants.sessionToken) ?? ""
                    GestureDetector(
                      onTap: () {
                        widget.onCartTap?.call();
                      },
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Image.asset(
                              "assets/images/cartIcon.png",
                              height: 28,
                              color: Colors.black,
                            ),

                            // 🔴 Item Count Badge
                            Obx(() {
                              if (cartItemCounts.value.toIntSafe() > 0) {
                                return Positioned(
                                  right: -6,
                                  top: -6,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                    ),
                                    constraints: const BoxConstraints(
                                      minWidth: 18,
                                      minHeight: 18,
                                    ),
                                    child: Text(
                                      cartItemCounts.value.toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }

                              return const SizedBox();
                            }),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(Collection collection, int index) {
    Widget sectionWidget;

    switch (collection.layoutType) {
      case CollectionLayoutType.productLayout1:
      case CollectionLayoutType.productLayout2:
      case CollectionLayoutType.trendingProduct:
        sectionWidget = SizedBox(
          height: 335,
          child: DualHorizontalProductView(
            titleHeader: collection.collectionName ?? "",
            products: collection.products,
            scrollDirection: Axis.horizontal,
            height: 285,
            wantHeader: true,
            scrollEnabled: true,
            isHomeHeader: true,
            isHideSeeAll: false,
            prodCatId: index.toString(),
            collection: collection,
            currencyCode: controller.currencySymbol.value,
          ),
        );

      case CollectionLayoutType.middleBanner:
        sectionWidget = Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: SizedBox(
            height: 120,
            child: DualBannerCellView(
              banners: collection.banners?.banners,
              collection: collection,
            ),
          ),
        );
      case CollectionLayoutType.categoryLayout1:
      case CollectionLayoutType.categoryLayout2:
        sectionWidget = SizedBox(
          height: 140,
          child: CategoryView(banners: collection.banners?.banners ?? []),
        );

      case CollectionLayoutType.brandLayout:
        sectionWidget = SizedBox(
          height: 350,
          child: FavoriteBrandCellView(collection: collection),
        );

      case CollectionLayoutType.dualSquareBanner:
        sectionWidget = SizedBox(
          height: 190,
          child: DualBannerCellView(
            banners: collection.banners?.banners,
            collection: collection,
          ),
        );

      case CollectionLayoutType.topBanner:
      case CollectionLayoutType.homeSlider:
      case CollectionLayoutType.homeSliderNew:
        sectionWidget = SizedBox(
          height: (collection.layoutType == CollectionLayoutType.topBanner)
              ? 240
              : 220,
          child: BannerPageView(
            addPadding:
                collection.layoutType != CollectionLayoutType.topBanner &&
                index != 0,
            slides: collection.slides,
            onColorChanged: (color) {
              if (!mounted) return; // ✅ Prevent calling setState after dispose
              if (index == 0) {
                setState(() => appBarColor = color);
              }
            },
            bannerImage: collection.banners?.banners?.first.bannerImage ?? "",
            bannerTitle: collection.banners?.banners?.first.bannerTitle ?? "",
            bannerUrlOrId: collection.banners?.banners?.first.bannerUrl ?? "",
            bannerURLType:
                collection.banners?.banners?.first.bannerUrlType ?? "",
            collection: collection,
          ),
        );

      case CollectionLayoutType.newProductLayout:
        sectionWidget = SizedBox(
          height: Get.width - 70,
          child: BeautyProductCellView(
            products: collection.products,
            collection: collection,
          ),
        );

      case CollectionLayoutType.reelCollectionLayout:
        sectionWidget = SizedBox(
          height: 300,
          child: ReelView(
            products: collection.products,
            collection: collection,
          ),
        );

      case CollectionLayoutType.shopLayout:
        sectionWidget = SizedBox(
          height: 480,
          child: ShopListView(collection: collection),
        );

      case CollectionLayoutType.smallBrandLayout:
        if ((collection.banners?.banners ?? []).isNotEmpty) {
          sectionWidget = SizedBox(
            height: 110,
            child: CategoryView(banners: collection.banners?.banners ?? []),
          );
        } else {
          sectionWidget = const SizedBox.shrink();
        }
      case CollectionLayoutType.newTopBrand:
        sectionWidget = SizedBox(
          height: 350,
          child: FavoriteBrandCellView(
            brands: collection.brands ?? [],
            titleHeader: collection.collectionName,
            collection: collection,
          ),
        );
      case CollectionLayoutType.perfume:
        sectionWidget = SizedBox(
          height: 410,
          child: PerfumeCellView(
            titleHeader: collection.collectionName ?? "",
            products: collection.products,
            collection: collection,
            currencyCode: controller.currencySymbol.value,
          ),
        );
      case CollectionLayoutType.spacer:
        sectionWidget = const SizedBox(height: 40);
      default:
        sectionWidget = const SizedBox.shrink(); // skip unknown layouts
    }

    // ✅ Wrap first section in VisibilityDetector
    if (index == 0) {
      return VisibilityDetector(
        key: Key("top-banner-$index"),
        onVisibilityChanged: (info) {
          if (!mounted) return; // ✅ Prevent setState after dispose
          if (info.visibleFraction < 0.5 && appBarColor != Colors.white) {
            setState(() => appBarColor = Colors.white);
          }
        },
        child: sectionWidget,
      );
    }
    return sectionWidget;
  }

  @override
  Widget build(BuildContext context) {
    double screenSizeWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: buildAppBar(appBarColor),
        leading: SizedBox(
          width: 100,
          height: 35,
          child: Container(
            color: Colors.transparent,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: TextButton(
                  onPressed: () async {
                    final result = await showDialog(
                      context: context,
                      builder: (_) => CountrySelectDialog(
                        selectedCountryName: PrefStore().loadString(AppConstants.countryName,
                      ),
                    ));
                    if (result != null) {
                      final selected = result as Result;
                      print("Selected Country ID: ${selected.id}");
                      print("Selected Country Name: ${selected.text}");
                      controller.setCountry(
                        "${selected.id ?? 0}",
                        selected.text ?? "Qatar",
                      );
                    }
                  },
                  child: Text(
                    "${(PrefStore().loadString(AppConstants.countryName) ?? "").isEmpty ? "Qatar" : PrefStore().loadString(AppConstants.countryName)}",
                    style: TextStyle(
                      color:
                          ThemeData.estimateBrightnessForColor(appBarColor) ==
                              Brightness.dark
                          ? Colors.white
                          : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        leadingWidth: PrefStore().loadString(AppConstants.languageCode) == "AR"
            ? 90
            : 170,
      ),
      backgroundColor: Colors.white,
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final posts = controller.posts;
        // if (posts.isEmpty) {
        //   return Center(
        //     child: EmptyCartWidget(
        //       imagePath: 'assets/images/no_data_image.png',
        //       message: AppStrings.appNoDataFound.tr,
        //     ),
        //   );
        // }

        return Column(
          children: [
            Container(
              color: appBarColor,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: SearchPage(),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  await controller.reloadHomeData();
                },
                child: ListView(
                  controller: _scrollController,
                  children: [
                    ...List.generate(
                      controller.posts.length,
                      (index) => _buildSection(controller.posts[index], index),
                    ),

                    // ⬇ Loader without Obx
                    GetBuilder<HomeController>(
                      builder: (_) {
                        return controller.isPageLoading
                            ? const Padding(
                                padding: EdgeInsets.all(20),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : const SizedBox();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: showScrollToTop
          ?

      Padding(padding: EdgeInsets.only(bottom: Platform.isIOS ? 40 : 0),child:
      FloatingActionButton.small(
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
      )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
