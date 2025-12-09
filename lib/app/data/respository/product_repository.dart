import 'package:flutter/foundation.dart';
import 'package:tajer/app/modules/product_detail/GetFiltersModel.dart';
import '../../modules/product_detail/product_detail_model.dart';
import '../../modules/wish_list/wish_list_model.dart';
import '../service/product_detail_api_client.dart';

class ProductRepository {
  final ProductDetailApiClient _apiClient = ProductDetailApiClient();

  /// Fetch one page of product detail
  Future<ProductDetailModel?> fetchProductDetail(
    String productId,
    int page,
  ) async {
    try {
      final response = await _apiClient.getProductDetailData(
        productId: productId,
        page: page,
      );

      if (response.statusCode == 200) {
        final model = ProductDetailModel.fromJson(response.data);
        return model;
      } else {
        debugPrint("⚠️ Failed to load product detail: ${response.statusCode}");
        return null;
      }
    } catch (e, s) {
      debugPrint("❌ Error in repository vfd (page $page): $e");
      debugPrint("$s");
      return null;
    }
  }

  /// report product
  Future<CommonResponseModel?> reportProduct(
    String selprodName,
    String spreportTitle,
    String spreportComments,
    String spreportSelprodId,
  ) async {
    try {
      final response = await _apiClient.reportForm(
        selprod_name: selprodName,
        spreport_title: spreportTitle,
        spreport_comments: spreportComments,
        spreport_selprod_id: spreportSelprodId,
      );

      if (response.statusCode == 200) {
        final model = CommonResponseModel.fromJson(response.data);
        return model;
      } else {
        debugPrint("⚠️ Failed to report product: ${response.statusCode}");
        return null;
      }
    } catch (e, s) {
      debugPrint("❌ Error in repository: $e");
      debugPrint("$s");
      return null;
    }
  }

  //get filters
  Future<GetFiltersModel?> getFilters(
       String keyword,
       String category,
       String shop_id,
       String featured,
       String top_products,
       String brand_id,
  ) async {
    try {
      final response = await _apiClient.getFilters(
        keyword: keyword,
        category: category,
        shop_id: shop_id,
        featured: featured,
        top_products: top_products,
        brand_id: brand_id,
      );

      if (response.statusCode == 200) {
        final model = GetFiltersModel.fromJson(response.data);
        return model;
      } else {
        debugPrint("⚠️ Failed to report product: ${response.statusCode}");
        return null;
      }
    } catch (e, s) {
      debugPrint("❌ Error in repository: $e");
      debugPrint("$s");
      return null;
    }
  }

  /// ✅ Fetch all pages of product detail dynamically
  Future<void> fetchAllProductPages(
    String productId, {
    required Function(List<Datum>) onPageLoaded,
  }) async {
    List<Datum> allSections = [];
    int currentPage = 1;
    int firstPageSize = 0;
    bool keepLoading = true;

    while (keepLoading) {
      final model = await fetchProductDetail(productId, currentPage);

      final newSections = model?.data?.data ?? [];

      if (currentPage == 1) {
        firstPageSize = newSections.length;
      }

      if (newSections.isNotEmpty) {
        allSections.addAll(newSections);
        onPageLoaded(newSections);
        debugPrint(
          "📄 Page $currentPage loaded with ${newSections.length} sections",
        );
      }

      if (newSections.length < firstPageSize || newSections.isEmpty) {
        debugPrint("🏁 No more product detail pages available");
        keepLoading = false;
      } else {
        currentPage++;
        await Future.delayed(const Duration(milliseconds: 250));
      }
    }

    debugPrint("✅ Total sections combined: ${allSections.length}");
  }
}
