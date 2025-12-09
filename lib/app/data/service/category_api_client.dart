import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

class CategoryApiClient {
  final ApiService _api = ApiService();

  Future<Response> getCategoryData({required String parentId}) async {
    return await _api.dio.post(
      AppConstants.categories,
      data: FormData.fromMap({
        "parentId": parentId,
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