import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/payment_summary_model/payment_summary_model.dart';
import 'package:tajer/utils/app_strings.dart';

import '../../home/header_view/header_view.dart';
import '../order_success_page/order_success_model.dart';

class OrderPriceDetailView extends StatelessWidget {
  final PaymentSummaryModel? paymentSummaryModel;

  const OrderPriceDetailView({super.key, required this.paymentSummaryModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: Key("order_price_detail_view"),
      // spacing: 40,
      children: [
        HeaderView(
          titleHeader: AppStrings.appOrderDetails.toUpperCase().tr,
          hideSeeAll: true,
          isHomeHeader: false,
        ),
        Container(
          margin: EdgeInsets.fromLTRB(12, 0, 12, 5),
          padding: EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Generate rows dynamically from list
              ListView.separated(
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                physics: NeverScrollableScrollPhysics(),
                itemCount: paymentSummaryModel?.data?.priceDetail?.length ?? 0,
                separatorBuilder: (_, __) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = paymentSummaryModel?.data?.priceDetail?[index];

                  final keyText = item?.key ?? "";
                  final valueText = item?.value ?? "";

                  // Check if row is Shipping Free
                  final isShippingFree =
                  keyText.toLowerCase().contains("shipping free") || keyText.toLowerCase().contains("الشحن مجاني");
                  //
                  // final isCouponDiscount =
                  // keyText.toLowerCase().contains("discount");

                 // final isGreenRow = isShippingFree || isCouponDiscount;

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                       keyText,
                        style: TextStyle(fontFamily: "Nunito",
                          color: Color(
                            int.parse(
                              (paymentSummaryModel?.data?.priceDetail?[index].colorCode ?? "0xFF000000")
                                  .replaceFirst("#", "0xFF"),
                            ),
                          ),
                          fontWeight: FontWeight.w600),
                      ),
                      Text(
                        valueText,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: "Nunito",
                          color: Color(
                            int.parse(
                              (paymentSummaryModel?.data?.priceDetail?[index].colorCode ?? "0xFF000000")
                                  .replaceFirst("#", "0xFF"),
                            ),
                          ),

                          decoration: isShippingFree
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          decorationColor:
                          isShippingFree ? Colors.green : Colors.transparent,
                            decorationThickness: 2.5
                        ),
                      ),
                    ],
                  );
                },
              ),

              Divider(height: 24, thickness: 1, color: Colors.grey[200]),

              // Total row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.appTotal.toUpperCase().tr,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Nunito",
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    paymentSummaryModel?.data?.netPayable?.value ?? "",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: "Nunito",
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
