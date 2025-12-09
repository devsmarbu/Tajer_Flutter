

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/respository/wish_list_repository.dart';
import 'package:tajer/app/modules/home/home_model.dart';
import 'package:tajer/app/modules/wish_list/wish_list_model.dart';

import '../../../core/routes/app_routes.dart';

class WishListItemController extends GetxController {

  final _repository = WishListRepository();
  var isLoading = true.obs;
  var products = <HomeProduct>[].obs;
  var listId = "";
  var wishlistTitle = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    final params = Get.parameters;
    debugPrint("Received Params: $params");
    if (params.isNotEmpty) {
      if (params['listId'] != null) {
        listId = params['listId']!;
        fetchWishListItems();
      }
      if (params['wishlistTitle'] != null) {
        wishlistTitle = params['wishlistTitle']!;
      }
    }
  }

  void goToProductDetailView(String productId, String productName) {
    Get.toNamed(
      AppRoutes.productDetail,
      arguments: {'productId': productId,'productName': productName},
    );
  }

  Future<void> fetchWishListItems() async {
    try {
      isLoading(true);
      products.clear(); // ✅ Clear previous products before API call
      final response = await _repository.fetchWishListItemData(listId);
      if (response != null) {
        products.assignAll(response.data?.products ?? []);
      }
    } catch (e) {
      print("❌ fetch wishlist items error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addRemoveToWishlist(String productId, String wishlistId, String isInAnyWishlist) async {
    try {
      final response = await _repository.addRemoveToWishList(productId,wishlistId,isInAnyWishlist);
      if (response != null) {
        print("✅ item add/remove to wishlist");
        fetchWishListItems();
      }
    } catch (e) {
      print("❌ add/remove wishlist error: $e");
    }
    return null;
  }

}