import 'package:flutter/foundation.dart';
import 'package:tajer/app/data/service/product_list_api_client.dart';
import 'package:tajer/app/modules/home/home_model.dart';
import 'package:tajer/app/modules/productList/models/filtered_product.dart';
import '../../modules/product_detail/product_detail_model.dart';

class ProductListRepository {
  final ProductListApiClient _apiClient = ProductListApiClient();

  /// Fetch one page of products using dynamic params
  Future<FilteredProduct?> fetchProductListData(
      Map<String, dynamic> params) async {
    try {
      final response = await _apiClient.getProductListData(params: params);

      if (response.statusCode == 200) {
        return FilteredProduct.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to load product list: ${response.statusCode}");
        return null;
      }
    } catch (e, s) {
      debugPrint("❌ Error in repository with params $params: $e");
      debugPrint("$s");
      return null;
    }
  }

  /// Fetch paginated products lazily (page by page)
  Future<Data?> fetchPaginatedProducts(Map<String, dynamic> params) async {
    final model = await fetchProductListData(params);
    final Data? productData = model?.data ;
    // debugPrint("📄 Page ${params['page']} loaded with $productData ");
    return productData;
  }
}