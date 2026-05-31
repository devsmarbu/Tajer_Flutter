import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:tajer/app/data/respository/shop_repository.dart';
import 'package:tajer/app/modules/product_detail/shop_detail_view/reviews_view/shop_review_model.dart';
import 'package:tajer/app/modules/product_detail/shop_detail_view/shop_model.dart';
import '../../home/home_model.dart';

class ShopDetailController extends GetxController {
  final ShopRepository _repository = ShopRepository();

  var page = 1;
  final isLoading = false.obs;
  final Rxn<ShopDetailModel> shopDetail = Rxn<ShopDetailModel>();
  var products = <HomeProduct>[].obs;
  var reviews = <ReviewsList>[].obs;
  var pageCount = 1;
  var hasMore = true.obs;

  String shopId = "";
  String shopUserId = "";
  String productName = "";
  String selProdId = "";
  Map<String, dynamic> baseParams = {};

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['shopId'] != null) {
      shopId = args['shopId'].toString();
      shopUserId = args['shopUserId'].toString();
      selProdId = args['productId'].toString();
      productName = args['productName'].toString();
      baseParams = {"shop_id": shopId, "page": 1};
      _loadAllData();
    } else {
      debugPrint("⚠️ No shopId found in arguments");
    }
  }

  @override
  void onClose() {
    debugPrint("ShopDetailController disposed");
    super.onClose();
  }

  Future<void> _loadAllData() async {
    await Future.wait([
      loadShopDetail(),
    ]);
  }

  Future<void> loadShopDetail() async {
    try {
      isLoading(true);
      final response = await _repository.fetchShopDetail(shopId);
      if (response != null) shopDetail.value = response;
      shopUserId = shopDetail.value?.data?.shop?.shopUserId ?? "";
      getShopProducts();
      getShopReviews();
    } catch (e) {
      debugPrint("❌ loadShopDetail error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> loadMoreProducts() async {
    if (isLoading.value || !hasMore.value) return;

    try {
      isLoading(true);

      page++;

      final response = await _repository.fetchProductListData({
        "shop_id": shopId,
        "page": page,
      });

      final data = response?.data;

      products.addAll(data?.products ?? []);

      pageCount = int.tryParse(data?.pageCount ?? "1") ?? 1;

      hasMore.value = page < pageCount;

    } catch (e) {
      debugPrint("❌ loadMoreProducts error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> getShopProducts() async {
    try {
      isLoading(true);

      page = 1;
      hasMore(true);

      final response = await _repository.fetchProductListData({
        "shop_id": shopId,
        "page": page,
      });

      final data = response?.data;

      products.assignAll(data?.products ?? []);
      pageCount = int.tryParse(data?.pageCount ?? "1") ?? 1;

      hasMore.value = page < pageCount;

    } catch (e) {
      debugPrint("❌ getShopProducts error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> getShopReviews() async {
    try {
      final response = await _repository.fetchShopReviews({
        "page": 1,
        "pageSize": 20,
        "shop_user_id": shopUserId,
        "shop_id": shopId,
      });
      reviews.assignAll(response?.data?.reviewsList ?? []);
      reviews.refresh();
    } catch (e) {
      debugPrint("❌ getShopReviews error: $e");
    }
  }

  Future<void> markReviewHelpful({
    required String isHelpful,
    required String reviewId,
  }) async {
    try {
      await _repository.markReviewHelpful({
        "isHelpful": isHelpful,
        "reviewId": reviewId,
      });
      await getShopReviews();
    } catch (e) {
      debugPrint("❌ markReviewHelpful error: $e");
    }
  }

  Future<void> sendMessageToShop({
    required String threadSubject,
    required String messageText,
    required String shopId,
  }) async {
    try {
      isLoading(true);
      final response = await _repository.sendMessageToShop({
        "thread_subject": threadSubject,
        "message_text": messageText,
        "shop_id": shopId,
        "product_id": selProdId
      });
      Get.back();
      Get.snackbar("",response?.msg ?? "",backgroundColor: Colors.green, colorText: Colors.white);

    } catch (e) {
      debugPrint("❌ send message to shop error: $e");
    }
    finally {
      isLoading(false);
    }
  }

  void updateFav(
      String isInAnyWishlist,
      String productIndex,
      ) {
    // 🔁 toggle value
    String newValue = isInAnyWishlist == '0' ? '0' : '1';
    int pIndex = int.parse(productIndex);

    // ✅ update inside posts
    products[pIndex] = products[pIndex]
        .copyWith(is_in_any_wishlist: newValue);

    products.refresh(); // 🔥 important for UI update
  }
}

