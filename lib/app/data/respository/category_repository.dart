import 'package:flutter/foundation.dart';
import 'package:tajer/app/data/service/category_api_client.dart';
import 'package:tajer/app/data/service/product_list_api_client.dart';
import 'package:tajer/app/modules/categories/models/category.dart';
import 'package:tajer/app/modules/home/home_model.dart';
import 'package:tajer/app/modules/productList/models/filtered_product.dart';
import '../../modules/product_detail/product_detail_model.dart';

class CategoryRepository {
  final CategoryApiClient _apiClient = CategoryApiClient();

  /// Fetch Category model
  Future<CategoryModel?> fetchCategoryListData({required String parentId}) async {
    try {
      debugPrint("tried to api call");
      final response = await _apiClient.getCategoryData(parentId: parentId);

      if (response.statusCode == 200) {
        return CategoryModel.fromJson(response.data);
      } else {
        debugPrint("⚠️ Failed to load product list: ${response.statusCode}");
        return null;
      }
    } catch (e, s) {
      debugPrint("❌ Error in repository with params $parentId: $e");
      debugPrint("$s");
      return null;
    }
  }
}