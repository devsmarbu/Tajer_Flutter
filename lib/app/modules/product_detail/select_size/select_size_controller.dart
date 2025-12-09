import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:tajer/app/Extensions/alert.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/core/constants/app_labels.dart';
import 'package:tajer/app/data/respository/home_respository.dart';
import 'package:tajer/app/modules/product_detail/add_to_cart_model/add_to_cart_model.dart';
import 'package:tajer/utils/app_dialog.dart';
import '../../../../common/widgets/app_dialog.dart';
import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';
import '../product_detail_model.dart';
import 'package:flutter/material.dart';

class SelectSizeController extends GetxController {
  final HomeRepository _repository = HomeRepository();
  final RxList<Datum> productSections = <Datum>[].obs;
  AddToCartData? addToCartData;
  final isLoading = false.obs;
  String productId;

  SelectSizeController(this.productId);

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchProductDetail();
  }

  Future<void> fetchProductDetail() async {
    try {
      isLoading(true);
      final response = await _repository.fetchProductDetail(productId);
      if (response != null) {
        productSections.value = response.data?.data ?? [];
      }
    } catch (e) {
      print("❌ fetchProductDetail error: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> addToCart(String selectedProductId) async {
    try {
      isLoading(true);
      final response = await _repository.addToCart(selectedProductId, "1");
      if (response != null) {
        if (response.status == "1") {
          addToCartData = response.data;
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
