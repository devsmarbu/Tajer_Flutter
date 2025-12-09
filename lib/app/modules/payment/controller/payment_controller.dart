import 'package:get/get.dart';
import '../models/payment_method.dart';

class PaymentController extends GetxController {
  // Available payment methods
  final paymentMethods = <PaymentMethod>[
    PaymentMethod(
      id: 1,
      name: "Credit/Debit Card",
      image: "assets/images/sky_cash.png", // replace with your image asset
    ),
  ].obs;

  // Selected payment method ID
  var selectedMethodId = 1.obs;

  void selectMethod(int id) {
    selectedMethodId.value = id;
  }

  void payNow() {
    final selected = paymentMethods.firstWhereOrNull(
          (m) => m.id == selectedMethodId.value,
    );
    if (selected != null) {
      Get.snackbar("Payment", "You selected ${selected.name}");
    }
  }
}