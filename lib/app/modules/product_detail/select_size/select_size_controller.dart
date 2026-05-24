import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tajer/app/Extensions/alert.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/core/constants/app_labels.dart';
import 'package:tajer/app/data/events/app_analytics_service.dart';
import 'package:tajer/app/data/respository/home_respository.dart';
import 'package:tajer/app/modules/product_detail/add_to_cart_model/add_to_cart_model.dart';
import 'package:tajer/app/modules/product_detail/productSizeInfo/size_chart_screen.dart';
import 'package:tajer/utils/app_dialog.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/routes/app_routes.dart';
import '../product_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:facebook_app_events/facebook_app_events.dart';

class SelectSizeController extends GetxController {
  final HomeRepository _repository = HomeRepository();
  final RxList<Datum> productSections = <Datum>[].obs;
  final RxList<ProductOptions> productOptions = <ProductOptions>[].obs;
  AddToCartData? addToCartData;
  final isLoading = false.obs;
  String productId;
  RxString inStock = "1".obs;
  String isSizeChartAvailable = '0';

  SelectSizeController(this.productId);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProductDetail();
    debugPrint("fetching product detail");
  }

  Future<void> fetchProductDetail() async {
    try {
      isLoading(true);

      final response = await _repository.fetchProductDetail(productId);
      if (response != null) {
        productSections.value = response.data?.data ?? [];

        final productDetailSection = productSections.firstWhereOrNull(
          (d) => d.customType == ProductDetailType.productDetail,
        );

        final optionsContent = productSections.firstWhereOrNull(
          (d) => d.customType == ProductDetailType.productOption,
        );

        final rows = optionsContent?.content?.optionRows;

        if (rows != null && rows.length == 2) {
          final index = rows.indexWhere((e) => e.optionIsColor == "1");

          if (index > 0 && index < rows.length) {
            final item = rows.removeAt(index);
            rows.insert(0, item);
          }
        }

        productOptions.value = optionsContent?.content?.optionRows ?? [];
        isSizeChartAvailable = optionsContent?.isSizeChartAvailable ?? '0';

        inStock.value =
            productDetailSection?.content?.productDetail?.inStock ?? "0";
      }
    } catch (e) {
      debugPrint("❌ fetchProductDetail error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addToCart(
    String selectedProductId,
    String itemName,
    String price, {
    List<String>? selProdIdsForBoxContent,
    String? comeFromSizeChart = "0",
    String? directAddedToCart = "0",
  }) async {
    try {
      isLoading(true);
      final response = await _repository.addToCart(
        selectedProductId,
        "1",
        selProdIdsForBoxContent: selProdIdsForBoxContent,
      );
      if (response != null) {
        if (response.status == "1") {
          addToCartData = response.data;
          AppAnalyticsService.addToCart(
            productId: selectedProductId,
            name: itemName,
            currency: PrefStore()
                .loadString(AppConstants.currencySymbol)
                .toString(),
            value: double.tryParse(price) ?? 0.0,
          );
          // if (comeFromSizeChart == "1") {
          if (directAddedToCart == '0') {
            Navigator.pop(Get.context!);
          }
          // }
        }
        Get.showSnackbar(
          GetSnackBar(
            message: response.msg ?? "",
            backgroundColor: Colors.black87,
            duration: Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM,
            margin: EdgeInsets.all(12),
            borderRadius: 8,
            isDismissible: true,
          ),
        );
      }
    } catch (e) {
      print("❌ add to cart error: $e");
    } finally {
      isLoading(false);
    }
  }
}
