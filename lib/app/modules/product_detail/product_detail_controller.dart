import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/data/events/app_analytics_service.dart';
import 'package:tajer/app/data/respository/wish_list_repository.dart';
import 'package:tajer/utils/pref_store.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';
import '../../core/routes/app_routes.dart';
import '../../data/respository/product_repository.dart';
import 'product_detail_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

class ProductDetailController extends GetxController {
  final ProductRepository _repository = ProductRepository();
  final WishListRepository _wishListRepository = WishListRepository();

  final RxList<Datum> productSections = <Datum>[].obs;
  final isLoading = false.obs;
  bool _isRequesting = false;
  String productId = "";
  String selProductId = "";
  RxString productName = "".obs;
  RxString productPrice = "".obs;
  RxString productUrl = "".obs;
  RxString productTitle = "".obs;
  RxString productDescription = "".obs;
  RxString imageURL = "".obs;
  RxString inStock = "".obs;
  int page = 1;
  RxString isInAnyWishlist = "0".obs;
  var listId = "";
  List<String>? selectedSelProdIdForBoxContent;

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments;
    productId = args != null && args['productId'] != null
        ? args['productId'].toString()
        : "0";
    productName.value = args != null && args['productName'] != null
        ? args['productName'].toString()
        : "";

    if (productId != "0") {
      loadProductDetail();
    }
  }

  /// ✅ Load paginated product details
  Future<void> loadProductDetail() async {
    if (_isRequesting) return;
    _isRequesting = true;
    isLoading(true);

    bool firstPageLoaded = false;

    try {
      await _repository.fetchAllProductPages(
        productId,
        onPageLoaded: (newSections) async {
          if (isClosed) {
            isLoading(false);
            return;
          }
          if (!firstPageLoaded) {
            productSections.clear();
          }
          productSections.addAll(newSections);

          // ✅ Hide loader after first page loaded
          if (!firstPageLoaded) {
            final productDetailSection = productSections.firstWhereOrNull(
              (d) => d.customType == ProductDetailType.productDetail,
            );
            final productImagesSection = productSections.firstWhereOrNull(
              (d) => d.customType == ProductDetailType.productImages,
            );
            final productBoxContent = productSections.firstWhereOrNull(
              (d) => d.customType == ProductDetailType.boxContent,
            );

            final items = productBoxContent?.content?.boxContent ?? [];
            prepareSelectedVariants(items);
            debugPrint("this is for in loop");
            productSections.refresh();
            inStock.value =
                productDetailSection?.content?.productDetail?.inStock ?? "0";
            isInAnyWishlist.value =
                productDetailSection?.content?.productDetail?.isInAnyWishlist ??
                "0";
            selProductId =
                productDetailSection?.content?.productDetail?.selprodId ?? "";
            productUrl.value =
                productDetailSection?.content?.productDetail?.productUrl ?? "";
            productTitle.value =
                productDetailSection?.content?.productDetail?.selprodTitle ??
                "";
            productPrice.value =
                productDetailSection?.content?.productDetail?.selprodPrice ??
                "";
            productDescription.value =
                productDetailSection
                    ?.content
                    ?.productDetail
                    ?.productDescription ??
                "";
            debugPrint("imageURL before");
            final images = productImagesSection?.content?.productImagesArr;

            imageURL.value = (images != null && images.isNotEmpty)
                ? images.first.productImageUrl ?? ""
                : "";
            "";
            debugPrint(
              "------------------------${imageURL.value}--------------------",
            );

            debugPrint(
              "selected product box content ids $selectedSelProdIdForBoxContent",
            );
            if (selProductId.isNotEmpty) {
              AppAnalyticsService.viewItem(
                productId: selProductId,
                name: productTitle.value,
                currency:
                    PrefStore().loadString(AppConstants.currencySymbol) ?? '\$',
                value:
                    double.tryParse(
                      productDetailSection
                              ?.content
                              ?.productDetail
                              ?.selprodPrice ??
                          '0',
                    ) ??
                    0,
              );
            }
            firstPageLoaded = true;
            isLoading(false);
          }
          debugPrint(
            "🟢 Product detail updated with ${productSections.length} sections",
          );
        },
      );
    } catch (e, s) {
      debugPrint("❌ Error loading product detail: $e");
      debugPrint("$s");
      isLoading(false);
    } finally {
      isLoading(false);
      _isRequesting = false;
    }
  }

  void prepareSelectedVariants(List<BoxContent> items) {
    selectedSelProdIdForBoxContent ??= [];

    for (var entry in items.asMap().entries) {
      final index = entry.key;
      final item = entry.value;

      final availableItems = item.availableVariants ?? [];
      final currentOptions = item.currentOptionValues ?? [];

      String? selectedSelprodId;

      // 🟢 CASE 1: only one variant → auto select
      if (availableItems.length == 1) {
        final singleVariant = availableItems.first;

        if (singleVariant.optionValues.isNotEmpty) {
          // normal variant with option
          final selectedOption = singleVariant.optionValues.first;
          item.currentOptionValues = [selectedOption];
          item.currentOptionValues!.first.inStock = singleVariant.inStock;
          selectedSelprodId = selectedOption.selprodoptionSelprodId;
        } else {
          // ✅ fallback (like Serena bag case)
          selectedSelprodId = singleVariant.selprodId;
        }
      }
      // 🟡 CASE 2: multiple variants → match selected option
      else if (currentOptions.isNotEmpty) {
        for (var innerItem in availableItems) {
          if (innerItem.optionValues.isEmpty) continue;

          if (currentOptions.first.optionvalueId ==
              innerItem.optionValues.first.optionvalueId) {
            currentOptions.first.inStock = innerItem.inStock;
            selectedSelprodId = currentOptions.first.selprodoptionSelprodId;
            break;
          }
        }
      }

      // 🧾 SAVE RESULT
      if (selectedSelprodId != null) {
        if (index < selectedSelProdIdForBoxContent!.length) {
          selectedSelProdIdForBoxContent![index] = selectedSelprodId;
        } else {
          selectedSelProdIdForBoxContent!.add(selectedSelprodId);
        }
      }
    }
  }

  Future<String?> addRemoveToWishlist(
    String productId,
    String wishlistId,
    String isInAnyWishlist,
  ) async {
    try {
      final response = await _wishListRepository.addRemoveToWishList(
        productId,
        wishlistId,
        isInAnyWishlist,
      );
      if (response != null) {
        print("✅ item add/remove to wishlist");
        return isInAnyWishlist;
      }
    } catch (e) {
      print("❌ add/remove wishlist error: $e");
    }
    return null;
  }

  Future<String?> reportProduct(
    String selprodName,
    String spreportTitle,
    String spreportComments,
    String spreportSelprodId,
  ) async {
    try {
      final response = await _repository.reportProduct(
        selprodName,
        spreportTitle,
        spreportComments,
        spreportSelprodId,
      );
      if (response != null) {
        print("✅ product reported");
      }
    } catch (e) {
      print("❌ product reporting error: $e");
    }
    return null;
  }

  Future<void> updateProductOption(String productCatId) async {
    if (_isRequesting) return;
    debugPrint("🔁 Updating product option: $productCatId");

    productId = productCatId;
    // You can modify `productId` or pass query params if your API supports variant fetching
    await loadProductDetail();
  }

  Future<void> reloadProductDetail() async {
    // productSections.clear();
    await loadProductDetail();
  }

  void goToAskAQuestionView(
    String shopId,
    String shopName,
    String productId,
    String productName,
  ) => Get.toNamed(
    AppRoutes.askAQuestionView,
    arguments: {
      "shopId": shopId,
      "shopName": shopName,
      "productId": productId,
      "productName": productName,
    },
  );

  void goToShopDetailView(String shopId, String shopUserId) => Get.toNamed(
    AppRoutes.shopDetailView,
    arguments: {"shopId": shopId, "shopUserId": shopUserId},
  );

  void goToSearchView() => Get.toNamed(AppRoutes.searchView);

  void goToMainCartPage() => Get.toNamed(AppRoutes.cartPage);

  void loadOtherProduct(String newProductId, String newProductName) {
    productId = newProductId;
    productName.value = newProductName;
    debugPrint(productId);
    debugPrint(productName.value);
    reloadProductDetail();
  }

  @override
  void onClose() {
    debugPrint("ProductDetailController disposed");
    super.onClose();
  }
}
