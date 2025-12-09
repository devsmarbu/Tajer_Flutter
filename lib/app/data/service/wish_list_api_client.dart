import 'package:dio/dio.dart';
import '../../core/constants/app_constants.dart';
import 'api_service/api_service.dart';

class WishListApiClient {
  final ApiService _api = ApiService();

  Future<Response> getWishListData() async {
    final url = AppConstants.wishListSearch;
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

  Future<Response> getWishListItemData(String listId) async {
    final url = AppConstants.wishlistItems;
    return await _api.dio.post(
      url,
      data: FormData.fromMap({
        "uwlist_id": listId
      }),
      options: Options(
        // ✅ Prevent Dio from throwing for non-200 codes
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );
  }

  Future<Response> createWishList(String listName) async {
    final url = AppConstants.createWishList;
    return await _api.dio.post(
      url,
      data: FormData.fromMap({
        "uwlist_title": listName
      }),
      options: Options(
        // ✅ Prevent Dio from throwing for non-200 codes
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );
  }

  Future<Response> deleteWishList(String listId) async {
    final url = AppConstants.deleteWishList;
    return await _api.dio.post(
      url,
      data: FormData.fromMap({
        "uwlist_id": listId
      }),
      options: Options(
        // ✅ Prevent Dio from throwing for non-200 codes
        validateStatus: (status) {
          return status != null && status < 500;
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