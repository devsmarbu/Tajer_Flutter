import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/routes/app_routes.dart';
import '../home_model.dart';

class CategoryView extends StatelessWidget {
  final List<HomeBanner> banners;

  const CategoryView({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'category_view_list',
      child: SizedBox(
        key: const Key('category_view'),
        child: ListView.builder(
          key: const Key('category_list_view'),
          scrollDirection: Axis.horizontal,
          itemCount: banners.length,
          clipBehavior: Clip.none,
          itemBuilder: (context, index) {
            final banner = banners[index];
            final provider = NetworkImage(banner.bannerImage ?? "");
            return 
              Semantics(
                label: 'category_item_$index',
                child: Container(
                  key: Key('category_item_container_$index'),
                clipBehavior: Clip.none,
                padding: EdgeInsets.all(0),
                width: 90,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
                child: GestureDetector(
                  key: Key('category_item_tap_$index'),
                  onTap: () {
                    handleSlideNavigation(
                      context,
                      banner.bannerUrlType ?? "",
                      banner.bannerUrl ?? "",
                      banner.bannerUrlTitle ?? "",
                    );
                  },
                  child: Column(
                    key: Key('category_item_column_$index'),
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 👇 Rounded image
                      const SizedBox(height: 8,key: Key('category_top_spacing'),),
                      Semantics(
                        label: 'category_image_${banner.bannerTitle}_$index',
                        image: true,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(40),
                          child: Container(
                            key: Key('category_image_container_$index'),
                            color: Colors.grey.withValues(alpha: 0.1),
                            // 👈 Background color while image loads
                            height: 70,
                            width: 70,
                            child: Image(
                              key: Key('category_image_$index'),
                              image: provider,
                              fit: BoxFit.cover,
                              height: 70,
                              width: 70,
                              errorBuilder: (context, error, stackTrace) => Container(
                                key: Key('category_image_error_$index'),
                                color: Colors.grey[300],
                                // 👈 fallback color for error
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Colors.grey,
                                  size: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5,key: Key('category_spacing_between_image_text'),),
                      Padding(
                        key: Key('category_title_padding_$index'),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        child: Semantics(
                          label:
                          'category_title_${banner.bannerTitle}_$index',
                          child: Text(
                            key: Key('category_title_text_$index'),
                            banner.bannerTitle ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 11,
                              fontFamily: "Nunito",
                            ),
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
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
          arguments: {"shopId": slideUrl, "shopUserId": ""},
        );
        break;

      case "3":
        Get.toNamed(
          AppRoutes.productDetail,
          arguments: {'productId': slideUrl, 'productName': slideUrlTitle},
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
          prodCatId: '',
          condition: "",
        );
        break;
    }
  }

  static Future<void> openUrl(String? urlString) async {
    if (urlString == null || urlString.isEmpty) return;

    final uri = Uri.tryParse(urlString);
    if (uri != null && await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('❌ Cannot open URL: $urlString');
    }
  }
}
