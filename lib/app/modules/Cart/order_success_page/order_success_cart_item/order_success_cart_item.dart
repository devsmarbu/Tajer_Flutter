import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../order_success_model.dart';

class OrderSuccessCartItem extends StatelessWidget {
  final List<ChildOrderDetail> orderedItems;
  const OrderSuccessCartItem({super.key, required this.orderedItems});

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      width: deviceWidth,
      child: Column(
        spacing: 20,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...orderedItems.map((item) {
            return

              Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        item.productImageUrl ?? "",
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                      ),
                    ),
            SizedBox(width: 10),
            Expanded(
            child:
            Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Text(
              item.opSelprodTitle ?? "",
            style: const TextStyle(
            fontSize: 12,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            ),
             Text(
              "Qty: ${item.opQty}",
            style: const TextStyle(
            fontSize: 12,
            fontFamily: "Nunito",
            fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 4),
            Text(
            item.opSelprodOptions ?? "",
            style: TextStyle(
            color: Colors.grey[800],
            fontFamily: "Nunito",
            fontWeight: FontWeight.w500,
            fontSize: 11,
            ),
            ),
            Text(
            "${"APP_SOLD_BY".tr}: ${item.opShopName ?? ""}",
            style: TextStyle(
            color: Colors.grey[800],
            fontFamily: "Nunito",
            fontWeight: FontWeight.w500,
            fontSize: 11,
            ),
            ),
            const SizedBox(height: 4),
            ],
            ))
              ]);
          }),
        ],
      ),
    );
  }
}