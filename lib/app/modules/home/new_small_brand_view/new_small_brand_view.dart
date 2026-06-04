import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/routes/app_routes.dart';
import '../home_model.dart';

class NewSmallBrandView extends StatelessWidget {
  final List<HomeBanner> banners;
  final Collection collection;

  const NewSmallBrandView({
    super.key,
    required this.banners,
    required this.collection,
  });

  @override
  Widget build(BuildContext context) {
    if (banners.isEmpty) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: 'new_small_brand_layout',
      child: Container(
        key: const Key('new_small_brand_root'),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.only(top: 10,bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFEEEEEE),
          borderRadius: BorderRadius.circular(24),
        ),
        child: SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: banners.length,
            itemBuilder: (context, index) {
              final banner = banners[index];

              return Semantics(
                label: 'new_small_brand_item_$index',
                button: true,
                child: GestureDetector(
                  key: Key('new_small_brand_tap_$index'),
                  onTap: () {
                    handleSlideNavigation(
                      context,
                      banner.bannerUrlType ?? "",
                      banner.bannerUrl ?? "",
                      banner.bannerUrlTitle ?? "",
                    );
                  },
                  child: Container(
                    width: 90,
                    margin: const EdgeInsets.only(right: 10,left: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.grey.shade300,
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 70,
                          width: 70,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              key: Key('new_small_brand_image_$index'),
                              imageUrl: banner.bannerImage ?? "",
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                              const Icon(
                                Icons.broken_image,
                                color: Colors.grey,
                                size: 32,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          banner.bannerTitle ?? "",
                          key: Key('new_small_brand_title_$index'),
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            fontFamily: "Nunito",
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
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
    );
  }

  void handleSlideNavigation(
      BuildContext context,
      String slideUrlType,
      String slideUrl,
      String slideUrlTitle,
      ) {
    switch (slideUrlType) {
      case "1":
        openUrl(slideUrl);
        break;

      case "2":
        Get.toNamed(
          AppRoutes.shopDetailView,
          arguments: {
            "shopId": slideUrl,
            "shopUserId": "",
          },
        );
        break;

      case "3":
        Get.toNamed(
          AppRoutes.productDetail,
          arguments: {
            "productId": slideUrl,
            "productName": slideUrlTitle,
          },
        );
        break;

      case "4":
        AppRoutes.goToProductListPage(
          brandId: "",
          productVideoAvailable: "0",
          titleHeader: slideUrlTitle,
          prodCatId: slideUrl,
          condition: "",
        );
        break;

      case "5":
        AppRoutes.goToProductListPage(
          brandId: slideUrl,
          productVideoAvailable: "0",
          titleHeader: slideUrlTitle,
          prodCatId: "",
          condition: "",
        );
        break;

      default:
        debugPrint("Unknown slideUrlType: $slideUrlType");
    }
  }

  static Future<void> openUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) return;

    final uri = Uri.tryParse(urlString);

    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      debugPrint('Cannot open URL: $urlString');
    }
  }
}