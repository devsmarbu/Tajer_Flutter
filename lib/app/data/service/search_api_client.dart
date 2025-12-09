import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

class SearchApiClient {
  final ApiService _api = ApiService();

  Future<Response> getSearchData(String keyword) async {
    final url = AppConstants.autoCompleteSearch;
    return await _api.dio.post(
      url,
      data: FormData.fromMap({"keyword": keyword}),
      options: Options(headers: {'Accept': 'application/json'}),
    );
  }
}
