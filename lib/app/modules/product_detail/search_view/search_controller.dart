import 'dart:async';
import 'package:get/get.dart';
import 'package:tajer/app/data/respository/search_repository.dart';
import 'package:tajer/app/modules/product_detail/search_view/search_model.dart';
import '../../../core/routes/app_routes.dart';

class SearchViewController extends GetxController {
  final _repository = SearchRepository();

  final RxList<SearchProduct> products = <SearchProduct>[].obs;
  final isLoading = false.obs;

  Timer? _debounce;


  /// 🔍 Called when user types in search bar
  void onSearchChanged(String keyword) {
    // Cancel previous timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Wait for 1 second after user stops typing
    _debounce = Timer(const Duration(seconds: 1), () {
      if (keyword.isNotEmpty && keyword.length >= 3) {
        loadSearchData(keyword);
      } else {
        products.clear();
      }
    });
  }

  /// 📡 Fetch search results
  Future<void> loadSearchData(String keyword) async {
    isLoading(true);
    try {
      final newSearch = await _repository.fetchSearchData(keyword);
      products.value = newSearch?.data?.suggestions?.products ?? [];
    } finally {
      isLoading(false);
    }
  }

  void goToProductDetailView(String productId, String productName) {
        Get.toNamed(AppRoutes.productDetail,
            arguments: { "productId": productId, "productName": productName});
    }

  @override
  void onClose() {
    _debounce?.cancel();
    super.onClose();
  }
}