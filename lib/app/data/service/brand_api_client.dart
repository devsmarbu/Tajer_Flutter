import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

class BrandApiClient {
  final ApiService _api = ApiService();

  Future<Response> getBrandListData() async {
    return await _api.dio.get(
      AppConstants.brands,
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<Response> getOurFavBrandListData(String collectionId) async {
    return await _api.dio.post(
      AppConstants.collectionSearch,
      data: FormData.fromMap({
        "collection_id": collectionId
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<Response> getShopListData(String page) async {
    return await _api.dio.post(
      AppConstants.shops,
      data: FormData.fromMap({
        "page": page
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<Response> getOurShopListData(String collectionId) async {
    return await _api.dio.post(
      AppConstants.collectionSearch,
      data: FormData.fromMap({
        "collection_id": collectionId
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }
}