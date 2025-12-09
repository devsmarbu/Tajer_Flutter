class AddToCartModel {
  final String? status;
  final String? msg;
  final AddToCartData? data;
  final String? responseCode;

  AddToCartModel({
    this.status,
    this.msg,
    this.data,
    this.responseCode,
  });

  factory AddToCartModel.fromJson(Map<String, dynamic> json) => AddToCartModel(
    status: json["status"]?.toString(),
    msg: json["msg"],
    data: json["data"] == null ? null : AddToCartData.fromJson(json["data"]),
    responseCode: json["responseCode"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
    "responseCode": responseCode,
  };
}

class AddToCartData {
  final String? tempUserId;
  final String? cartItemsCount;
  final String? currencySymbol;
  final String? totalFavouriteItems;
  final String? totalUnreadNotificationCount;
  final String? totalUnreadMessageCount;

  AddToCartData({
    this.tempUserId,
    this.cartItemsCount,
    this.currencySymbol,
    this.totalFavouriteItems,
    this.totalUnreadNotificationCount,
    this.totalUnreadMessageCount,
  });

  factory AddToCartData.fromJson(Map<String, dynamic> json) => AddToCartData(
    tempUserId: json["tempUserId"],
    cartItemsCount: json["cartItemsCount"],
    currencySymbol: json["currencySymbol"],
    totalFavouriteItems: json["totalFavouriteItems"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
  );

  Map<String, dynamic> toJson() => {
    "tempUserId": tempUserId,
    "cartItemsCount": cartItemsCount,
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "totalUnreadMessageCount": totalUnreadMessageCount,
  };
}