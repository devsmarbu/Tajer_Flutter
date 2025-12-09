import 'package:get/get.dart';
import 'package:tajer/app/data/respository/order_success_repository.dart';
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
