

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:tajer/app/data/service/search_api_client.dart';
import 'package:tajer/app/modules/product_detail/search_view/search_model.dart';
import 'package:tajer/app/modules/wish_list/wish_list_model.dart';

class SearchRepository {
  final SearchApiClient _apiClient = SearchApiClient();

  /// ✅ Fetch items on basis of search keyword
  Future<SearchModel?> fetchSearchData(String keyword,String recordId) async {
    try {
      final response = await _apiClient.getSearchData(recordId,keyword);

      if (response.statusCode == 200 && response.data != null) {
        dynamic data = response.data;

        // CASE 1 → API returned plain string
        if (data is String) {
          data = jsonDecode(data);
        }

        // CASE 2 → Must be valid JSON map
        if (data is Map<String, dynamic>) {
          final model = SearchModel.fromJson(data);

          if (model.status == "1") {
            //cart item count
            debugPrint("✅ Item added successfully");
          } else {
            debugPrint("⚠️ ${model.msg ?? 'Something went wrong'}");
          }

          return model; // success or failure -> return model anyway
        } else {
          debugPrint("❌ Invalid JSON structure");
          return null;
        }
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


  Future<UploadImageModel?> getSearchImageRecordId(File file) async {
    try {
      final response = await _apiClient.getSearchImageRecordId(file: file);

      if (response.statusCode == 200 && response.data != null) {

        dynamic data = response.data;
        // CASE 1 → API returned plain string
        if (data is String) {
          data = jsonDecode(data);
        }

        // CASE 2 → Must be valid JSON map
        if (data is Map<String, dynamic>) {
          final model = UploadImageModel.fromJson(data);

          if (model.status == 1) {
            //cart item count
            debugPrint("✅ Item added successfully");
          } else {
            debugPrint("⚠️ ${model.msg ?? 'Something went wrong'}");
          }

          return model; // success or failure -> return model anyway
        } else {
          debugPrint("❌ Invalid JSON structure");
          return null;
        }
      } else {
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