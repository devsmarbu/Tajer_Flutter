class ConfirmOrderModel {
  final String? status;
  final String? responseCode;
  final String? msg;
  final ConfirmModelData? data;

  ConfirmOrderModel({
    this.status,
    this.responseCode,
    this.msg,
    this.data,
  });

  factory ConfirmOrderModel.fromJson(Map<String, dynamic> json) => ConfirmOrderModel(
    status: json["status"],
    responseCode: json["responseCode"],
    msg: json["msg"],
    data: json["data"] == null ? null : ConfirmModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "responseCode": responseCode,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class ConfirmModelData {
  final String? currencySymbol;
  final String? totalFavouriteItems;
  final String? totalUnreadMessageCount;
  final String? totalUnreadNotificationCount;
  final String? cartItemsCount;
  final String? sendToWeb;
  final String? orderPayment;

  ConfirmModelData({
    this.currencySymbol,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.sendToWeb,
    this.orderPayment,
  });

  factory ConfirmModelData.fromJson(Map<String, dynamic> json) => ConfirmModelData(
    currencySymbol: json["currencySymbol"],
    totalFavouriteItems: json["totalFavouriteItems"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    cartItemsCount: json["cartItemsCount"],
    sendToWeb: json["sendToWeb"],
    orderPayment: json["orderPayment"],
  );

  Map<String, dynamic> toJson() => {
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "sendToWeb": sendToWeb,
    "orderPayment": orderPayment,
  };
}
