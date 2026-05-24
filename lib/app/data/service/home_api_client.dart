import 'package:dio/dio.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

class HomeApiClient {
  final ApiService _api = ApiService();

  Future<Response> getHomeData({int page = 1}) async {
    // 👇 This will log in PrettyDioLogger & InterceptorsWrapper
    return await _api.dio.post(
      AppConstants.home,
      data: FormData.fromMap({
        "page": page, // ✅ send as form-data
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
          // Important: override to allow form data
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> getProductDetailData({required String productId}) async {
    final url =
        '${AppConstants.productDetail}$productId'; // ✅ Append ID to path
    return await _api.dio.post(url);
  }

  Future<Response> addToCart({
    required String productId,
    required String quantity,
    List<String>? selProdIdsForBoxContent,
  }) async {
    final Map<String, dynamic> data = {
      "quantity": quantity,
      "selprod_id": productId
  };

    // ✅ If box content exists → send only box items
    if (selProdIdsForBoxContent != null && selProdIdsForBoxContent.isNotEmpty) {
      for (int i = 0; i < selProdIdsForBoxContent.length; i++) {
        data["box_item_selprods[$i]"] = selProdIdsForBoxContent[i];
      }
    }

    return await _api.dio.post(
      AppConstants.addToCart,
      data: FormData.fromMap(data),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
          'X-IP-COUNTRY-CODE':
          PrefStore().loadString(AppConstants.countryCode) ?? "QA",
          'X-IP-COUNTRY-ID':
          PrefStore().loadString(AppConstants.countryId) ?? "173",
        },
      ),
    );
  }

  Future<Response> getCountries({required String keyword}) async {
    return await _api.dio.post(
      AppConstants.getCountries,
      data: FormData.fromMap({
        "keyword": keyword,
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> setCountry({required String countryId}) async {
    return await _api.dio.post(
      AppConstants.setCountry,
      data: FormData.fromMap({
        "country_id": countryId,
      }),
      options: Options(
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'multipart/form-data',
        },
      ),
    );
  }

  Future<Response> addRemoveToWishList(String productId,String wishListId,String isInAnyWishlist) async {
    final url = "${AppConstants.addToWishlist}/$productId/$wishListId/$isInAnyWishlist";
    return await _api.dio.get(
      url,
      options: Options(
        // ✅ Prevent Dio from throwing for non-200 codes
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );
  }
}
