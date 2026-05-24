

import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/service/search_api_client.dart';
import 'package:tajer/app/modules/product_detail/search_view/search_model.dart';
import 'package:tajer/app/modules/wish_list/wish_list_model.dart';

import '../../../common/widgets/app_dialog.dart';
import '../../core/constants/app_constants.dart';

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
    } catch (e, s) {
      debugPrint("❌ Unknown error in search: $e");
      debugPrint("$s");
      rethrow;
    }
  }
}