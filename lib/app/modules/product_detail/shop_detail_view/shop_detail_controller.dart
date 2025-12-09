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
  var hasMore = true.obs;

  String shopId = "";
  String shopUserId = "";
  Map<String, dynamic> baseParams = {};

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments;
    if (args != null && args['shopId'] != null) {
      shopId = args['shopId'].toString();
      shopUserId = args['shopUserId'].toString();
      baseParams = {"shop_id": shopId, "page": 1};
      _loadAllData();
    } else {
      debugPrint("⚠️ No shopId found in arguments");
    }
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

  Future<void> getShopProducts() async {
    try {
      final response = await _repository.fetchProductListData(baseParams);
      products.assignAll(response?.data?.products ?? []);
    } catch (e) {
      debugPrint("❌ getShopProducts error: $e");
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
      });
      Get.snackbar("",response?.msg ?? "",backgroundColor: Colors.green, colorText: Colors.white);

    } catch (e) {
      debugPrint("❌ send message to shop error: $e");
    }
    finally {
      isLoading(false);
    }
  }
}