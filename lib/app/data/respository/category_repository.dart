import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/category_api_client.dart';
import 'package:tajer/app/data/service/product_list_api_client.dart';
import 'package:tajer/app/modules/categories/models/category.dart';
import 'package:tajer/app/modules/home/home_model.dart';
import 'package:tajer/app/modules/productList/models/filtered_product.dart';
import '../../../common/widgets/app_dialog.dart';
import '../../core/constants/app_constants.dart';
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
    return null;
  }
}