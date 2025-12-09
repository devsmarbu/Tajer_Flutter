
import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

mixin OrderApiClient {

  final ApiService _api = ApiService();

  Future<Response> getMyOrders(
      String token,
      int page,
      String status,
      String keyword,
      ) async {
    return await _api.dio.post(
      AppConstants.getMyOrderList,
      data: FormData.fromMap({
        '_token': token,
        'page': page,
        'status': status,
        'keyword': keyword,
      }),
    );
  }

  Future<Response> getOrderDetail(
      String orderProductId,
      String orderID,
      ) async {
    return await _api.dio.get(
      "${AppConstants.getOrderDetail}$orderID/$orderProductId",
    );

  }

  Future<Response> orderReceiptApi(
      String orderID,
      ) async {
    return await _api.dio.get(
      "${AppConstants.orderReceipt}$orderID}",
    );

  }

  Future<Response> reOrderProductApi(
      String orderID,
      ) async {
    return await _api.dio.get(
      "${AppConstants.reOrderProduct}$orderID",
    );

  }

}