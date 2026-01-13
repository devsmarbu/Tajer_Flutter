import 'package:get/get.dart';
import 'package:tajer/app/data/respository/order_success_repository.dart';
import '../../../core/routes/app_routes.dart';
import 'order_success_model.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

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
        final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
        // await analytics.logPurchase(
        //   transactionId: orderId,
        //   currency: orderSuccessModel.value?.data?.currencySymbol ?? 'QR',
        //   value: double.tryParse(orderSuccessModel.value?.data?.orderDetail?.orderNetAmount ?? '0') ?? 0,
        //   items: orderSuccessModel.value?.data?.orderSummary?.map((item) {
        //     return AnalyticsEventItem(
        //       itemId: item.key,
        //       itemName: item.productName,
        //       quantity: item.qty,
        //       price: double.tryParse(item.price ?? '0'),
        //     );
        //   }).toList(),
        // );

      }
    } catch (e) {
      print("❌ order success model error: $e");
    } finally {
      isLoading(false);
    }
  }

  void goToHome() {
    Get.offAllNamed(AppRoutes.bottomNavigation);
  }
}
