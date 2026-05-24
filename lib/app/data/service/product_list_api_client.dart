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

  Future<Response> addRemoveToWishList(String productId,String wishListId,String isInAnyWishlist) async {
    final url = "${AppConstants.addToWishlist}/$productId/$wishListId/$isInAnyWishlist";
    return await _api.dio.get(
      url,
      options: Options(
        // ✅ Prevent Dio from throwing for non-200 codes
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );
  }

}
