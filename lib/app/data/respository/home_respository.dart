import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:tajer/app/modules/home/change_location_view/country_model.dart';
import 'package:tajer/app/modules/product_detail/product_detail_model.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../common/widgets/app_dialog.dart';
import '../../core/constants/app_constants.dart';
import '../../modules/home/home_model.dart';
import '../../modules/product_detail/add_to_cart_model/add_to_cart_model.dart';
import '../../modules/wish_list/wish_list_model.dart';
import '../service/home_api_client.dart';

class HomeRepository {
  final HomeApiClient _apiClient = HomeApiClient();
  RxInt cartCount = 0.obs;
  String currencyCode = "";
  bool cancelPagination = false;
  var isFirstTimeBannerImage = "1";
  var firstTimeBannerImageURL = "";
  var bannerRedirectURL = "";
  var promoBannerText = "";
  var promoBannerEnabled = "0";

  void resetPagination() {
    cancelPagination = true;
    Future.delayed(const Duration(milliseconds: 200), () {
      cancelPagination = false;
    });
  }

  Future<List<Collection>> fetchHomePage(int page) async {
    debugPrint("📡 Fetching Home Page $page...");

    final response = await _apiClient.getHomeData(page: page);
    final homeModel = setupHomeModelFromJson(response.data);
    currencyCode = homeModel.data?.currencySymbol ?? "\$";
    firstTimeBannerImageURL = homeModel.data?.home_promotion_popup_image_url ?? "";
    isFirstTimeBannerImage = homeModel.data?.home_promotion_popup_available ?? "1";
    bannerRedirectURL = homeModel.data?.home_promotion_popup_redirect_url ?? "1";
    promoBannerEnabled = homeModel.data?.promo_banner_enabled ?? "0";
    promoBannerText = homeModel.data?.promo_banner_text ?? "";
    cartItemCounts.value = homeModel.data?.cartItemsCount ?? "0";

    PrefStore().saveString(AppConstants.promoBannerText, promoBannerText);
    PrefStore().saveString(AppConstants.promoBannerEnabled, promoBannerEnabled);
    return homeModel.data?.collections ?? [];
  }

  /// Fetch one page of product detail
  Future<ProductDetailModel?> fetchProductDetail(String productId) async {
    try {
      final response = await _apiClient.getProductDetailData(
        productId: productId,
      );

      if (response.statusCode == 200) {
        final model = ProductDetailModel.fromJson(response.data);
        return model;
      } else {
        debugPrint("⚠️ Failed to load product detail: ${response.statusCode}");
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

  //add to cart
  Future<AddToCartModel?> addToCart(String productId, String quantity,{List<String>? selProdIdsForBoxContent}) async {
    try {
      final response = await _apiClient.addToCart(
        productId: productId,
        quantity: quantity,
        selProdIdsForBoxContent: selProdIdsForBoxContent
      );

      if (response.statusCode == 200) {
        dynamic data = response.data;

        // CASE 1 → API returned plain string
        if (data is String) {
          data = jsonDecode(data);
        }

        // CASE 2 → Must be valid JSON map
        if (data is Map<String, dynamic>) {
          final model = AddToCartModel.fromJson(data);

          if (model.status == "1") {
            //cart item count
            cartItemCounts.value = model.data?.cartItemsCount ?? "";
            debugPrint("✅ Item added successfully");
          } else {
            debugPrint("⚠️ ${model.msg ?? 'Something went wrong'}");
          }

          return model; // success or failure -> return model anyway
        } else {
          debugPrint("❌ Invalid JSON structure");
          return null;
        }
      } else {
        debugPrint("⚠️ add to cart failed: ${response.statusCode}");
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

  /// get countries by search
  Future<CountryModel?> getCountriesBySearch(String keyword) async {
    try {
      final response = await _apiClient.getCountries(keyword: keyword);

      if (response.statusCode == 200) {
        dynamic data = response.data;

        // CASE 1 → API returned String instead of JSON
        if (data is String) {
          data = jsonDecode(data);
        }

        // CASE 2 → Expected JSON list inside "results"
        if (data is Map<String, dynamic>) {
          return CountryModel.fromJson(data);
        } else {
          debugPrint("❌ Invalid JSON structure");
          return null;
        }
      } else {
        debugPrint("⚠️ API failed: ${response.statusCode}");
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

  /// set country
  Future<CountrySelectModel?> setCountry(
    String countryId,
    String? countryName,
  ) async {
    try {
      final response = await _apiClient.setCountry(countryId: countryId);

      if (response.statusCode == 200) {
        final countryCode = response.headers.value("X-IP-COUNTRY-CODE");
        await PrefStore().saveString(
          AppConstants.countryCode,
          countryCode ?? "QA",
        );
        final countryId = response.headers.value("X-IP-COUNTRY-ID");

        debugPrint("selected countryId :- $countryId");
        debugPrint("selected countryCode :- $countryCode");
        await PrefStore().saveString(
          AppConstants.countryId,
          countryId ?? "173",
        );
        await PrefStore().saveString(
          AppConstants.countryName,
          countryName ?? "Qatar",
        );

        String countryIdSaved =
            PrefStore().loadString(AppConstants.countryId) ?? "";
        String countryCodeSaved =
            PrefStore().loadString(AppConstants.countryCode) ?? "";

        debugPrint("saved selected country data");
        debugPrint(countryIdSaved);
        debugPrint(countryCodeSaved);

        dynamic data = response.data;

        // CASE 1 → API returned String instead of JSON
        if (data is String) {
          data = jsonDecode(data);
        }

        // CASE 2 → Expected JSON list inside "results"
        if (data is Map<String, dynamic>) {
          return CountrySelectModel.fromJson(data);
        } else {
          debugPrint("❌ Invalid JSON structure");
          return null;
        }
      } else {
        debugPrint("⚠️ API failed: ${response.statusCode}");
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
