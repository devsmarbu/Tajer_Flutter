import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../core/routes/app_routes.dart';
import '../../../data/respository/product_list_repository.dart';
import '../../home/home_model.dart';
import '../../product_detail/shop_detail_view/shop_detail_controller.dart';
import '../models/filtered_product.dart';


class ProductController extends GetxController {
  final _repository = ProductListRepository();

  // ✅ Reactive data and product list
  var productData = Rxn<Data>();
  var products = <HomeProduct>[].obs;

  // ✅ States
  var isLoading = false.obs;
  var page = 1;
  var hasMore = true.obs;

  // ✅ API params
  Map<String, dynamic> baseParams = {};
  String prodCatId = "";
  String keyword = "";
  String brandId = "";
  String titleHeader = "";
  String image = "";
  String imagePath = "";
  String productVideoAvailable = "";
  List<String> condition = [];
  File? imageFile;

  static Map<String, Data?> preloadedDataMap = {};

  @override
  void onInit() {
    super.onInit();

    // ✅ Read parameters passed via Get.toNamed(..., parameters: {...})
    final params = Get.parameters;
    debugPrint("Received Params: $params");

    final tag = params['uniqueId'];
    Data? initialData;
    if (tag != null && preloadedDataMap.containsKey(tag)) {
      initialData = preloadedDataMap.remove(tag);
    }

    if (params.isNotEmpty) {
      if (params['prodCatId'] != null && params['prodCatId'] != "") {
        prodCatId = params['prodCatId']!;
      }
      if (params['brandId'] != null && params['brandId'] != "") {
        brandId = params['brandId']!;
      }
      if (params['imagePath'] != null && params['imagePath'] != "") {
        imagePath = params['imagePath']!;
        imageFile = imagePath.isNotEmpty
            ? File(imagePath)
            : null;
      }
      if (params['condition'] != null && params['condition'] != "") {
        condition.add(params['condition']!);
      }
      if (params['image'] != null && params['image'] != "") {
        image = params['image']!;
      }
      if (params['keyword'] != null && params['keyword'] != "") {
        keyword = params['keyword']!;
      }
      titleHeader = params['titleHeader'] ?? "";
      productVideoAvailable = params['productVideoAvailable'] ?? "0";
      baseParams["prodcat"] = prodCatId;
      if(keyword=="null"){
        baseParams["keyword"] = "";
      }else{
        baseParams["keyword"] = keyword;
      }

      baseParams["brand"] = brandId;
      baseParams["image"] = image;
      baseParams["productVideoAvailable"] = productVideoAvailable;
      baseParams["condition"] = condition;

      // ✅ Add extra keys only if video products are requested
      if (productVideoAvailable == "1") {
        baseParams["productIds"] = []; // add dynamic ids later if needed
        baseParams["pageSize"] = "5";
      }

      if (initialData != null) {
        productData.value = initialData;
        products.assignAll(initialData.products ?? []);
        if ((initialData.products ?? []).isEmpty) hasMore(false);
        isLoading(false);
      } else {
        loadProducts(baseParams);
      }
    } else {
      debugPrint("⚠️ No arguments passed to ProductController");
    }
  }

  /// 🔹 Initial Load
  Future<void> loadProducts(Map<String, dynamic> baseParam) async {
    baseParams = baseParam;
    try {
      isLoading(true);
      page = 1;
      hasMore(true);
      products.clear();

      final params = {...baseParams, "page": page};
      final data = await _repository.fetchPaginatedProducts(params);

      if (data != null) {
        productData.value = data;
        products.assignAll(data.products ?? []);
        if ((data.products ?? []).isEmpty) hasMore(false);
      }
    } catch (e) {
      debugPrint("❌ loadProducts error: $e");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 Load more when scrolling bottom
  Future<void> loadMoreProducts() async {
    if (isLoading.value || !hasMore.value) return;

    try {
      isLoading(true);
      page++;

      final params = {...baseParams, "page": page};
      final newData = await _repository.fetchPaginatedProducts(params);

      if (newData != null && (newData.products ?? []).isNotEmpty) {
        products.addAll(newData.products!);
      } else {
        hasMore(false);
        debugPrint("🏁 No more products available.");
      }
    } catch (e) {
      debugPrint("❌ loadMoreProducts error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<String?> addRemoveToWishlist(
      String productId,
      String wishlistId,
      String isInAnyWishlist,
      String productIndex,
      ) async {
    try {
      final response = await _repository.addRemoveToWishList(
        productId,
        wishlistId,
        isInAnyWishlist,
      );
      if (response != null) {
        debugPrint("✅ item add/remove to wishlist");
        if (Get.currentRoute == AppRoutes.shopDetailView) {
          final shopController = Get.put(ShopDetailController());
          shopController.updateFav(
            isInAnyWishlist,
            productIndex,
          );
        }
        else  {
          updateFav(isInAnyWishlist, productIndex);
        }

        return isInAnyWishlist;
      }
    } catch (e) {
      debugPrint("❌ add/remove wishlist error: $e");
    }
    return null;
  }

  void updateFav(
      String isInAnyWishlist,
      String productIndex,
      ) {
    // 🔁 toggle value
    String newValue = isInAnyWishlist == '0' ? '0' : '1';
    int pIndex = int.parse(productIndex);

    // ✅ update inside posts
   products[pIndex] = products[pIndex]
        .copyWith(is_in_any_wishlist: newValue);

    products.refresh(); // 🔥 important for UI update
  }

}
