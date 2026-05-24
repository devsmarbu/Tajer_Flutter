import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/routes/app_routes.dart';
import '../home_model.dart';

class DualBannerCellView extends StatelessWidget {
  final double borderRadius;
  final Collection collection;
  final List<HomeBanner>? banners;

  const DualBannerCellView({
    super.key,
    this.borderRadius = 10,
    required this.collection,
    this.banners,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const Key('dual_banner_view'),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          // Left Image
          Expanded(
            child: GestureDetector(
              onTap: () {
                handleSlideNavigation(
                  context,
                  banners?.first.bannerUrlType ?? "",
                  banners?.first.bannerUrl ?? "",
                  banners?.first.bannerUrlTitle ?? "",
                );
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  // 👈 Background color while image loads or fails
                  borderRadius: BorderRadius.circular(borderRadius),
                  image: DecorationImage(
                    image: NetworkImage(banners?.first.bannerImage ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),

          // Right Image
          Expanded(
            child: GestureDetector(
              onTap: () {
                handleSlideNavigation(
                  context,
                  banners?.last.bannerUrlType ?? "",
                  banners?.last.bannerUrl ?? "",
                  banners?.last.bannerUrlTitle ?? "",
                );
              },
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  // 👈 Background color while image loads or fails
                  borderRadius: BorderRadius.circular(borderRadius),
                  image: DecorationImage(
                    image: NetworkImage(banners?.last.bannerImage ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ],
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
