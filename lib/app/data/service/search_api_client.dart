import 'dart:io';

import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

class SearchApiClient {
  final ApiService _api = ApiService();

  Future<Response> getSearchData(String recordId, String keyword) async {
    final url = AppConstants.autoCompleteSearch;
    return await _api.dio.post(
      url,
      data: FormData.fromMap({"keyword": keyword,"image": recordId}),
      options: Options(headers: {'Accept': 'application/json'}),
    );
  }

  Future<Response> getSearchImageRecordId({required File file}) async {
    final url = AppConstants.searchImageRecordId;
    return await _api.dio.post(
      url,
      data: FormData.fromMap({
        "searchImage": await MultipartFile.fromFile(
          file.path,
          filename: file.path.split('/').last,
        ),
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
          "Content-Type": "multipart/form-data",
        },
      ),
    );
  }
}
