import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';
class OrderSuccessApiClient {
  final ApiService _api = ApiService();

  Future<Response> fetchOrderSuccessData({required String orderId}) async {
    final finalURL = "${AppConstants.viewOrder}/$orderId";
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

  //get temp token
  Future<Response> getTempToken() async {
    return await _api.dio.get(
      AppConstants.getTempToken,
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }
}