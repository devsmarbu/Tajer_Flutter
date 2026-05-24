import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/core/constants/app_labels.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/payment_summary_model/payment_summary_model.dart';
import '../../../Extensions/alert.dart';
import 'package:tajer/utils/app_strings.dart';
import '../cart_shipping/regular_products/regular_product_controller.dart';

class PlaceOrderView extends StatelessWidget {
  final bool _isAgreed; // 🔹 store value from DeliveryHtmlPage
  final PaymentSummaryModel? paymentSummaryModel;
  final String orderId;
  final String usedRewardPoint;

  const PlaceOrderView({
    super.key,
    required bool isAgreed,
    required this.paymentSummaryModel,
    required this.orderId,
    required this.usedRewardPoint,
  }) : _isAgreed = isAgreed;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegularProductController());

    return Column(
      key: Key("place_order_view"),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: Container(
            padding: EdgeInsets.all(22),
            height: 100,
            decoration: BoxDecoration(color: Colors.white),
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 1),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  padding: EdgeInsets.all(15),
                  child: Text(
                    paymentSummaryModel?.data?.netPayable?.value ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Nunito",
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                // spacing between price & button
                Expanded(
                  // 👈 Move Expanded here
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: _isAgreed ? Colors.black : Colors.grey,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (_isAgreed == true) {
                          debugPrint("Agree btn working");
                          // controller.goToOrderSuccess();
                          final orderNetAmount =
                              paymentSummaryModel?.data?.orderNetAmount
                                  .toIntSafe() ??
                              0;
                          if (orderNetAmount == 0) {
                            controller.goToOrderSuccess(
                              orderId: orderId,
                            );
                          } else {
                            final canUseWalletForPayment =
                                paymentSummaryModel
                                    ?.data
                                    ?.canUseWalletForPayment ??
                                "1";
                            final walletBalance =
                                paymentSummaryModel?.data?.userWalletBalance
                                    .toIntSafe() ??
                                0;
                            debugPrint("$walletBalance");
                            debugPrint("$orderNetAmount");
                            if(controller.useWallet.value==false && controller.useCard.value==false){
                              showAlertMessage(
                                Get.context!,
                                title: AppLabels.APP_NAME,
                                message: AppStrings.APP_PLEASE_SELECT_PAYMENT_METHOD.tr,
                              );
                              return;
                            }
                            else{
                              if (walletBalance < orderNetAmount) {
                                if (controller.useCard.value==false && controller.useWallet.value==true) {
                                  showAlertMessage(
                                    Get.context!,
                                    title: AppLabels.APP_NAME,
                                    message: "Insufficient balance.",
                                  );
                                } else {
                                  final result = await controller.confirmOrder(
                                    controller.cartOrderId,
                                    controller.orderType,
                                    controller.selectedPlugin?.pluginId ?? "56",
                                    walletBalance,
                                    controller.isUseWalletPayment,
                                  );
                                }
                              }
                              else {
                                final result = await controller.confirmOrder(
                                  controller.cartOrderId,
                                  controller.orderType,
                                  controller.selectedPlugin?.pluginId ?? "56",
                                  walletBalance,
                                  controller.isUseWalletPayment,
                                );
                              }
                            }

                          }
                        }
                      },
                      child: Row(
                        key: Key("app_place_order_button"),
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            'assets/images/cartIcon.png',
                            color: Colors.white,
                            width: 22,
                            height: 22,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            AppStrings.appPlaceOrder.toUpperCase().tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Nunito",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
