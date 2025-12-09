import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/price_detail.dart';
import 'package:tajer/common/functions/app_function.dart';
import 'package:tajer/utils/app_colors.dart';
import 'package:tajer/utils/app_params.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../review/rating/view/rating_screen.dart';
import '../controller/order_details_controller.dart';
import '../models/child_order_detail_item.dart';
import '../models/shipping_comments.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final String orderProductId;
  final String orderNumber;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.orderProductId,
    required this.orderNumber,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late final OrderDetailsController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(OrderDetailsController(), permanent: false);
    controller.orderId.value = widget.orderId;
    controller.orderProductId.value = widget.orderProductId;
    controller.fetchOrders(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.white,
        titleSpacing: 0,
        title: Text(
          widget.orderNumber,
          style: const TextStyle(
            color: Colors.black,
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        final order = controller.orderModel.value?.childOrderDetail?.first;

        if (order == null) {
          return Container();
        }

        // Ensure priceDetail list is initialized
        order.priceDetail ??= [];
        // Add total price if not already added
        if (!order.priceDetail!.any(
          (item) => item.key == AppStrings.app_total,
        )) {
          order.priceDetail!.add(
            PriceDetail(
              key: AppStrings.appTotal.toUpperCase().tr,
              value: order.totalAmount!.value.toString(),
              isBold: true,
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // -------------------------------
              // PRODUCT CARD
              // -------------------------------
              Container(
                padding: const EdgeInsets.all(12),
                decoration: _box(),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _productImage(order.product_image_url ?? ""),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order.selprod_title ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontFamily: 'Nunito',
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${AppStrings.appSoldBy.toUpperCase().tr}: ${order.op_shop_name ?? ""}",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Nunito',
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Qty: ${order.op_qty} | Size: ${order.op_selprod_options}",
                            style: const TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Nunito',
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            order.op_unit_price.toString(),
                            style: const TextStyle(
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // -------------------------------
              // ORDER STATUS
              // -------------------------------
              _sectionContainer(
                title: AppStrings.appOrderStatus.tr,
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.blueAccent,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Column(
                      children: [
                        Text(
                          order.orderstatus_name ?? "",
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          AppFunction.getDateFormat(
                            order.order_date_added ?? "",
                            "dd-MMM-yyyy, HH:mm",
                          ),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // -------------------------------
              // RATING
              // -------------------------------
              if (order.reviewsAllowed == "1" && order.canSubmitFeedback == "1")
                _sectionContainer(
                  title: AppStrings.appRating.toUpperCase().tr,
                  child: Row(
                    children: [
                      ...List.generate(
                        5,
                        (index) => IconButton(
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            index < controller.rating.value
                                ? Icons.star
                                : Icons.star_border,
                            color: Colors.amber,
                          ),
                          onPressed: () => controller.updateRating(index + 1.0),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () async {
                          final result = await Get.to(
                            () => RatingScreen(),
                            arguments: {
                              AppParams.orderNumber: order.op_invoice_number,
                              AppParams.optId: order.op_id,
                              AppParams.shopName: order.op_shop_name,
                              AppParams.productType: order.op_product_type,
                              AppParams.productName: order.selprod_title,
                              AppParams.imageUrl: order.product_image_url,
                            },
                          );

                          if (result == true) {
                            controller.fetchOrders(widget.orderId);
                          }
                        },
                        child: Text(
                          AppStrings.appWriteAReview.tr,
                          style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              // -------------------------------
              // PAYMENT METHOD
              // -------------------------------
              _sectionContainer(
                title: AppStrings.appPaymentMethod.tr,
                child: Text(order.plugin_name ?? ""),
              ),

              // -------------------------------
              // SHIPPING MODE
              // -------------------------------
              _sectionContainer(
                title: AppStrings.appShippingMode.tr,
                child: Text(order.opshipping_label.toString()),
              ),

              // -------------------------------
              // EMAIL RECEIPT
              // -------------------------------
              _sectionContainer(
                title: AppStrings.appEmailOrderReceipt.tr,
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  controller.orderReceipt();
                },
              ),

              // -------------------------------
              // PAYMENT TIMELINE
              // -------------------------------
              _timelineCard(
                controller.orderModel.value!.orderDetail!.comments ?? [],
              ),

              const SizedBox(height: 12),

              // -------------------------------
              // BILLING DETAILS
              // -------------------------------
              _sectionContainer(
                title: AppStrings.appBillingDetails.tr,
                child: _addressSection(
                  name:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.billingAddress
                          ?.ouaName ??
                      "",
                  phone:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.billingAddress
                          ?.ouaPhone ??
                      "",
                  a1:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.billingAddress
                          ?.ouaAddress1 ??
                      "",
                  a2:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.billingAddress
                          ?.ouaAddress2 ??
                      "",
                  city:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.billingAddress
                          ?.ouaCity ??
                      "",
                  state:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.billingAddress
                          ?.ouaState ??
                      "",
                  country:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.billingAddress
                          ?.ouaCountry ??
                      "",
                  zip:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.billingAddress
                          ?.ouaZip ??
                      "",
                ),
              ),

              // -------------------------------
              // SHIPPING DETAILS
              // -------------------------------
              _sectionContainer(
                title: AppStrings.appShippingDetails.tr,
                child: _addressSection(
                  name:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.shippingAddress
                          ?.ouaName ??
                      "",
                  phone:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.shippingAddress
                          ?.ouaPhone ??
                      "",
                  a1:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.shippingAddress
                          ?.ouaAddress1 ??
                      "",
                  a2:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.shippingAddress
                          ?.ouaAddress2 ??
                      "",
                  city:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.shippingAddress
                          ?.ouaCity ??
                      "",
                  state:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.shippingAddress
                          ?.ouaState ??
                      "",
                  country:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.shippingAddress
                          ?.ouaCountry ??
                      "",
                  zip:
                      controller
                          .orderModel
                          .value
                          ?.orderDetail
                          ?.shippingAddress
                          ?.ouaZip ??
                      "",
                ),
              ),

              // -------------------------------
              // ORDER DETAILS
              // -------------------------------
              _sectionContainer(
                title: AppStrings.appOrderDetails.toUpperCase().tr,
                child: Column(
                  children: order.priceDetail!
                      .map(
                        (item) => _rowItem(
                          item.key ?? "",
                          item.value ?? "",
                          isBold: item.isBold ?? false,
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 12),

              // -------------------------------
              // RETURN | EXCHANGE | REORDER BUTTONS
              // -------------------------------
              Row(
                children: [
                  // if(order.canCancelOrder.toString()=="1")
                  //   Expanded(
                  //       child: _bottomButton(
                  //           "Cancel", Colors.white, Colors.black,
                  //           onTap: (){
                  //             Get.toNamed(AppRoutes.returnOrderScreen,arguments: {
                  //               AppParams.optId,order.op_id,
                  //               AppParams.isExchange,false,
                  //             });
                  //           }
                  //       )),
                  // const SizedBox(width: 10),
                  if (order.canReturnOrder.toString() == "1")
                    Expanded(
                      child: _bottomButton(
                        AppStrings.appReturn.tr,
                        Colors.white,
                        Colors.black,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.returnOrderScreen,
                            arguments: {
                              AppParams.optId,
                              order.op_id,
                              AppParams.isExchange,
                              false,
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(width: 10),
                  if (order.canExchangeOrder.toString() == "1")
                    Expanded(
                      child: _bottomButton(
                        AppStrings.appExchange.tr,
                        Colors.white,
                        Colors.black,
                        onTap: () {
                          Get.toNamed(
                            AppRoutes.returnOrderScreen,
                            arguments: {
                              AppParams.optId,
                              order.op_id,
                              AppParams.isExchange,
                              true,
                            },
                          );
                        },
                      ),
                    ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _bottomButton(
                      ((order.selprod_stock ?? "0").toIntSafe() > 0)
                          ? AppStrings.appReorder.tr
                          : "APP_SOLD_OUT".tr,
                      ((order.selprod_stock ?? "0").toIntSafe() > 0)
                          ? Colors.black
                          : Colors.grey,
                      Colors.white,
                      onTap: () {
                        ((order.selprod_stock ?? "0").toIntSafe() > 0)
                            ? controller.reOrderProduct(order)
                            : null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  // --------------------------------------------------------
  // UI HELPERS
  // --------------------------------------------------------
  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(12),
  );

  Widget _productImage(String url) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        url,
        width: 100,
        height: 100,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 100,
          height: 100,
          color: Colors.grey[300],
          child: const Icon(Icons.broken_image, size: 40),
        ),
      ),
    );
  }

  Widget _timelineCard(List<ShippingComments> commentsList) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: commentsList.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 6),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.orderstatusName ?? "---",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Nunito',
                      ),
                    ),
                    const SizedBox(height: 2),

                    Text(
                      item.oshistoryDateAdded ?? "",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Nunito',
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _addressSection({
    required String name,
    required String phone,
    required String a1,
    required String a2,
    required String city,
    required String state,
    required String country,
    required String zip,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$name | $phone",
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'Nunito',
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          a1,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'Nunito',
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          a2,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'Nunito',
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          "$city, $state",
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'Nunito',
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        Text(
          "$country, $zip",
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontFamily: 'Nunito',
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _rowItem(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _bottomButton(
    String text,
    Color bg,
    Color textColor, {
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10), // ripple respects border radius
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Nunito',
            fontWeight: FontWeight.w500,
            color: textColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _sectionContainer({
    required String title,
    Widget? child,
    Widget? trailing,
    VoidCallback? onTap, // <-- add onTap
  }) {
    return GestureDetector(
      onTap: onTap, // <-- handle tap
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: _box(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'Nunito',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing,
              ],
            ),
            if (child != null) ...[const SizedBox(height: 8), child],
          ],
        ),
      ),
    );
  }
}
