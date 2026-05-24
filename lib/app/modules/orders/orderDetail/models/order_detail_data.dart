import 'package:tajer/app/modules/orders/orderDetail/models/order_detail_account.dart';

import 'child_order_detail_item.dart';
import 'order_detail.dart';
import 'shipping_address.dart';
import 'shipping_comments.dart';
import 'price_detail.dart';

class OrderDetailData {
  String? totalUnreadMessageCount;
  String? currencySymbol;
  String? totalUnreadNotificationCount;
  String? cartItemsCount;
  OrderDetailAccount? orderDetail;
  String? totalFavouriteItems;
  List<ChildOrderDetailItem>? childOrderDetail;
  List<OtherOrderProduct>? otherOrderProducts;
  String? primaryOrder;
  List<PriceDetail>? orderSummary;

  OrderDetailData({
    this.totalUnreadMessageCount,
    this.currencySymbol,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.orderDetail,
    this.totalFavouriteItems,
    this.childOrderDetail,
    this.primaryOrder,
    this.orderSummary,
    this.otherOrderProducts,
  });

  factory OrderDetailData.fromJson(Map<String, dynamic> json) {
    return OrderDetailData(
      totalUnreadMessageCount: json['totalUnreadMessageCount'],
      currencySymbol: json['currencySymbol'],
      totalUnreadNotificationCount: json['totalUnreadNotificationCount'],
      cartItemsCount: json['cartItemsCount'],
      orderDetail: json['orderDetail'] != null
          ? OrderDetailAccount.fromJson(json['orderDetail'])
          : null,
      totalFavouriteItems: json['totalFavouriteItems'],
      childOrderDetail: json['childOrderDetail'] != null
          ? List<ChildOrderDetailItem>.from(
              json['childOrderDetail'].map(
                (x) => ChildOrderDetailItem.fromJson(x),
              ),
            )
          : [],
      otherOrderProducts: json['otherOrderProducts'] != null
          ? List<OtherOrderProduct>.from(
              json['otherOrderProducts'].map(
                (x) => OtherOrderProduct.fromJson(x),
              ),
            )
          : [],
      primaryOrder: json['primaryOrder'],
      orderSummary: json['orderSummary'] != null
          ? List<PriceDetail>.from(
              json['orderSummary'].map((x) => PriceDetail.fromJson(x)),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "currencySymbol": currencySymbol,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "orderDetail": orderDetail?.toJson(),
    "totalFavouriteItems": totalFavouriteItems,
    "childOrderDetail": childOrderDetail?.map((x) => x.toJson()).toList() ?? [],
    "otherOrderProducts":
        otherOrderProducts?.map((x) => x.toJson()).toList() ?? [],
    "primaryOrder": primaryOrder,
    "orderSummary": orderSummary?.map((x) => x.toJson()).toList() ?? [],
  };
}
