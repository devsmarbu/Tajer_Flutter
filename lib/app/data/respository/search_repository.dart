

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tajer/app/data/service/search_api_client.dart';
import 'package:tajer/app/modules/product_detail/search_view/search_model.dart';

class SearchRepository {
  final SearchApiClient _apiClient = SearchApiClient();

  /// ✅ Fetch items on basis of search keyword
  Future<SearchModel?> fetchSearchData(String keyword) async {
    try {
      final response = await _apiClient.getSearchData(keyword);

      if (response.statusCode == 200 && response.data != null) {
        final data = SearchModel.fromJson(response.data);
        debugPrint("🟢 Search keyword: $keyword");
        return data;
      } else {
        debugPrint("⚠️ Unexpected response for shopId: $keyword");
        return null;
      }
    } on DioException catch (e) {
      debugPrint("❌ Dio Error in searching: ${e.message}");
      return null;
    } catch (e, s) {
      debugPrint("❌ Unknown error in search: $e");
      debugPrint("$s");
      rethrow;
    }
  }
}