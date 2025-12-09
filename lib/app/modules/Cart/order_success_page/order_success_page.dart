import 'package:flutter/material.dart';
import 'package:tajer/app/modules/home/home_controller.dart';
import '../../navigation/bottom_navigation.dart';
import '../order_price_detail/order_price_detail_view.dart';
import '../order_price_detail/order_success_price_detail_view.dart';
import 'order_success_cart_item/order_success_cart_item.dart';
import 'package:get/get.dart';

import 'order_success_controller.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OrderSuccessController());
    final double deviceWidth = MediaQuery
        .of(context)
        .size
        .width;
    // TODO: implement build
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 65),
            Container(
              height: 300,
              width: deviceWidth,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/OrderSuccess.png'),
                  fit: BoxFit.fitHeight,
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(0, -35),
              // Adjust -20 to your preference (negative Y moves up)
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                // Optional: Side padding for readability
                child: Text(
                  "Thank You!",
                  textAlign: TextAlign.center,
                  // Centers the text horizontally
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 25,
                    fontFamily: "Nunito",
                  ),
                ),
              ),
            ),
            Obx(() {
              final orderNumber = controller.orderSuccessModel.value?.data?.orderDetail?.orderNumber ?? "";
              final orderNetAmount = controller.orderSuccessModel.value?.data?.orderDetail?.orderNetAmount ?? "";
              final orderSummary = controller.orderSuccessModel.value?.data?.orderSummary;
              final shippingAddress = controller.orderSuccessModel.value?.data
                  ?.orderDetail?.shippingAddress;
              final billingAddress = controller.orderSuccessModel.value?.data
                  ?.orderDetail?.billingAddress;
              final orderedItems = controller.orderSuccessModel.value?.data
                  ?.childOrderDetail;

              return Column(children: [
                Transform.translate(
                  offset: Offset(0, -25),
                  // Adjust -20 to your preference (negative Y moves up)
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Text(
                      "Your order #$orderNumber has been placed. We've sent you an email confirmation.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        fontFamily: "Nunito",
                      ),
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Shipping Address",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                spacing: 5,
                                children: [
                                  Text(
                                    shippingAddress?.ouaName ?? "",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "${shippingAddress?.ouaAddress1 ??
                                        ""},${shippingAddress?.ouaAddress2 ??
                                        ""}\n${shippingAddress?.ouaState ??
                                        ""},${shippingAddress?.ouaCountry ??
                                        ""}\n${shippingAddress?.ouaZip ?? ""}",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "${shippingAddress?.ouaPhoneDcode ??
                                        ""}${shippingAddress?.ouaPhone ?? ""}",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Column(
                        children: [
                          Container(
                            width: double.infinity,
                            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            padding: EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Text(
                              "Billing Address",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Nunito",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                spacing: 5,
                                children: [
                                  Text(
                                    billingAddress?.ouaName ?? "",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "${billingAddress?.ouaAddress1 ??
                                        ""},${billingAddress?.ouaAddress2 ??
                                        ""}\n${billingAddress?.ouaState ??
                                        ""},${billingAddress?.ouaCountry ??
                                        ""}\n${billingAddress?.ouaZip ?? ""}",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Text(
                                    "${billingAddress?.ouaPhoneDcode ??
                                        ""}${billingAddress?.ouaPhone ?? ""}",
                                    style: TextStyle(
                                      fontFamily: "Nunito",
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      OrderSuccessCartItem(orderedItems: orderedItems ?? []),
                      SizedBox(height: 20),
                      OrderSuccessPriceDetailView(orderSummary: orderSummary,orderNetAmount: orderNetAmount),
                      SizedBox(height: 20),
                      SizedBox(
                        width: deviceWidth - 50,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            // your onTap logic here
                            final bottomController = Get.find<BottomNavController>();
                            bottomController.changeTab(0);
                            controller.goToHome();
                          },
                          child: const Text(
                            "Continue Shopping",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Nunito",
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                )
              ]
              );
            })
          ],
        ),
      ),
    );
  }
}
