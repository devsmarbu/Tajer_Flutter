import 'package:meta/meta.dart';
import 'package:tajer/app/modules/return/return_order/model/resason_item.dart';

class ReasonData {
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  List<ReasonsItem>? reasons;
  String? cartItemsCount;
  String? currencySymbol;
  String? totalFavouriteItems;

  ReasonData({
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.reasons,
    this.cartItemsCount,
    this.currencySymbol,
    this.totalFavouriteItems,
  });

  factory ReasonData.fromJson(Map<String, dynamic> json) {
    return ReasonData(
      totalUnreadMessageCount: json['totalUnreadMessageCount'],
      totalUnreadNotificationCount: json['totalUnreadNotificationCount'],
      reasons: json['reasons'] != null
          ? List<ReasonsItem>.from(
          json['reasons'].map((x) => ReasonsItem.fromJson(x)))
          : null,
      cartItemsCount: json['cartItemsCount'],
      currencySymbol: json['currencySymbol'],
      totalFavouriteItems: json['totalFavouriteItems'],
    );
  }

  Map<String, dynamic> toJson() => {
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "reasons": reasons?.map((x) => x.toJson()).toList(),
    "cartItemsCount": cartItemsCount,
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
  };
}


