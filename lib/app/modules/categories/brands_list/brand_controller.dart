import 'package:flutter/cupertino.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/respository/brand_repository.dart';
import 'models/brand.dart';

class BrandController extends GetxController {
  final _repository = BrandRepository();

  // Data lists
  var brandList = <AllBrand>[].obs;
  var shopList = <AllShop>[].obs;

  // State variables
  var isLoading = false.obs;
  var isMoreLoading = false.obs; // for pagination loading
  var currentPage = 1.obs;
  var hasMoreData = true.obs; // track if more pages exist
  var collectionId = "";

  // Models
  final Rxn<BrandModel> brandModel = Rxn<BrandModel>();
  final Rxn<ShopModel> shopModel = Rxn<ShopModel>();

  /// 🔹 Fetch Brand List (GET)
  Future<void> fetchBrandList() async {
    // Skip if already loaded
    if (brandList.isNotEmpty) return;
    try {
      isLoading(true);
      final response = await _repository.fetchBrandListData();

      if (response != null) {
        brandModel.value = response;
        brandList.assignAll(response.data?.allBrands ?? []);
      }
    } catch (e) {
      print("❌ fetchBrandList error: $e");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 Fetch Shop List (POST) — initial load
  Future<void> fetchShopList({String page = "1"}) async {
    // Skip if already loaded
    if (shopList.isNotEmpty) return;
    try {
      isLoading(true);
      currentPage.value = 1;
      hasMoreData(true);

      final response = await _repository.fetchShopListData(page);

      if (response != null) {
        shopModel.value = response;
        shopList.assignAll(response.data?.allShops ?? []);
      }
    } catch (e) {
      print("❌ fetchShopList error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchOurShopList() async {
    try {
      isLoading(true);
      hasMoreData(false);
      final params = Get.parameters;
      collectionId = params["collectionId"] ?? "";
      final response = await _repository.fetchOurShopListData(collectionId);

      if (response != null) {
        shopModel.value = response;
        shopList.assignAll(response.data?.allShops ?? []);
      }
    } catch (e) {
      print("❌ fetchShopList error: $e");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 Fetch Brand List (GET)
  Future<void> fetchOurFavBrandList() async {
    try {
      isLoading(true);
      final params = Get.parameters;
      collectionId = params["collectionId"] ?? "";
      final response = await _repository.fetchOurFavBrandListData(collectionId);

      if (response != null) {
        debugPrint("brands received");
        brandModel.value = response;
        brandList.assignAll(response.data?.allBrands ?? []);
      }
    } catch (e) {
      print("❌ fetchBrandList error: $e");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 Load More Shops (Pagination)
  Future<void> loadMoreShops() async {
    if (isMoreLoading.value || !hasMoreData.value) return; // avoid duplicates

    try {
      isMoreLoading(true);
      final nextPage = currentPage.value + 1;
      final response = await _repository.fetchShopListData(nextPage.toString());

      if (response != null) {
        final newList = response.data?.allShops ?? [];

        if (newList.isEmpty) {
          hasMoreData(false); // no more pages
        } else {
          shopList.addAll(newList);
          currentPage.value = nextPage;
        }
      }
    } catch (e) {
      print("❌ loadMoreShops error: $e");
    } finally {
      isMoreLoading(false);
    }
  }
}