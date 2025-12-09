import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../utils/app_strings.dart';
import '../../home/header_view/header_view.dart';
import '../order_success_page/order_success_model.dart';


class OrderSuccessPriceDetailView extends StatelessWidget {
  final List<OrderSummary>? orderSummary;
  final String? orderNetAmount;
  const OrderSuccessPriceDetailView({super.key, required this.orderSummary, this.orderNetAmount});

  @override
  Widget build(BuildContext context) {
    return
      Column(
        // spacing: 40,
          children: [
            HeaderView(titleHeader: AppStrings.appOrderDetails.toUpperCase().tr,hideSeeAll: true,isHomeHeader: false),
            Container(
              margin: EdgeInsets.fromLTRB(12,0,12,5),
              padding: EdgeInsets.all(15),
              decoration:
              BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child:
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Generate rows dynamically from list
                  ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderSummary?.length ?? 0,
                    separatorBuilder: (_, __) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(orderSummary?[index].key ?? "",style: TextStyle(fontFamily: "Nunito")),
                          Text(
                            orderSummary?[index].value ?? "",
                            style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Nunito"),
                          ),
                        ],
                      );
                    },
                  ),

                  Divider(height: 24, thickness: 1,color: Colors.grey[200]),

                  // Total row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(AppStrings.appTotal.toUpperCase().tr,
                          style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Nunito", fontSize: 16)),
                      Text(orderNetAmount ?? "",
                          style: TextStyle(fontWeight: FontWeight.w600,fontFamily: "Nunito", fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
          ]);
  }
}