import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/brand_api_client.dart';
import 'package:tajer/app/data/service/category_api_client.dart';
import 'package:tajer/app/data/service/product_list_api_client.dart';
import 'package:tajer/app/modules/categories/brands_list/models/brand.dart';
import 'package:tajer/app/modules/categories/models/category.dart';
import 'package:tajer/app/modules/home/home_model.dart';
import 'package:tajer/app/modules/productList/models/filtered_product.dart';
import 'package:tajer/app/modules/product_detail/shop_detail_view/shop_model.dart';
import '../../../common/widgets/app_dialog.dart';
import '../../core/constants/app_constants.dart';
import '../../modules/product_detail/product_detail_model.dart';

class BrandRepository {
  final BrandApiClient _apiClient = BrandApiClient();

  /// Fetch Brand model
  Future<BrandModel?> fetchBrandListData() async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.getBrandListData();

      if (response.statusCode == 200) {
        return BrandModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to load brands list: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION");
        

        return null;
      }
      else {
        debugPrint("❌ Error in repository: $e");
        debugPrint("$s");
        return null;
      }
    }
  }

  /// Fetch Our Fav Brand model
  Future<BrandModel?> fetchOurFavBrandListData(String collectionId) async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.getOurFavBrandListData(collectionId);

      if (response.statusCode == 200) {
        return BrandModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to load brands list: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION");
        return null;
      }
      else {
        debugPrint("❌ Error in repository: $e");
        debugPrint("$s");
        return null;
      }
    }
  }

  /// Fetch Shop model
  Future<ShopModel?> fetchShopListData(String page) async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.getShopListData(page);

      if (response.statusCode == 200) {
        return ShopModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to load brands list: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION");
        return null;
      }
      else {
        debugPrint("❌ Error in repository: $e");
        debugPrint("$s");
        return null;
      }
    }
  }

  /// Fetch Shop model
  Future<ShopModel?> fetchOurShopListData(String collectionId) async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.getOurShopListData(collectionId);

      if (response.statusCode == 200) {
        return ShopModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to load brands list: ${response.statusCode}");
        return null;
      }
    } on DioException catch (e, s) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION");
        return null;
      }
      else {
        debugPrint("❌ Error in repository: $e");
        debugPrint("$s");
        return null;
      }
    }
  }
}