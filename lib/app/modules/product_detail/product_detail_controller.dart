import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/data/respository/wish_list_repository.dart';
import 'package:tajer/utils/pref_store.dart';
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
  RxString inStock = "1".obs;
  int page = 1;
  RxString isInAnyWishlist = "0".obs;
  var listId = "";

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
    productSections.clear();

    bool firstPageLoaded = false;

    try {
      await _repository.fetchAllProductPages(
        productId,
        onPageLoaded: (newSections) async {
          productSections.addAll(newSections);

          // ✅ Hide loader after first page loaded
          if (!firstPageLoaded) {
            final productDetailSection = productSections.firstWhereOrNull(
              (d) => d.customType == ProductDetailType.productDetail,
            );
            final productImagesSection = productSections.firstWhereOrNull(
              (d) => d.customType == ProductDetailType.productImages,
            );
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
            imageURL.value =
                productImagesSection
                    ?.content
                    ?.productImagesArr
                    ?.first
                    .productImageUrl ??
                "";
            debugPrint(
              "------------------------${imageURL.value}--------------------",
            );
            if (selProductId.isNotEmpty) {
              final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
              await analytics.logViewItem(
                currency: PrefStore().loadString(AppConstants.currencySymbol),
                value: double.tryParse(productDetailSection
                    ?.content
                    ?.productDetail?.selprodPrice ?? '0') ?? 0,
                items: [
                  AnalyticsEventItem(
                    itemId: selProductId,
                    itemName: productTitle.value,
                    itemCategory: productDetailSection
                        ?.content
                        ?.productDetail?.prodcatName,
                  ),
                ],
              );
              final facebookAppEvents = FacebookAppEvents();

              facebookAppEvents.logEvent(
                name: 'ViewContent',
                parameters: {
                  'content_id': selProductId,
                  'content_name': productTitle.value,
                  'content_type': 'product',
                  'value': double.tryParse(productDetailSection
                      ?.content
                      ?.productDetail?.selprodPrice ?? '0') ?? 0,
                  'currency': PrefStore().loadString(AppConstants.currencySymbol),
                },
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

  void goToAskAQuestionView(String shopId, String shopName) => Get.toNamed(
    AppRoutes.askAQuestionView,
    arguments: {"shopId": shopId, "shopName": shopName},
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
    productSections.close();
    super.onClose();
  }
}
