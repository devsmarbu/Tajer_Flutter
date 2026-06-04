import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/firebase/one_signal_notification.dart';
import 'package:tajer/marque_label.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../main_extension.dart';
import '../../../utils/app_colors.dart';
import '../../../utils/app_loader.dart';
import '../../core/constants/app_constants.dart';
import '../../core/routes/app_routes.dart';
import '../../modules/home/beauty_product_view/beauty_product_view.dart';
import '../../modules/home/category_view/category_view.dart';
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
import 'new_small_brand_view/new_small_brand_view.dart';
import 'perfume_view/perfume_view.dart';
import 'package:get/get.dart';
import '../notifications/alerts/view/notification_screen.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter/services.dart';

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
  late Worker _bannerWorker;

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

    _bannerWorker = ever(controller.firstTimeBannerImageURL, (url) {
      if (!mounted) return;
      // ✅ Only show if Home screen is currently visible
      if (Get.currentRoute != AppRoutes.bottomNavigation) return;
      if (url.isNotEmpty && controller.isFirstTimeBannerImage == "1") {
        tryShowBanner(context);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bannerWorker.dispose();

    // Optional: safely remove listeners or reset reactive updates
    // if (Get.isRegistered<HomeController>()) {
    //   controller.isLoading.close();
    // }

    super.dispose();
  }

  Widget _buildSection(Collection collection, int index) {
    Widget sectionWidget;

    switch (collection.layoutType) {
      case CollectionLayoutType.productLayout1:
      case CollectionLayoutType.productLayout2:
      case CollectionLayoutType.trendingProduct:
        sectionWidget = SizedBox(
          height: 346,
          child: DualHorizontalProductView(
            titleHeader: collection.collectionName ?? "",
            products: collection.products,
            scrollDirection: Axis.horizontal,
            height: 286,
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
              // if (!mounted) return; // ✅ Prevent calling setState after dispose
              // if (index == 0) {
              //   setState(() => appBarColor = color);
              // }
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
          if ((collection.banners?.banners ?? []).isNotEmpty) {
            sectionWidget = SizedBox(
              height: 110,
              child: CategoryView(banners: collection.banners?.banners ?? []),
            );
          } else {
            sectionWidget = const SizedBox.shrink();
          }
        } else {
          sectionWidget = const SizedBox.shrink();
        }
      case CollectionLayoutType.smallBrandLayoutNew:
        if ((collection.banners?.banners ?? []).isNotEmpty) {
          sectionWidget = SizedBox(
            height: 150,
            child: NewSmallBrandView(
              banners: collection.banners?.banners ?? [],
              collection: collection,
            ),
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
      case CollectionLayoutType.homePageBannerStripe:
        final stripeSvgUrl = collection.homePageStripeSVGUrl;
        if (stripeSvgUrl != null && stripeSvgUrl.isNotEmpty) {
          sectionWidget = InfiniteScrollBanner(
            height: 40,
            duration: const Duration(seconds: 30),
            child: SvgPicture.network(
              stripeSvgUrl,
              height: 40,
              fit: BoxFit.fitHeight,
            ),
          );
        } else {
          sectionWidget = (collection.collectionDescription ?? '').marqueeLabel(
            height: 40,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            forceShow: true,
          );
        }
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
    final bool isDarkBg =
        ThemeData.estimateBrightnessForColor(appBarColor) == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkBg
          ? SystemUiOverlayStyle.light // white status bar icons
          : SystemUiOverlayStyle.dark, // black status bar icons
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.black),
            );
          }

          return SafeArea(
            bottom: false,
            child: Column(
              children: [
                /// Row 1: 🔥 Marquee Label (Promo Banner)
                (PrefStore().loadString(AppConstants.promoBannerText) ?? '')
                    .marqueeLabel(),

                /// 🔥 New Custom Dynamic Header Container (Row 2 & Row 3)
                Container(
                  color: appBarColor,
                  padding: const EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 10,
                    bottom: 14,
                  ),
                  child: Column(
                    children: [
                      /// Row 2: Logo + Address Picker
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset(
                            key: const Key('home_tajer_logo'),
                            "assets/icons/ic_eid_icon.png",
                            height: 38,
                          ),
                          GestureDetector(
                            onTap: () async {
                              final result = await showDialog(
                                context: context,
                                builder: (_) => CountrySelectDialog(
                                  selectedCountryName: PrefStore().loadString(
                                    AppConstants.countryName,
                                  ),
                                ),
                              );
                              if (result != null) {
                                final selected = result as Result;
                                controller.setCountry(
                                  "${selected.id ?? 0}",
                                  selected.text ?? "Qatar",
                                );
                              }
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/ic_location_new.svg",
                                  height: 18,
                                  colorFilter: ColorFilter.mode(
                                    ThemeData.estimateBrightnessForColor(appBarColor) ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "${(PrefStore().loadString(AppConstants.countryName) ?? "").isEmpty ? "Qatar" : PrefStore().loadString(AppConstants.countryName)}",
                                  style: TextStyle(
                                    color: ThemeData.estimateBrightnessForColor(appBarColor) ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      /// Row 3: Search + Notification + Bag
                      Row(
                        children: [
                          const Expanded(
                            child: SearchPage(),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              Get.to(() => NotificationScreen());
                            },
                            child: SvgPicture.asset(
                              "assets/icons/ic_bell_new.svg",
                              height: 24,
                              colorFilter: ColorFilter.mode(
                                ThemeData.estimateBrightnessForColor(appBarColor) ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          GestureDetector(
                            onTap: () {
                              widget.onCartTap?.call();
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/ic_cart_new.svg",
                                  height: 24,
                                  colorFilter: ColorFilter.mode(
                                    ThemeData.estimateBrightnessForColor(appBarColor) ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Obx(() {
                                  if (cartItemCounts.value.toIntSafe() > 0) {
                                    return Positioned(
                                      right: -5,
                                      top: -5,
                                      child: Container(
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                        constraints: const BoxConstraints(
                                          minWidth: 16,
                                          minHeight: 16,
                                        ),
                                        child: Text(
                                          cartItemCounts.value.toString(),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
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
                        ],
                      ),
                    ],
                  ),
                ),

                /// Expanded scrollable list of home sections
                Expanded(
                  child: RefreshIndicator(
                    color: Colors.black,
                    onRefresh: () async {
                      await controller.reloadHomeData();
                    },
                    child: ListView(
                      controller: _scrollController,
                      children: [
                        ...List.generate(controller.posts.length, (index) {
                          return Column(
                            children: [
                              (controller.posts[index].layoutType != CollectionLayoutType.smallBrandLayoutNew)
                                  ? Container(
                                height: 16,
                                color: AppColors.colorBackgroundHomeNew,
                              )
                                  : Container(
                                height: 16,
                                color: AppColors.white,
                              ),

                              _buildSection(controller.posts[index], index),
                            ],
                          );
                        }),

                        // Loader
                        GetBuilder<HomeController>(
                          builder: (_) {
                            return controller.isPageLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(20),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: Colors.black,
                                      ),
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
            ),
          );
        }),
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  void showBannerPopup(BuildContext context) {
    bool imageLoaded = false;

    showDialog(
      context: context,
      barrierDismissible: false,
      // 👈 we handle dismissal ourselves
      barrierColor: Colors.transparent,
      useSafeArea: false,
      builder: (_) => StatefulBuilder(
        builder: (context, setState) {
          return Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                // 🔴 FULLSCREEN BLACK OVERLAY (tap to dismiss)
                if (imageLoaded)
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => Get.back(),
                      child: Container(color: Colors.black.withOpacity(0.6)),
                    ),
                  ),

                // 🖼️ CENTERED BANNER
                Center(
                  child: Dialog(
                    insetPadding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: GestureDetector(
                            onTap: () {
                              // 👉 your click action here
                              // e.g. open webview / navigate
                              print("Banner tapped");
                              redirectionURL =
                                  controller.bannerRedirectURL.value;
                              if (AppState.isReady == true) {
                                debugPrint('this is universal navigation 4');
                                UrlHandling.shared.universalUrlDetailsAPI(
                                  controller.bannerRedirectURL.value,
                                );
                              }
                              // Get.to(() => OfferScreen());
                            },
                            child: Image.network(
                              controller.firstTimeBannerImageURL.value,
                              fit: BoxFit.cover,
                              frameBuilder: (context, child, frame, _) {
                                if (frame != null && !imageLoaded) {
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    setState(() => imageLoaded = true);
                                  });
                                }
                                return child;
                              },
                              errorBuilder: (_, __, ___) =>
                                  const SizedBox(height: 200),
                            ),
                          ),
                        ),
                        // ❌ CLOSE BUTTON (after load)
                        if (imageLoaded)
                          Positioned(
                            top: -40,
                            right: 0,
                            child: GestureDetector(
                              onTap: () => Get.back(),
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void tryShowBanner(BuildContext context) {
    final url = controller.firstTimeBannerImageURL.value;
    if (url.isEmpty) return;

    final image = NetworkImage(url);
    final ImageStream stream = image.resolve(const ImageConfiguration());

    late ImageStreamListener listener;
    listener = ImageStreamListener((_, __) {
      stream.removeListener(listener);

      if (context.mounted) {
        showBannerPopup(context); // ✅ open dialog ONLY after load
      }
    });

    stream.addListener(listener);
  }
}
