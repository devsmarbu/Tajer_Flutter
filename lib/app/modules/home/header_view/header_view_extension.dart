import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/modules/productList/controllers/product_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/routes/app_routes.dart';
import '../home_model.dart';
import '../reel_page_view/reel_page_view.dart';

class HeaderViewHelper {
  static seeAllButton(BuildContext context, Collection? collection,String? currencySymbol) {
    switch (collection?.layoutType) {
      case null:
        // TODO: Handle this case.
        throw UnimplementedError();
      case (CollectionLayoutType.productLayout1) ||
          (CollectionLayoutType.productLayout2) ||
          (CollectionLayoutType.productLayout3) ||
          (CollectionLayoutType.perfume) ||
          (CollectionLayoutType.trendingProduct) ||
          (CollectionLayoutType.newProductLayout) ||
          (CollectionLayoutType.faqLayout) ||
          (CollectionLayoutType.shopLayout) ||
          (CollectionLayoutType.brandLayout) ||
          (CollectionLayoutType.newTopBrand) ||
          (CollectionLayoutType.blogLayout) ||
          (CollectionLayoutType.sponsoredProductLayout) ||
          CollectionLayoutType.categoryLayout1 ||
          CollectionLayoutType.categoryLayout2 ||
          CollectionLayoutType.newCategory ||
          CollectionLayoutType.parentCategory ||
          CollectionLayoutType.newCategoryLayout:
        if (collection?.collectionDisplayMediaOnly != "1") {
          debugPrint(
            "-------------${collection?.collectionUrlType ?? ""}----------------",
          );
          debugPrint(
            "-------------${collection?.layoutType ?? ""}----------------",
          );
          if ((collection?.collectionLinkUrl ?? '').isNotEmpty) {
            if (collection?.collectionUrlType == "1") {
              openUrl(collection?.collectionLinkUrl ?? "");
            } else if (collection?.collectionUrlType == "2") {
              Get.toNamed(
                AppRoutes.shopDetailView,
                arguments: {
                  "shopId": collection?.collectionLinkUrl,
                  "shopUserId": collection?.shops?.first.shopUserId ?? "",
                },
              );
            } else if (collection?.collectionUrlType == "3") {
              Get.toNamed(
                AppRoutes.productDetail,
                arguments: {
                  'productId': collection?.collectionLinkUrl,
                  'productName': collection?.collectionUrlTitle,
                },
              );
            } else if (collection?.collectionUrlType == "4") {
              AppRoutes.goToProductListPage(
                brandId: "",
                productVideoAvailable: "0",
                titleHeader: collection?.collectionUrlTitle ?? "",
                prodCatId: (collection?.collectionLinkUrl ?? ""),
                condition: "",
              );
            } else if (collection?.collectionUrlType == "5") {
              AppRoutes.goToProductListPage(
                brandId: (collection?.collectionLinkUrl ?? ""),
                productVideoAvailable: "0",
                titleHeader: collection?.collectionName ?? "",
                prodCatId: '',
              );
            }
          } else if (collection?.collectionLinkUrl == null ||
              collection!.collectionLinkUrl!.isEmpty) {
            if (collection?.layoutType == (CollectionLayoutType.newTopBrand)) {
              AppRoutes.goToBrandsListViewPage(
                collectionId: collection?.collectionId ?? "",
              );
            } else if (collection?.layoutType ==
                (CollectionLayoutType.shopLayout)) {
              AppRoutes.goToShopListViewPage(
                collectionId: collection?.collectionId ?? "",
              );
            }
          }
        }
      case (CollectionLayoutType.topBanner) ||
          (CollectionLayoutType.sliderBanner) ||
          (CollectionLayoutType.middleBanner) ||
          (CollectionLayoutType.bottomBanner) ||
          (CollectionLayoutType.sponsoredShopLayout) ||
          (CollectionLayoutType.testimonialLayout) ||
          (CollectionLayoutType.pendingReviewLayout) ||
          (CollectionLayoutType.aboutUs) ||
          (CollectionLayoutType.newPrediction1) ||
          (CollectionLayoutType.homeSlider) ||
          (CollectionLayoutType.homeSliderNew) ||
          (CollectionLayoutType.smallBrandLayout) ||
          (CollectionLayoutType.smallBrandLayoutNew) ||
          (CollectionLayoutType.dualSquareBanner):
      // TODO: Handle this case.
      case CollectionLayoutType.reelCollectionLayout:
        // TODO: Handle this case.
      final productIdsString =
          "[${collection?.products.map((p) => p.productId?.toIntSafe()).join(',')}]";
      // ✅ Move tapped product to first index
      final tappedProduct = collection?.products[0];

      // ✅ Open full-screen reel view
      Get.to(
            () => ReelPage(products: [?tappedProduct]),
        arguments: {
          "productVideoAvailable": "1",
          "productIds": productIdsString,
          "indexToPlayVideoFirst": 0,
        },
      );

      throw UnimplementedError();
      case CollectionLayoutType.unknown:
        // TODO: Handle this case.
        throw UnimplementedError();
      case CollectionLayoutType.spacer:
        // TODO: Handle this case.
        throw UnimplementedError();
      case CollectionLayoutType.homePageBannerStripe:
        // TODO: Handle this case.
        throw UnimplementedError();
    }
    return Text("data");
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
