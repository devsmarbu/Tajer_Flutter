import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

class ShopApiClient {
  final ApiService _api = ApiService();

  Future<Response> getShopData(String shopId) async {
    final url = "${AppConstants.shopDetail}/$shopId"; // ✅ Append ID to path
    return await _api.dio.post(
      url,
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<Response> getShopReview({required Map<String, dynamic> params}) async {
    final url = AppConstants.shopReviews;
    return await _api.dio.post(
      url,
      data: FormData.fromMap(params),
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<Response> markHelpful({required Map<String, dynamic> params}) async {
    final url = AppConstants.shopMarkHelpful;
    return await _api.dio.post(
      url,
      data: FormData.fromMap(params),
    );
  }

  Future<Response> getProductListData({required Map<String, dynamic> params}) async {
    final url = AppConstants.filteredProducts;
    return await _api.dio.post(
      url,
      data: FormData.fromMap(params),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> sendMessageToShop({required Map<String, dynamic> params}) async {
    final url = AppConstants.shopSendMessage;
    return await _api.dio.post(
      url,
      data: FormData.fromMap(params),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }
}