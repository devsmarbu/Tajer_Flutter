import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../data/respository/product_list_repository.dart';
import '../../home/home_model.dart';
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
  String brandId = "";
  String titleHeader = "";
  String productVideoAvailable = "";
  List<String> condition = [];

  @override
  void onInit() {
    super.onInit();

    // ✅ Read parameters passed via Get.toNamed(..., parameters: {...})
    final params = Get.parameters;
    debugPrint("Received Params: $params");

    if (params.isNotEmpty) {
      if (params['prodCatId'] != null && params['prodCatId'] != "") {
        prodCatId = params['prodCatId']!;
      }
      if (params['brandId'] != null && params['brandId'] != "") {
        brandId = params['brandId']!;
      }
      if (params['condition'] != null && params['condition'] != "") {
        condition.add(params['condition']!);
      }
      titleHeader = params['titleHeader'] ?? "";
      productVideoAvailable = params['productVideoAvailable'] ?? "0";
      baseParams["prodcat"] = prodCatId;
      baseParams["brand"] = brandId;
      baseParams["productVideoAvailable"] = productVideoAvailable;
      baseParams["condition"] = condition;

      // ✅ Add extra keys only if video products are requested
      if (productVideoAvailable == "1") {
        baseParams["productIds"] = []; // add dynamic ids later if needed
        baseParams["pageSize"] = "5";
      }

      loadProducts(baseParams);
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
}
