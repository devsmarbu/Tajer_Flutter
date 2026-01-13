import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

class ProductDetailApiClient {
  final ApiService _api = ApiService();

  Future<Response> getProductDetailData({
    required String productId,
    required int page,
  }) async {
    final url =
        '${AppConstants.productDetail}/$productId'; // ✅ Append ID to path

    return await _api.dio.post(
      url,
      data: FormData.fromMap({
        "page": page, // ✅ send as form-data
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> getSizeChartData({
    required String productId,
  }) async {
    final url =
        '${AppConstants.productSizeGuide}/$productId'; // ✅ Append ID to path

    return await _api.dio.get(
      url,
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<Response> reportForm({
    required String selprod_name,
    required String spreport_title,
    required String spreport_comments,
    required String spreport_selprod_id,
  }) async {
    final url = AppConstants.reportForm; // ✅ Append ID to path

    return await _api.dio.post(
      url,
      data: FormData.fromMap({
        "selprod_name": selprod_name,
        "spreport_title": spreport_title,
        "spreport_comments": spreport_comments,
        "spreport_selprod_id": spreport_selprod_id,
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> getFilters({
    required String keyword,
    required String category,
    required String shop_id,
    required String featured,
    required String top_products,
    required String brand_id,
  }) async {
    final url = AppConstants.getFilters;

    return await _api.dio.post(
      url,
      data: FormData.fromMap({
        "keyword" : keyword,
        "category" : category,
        "shop_id" : shop_id,
        "featured" : featured,
        "top_products" : top_products,
        "brand_id" : brand_id,
        "position" : "1"
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }
}
