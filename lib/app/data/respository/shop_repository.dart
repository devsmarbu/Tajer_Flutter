import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/shop_api_client.dart';
import 'package:tajer/app/modules/product_detail/shop_detail_view/shop_model.dart';
import 'package:tajer/app/modules/wish_list/wish_list_model.dart';

import '../../../common/widgets/app_dialog.dart';
import '../../core/constants/app_constants.dart';
import '../../modules/home/home_model.dart';
import '../../modules/productList/models/filtered_product.dart';
import '../../modules/product_detail/shop_detail_view/reviews_view/shop_review_model.dart';

class ShopRepository {
  final ShopApiClient _apiClient = ShopApiClient();

  /// ✅ Fetch shop details by ID
  Future<ShopDetailModel?> fetchShopDetail(String shopId) async {
    try {
      final response = await _apiClient.getShopData(shopId);

      if (response.statusCode == 200 && response.data != null) {
        final data = ShopDetailModel.fromJson(response.data);
        debugPrint("🟢 Shop detail fetched successfully for ID: $shopId");
        return data;
      } else {
        debugPrint("⚠️ Unexpected response for shopId: $shopId");
        return null;
      }
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION".tr);
        return null;
      }
      else {
        debugPrint("❌ Error in repository: $e");
        debugPrint("$s");
        return null;
      }
    } catch (e, s) {
      debugPrint("❌ Unknown error in fetchShopDetail: $e");
      debugPrint("$s");
      rethrow;
    }
  }

  /// Fetch one page of products using dynamic params
  Future<FilteredProduct?> fetchProductListData(
      Map<String, dynamic> params) async {
    try {
      final response = await _apiClient.getProductListData(params: params);

      if (response.statusCode == 200) {
        return FilteredProduct.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to load product list: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION".tr);
        return null;
      }
      else {
        debugPrint("❌ Error in repository: $e");
        debugPrint("$s");
        return null;
      }
    }
  }

  /// Fetch product reviews using dynamic params
  Future<ShopReviewModel?> fetchShopReviews(
      Map<String, dynamic> params) async {
    try {
      final response = await _apiClient.getShopReview(params: params);

      if (response.statusCode == 200) {
        return ShopReviewModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to load shop review list: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION".tr);
        return null;
      }
      else {
        debugPrint("❌ Error in repository: $e");
        debugPrint("$s");
        return null;
      }
    }
  }

  /// api call for marking review helpful or not
  Future<MarkHelpfulModel?> markReviewHelpful(
      Map<String, dynamic> params) async {
    try {
      final response = await _apiClient.markHelpful(params: params);

      if (response.statusCode == 200) {
        return MarkHelpfulModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to load shop review list: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION".tr);
        return null;
      }
      else {
        debugPrint("❌ Error in repository: $e");
        debugPrint("$s");
        return null;
      }
    }
  }

  /// api call for sending message to the shop
  Future<CommonResponseModel?> sendMessageToShop(
      Map<String, dynamic> params) async {
    try {
      final response = await _apiClient.sendMessageToShop(params: params);

      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to send message to  shop: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION".tr);
        return null;
      }
      else {
        debugPrint("❌ Error in repository: $e");
        debugPrint("$s");
        return null;
      }
    }
  }


  /// Fetch paginated products lazily (page by page)
  Future<List<HomeProduct>> fetchPaginatedProducts(Map<String, dynamic> params) async {
    final model = await fetchProductListData(params);
    final List<HomeProduct> products = model?.data?.products ?? [];
    debugPrint("📄 Page ${params['page']} loaded with ${products.length} items");
    return products;
  }

}