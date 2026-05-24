import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/Cart/order_success_page/order_success_model.dart';
import 'package:tajer/app/modules/orders/myOrders/models/order_list_response.dart';
import 'package:tajer/app/modules/wish_list/wish_list_model.dart';
import '../../../common/widgets/app_dialog.dart';
import '../../core/constants/app_constants.dart';
import '../service/order_success_api_client.dart';

class OrderSuccessRepository {
  final OrderSuccessApiClient _apiClient = OrderSuccessApiClient();

  /// Fetch Order Success model
  Future<OrderDetailModel?> fetchOrderSuccess({required String orderId}) async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.fetchOrderSuccessData(orderId: orderId);

      if (response.statusCode == 200) {
        return OrderDetailModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to order success data: ${response.statusCode}");
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

  /// get temp token
  Future<CommonResponseModel?> getTempToken() async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.getTempToken();

      if (response.statusCode == 200) {
        return CommonResponseModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to load temp token data: ${response.statusCode}");
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
}