
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tajer/app/data/service/wish_list_api_client.dart';
import 'package:tajer/app/modules/wish_list/wish_list_model.dart';

class WishListRepository {
  final WishListApiClient _apiClient = WishListApiClient();

  /// ✅ Fetch wish list data
  Future<WishListSearchModel?> fetchWishListData() async {
    try {
      final response = await _apiClient.getWishListData();

      if (response.statusCode == 200 && response.data != null) {
        final data = WishListSearchModel.fromJson(response.data);
        debugPrint("🟢 Wishlist fetched successfully");
        return data;
      } else if (response.statusCode == 404) {
        debugPrint("⚠️ Wishlist not found (404) — returning empty model");
        return WishListSearchModel(data: null); // ✅ safe empty response
      } else {
        debugPrint("⚠️ Unexpected status: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      debugPrint("❌ Dio Error in wishlist: ${e.message}");
      return null;
    } catch (e, s) {
      debugPrint("❌ Unknown error in wishlist: $e");
      debugPrint("$s");
      rethrow;
    }
  }

  /// ✅ Fetch wish list item data
  Future<WishListItemModel?> fetchWishListItemData(String listId) async {
    try {
      final response = await _apiClient.getWishListItemData(listId);

      if (response.statusCode == 200 && response.data != null) {
        final data = WishListItemModel.fromJson(response.data);
        debugPrint("🟢 Wishlist item fetched successfully");
        return data;
      } else if (response.statusCode == 404) {
        debugPrint("⚠️ Wishlist item not found (404) — returning empty model");
        return WishListItemModel(data: null); // ✅ safe empty response
      } else {
        debugPrint("⚠️ Unexpected status: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      debugPrint("❌ Dio Error in wishlist item: ${e.message}");
      return null;
    } catch (e, s) {
      debugPrint("❌ Unknown error in wishlist item: $e");
      debugPrint("$s");
      rethrow;
    }
  }
 /// ✅ create wish list
  Future<CommonResponseModel?> createWishList(String listName) async {
    try {
      final response = await _apiClient.createWishList(listName);

      if (response.statusCode == 200 && response.data != null) {
        final data = CommonResponseModel.fromJson(response.data);
        debugPrint("🟢 wishlist created successfully");
        return data;
      } else if (response.statusCode == 404) {
        return CommonResponseModel(data: null); // ✅ safe empty response
      } else {
        debugPrint("⚠️ Unexpected status: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      debugPrint("❌ Dio Error in CreateWishListModel: ${e.message}");
      return null;
    } catch (e, s) {
      debugPrint("❌ Unknown error in CreateWishListModel: $e");
      debugPrint("$s");
      rethrow;
    }
  }
/// ✅ delete wish list
  Future<CommonResponseModel?> deleteWishList(String listId) async {
    try {
      final response = await _apiClient.deleteWishList(listId);

      if (response.statusCode == 200 && response.data != null) {
        final data = CommonResponseModel.fromJson(response.data);
        debugPrint("🟢 wishlist deleted successfully");
        return data;
      } else if (response.statusCode == 404) {
        return CommonResponseModel(data: null); // ✅ safe empty response
      } else {
        debugPrint("⚠️ Unexpected status: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      debugPrint("❌ Dio Error in CreateWishListModel: ${e.message}");
      return null;
    } catch (e, s) {
      debugPrint("❌ Unknown error in CreateWishListModel: $e");
      debugPrint("$s");
      rethrow;
    }
  }

/// ✅ add to wish list
  Future<CommonResponseModel?> addRemoveToWishList(String productId,String wishlistId,String isInAnyWishlist) async {
    try {
      final response = await _apiClient.addRemoveToWishList(productId,wishlistId,isInAnyWishlist);

      if (response.statusCode == 200 && response.data != null) {
        final data = CommonResponseModel.fromJson(response.data);
        debugPrint("🟢 item added to wishlist successfully");
        return data;
      } else if (response.statusCode == 404) {
        return CommonResponseModel(data: null); // ✅ safe empty response
      } else {
        debugPrint("⚠️ Unexpected status: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e) {
      debugPrint("❌ Dio Error in CreateWishListModel: ${e.message}");
      return null;
    } catch (e, s) {
      debugPrint("❌ Unknown error in CreateWishListModel: $e");
      debugPrint("$s");
      rethrow;
    }
  }
}