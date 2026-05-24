import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/price_detail.dart';
import 'package:tajer/common/functions/app_function.dart';
import 'package:tajer/utils/app_colors.dart';
import 'package:tajer/utils/app_params.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../return/cancelOrder/cancel_order.dart';
import '../../../review/rating/view/rating_screen.dart';
import '../../myOrders/view/order_card.dart';
import '../controller/order_details_controller.dart';
import '../models/child_order_detail_item.dart';
import '../models/order_detail.dart';
import '../models/shipping_comments.dart';

class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final String orderProductId;
  final String orderNumber;
  final String quantity;
  final String selProdId;

  const OrderDetailsScreen({
    super.key,
    required this.orderId,
    required this.orderProductId,
    required this.orderNumber,
    required this.quantity,
    required this.selProdId,
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
    controller.selProdId.value = widget.selProdId;
    controller.fetchOrders(widget.orderId);
  }

  @override
  Widget build(BuildContext context) {
    final order = controller.orderModel.value?.childOrderDetail?.first;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.white,
        titleSpacing: 0,
        centerTitle: false,
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
        actions: [
          Obx(() {
            final order = controller.orderModel.value?.childOrderDetail?.first;

            if (order == null) return const SizedBox();

            final status = order.op_status_id;

            if (!shouldShowMessageButton(status)) {
              return const SizedBox();
            }

            final messageCount = order.message_count ?? "0";

            return GestureDetector(
              onTap: () {
                // TODO: Navigate to messages screen
                final order =
                    controller.orderModel.value?.childOrderDetail?.first;
                final statusCode = order?.op_status_id ?? '';
                final returnRequestId = order?.return_request ?? '';
                final exchangeRequestId = order?.exchange_request ?? '';
                final missingRequestId = order?.missing_request ?? '';

                String requestId = '';
                String screen = '';

                if (statusCode == '6') {
                  requestId = returnRequestId;
                  screen = AppStrings.app_return_request;
                } else if (statusCode == '20') {
                  requestId = exchangeRequestId;
                  screen = AppStrings.app_exchange_request;
                } else if (statusCode == '19') {
                  requestId = missingRequestId;
                  screen = AppStrings.app_return_request;
                }

                controller.openMessages(
                  requestId,
                  screen,
                  order?.selprod_title ?? '',
                );
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    'assets/icons/ChatCircle.svg', // 👈 your asset
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),

                  const SizedBox(width: 6),

                  Text(
                    "APP_BTN_MESSAGES".tr,
                    style: TextStyle(
                      fontSize: 17,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 5),
                  // 🔵 Badge
                  if (messageCount.toIntSafe() > 0)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFFBBD7EA), // 👈 light blue
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        messageCount, // 👈 dynamic later
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  const SizedBox(width: 10),
                ],
              ),
            );
          }),
        ],
      ),
      body: Obx(() {
        final order = controller.orderModel.value?.childOrderDetail?.first;
        final otherProducts = controller.orderModel.value?.otherOrderProducts;
        final totalKey = AppStrings.appTotal.toUpperCase().tr;
        int hours = AppFunction.getRemainingHours(
          order?.cancel_until_date ?? "",
        );
        debugPrint('hours $hours');

        if (order == null) {
          return Container();
        }

        // Ensure priceDetail list is initialized
        order.priceDetail ??= [];
        // Add total price if not already added
        if (!order.priceDetail!.any(
          (item) => item.key == AppStrings.app_total,
        )) {
          if (!order.priceDetail!.any((item) => item.key == totalKey)) {
            order.priceDetail!.add(
              PriceDetail(
                key: totalKey,
                value: order.totalAmount?.value.toString() ?? "",
                isBold: true,
              ),
            );
          }
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              // PRODUCT CARD
              OrderCard(childOrderDetailItem: order),
              const SizedBox(height: 12),

              //return/exchange/missing request submitted info
              if (order.requestInfo != null) ...[
                const SizedBox(height: 12),
                requestInfoCard(
                  reason: order.requestInfo?.reason ?? "",
                  comments: order.requestInfo?.comments ?? "",
                ),
              ],
              //missing product
              if (order.canMissingProductRequest.toString() == "1") ...[
                const SizedBox(height: 12),
                _sectionContainer(
                  title: 'APP_DIDNT_RECEIVE'.tr,
                  trailing: GestureDetector(
                    onTap: () {
                      // handle missing
                      Get.toNamed(
                        AppRoutes.returnOrderScreen,
                        arguments: {
                          'quantity': widget.quantity,
                          AppParams.optId: order.op_id,
                          AppParams.returnType: AppConstants.missing,
                          'orderDetail': order,
                        },
                      )?.then((value) {
                        // 🔥 REFRESH ORDER DETAILS
                        controller.fetchOrders(widget.orderId);
                      });
                    },
                    child: Text(
                      'APP_REPORT_MISSING'.tr,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.w600,
                        fontFamily: "Nunito",
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 12),

              // Order details
              _sectionContainer(
                title: AppStrings.appOrderDetails.toUpperCase().tr,
                trailing: GestureDetector(
                  onTap: controller.orderReceipt,
                  child: Text(
                    AppStrings.appEmailOrderReceipt.tr,
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                      fontSize: 15,
                    ),
                  ),
                ),
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

              //other items section
              if ((otherProducts ?? []).isNotEmpty)
                _otherItemsSection(otherProducts ?? []),
              // -------------------------------
              // RATING
              // -------------------------------
              if (order.reviewsAllowed == "1" && order.canSubmitFeedback == "1")
                _sectionContainer(
                  title: AppStrings.appRating.toUpperCase().tr,
                  trailing: GestureDetector(
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
                        fontSize: 15,
                        fontFamily: 'Nunito',
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                  child: Row(
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () => controller.updateRating(index + 1.0),
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Icon(
                            index < controller.rating.value
                                ? Icons.star
                                : Icons.star_border,
                            size: 25, // 👈 smaller like design
                            color: Colors.yellow[700], // 👈 match UI
                          ),
                        ),
                      );
                    }),
                  ),
                ),

              // -------------------------------
              // PAYMENT METHOD
              // -------------------------------
              _sectionContainer(
                title: AppStrings.appPaymentMethod.tr,
                child: Text(
                  order.plugin_name ?? "",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              // -------------------------------
              // SHIPPING MODE
              // -------------------------------
              _sectionContainer(
                title: AppStrings.appShippingMode.tr,
                child: Text(
                  order.opshipping_label.toString(),
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Nunito",
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // PAYMENT TIMELINE
              // -------------------------------
              _timelineCard(
                (controller.orderModel.value!.orderDetail!.comments ?? [])
                    .reversed
                    .toList(),
              ),

              const SizedBox(height: 12),

              // -------------------------------
              // BILLING DETAILS
              // -------------------------------
              _sectionContainer(
                title: 'APP_DELIVERY_DETAILS'.tr,
                child: _addressSection(
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
                  zip: "",
                ),
              ),

              if ((order.canCancelOrder == '1')) ...[
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'APP_CANCEL_WITHIN_HOURS'.trParams({
                          'hours': hours.toString().isEmpty
                              ? '0'
                              : hours.toString(),
                        }),
                        style: const TextStyle(
                          fontSize: 12,
                          fontFamily: 'Nunito',
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          Get.to(
                            () => CancelOrderScreen(opId: order.op_id ?? ''),
                          );
                        },
                        child: Text(
                          'APP_CANCEL_ORDER'.tr,
                          maxLines: 2,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 25),
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

  Widget _timelineCard(List<ShippingComments> list) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 5),
      decoration: _box(),
      child: Column(
        children: List.generate(list.length, (index) {
          final item = list[index];
          final isLast = index == list.length - 1;
          final formattedDate = AppFunction.getDateFormat(
            item.oshistoryDateAdded ?? "",
            "d, MMM, hh:mm a",
            inputFormatStr: 'yyyy-MM-dd HH:mm:ss',
          );

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  // circle
                  Container(
                    width: 18,
                    height: 18,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      size: 14,
                      color: Colors.white,
                    ),
                  ),

                  // line
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 45,
                      color: Colors.grey.shade400,
                    ),
                ],
              ),

              const SizedBox(width: 5),

              Expanded(
                child: Transform.translate(
                  offset: const Offset(0, -2), // 👈 move up by 2px
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 0, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.orderstatusName ?? "",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Nunito",
                            color: Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${'APP_ON'.tr} $formattedDate',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Nunito",
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _addressSection({
    required String phone,
    required String a1,
    required String a2,
    required String city,
    required String state,
    required String country,
    required String zip,
  }) {
    String fullAddress =
        "$a1 ${a2.isNotEmpty ? ', $a2' : ''}, $city, $state, $country";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------------- CONTACT ----------------
        _infoTile(
          iconPath: 'assets/icons/phone.svg',
          title: 'APP_CONTACT'.tr,
          value: phone,
        ),

        const SizedBox(height: 16),

        // ---------------- BILLING ----------------
        _infoTile(
          iconPath: 'assets/icons/location.svg',
          title: 'APP_BILLING_ADDRESS'.tr,
          value: fullAddress,
        ),

        const SizedBox(height: 16),

        // ---------------- SHIPPING ----------------
        _infoTile(
          iconPath: 'assets/icons/location.svg',
          title: "APP_SHIPPING_ADDRESS".tr,
          value: fullAddress,
        ),
      ],
    );
  }

  Widget _infoTile({
    required String iconPath,
    required String title,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 2),
          child: SvgPicture.asset(
            iconPath,
            width: 20,
            height: 25,
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.srcIn,
            ), // 👈 tint like design
          ),
        ),
        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontFamily: 'Nunito',
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
            ],
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
              color: Colors.black54,
              fontSize: 14,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
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
                    fontSize: 16,
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

  Widget _otherItemsSection(List<dynamic> items) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'APP_OTHER_ITEMS_IN_ORDER'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              fontFamily: 'Nunito',
            ),
          ),
          const SizedBox(height: 12),
          ...items.map((item) => _otherItemCard(item)).toList(),
        ],
      ),
    );
  }

  Widget _otherItemCard(OtherOrderProduct item) {
    return GestureDetector(
      onTap: () {
        /// 👇 update selected product id
        controller.orderProductId.value = item.opId ?? "";

        /// 👇 call API again
        controller.fetchOrders(controller.orderId.value);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                item.image ?? "",
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.image_not_supported),
              ),
            ),
            const SizedBox(width: 12),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Nunito',
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        item.op_selprod_options ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontFamily: 'Nunito',
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "APP_SEPARATOR".tr,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontFamily: 'Nunito',
                        ),
                      ),
                      const SizedBox(width: 4),

                      Text(
                        "Qty: ${item.qty}",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontFamily: 'Nunito',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Text(
                    item.price ?? "",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Nunito',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget requestInfoCard({required String reason, required String comments}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, // light grey like image
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Reason title
          Text(
            "APP_REASON".tr,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Nunito',
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          // Reason value
          Text(
            reason,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),

          const SizedBox(height: 14),

          // Comments title
          Text(
            "APP_COMMENTS".tr,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Nunito',
              color: Colors.black54,
              fontWeight: FontWeight.w500,
            ),
          ),

          const SizedBox(height: 6),

          // Comments value
          Text(
            comments,
            style: const TextStyle(
              fontSize: 14,
              fontFamily: 'Nunito',
              fontWeight: FontWeight.w500,
              color: Colors.black,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  bool shouldShowMessageButton(String? status) {
    return status == '6' || status == '19' || status == '20';
  }
}
