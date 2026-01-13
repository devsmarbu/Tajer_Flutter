import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/respository/search_repository.dart';
import 'package:tajer/app/modules/product_detail/search_view/search_model.dart';
import '../../../core/routes/app_routes.dart';

class SearchViewController extends GetxController {
  final _repository = SearchRepository();

  final RxList<SearchProduct> products = <SearchProduct>[].obs;
  final RxList<Tag> productsTags = <Tag>[].obs;
  final isLoading = false.obs;
  final keyword = ''.obs;


  Timer? _debounce;

  /// 🔍 Called when user types in search bar
  void onSearchChanged(String keyword) {
    // Cancel previous timer
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Wait for 1 second after user stops typing
    _debounce = Timer(const Duration(seconds: 1), () {
      if (keyword.isNotEmpty && keyword.length >= 3) {
        loadSearchData(keyword, "");
      } else {
        products.clear();
      }
    });
  }

  void onKeyboardSearchButton(String keyword){
    goToProductListing("","",keyword);
  }

  /// 📡 Fetch search results
  Future<void> loadSearchData(String keyword, String recordId) async {
    isLoading(true);
    try {
      final newSearch = await _repository.fetchSearchData(keyword, recordId);
      productsTags.value = newSearch?.data?.suggestions?.tags ?? [];
      products.value = newSearch?.data?.suggestions?.products ?? [];

    } finally {
      isLoading(false);
    }
  }

  /// 📡 Fetch search results
  Future<void> loadRecordIdFromImage(File file) async {
    isLoading(true);
    try {
      final newSearch = await _repository.getSearchImageRecordId(file);
      goToProductListing("${newSearch?.recordId ?? ""}",file.path,"Search result for");
      debugPrint("navigating from here");
    } finally {
      isLoading(false);
    }
  }

  void goToProductDetailView(String productId, String productName) {
    Get.toNamed(
      AppRoutes.productDetail,
      arguments: {"productId": productId, "productName": productName},
    );
  }

  void goToProductListing(String productCatId,String imagePath,String title) {
    AppRoutes.goToProductListPage(
      brandId: "",
      productVideoAvailable: "0",
      titleHeader: title,
      prodCatId: '',
      condition: "",
      keyword: title,
      image: productCatId,
      imagePath: imagePath
    );
  }

  @override
  void onClose() {
    _debounce?.cancel();
    productsTags.clear();
    products.clear();
    super.onClose();
  }
}
