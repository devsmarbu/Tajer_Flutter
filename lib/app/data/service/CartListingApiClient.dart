import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

class CartListingApiClient {
  final ApiService _api = ApiService();

  Future<Response> getCartListingData({
    required String cartType,
    required String isDeliverAllTogether,
  }) async {
    final finalUrl = "${AppConstants.cartListing}/$cartType";
    return await _api.dio.post(
      finalUrl,
      data: FormData.fromMap({"is_deliver_together": isDeliverAllTogether}),
      options:
      Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> getPaymentSummary({
    required String redeemPoints,
    required String orderId,
    required String fulfilmentType,
    required Map<String, String> shippingMethods,
    required String payFromWallet,
  }) async {
    return await _api.dio.post(
      AppConstants.paymentSummaryWithShippingSelection,
      data: FormData.fromMap({
        "redeem_rewards": redeemPoints,
        "orderId": orderId,
        "fulfilmentType": fulfilmentType,
        "payFromWallet": payFromWallet,
        ...shippingMethods,
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> removeRewardPoints({
    required String orderId,
  }) async {
    return await _api.dio.post(
      AppConstants.removeReward,
      data: FormData.fromMap({
        "orderId": orderId,
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> confirmOrder({
    required String orderId,
    required String orderType,
    required String pluginId,
  }) async {
    return await _api.dio.post(
      AppConstants.confirmOrder,
      data: FormData.fromMap({
        "order_id": orderId,
        "order_type": orderType,
        "plugin_id": pluginId,
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> saveForLaterProduct({
    required String selproductId,
    required String fulfilmentType,
  }) async {
    final finalUrl = "${AppConstants.saveForLater}/$selproductId";
    return await _api.dio.post(
      finalUrl,
      data: FormData.fromMap({"fulfilmentType": fulfilmentType}),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> deleteCartItem({
    required String key,
    required String fulfilmentType
  }) async {
    return await _api.dio.post(
      AppConstants.cartRemove,
      data: FormData.fromMap({"key": key, "fulfilmentType": fulfilmentType}),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> payFromWallet({
    required String orderId,
  }) async {
    final finalURL = "${AppConstants.payFromWallet}/$orderId";
    return await _api.dio.get(
      finalURL,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }


  Future<Response> moveItemToCart({
    required String productId,
    required String quantity,
  }) async {
    return await _api.dio.post(
      AppConstants.addToCart,
      data: FormData.fromMap({"selprod_id": productId, "quantity": quantity}),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> cartUpdate({
    required String key,
    required String quantity,
  }) async {
    return await _api.dio.post(
      AppConstants.cartUpdate,
      data: FormData.fromMap({"key": key, "quantity": quantity}),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> applyCoupon({
    required String couponCode,
    required String fullfilmentType,
  }) async {
    return await _api.dio.post(
      AppConstants.applyCoupon,
      data: FormData.fromMap({"coupon_code": couponCode, "fulfilmentType": fullfilmentType}),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> removeCoupon({
    required String fullfilmentType,
  }) async {
    return await _api.dio.post(
      AppConstants.removeCoupon,
      data: FormData.fromMap({"fulfilmentType": fullfilmentType}),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> removeCardItem({
    required String fullfilmentType,
    required String tokenId,
  }) async {
    return await _api.dio.post(
      AppConstants.deleteCard,
      data: FormData.fromMap({"fulfilmentType": fullfilmentType,"tokenId": tokenId}),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> addRemoveItemSaveFromLater({
    required String fulfilmentType,
    required String selproductId,
    required String wishListId,
    required String rowAcion,
  }) async {
    final finalUrl =
        "${AppConstants.addToWishlist}/$selproductId/$wishListId/$rowAcion";
    return await _api.dio.post(
      finalUrl,
      data: FormData.fromMap({"fulfilmentType": fulfilmentType}),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }
}
