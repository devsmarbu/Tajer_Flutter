import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/data/events/app_analytics_service.dart';
import 'package:tajer/app/data/respository/order_success_repository.dart';
import 'package:tajer/utils/pref_store.dart';
import '../../../core/routes/app_routes.dart';
import 'order_success_model.dart';

class OrderSuccessController extends GetxController {
  final _repository = OrderSuccessRepository();
  var isLoading = true.obs;
  final Rxn<OrderDetailModel> orderSuccessModel = Rxn<OrderDetailModel>();
  var orderID = "";

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    final params = Get.arguments;
    final orderId = params["orderId"];
    orderID = orderId;
    fetchOrderSuccessDetail(orderId);
  }

  Future<void> fetchOrderSuccessDetail(String orderId) async {
    try {
      isLoading(true);
      final response = await _repository.fetchOrderSuccess(orderId: orderId);
      if (response != null) {
        orderSuccessModel.value = response;
        /// Clean currency value (QR629.00 → 629.00)
        final orderValue = double.tryParse(
          orderSuccessModel.value?.data?.orderDetail?.orderNetAmount
              ?.replaceAll(RegExp(r'[^0-9.]'), '') ??
              '0',
        ) ??
            0;

        /// Get purchased products
        final products =
            orderSuccessModel.value?.data?.childOrderDetail ?? [];

        /// Convert to Firebase ecommerce format
        final items = products.map((product) {
          final price = double.tryParse(
              product.opSelprodPrice
                  ?.replaceAll(RegExp(r'[^0-9.]'), '') ??
                  '0') ??
              0;

          final qty = int.tryParse(product.opQty ?? "1") ?? 1;

          return {
            "item_id": product.opSelprodId ?? "",
            "item_name": product.opProductName ?? "",
            "price": price,
            "quantity": qty,
          };
        }).toList();

        /// Send purchase analytics
        await AppAnalyticsService.logPurchase(
          currency:
          PrefStore().loadString(AppConstants.currencySymbol) ?? 'QAR',
          value: orderValue,
           items: items,
        );

        final cleared = PrefStore().loadString("campaign_cleared");
        final utmId = PrefStore().loadString("utm_id");
        if (utmId != null && utmId.isNotEmpty && cleared != "true") {
          await FirebaseAnalytics.instance.setUserProperty(
            name: "campaign_id",
            value: null,
          );
          await FirebaseAnalytics.instance.setUserProperty(
            name: "campaign_name",
            value: null,
          );
          await FirebaseAnalytics.instance.setUserProperty(
            name: "source",
            value: null,
          );

          PrefStore().saveString("campaign_cleared", "true");
        }
      }
    } catch (e) {
      debugPrint("❌ order success model error: $e");
    } finally {
      isLoading(false);
    }
  }

  void goToHome() {
    Get.offAllNamed(AppRoutes.bottomNavigation);
  }
}
