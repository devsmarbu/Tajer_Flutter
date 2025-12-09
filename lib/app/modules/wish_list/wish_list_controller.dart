import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/respository/wish_list_repository.dart';
import 'package:tajer/app/modules/home/home_model.dart';
import 'package:tajer/app/modules/wish_list/wish_list_model.dart';

import '../../core/routes/app_routes.dart';

class WishListController extends GetxController {
  final _repository = WishListRepository();
  var isLoading = true.obs;
  var wishList = <WishList>[].obs;
  var products = <HomeProduct>[].obs;
  var listId = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();

    final params = Get.parameters;
    debugPrint("Received Params: $params");

    if (params.isNotEmpty) {
      if (params['listId'] != null) {
        listId = params['listId']!;
      }
    }
    fetchWishLists();
    fetchWishListItems();
  }

  void goToProductDetailView(String productId, String productName) {
    Get.toNamed(
      AppRoutes.productDetail,
      arguments: {'productId': productId, 'productName': productName},
    );
  }

  Future<void> fetchWishLists() async {
    try {
      isLoading(true);
      final response = await _repository.fetchWishListData();
      if (response != null) {
        wishList.assignAll(response.data?.wishLists ?? []);
      }
    } catch (e) {
      print("❌ fetch wishlist error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchWishListItems() async {
    try {
      isLoading(true);
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

  Future<void> createWishlist(String wishlistName) async {
    try {
      isLoading(true);
      final response = await _repository.createWishList(wishlistName);
      if (response != null) {
        fetchWishLists();
      }
    } catch (e) {
      print("❌ create wishlist error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<String?> addRemoveToWishlist(
    String productId,
    String wishlistId,
    String isInAnyWishlist,
  ) async {
    try {
      isLoading(true);
      final response = await _repository.addRemoveToWishList(
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
    } finally {
      isLoading(false);
    }
    return null;
  }

  Future<void> deleteWishlist(String listId) async {
    try {
      isLoading(true);
      final response = await _repository.deleteWishList(listId);
      if (response != null) {
        fetchWishLists();
      }
    } catch (e) {
      print("❌ delete wishlist error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> goToWishListItemView(String listId, String wishlistTitle) async {
    await Get.toNamed(
      AppRoutes.wishListItemsView,
      parameters: {"listId": listId, "wishlistTitle": wishlistTitle},
    );
    fetchWishLists();
  }
}
