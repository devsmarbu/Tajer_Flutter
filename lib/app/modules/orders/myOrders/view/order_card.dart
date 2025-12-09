import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
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

  const OrderCard({
    super.key,
    this.order,
    this.childOrderDetailItem,
  });

  @override
  Widget build(BuildContext context) {
    // Decide which model to use
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

    final productImage = isParentOrder
        ? (order!.productImageUrl ?? '')
        : (childOrderDetailItem?.product_image_url ?? '');

    final statusName = isParentOrder
        ? (order!.orderstatusName ?? '')
        : (childOrderDetailItem?.orderstatus_name ?? '');

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

    final options = isParentOrder
        ? (order!.opSelprodOptions ?? '')
        : (childOrderDetailItem?.op_selprod_options ?? '');

    final totalOrders = isParentOrder
        ? int.tryParse(order!.totOrders ?? "0") ?? 0
        : int.tryParse("0") ?? 0;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Get.to(() => OrderDetailsScreen(
            orderId: orderId,
            orderProductId: productId,
            orderNumber: orderNumber,
          ));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
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
                  Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.blue, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        statusName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'nunito',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    AppFunction.getDateFormat(
                        dateAdded, "dd-MMM-yyyy, HH:mm"),
                    style: const TextStyle(
                      fontSize: 12,
                      fontFamily: 'nunito',
                      color: AppColors.black1,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),
              Divider(color: Colors.grey.shade300, thickness: 1),
              const SizedBox(height: 8),

              // 🔹 Product row
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      productImage,
                      width: 70,
                      height: 70,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported),
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          invoiceNumber,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.black1,
                            fontFamily: 'nunito',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontFamily: 'nunito',
                            fontWeight: FontWeight.w300,
                            color: AppColors.black1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "QTY: $qty | $options",
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'nunito',
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 6),

                        if (totalOrders > 1 && isParentOrder)
                          GestureDetector(
                            onTap: () {
                              Get.to(() => MyOrdersView(),
                                  arguments: {
                                    AppParams.orderId: orderId,
                                    AppParams.orderNumber: orderNumber,
                                  });
                            },
                            child: Text(
                              AppStrings.appViewCompleteOrder
                                  .toUpperCase()
                                  .tr,
                              style: const TextStyle(
                                fontSize: 14,
                                fontFamily: 'nunito',
                                fontWeight: FontWeight.w400,
                                color: AppColors.black1,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),

                        const SizedBox(height: 6),
                      ],
                    ),
                  ),

                  const Align(
                    alignment: Alignment.center,
                    child:
                    Icon(Icons.chevron_right, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

