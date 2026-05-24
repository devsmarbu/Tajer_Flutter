import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';
import 'package:tajer/app/Extensions/convert_extension.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:tajer/app/modules/orders/orderDetail/controller/order_details_controller.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/order_detail.dart';
import 'package:tajer/common/functions/app_function.dart';
import 'package:tajer/utils/app_strings.dart';

import '../../../../../../utils/app_colors.dart';
import '../../../../../utils/app_params.dart';
import '../../orderDetail/models/child_order_detail_item.dart';
import '../../orderDetail/models/order_detail_data.dart';
import '../../orderDetail/view/order_details_screen.dart';
import 'my_order_view.dart';

class OrderCard extends StatelessWidget {
  final OrderDetail? order;
  final ChildOrderDetailItem? childOrderDetailItem;
  final VoidCallback? onActionCompleted;

  const OrderCard({super.key, this.order, this.childOrderDetailItem, this.onActionCompleted});

  @override
  Widget build(BuildContext context) {
    // Decide which model to use
    final controller = Get.put(OrderDetailsController());
    final isParentOrder = order != null;

    // Extract values dynamically
    final orderId = isParentOrder
        ? (order!.orderId ?? '')
        : (childOrderDetailItem?.op_order_id ?? '');

    final orderNumber = isParentOrder
        ? (order!.orderNumber ?? '')
        : (childOrderDetailItem?.op_invoice_number ?? '');

    final productId = isParentOrder
        ? (order!.opId ?? '')
        : (childOrderDetailItem?.op_id ?? '');

    final selProdId = isParentOrder
        ? (order!.opSelprodId ?? '')
        : (childOrderDetailItem?.selprod_id ?? '');

    final productImage = isParentOrder
        ? (order!.productImageUrl ?? '')
        : (childOrderDetailItem?.product_image_url ?? '');

    final statusName = isParentOrder
        ? (order!.orderstatusName ?? '')
        : (childOrderDetailItem?.orderstatus_name ?? '');

    final statusCode = isParentOrder
        ? (order!.opStatusId ?? '')
        : (childOrderDetailItem?.op_status_id ?? '');

    final statusIcon = isParentOrder
        ? (order?.statusIcon)
        : (childOrderDetailItem?.statusIcon ?? '');

    final statusColorCode = isParentOrder
        ? (order!.orderstatusColorCode ?? '')
        : (childOrderDetailItem?.orderstatus_color_code ?? '');

    final baseColor = hexToColor(statusColorCode); // "#5578eb"

    final dateAdded = isParentOrder
        ? (order!.orderDateAdded ?? '')
        : (childOrderDetailItem?.order_date_added ?? '');

    final invoiceNumber = isParentOrder
        ? (order!.opInvoiceNumber ?? '')
        : (childOrderDetailItem?.op_invoice_number ?? '');

    final title = isParentOrder
        ? (order!.opSelprodTitle ?? '')
        : (childOrderDetailItem?.op_selprod_title ?? '');

    final qty = isParentOrder
        ? (order!.opQty ?? '')
        : (childOrderDetailItem?.op_qty ?? '');

    final returnUntil = isParentOrder
        ? (order?.return_until_date ?? '')
        : (childOrderDetailItem?.return_until_date ?? '');
    final exchangeUntil = isParentOrder
        ? (order?.exchange_until_date ?? '')
        : (childOrderDetailItem?.exchange_until_date ?? '');

    final returnRequested = isParentOrder
        ? (order?.return_request_date ?? '')
        : (childOrderDetailItem?.return_request_date ?? '');

    final exchangeRequested = isParentOrder
        ? (order?.exchange_request_date ?? '')
        : (childOrderDetailItem?.exchange_request_date ?? '');

    final canReturnOrder = isParentOrder
        ? (order?.canReturnOrder ?? '')
        : (childOrderDetailItem?.canReturnOrder ?? '');
    final canExchangeOrder = isParentOrder
        ? (order?.canExchangeOrder ?? '')
        : (childOrderDetailItem?.canExchangeOrder ?? '');

    final messageCount = isParentOrder
        ? (order?.message_count ?? '').toIntSafe()
        : (childOrderDetailItem?.message_count ?? '').toIntSafe();
    final returnRequestId = isParentOrder
        ? (order?.returnRequest ?? '')
        : (childOrderDetailItem?.return_request ?? '');
    final exchangeRequestId = isParentOrder
        ? (order?.exchangeRequest ?? '')
        : (childOrderDetailItem?.exchange_request ?? '');

    final formattedReturnDate = AppFunction.getDateFormat(
      returnUntil,
      "d MMM",
      inputFormatStr: 'yyyy-MM-dd HH:mm:ss',
    );

    final formattedExchangeDate = AppFunction.getDateFormat(
      exchangeUntil,
      "d MMM",
    );

    final formattedReturnRequestedDate = AppFunction.getDateFormat(
      returnRequested,
      "d MMM",
      inputFormatStr: 'yyyy-MM-dd HH:mm:ss',
    );

    final formattedExchangeRequestedDate = AppFunction.getDateFormat(
      exchangeRequested,
      "d MMM",
    );

    final options = isParentOrder
        ? (order!.opSelprodOptions ?? '')
        : (childOrderDetailItem?.op_selprod_options ?? '');

    final totalOrders = isParentOrder
        ? int.tryParse(order!.totOrders ?? "0") ?? 0
        : int.tryParse("0") ?? 0;
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          debugPrint(selProdId);
          Get.to(
            () => OrderDetailsScreen(
              orderId: orderId,
              orderProductId: productId,
              orderNumber: orderNumber,
              quantity: qty,
              selProdId: selProdId,
            ),
          );
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Top Row (Status + Date)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: isRTL
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        end: isRTL
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        colors: [
                          baseColor.withOpacity(0),
                          baseColor.withOpacity(0.0),
                          baseColor.withOpacity(0.04),
                          baseColor.withOpacity(0.1),
                          baseColor.withOpacity(0.2),
                          baseColor.withOpacity(0.3),
                        ],
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          statusIcon ?? '',
                          width: 18,
                          height: 15,
                          colorFilter: const ColorFilter.mode(
                            Colors.black87,
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          statusName,
                          style: const TextStyle(
                            fontSize: 12,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "${'APP_ON'.tr} ${AppFunction.getDateFormat(dateAdded, "dd, MMM, hh:mm a")}",
                    style: TextStyle(
                      fontSize: 12,
                      fontFamily: 'Nunito',
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),
              // Divider(color: Colors.grey.shade300, thickness: 1),
              // const SizedBox(height: 8),

              // 🔹 Product row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      productImage,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.image_not_supported),
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Align(
                      alignment: Alignment.topLeft, // keeps text top aligned
                      child: Column(
                        spacing: 2,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 2),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 13,
                              fontFamily: 'nunito',
                              fontWeight: FontWeight.w600,
                              color: AppColors.black1,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "QTY: $qty | $options",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Nunito',
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '${'APP_ORDER_NO'.tr} $invoiceNumber',
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          // const SizedBox(height: 6),
                          // if (totalOrders > 1 && isParentOrder)
                          //   GestureDetector(
                          //     onTap: () {
                          //       Get.to(
                          //         () => MyOrdersView(),
                          //         arguments: {
                          //           AppParams.orderId: orderId,
                          //           AppParams.orderNumber: orderNumber,
                          //         },
                          //       );
                          //     },
                          //     child: Text(
                          //       AppStrings.appViewCompleteOrder
                          //           .toUpperCase()
                          //           .tr,
                          //       style: const TextStyle(
                          //         fontSize: 14,
                          //         fontFamily: 'Nunito',
                          //         fontWeight: FontWeight.w400,
                          //         color: AppColors.black1,
                          //         decoration: TextDecoration.underline,
                          //       ),
                          //     ),
                          //   ),
                        ],
                      ),
                    ),
                  ),
                  // ✅ THIS is the key fix
                  SizedBox(
                    height: 90, // same as image height
                    child: Center(
                      child: Icon(Icons.chevron_right, color: Colors.black54),
                    ),
                  ),
                ],
              ),
              // 🔹 Buttons Row
              if (canExchangeOrder == '1' || canReturnOrder == '1')
                Column(
                  children: [
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        if (canExchangeOrder == '1')
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Exchange action

                                Get.toNamed(
                                  AppRoutes.returnOrderScreen,
                                  arguments: {
                                    'quantity':
                                        order?.opQty ??
                                        childOrderDetailItem?.op_qty ??
                                        '1',
                                    AppParams.optId:
                                        order?.opId ??
                                        childOrderDetailItem?.op_id ??
                                        '0',
                                    AppParams.returnType: AppConstants.exchange,
                                    'orderDetail': order ?? childOrderDetailItem
                                  },
                                )?.then((value) {
                                  // 🔥 REFRESH ORDER DETAILS
                                  onActionCompleted?.call();
                                });
                              },
                              icon: const Icon(Icons.swap_horiz, size: 18),
                              label: Text(
                                "APP_EXCHANGE".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ),
                        const SizedBox(width: 10),
                        if (canReturnOrder == '1')
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {
                                // TODO: Return action
                                Get.toNamed(
                                  AppRoutes.returnOrderScreen,
                                  arguments: {
                                    'quantity':
                                        order?.opQty ??
                                        childOrderDetailItem?.op_qty ??
                                        '1',
                                    AppParams.optId:
                                        order?.opId ??
                                        childOrderDetailItem?.op_id ??
                                        '0',
                                    AppParams.returnType:
                                        AppConstants.returnOrder,
                                    'orderDetail': order ?? childOrderDetailItem
                                  },
                                )?.then((value) {
                                  // 🔥 REFRESH ORDER DETAILS
                                  onActionCompleted?.call();
                                });
                              },
                              icon: const Icon(Icons.keyboard_return, size: 18),
                              label: Text(
                                "APP_RETURN".tr,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  side: const BorderSide(
                                    color: Colors.black,
                                    width: 4,
                                  ),
                                ),
                                foregroundColor: Colors.black,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    if (canReturnOrder == '1' || canExchangeOrder == '1')
                      Center(
                        child: RichText(
                          text: TextSpan(
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontFamily: 'Nunito',
                              fontWeight: FontWeight.w500,
                            ),
                            children: [
                              // 🔹 BOTH
                              if (canReturnOrder == '1' &&
                                  canExchangeOrder == '1') ...[
                                TextSpan(text: 'APP_RETURN_TILL'.tr),
                                TextSpan(
                                  text: formattedReturnDate,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                TextSpan(text: 'APP_SEPARATOR'.tr),
                                TextSpan(text: 'APP_EXCHANGE_TILL'.tr),
                                TextSpan(
                                  text: formattedExchangeDate,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ]
                              // 🔹 ONLY RETURN
                              else if (canReturnOrder == '1') ...[
                                TextSpan(text: 'APP_RETURN_TILL'.tr),
                                TextSpan(
                                  text: formattedReturnDate,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ]
                              // 🔹 ONLY EXCHANGE
                              else if (canExchangeOrder == '1') ...[
                                TextSpan(
                                  text: 'APP_EXCHANGE_AVAILABLE_TILL'.tr,
                                ),
                                TextSpan(
                                  text: formattedExchangeDate,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              if (statusCode == '6' || statusCode == '20')
                Column(
                  children: [
                    const SizedBox(height: 16),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                            fontFamily: 'Nunito',
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            // 🔹 Dynamic label
                            TextSpan(
                              text: (statusCode == '20')
                                  ? AppStrings.appExchange.tr
                                  : AppStrings.appReturn.tr,
                            ),
                            const TextSpan(text: " "),
                            TextSpan(text: "APP_REQUESTED_ON".tr),
                            const TextSpan(text: " "),
                            // 🔹 Date (bold)
                            TextSpan(
                              text: (statusCode == '20')
                                  ? formattedExchangeRequestedDate
                                  : formattedReturnRequestedDate,
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

              if ((statusCode == '6' || statusCode == '20') &&
                  (messageCount > 0))
                Column(
                  children: [
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () {
                        controller.openMessages(
                          statusCode == '6'
                              ? returnRequestId
                              : exchangeRequestId,
                          statusCode == '6'
                              ? AppStrings.app_return_request
                              : AppStrings.app_exchange_request,
                          order?.opSelprodTitle ?? '',
                        );
                      },
                      // borderRadius: BorderRadius.circular(12), // 👈 ripple boundary (optional)
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDF3FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              'assets/icons/Bell.svg',
                              width: 20,
                              height: 18,
                              colorFilter: const ColorFilter.mode(
                                Colors.black87,
                                BlendMode.srcIn,
                              ),
                            ),
                            const SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                "$messageCount ${"APP_NEW_MESSAGES".tr}",
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Nunito',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ),

                            const Icon(
                              Icons.chevron_right,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 12),

              if (childOrderDetailItem != null)
                _bottomButton(
                  ((childOrderDetailItem?.selprod_stock ?? "0").toIntSafe() > 0)
                      ? AppStrings.appReorder.tr
                      : "APP_SOLD_OUT".tr,
                  ((childOrderDetailItem?.selprod_stock ?? "0").toIntSafe() > 0)
                      ? Colors.black
                      : Colors.grey,
                  Colors.white,
                  onTap: () {
                    if ((childOrderDetailItem?.selprod_stock ?? "0")
                            .toIntSafe() >
                        0) {
                       controller.reOrderProduct(childOrderDetailItem!);
                    }
                  },
                ),
            ],
          ),
        ),
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
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: double.infinity,
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
            fontWeight: FontWeight.w600,
            color: textColor,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Color hexToColor(String hex) {
    hex = hex.replaceAll("#", "");

    if (hex.length == 8) {
      // Convert RGBA -> ARGB
      hex = hex.substring(6, 8) + hex.substring(0, 6);
    } else if (hex.length == 6) {
      hex = "FF$hex";
    }

    return Color(int.parse(hex, radix: 16));
  }
}
