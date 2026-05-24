import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/CartListingApiClient.dart';
import 'package:tajer/app/data/service/category_api_client.dart';
import 'package:tajer/app/data/service/product_list_api_client.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/apply_coupon_model.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/cart_listing_model/cart_listing_model.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/cart_update_model/cart_update_model.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/confirm_order_model.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/payment_summary_model/payment_summary_model.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/save_for_later_model/save_for_later_model.dart';
import 'package:tajer/app/modules/categories/models/category.dart';
import 'package:tajer/app/modules/home/home_model.dart';
import 'package:tajer/app/modules/productList/models/filtered_product.dart';
import 'package:tajer/app/modules/wish_list/wish_list_model.dart';
import '../../../common/widgets/app_dialog.dart';
import '../../../utils/pref_store.dart';
import '../../core/constants/app_constants.dart';
import '../../modules/product_detail/add_to_cart_model/add_to_cart_model.dart';
import '../../modules/product_detail/product_detail_model.dart';

class CartListingRepository {
  final CartListingApiClient _apiClient = CartListingApiClient();

  /// Fetch CartListing model
  Future<CartListingModel?> getCartListingData({
    required String cartType,
    required String isDeliverAllTogether,
  }) async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.getCartListingData(
        cartType: cartType,
        isDeliverAllTogether: isDeliverAllTogether,
      );

      if (response.statusCode == 200) {
        // ✅ Decode if String
        final decoded = response.data is String
            ? json.decode(response.data)
            : response.data;

        // ✅ Case 1: API returns [] (empty list)
        if (decoded is List) {
          debugPrint(
            "⚠️ API returned a List instead of Map — returning empty CartListingModel",
          );
          return CartListingModel(
            status: "0",
            msg: "Empty or invalid cart response",
            data: null,
          );
        }

        // ✅ Case 2: API returns Map (expected)
        if (decoded is Map<String, dynamic>) {
          final decodedResponse = CartListingModel.fromJson(decoded);
          cartItemCounts.value = decodedResponse.data?.cartItemsCount ?? "";
          return decodedResponse;
        }

        debugPrint("⚠️ Unexpected response type: ${decoded.runtimeType}");
        return null;
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

  /// Fetch paymentsummary model
  Future<PaymentSummaryModel?> getPaymentSummary({
    required String orderId,
    required String redeemPoints,
    required String fulfilmentType,
    required Map<String, String> shippingMethods,
    required String payFromWallet,
  }) async {
    try {
      debugPrint("tried to api call");
      debugPrint('before get payment summary api call ${PrefStore().loadString(AppConstants.sessionId)}');
      final response = await _apiClient.getPaymentSummary(
        orderId: orderId,
        redeemPoints: redeemPoints,
        fulfilmentType: fulfilmentType,
        shippingMethods: shippingMethods,
        payFromWallet: payFromWallet,
      );

      if (response.statusCode == 200) {
        debugPrint('after get payment summary api call ${PrefStore().loadString(AppConstants.sessionId)}');
        final decoded = response.data is String
            ? json.decode(response.data)
            : response.data;

        if (decoded is Map<String, dynamic>) {
          return PaymentSummaryModel.fromJson(decoded);
        }

        return PaymentSummaryModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to load payment summary: ${response.statusCode}");
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

  /// remove reward points
  Future<PaymentSummaryModel?> removeRewardPoints({
    required String orderId,
  }) async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.removeRewardPoints(orderId: orderId);

      if (response.statusCode == 200) {
        final decoded = response.data is String
            ? json.decode(response.data)
            : response.data;

        if (decoded is Map<String, dynamic>) {
          return PaymentSummaryModel.fromJson(decoded);
        }

        return PaymentSummaryModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to remove reward: ${response.statusCode}");
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

  /// confirm order
  Future<ConfirmOrderModel?> confirmOrder(
    String orderId,
    String orderType,
    String pluginId,
  ) async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.confirmOrder(
        orderId: orderId,
        orderType: orderType,
        pluginId: pluginId,
      );

      if (response.statusCode == 200) {
        final decoded = response.data is String
            ? json.decode(response.data)
            : response.data;

        
        if (decoded is Map<String, dynamic>) {
          return ConfirmOrderModel.fromJson(decoded);
        }
        final apiResponse = ConfirmOrderModel.fromJson(response.data);

        return apiResponse;
      } else {
        debugPrint("⚠️ Failed to confirm order: ${response.statusCode}");
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

  /// wallet payment
  Future<CommonResponseModel?> payFromWallet(
    String orderId,
  ) async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.payFromWallet(
        orderId: orderId,
      );

      if (response.statusCode == 200) {
        final decoded = response.data is String
            ? json.decode(response.data)
            : response.data;


        if (decoded is Map<String, dynamic>) {
          return CommonResponseModel.fromJson(decoded);
        }
        final apiResponse = CommonResponseModel.fromJson(response.data);

        return apiResponse;
      } else {
        debugPrint("⚠️ Failed to payment from wallet : ${response.statusCode}");
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



  /// Save for later model
  Future<SaveForLaterModel?> saveForLaterProduct({
    required String fulfilmentType,
    required String selproductId,
  }) async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.saveForLaterProduct(
        fulfilmentType: fulfilmentType,
        selproductId: selproductId,
      );

      if (response.statusCode == 200) {
        return SaveForLaterModel.fromJson(response.data);
      } else {
        debugPrint(
          "⚠️ Failed to save for later product: ${response.statusCode}",
        );
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

  /// move from saveforlater to cart model
  Future<AddToCartModel?> moveItemToCart({
    required String selproductId,
    required String quantity,
  }) async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.moveItemToCart(
        productId: selproductId,
        quantity: quantity,
      );

      if (response.statusCode == 200) {
        final model = AddToCartModel.fromJson(response.data);
        // ✅ check status from API response
        if (model.status == "1") {
          //cart item count
          cartItemCounts.value = model.data?.cartItemsCount ?? "";
          debugPrint("✅ Item moved successfully");
          return model;
        } else {
          debugPrint("-----------in this block-----------");
          debugPrint("⚠️ ${model.msg ?? 'Something went wrong'}");
          return model; // return model even if error to show message
        }
      } else {
        debugPrint("⚠️ Failed to add product to cart: ${response.statusCode}");
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

  /// update cart quantity model
  Future<CartUpdateModel?> updateCartQuantity({
    required String key,
    required String quantity,
  }) async {
    try {
      debugPrint("📦 updating cart quantity...");

      final response = await _apiClient.cartUpdate(
        key: key,
        quantity: quantity,
      );

      debugPrint("📥 API RESPONSE: ${response.data}");

      // ✅ API returned valid JSON but might contain only msg + status
      if (response.statusCode == 200) {
        final json = response.data;

        // ✅ even if "data" is missing, CartUpdateModel will handle it safely
        return CartUpdateModel.fromJson(json);
      }

      // ⚠️ Non-200 response
      debugPrint("⚠️ Failed: HTTP ${response.statusCode}");
      return CartUpdateModel(status: "0", msg: "Something went wrong");
    }
    on DioException catch (e, stack) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION".tr);
        return CartUpdateModel(status: "0", msg: e.toString());
      }
      else {
        debugPrint("❌ Exception in updateCartQuantity: $e");
        debugPrint("$stack");

        // ✅ Return model with error msg so UI can show toast/snackbar
        return CartUpdateModel(status: "0", msg: e.toString());
      }
    }
  }

  /// delete cart item model
  Future<CartUpdateModel?> deleteCartItem({
    required String key,
    required String fulfilmentType,
  }) async {
    try {
      debugPrint("📦 deleting cart item...");

      final response = await _apiClient.deleteCartItem(
        key: key,
        fulfilmentType: fulfilmentType,
      );

      debugPrint("📥 API RESPONSE: ${response.data}");

      // ✅ API returned valid JSON but might contain only msg + status
      if (response.statusCode == 200) {
        final json = response.data;

        // ✅ even if "data" is missing, CartUpdateModel will handle it safely
        return CartUpdateModel.fromJson(json);
      }

      // ⚠️ Non-200 response
      debugPrint("⚠️ Failed: HTTP ${response.statusCode}");
      return CartUpdateModel(status: "0", msg: "Something went wrong");
    } on DioException catch (e, stack) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION".tr);
        return CartUpdateModel(status: "0", msg: e.toString());
      }
      else {
        debugPrint("❌ Exception in updateCartQuantity: $e");
        debugPrint("$stack");

        // ✅ Return model with error msg so UI can show toast/snackbar
        return CartUpdateModel(status: "0", msg: e.toString());
      }
    }
  }

  /// apply coupon
  Future<ApplyCouponModel?> applyCouponCode({
    required String couponCode,
    required String fulfilmentType,
  }) async {
    try {
      debugPrint("📦 applying coupon to cart items...");

      final response = await _apiClient.applyCoupon(
        couponCode: couponCode,
        fullfilmentType: fulfilmentType,
      );

      debugPrint("📥 API RESPONSE: ${response.data}");

      // ✅ API returned valid JSON but might contain only msg + status
      if (response.statusCode == 200) {
        // ✅ Decode if String
        final decoded = response.data is String
            ? json.decode(response.data)
            : response.data;

        // ✅ Case 1: API returns [] (empty list)
        if (decoded is List) {
          debugPrint(
            "⚠️ API returned a List instead of Map — returning empty ",
          );
          return ApplyCouponModel(
            status: "0",
            msg: "Empty or invalid cart response",
            data: null,
          );
        }

        // ✅ Case 2: API returns Map (expected)
        if (decoded is Map<String, dynamic>) {
          return ApplyCouponModel.fromJson(decoded);
        }

        debugPrint("⚠️ Unexpected response type: ${decoded.runtimeType}");
        return null;
      }
      // ⚠️ Non-200 response
      debugPrint("⚠️ Failed: HTTP ${response.statusCode}");
      return ApplyCouponModel(status: "0", msg: "Something went wrong");
    }
    on DioException catch (e, stack) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION".tr);
        return ApplyCouponModel(status: "0", msg: e.toString());
      }
      else {
        debugPrint("❌ Exception in applying coupon to cart items: $e");
        debugPrint("$stack");
        // ✅ Return model with error msg so UI can show toast/snackbar
        return ApplyCouponModel(status: "0", msg: e.toString());
      }
    }
  }

  /// remove coupon
  Future<ApplyCouponModel?> removeCoupon({
    required String fulfilmentType,
  }) async {
    try {
      debugPrint("📦 removing coupon to cart items...");

      final response = await _apiClient.removeCoupon(
        fullfilmentType: fulfilmentType,
      );

      debugPrint("📥 API RESPONSE: ${response.data}");

      // ✅ API returned valid JSON but might contain only msg + status
      if (response.statusCode == 200) {
        // ✅ Decode if String
        final decoded = response.data is String
            ? json.decode(response.data)
            : response.data;

        // ✅ Case 1: API returns [] (empty list)
        if (decoded is List) {
          debugPrint(
            "⚠️ API returned a List instead of Map — returning empty ",
          );
          return ApplyCouponModel(
            status: "0",
            msg: "Empty or invalid cart response",
            data: null,
          );
        }

        // ✅ Case 2: API returns Map (expected)
        if (decoded is Map<String, dynamic>) {
          return ApplyCouponModel.fromJson(decoded);
        }

        debugPrint("⚠️ Unexpected response type: ${decoded.runtimeType}");
        return null;
      }
      // ⚠️ Non-200 response
      debugPrint("⚠️ Failed: HTTP ${response.statusCode}");
      return ApplyCouponModel(status: "0", msg: "Something went wrong");
    }

    on DioException catch (e, stack) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION".tr);
        return ApplyCouponModel(status: "0", msg: e.toString());
      }
      else {
        debugPrint("❌ Exception in removing coupon to cart items: $e");
        debugPrint("$stack");

        // ✅ Return model with error msg so UI can show toast/snackbar
        return ApplyCouponModel(status: "0", msg: e.toString());
      }
    }
  }

  /// remove card item
  Future<CommonResponseModel?> removeCardItem({
    required String fulfilmentType,
    required String tokenId,
  }) async {
    try {
      debugPrint("📦 removing saved card items...");

      final response = await _apiClient.removeCardItem(
        fullfilmentType: fulfilmentType,
        tokenId: tokenId,
      );

      debugPrint("📥 API RESPONSE: ${response.data}");

      if (response.statusCode == 200) {
        final decoded = response.data is String
            ? json.decode(response.data)
            : response.data;

        if (decoded is List) {
          debugPrint("⚠️ API returned List instead of Map");
          return CommonResponseModel(
            status: "0",
            msg: "Empty or invalid response",
          );
        }

        if (decoded is Map<String, dynamic>) {
          /// 🔥 IMPORTANT FIX
          decoded['status'] = decoded['status']?.toString();

          return CommonResponseModel.fromJson(decoded);
        }

        debugPrint("⚠️ Unexpected response type: ${decoded.runtimeType}");
        return null;
      }

      debugPrint("⚠️ Failed: HTTP ${response.statusCode}");
      return CommonResponseModel(status: "0", msg: "Something went wrong");
    } catch (e) {
      debugPrint("❌ removeCardItem error: $e");
      return CommonResponseModel(status: "0", msg: "Exception occurred");
    }
  }

  /// add or delete save for later cart item model
  Future<CartUpdateModel?> addRemoveItemSaveFromLater({
    required String fulfilmentType,
    required String selProductId,
    required String wishListId,
    required String rowAction,
  }) async {
    try {
      debugPrint("📦 removing save for later cart item...");

      final response = await _apiClient.addRemoveItemSaveFromLater(
        fulfilmentType: fulfilmentType,
        selproductId: selProductId,
        wishListId: wishListId,
        rowAcion: rowAction,
      );

      debugPrint("📥 API RESPONSE: ${response.data}");

      // ✅ API returned valid JSON but might contain only msg + status
      if (response.statusCode == 200) {
        final json = response.data;

        // ✅ even if "data" is missing, CartUpdateModel will handle it safely
        return CartUpdateModel.fromJson(json);
      }

      // ⚠️ Non-200 response
      debugPrint("⚠️ Failed: HTTP ${response.statusCode}");
      return CartUpdateModel(status: "0", msg: "Something went wrong");
    }
    on DioException catch (e, stack) {
      if (e.type == DioExceptionType.connectionError) {
        Get.snackbar(AppConstants.appName, "APP_ERROR_INTERNET_CONNECTION".tr);
        return CartUpdateModel(status: "0", msg: e.toString());
      }
      else {
        debugPrint("❌ Exception in removing save for later cart item: $e");
        debugPrint("$stack");
        // ✅ Return model with error msg so UI can show toast/snackbar
        return CartUpdateModel(status: "0", msg: e.toString());
      }
    }
  }
}
