import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

class ProductListApiClient {
  final ApiService _api = ApiService();

  Future<Response> getProductListData({
    required Map<String, dynamic> params,
  }) async {
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
}
