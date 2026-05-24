import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/product_list_api_client.dart';
import 'package:tajer/app/modules/home/home_model.dart';
import 'package:tajer/app/modules/productList/models/filtered_product.dart';
import '../../../common/widgets/app_dialog.dart';
import '../../core/constants/app_constants.dart';
import '../../modules/product_detail/product_detail_model.dart';
import '../../modules/wish_list/wish_list_model.dart';

class ProductListRepository {
  final ProductListApiClient _apiClient = ProductListApiClient();

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

  /// Fetch paginated products lazily (page by page)
  Future<Data?> fetchPaginatedProducts(Map<String, dynamic> params) async {
    final model = await fetchProductListData(params);
    final Data? productData = model?.data ;
    // debugPrint("📄 Page ${params['page']} loaded with $productData ");
    return productData;
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
      debugPrint("❌ Unknown error in CreateWishListModel: $e");
      debugPrint("$s");
      rethrow;
    }
  }
}