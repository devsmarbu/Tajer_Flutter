import 'package:tajer/app/modules/Cart/cart_shipping/cart_listing_model/cart_listing_model.dart';

class CartUpdateModel {
  final String? responseCode;
  final String? status;
  final CartUpdateData? data;
  final String? msg;

  CartUpdateModel({
    this.responseCode,
    this.status,
    this.data,
    this.msg,
  });

  factory CartUpdateModel.fromJson(Map<String, dynamic> json) => CartUpdateModel(
    responseCode: json["responseCode"],
    status: json["status"]?.toString(),
    data: json["data"] == null ? null : CartUpdateData.fromJson(json["data"]),
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "status": status,
    "data": data?.toJson(),
    "msg": msg,
  };
}

class CartUpdateData {
  final String? currencySymbol;
  final String? totalUnreadNotificationCount;
  final String? remainingWalletBalance;
  final String? userWalletBalance;
  final String? canBeUseRpAmt;
  final String? rewardPoints;
  final String? totalUnreadMessageCount;
  final String? canBeUseRp;
  final String? totalFavouriteItems;
  final String? displayUserWalletBalance;
  final NetPayable? netPayable;
  final List<NetPayable>? priceDetail;
  final CartSummary? cartSummary;
  final String? cartItemsCount;
  final String? orderNetAmount;
  final String? walletCharged;
  final String? displayRemainingWalletBalance;

  CartUpdateData({
    this.currencySymbol,
    this.totalUnreadNotificationCount,
    this.remainingWalletBalance,
    this.userWalletBalance,
    this.canBeUseRpAmt,
    this.rewardPoints,
    this.totalUnreadMessageCount,
    this.canBeUseRp,
    this.totalFavouriteItems,
    this.displayUserWalletBalance,
    this.netPayable,
    this.priceDetail,
    this.cartSummary,
    this.cartItemsCount,
    this.orderNetAmount,
    this.walletCharged,
    this.displayRemainingWalletBalance,
  });

  factory CartUpdateData.fromJson(Map<String, dynamic> json) => CartUpdateData(
    currencySymbol: json["currencySymbol"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    remainingWalletBalance: json["remainingWalletBalance"],
    userWalletBalance: json["userWalletBalance"],
    canBeUseRpAmt: json["canBeUseRPAmt"],
    rewardPoints: json["rewardPoints"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    canBeUseRp: json["canBeUseRP"],
    totalFavouriteItems: json["totalFavouriteItems"],
    displayUserWalletBalance: json["displayUserWalletBalance"],
    netPayable: json["netPayable"] == null ? null : NetPayable.fromJson(json["netPayable"]),
    priceDetail: json["priceDetail"] == null ? [] : List<NetPayable>.from(json["priceDetail"]!.map((x) => NetPayable.fromJson(x))),
    cartSummary: json["cartSummary"] == null ? null : CartSummary.fromJson(json["cartSummary"]),
    cartItemsCount: json["cartItemsCount"],
    orderNetAmount: json["orderNetAmount"],
    walletCharged: json["walletCharged"],
    displayRemainingWalletBalance: json["displayRemainingWalletBalance"],
  );

  Map<String, dynamic> toJson() => {
    "currencySymbol": currencySymbol,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "remainingWalletBalance": remainingWalletBalance,
    "userWalletBalance": userWalletBalance,
    "canBeUseRPAmt": canBeUseRpAmt,
    "rewardPoints": rewardPoints,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "canBeUseRP": canBeUseRp,
    "totalFavouriteItems": totalFavouriteItems,
    "displayUserWalletBalance": displayUserWalletBalance,
    "netPayable": netPayable?.toJson(),
    "priceDetail": priceDetail == null ? [] : List<dynamic>.from(priceDetail!.map((x) => x.toJson())),
    "cartSummary": cartSummary?.toJson(),
    "cartItemsCount": cartItemsCount,
    "orderNetAmount": orderNetAmount,
    "walletCharged": walletCharged,
    "displayRemainingWalletBalance": displayRemainingWalletBalance,
  };
}

class CartDiscounts {
  CartDiscounts();

  factory CartDiscounts.fromJson(Map<String, dynamic> json) => CartDiscounts(
  );

  Map<String, dynamic> toJson() => {
  };
}

class NetPayable {
  final String? value;
  final String? key;

  NetPayable({
    this.value,
    this.key,
  });

  factory NetPayable.fromJson(Map<String, dynamic> json) => NetPayable(
    value: json["value"],
    key: json["key"],
  );

  Map<String, dynamic> toJson() => {
    "value": value,
    "key": key,
  };
}
