import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/data/respository/product_list_repository.dart';
import '../../productList/models/filtered_product.dart';
import '../home_model.dart';

class ReelPageController extends GetxController {
  final _repository = ProductListRepository();

  // 🔹 PageView state
  late final PageController pageController;
  final RxInt currentIndex = 0.obs;

  // 🔹 Data
  var productData = Rxn<Data>();
  final RxList<HomeProduct> products = <HomeProduct>[].obs;

  // 🔹 States
  var isLoading = false.obs;
  var page = 1;
  var hasMore = true.obs;

  // 🔹 API params
  Map<String, dynamic> baseParams = {};
  String productIds = "";
  String productVideoAvailable = "";
  int initialIndex = 0;

  @override
  void onInit() {
    super.onInit();

    final params = Get.arguments ?? {};
    debugPrint("Received Params: $params");

    productIds = params['productIds'] ?? "";
    productVideoAvailable = params['productVideoAvailable'] ?? "0";

    baseParams["productVideoAvailable"] = productVideoAvailable;
    baseParams["pageSize"] = "5";

    if (productVideoAvailable == "1" && productIds.isNotEmpty) {
      baseParams["productIds"] = productIds;
    }

    initialIndex = params['indexToPlayVideoFirst'] ?? 0;
    currentIndex.value = initialIndex;

    // init PageController ONCE
    pageController = PageController(
      initialPage: initialIndex,
      keepPage: true,
    );

    loadProducts();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  void onPageChanged(int index) => currentIndex.value = index;

  /// 🔹 Set initial data (from previous screen)
  void setInitialProducts(List<HomeProduct> initialProducts) {
    if (initialProducts.isEmpty) return;

    for (var p in initialProducts) {
      if (!_containsProduct(p.productId)) {
        products.add(p);
      }
    }

    debugPrint("✅ Loaded initial ${initialProducts.length} products");
  }

  bool _containsProduct(dynamic productId) {
    return products.any((e) => e.productId == productId);
  }

  /// 🔹 Initial Load
  Future<void> loadProducts() async {
    try {
      isLoading(true);
      page = 1;
      hasMore(true);

      final params = {...baseParams, "page": page};
      final data = await _repository.fetchPaginatedProducts(params);

      if (data != null) {
        productData.value = data;

        final fetched = data.products ?? [];

        // Remove duplicacy
        final cleanList =
        fetched.where((p) => !_containsProduct(p.productId)).toList();

        if (cleanList.isEmpty) {
          debugPrint("⚠️ All products were duplicates.");
          return;
        }

        products.addAll(cleanList);

        debugPrint("✅ Added ${cleanList.length} initial products");
      }
    } catch (e) {
      debugPrint("❌ loadProducts error: $e");
    } finally {
      isLoading(false);
    }
  }

  /// 🔹 Load more (no duplicates)
  Future<void> loadMoreProducts() async {
    if (isLoading.value || !hasMore.value) return;

    try {
      isLoading(true);
      page++;

      // Remove productIds after first page
      if (page > 1) baseParams["productIds"] = "";

      final params = {...baseParams, "page": page};
      final newData = await _repository.fetchPaginatedProducts(params);

      if (newData != null) {
        final fetched = newData.products ?? [];

        // Remove duplicates
        final cleanList =
        fetched.where((p) => !_containsProduct(p.productId)).toList();

        if (cleanList.isEmpty) {
          hasMore(false);
          debugPrint("🏁 No more unique products available.");
          return;
        }

        products.addAll(cleanList);

        debugPrint(
            "📥 Loaded more: ${cleanList.length} (Total: ${products.length})");
      } else {
        hasMore(false);
      }
    } catch (e) {
      debugPrint("❌ loadMoreProducts error: $e");
    } finally {
      isLoading(false);
    }
  }
}