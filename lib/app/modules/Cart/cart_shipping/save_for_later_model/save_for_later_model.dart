class SaveForLaterModel {
  final String? responseCode;
  final Data? data;
  final String? msg;
  final String? status;

  SaveForLaterModel({
    this.responseCode,
    this.data,
    this.msg,
    this.status,
  });

  factory SaveForLaterModel.fromJson(Map<String, dynamic> json) => SaveForLaterModel(
    responseCode: json["responseCode"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "data": data?.toJson(),
    "msg": msg,
    "status": status,
  };
}

class Data {
  final CartSummary? cartSummary;
  final String? canBeUseRp;
  final String? canBeUseRpAmt;
  final String? displayUserWalletBalance;
  final String? rewardPoints;
  final String? totalUnreadNotificationCount;
  final String? totalFavouriteItems;
  final String? cartItemsCount;
  final String? orderNetAmount;
  final String? walletCharged;
  final String? remainingWalletBalance;
  final String? userWalletBalance;
  final String? totalUnreadMessageCount;
  final List<NetPayable>? priceDetail;
  final String? currencySymbol;
  final NetPayable? netPayable;
  final String? displayRemainingWalletBalance;

  Data({
    this.cartSummary,
    this.canBeUseRp,
    this.canBeUseRpAmt,
    this.displayUserWalletBalance,
    this.rewardPoints,
    this.totalUnreadNotificationCount,
    this.totalFavouriteItems,
    this.cartItemsCount,
    this.orderNetAmount,
    this.walletCharged,
    this.remainingWalletBalance,
    this.userWalletBalance,
    this.totalUnreadMessageCount,
    this.priceDetail,
    this.currencySymbol,
    this.netPayable,
    this.displayRemainingWalletBalance,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    cartSummary: json["cartSummary"] == null ? null : CartSummary.fromJson(json["cartSummary"]),
    canBeUseRp: json["canBeUseRP"],
    canBeUseRpAmt: json["canBeUseRPAmt"],
    displayUserWalletBalance: json["displayUserWalletBalance"],
    rewardPoints: json["rewardPoints"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    totalFavouriteItems: json["totalFavouriteItems"],
    cartItemsCount: json["cartItemsCount"],
    orderNetAmount: json["orderNetAmount"],
    walletCharged: json["walletCharged"],
    remainingWalletBalance: json["remainingWalletBalance"],
    userWalletBalance: json["userWalletBalance"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    priceDetail: json["priceDetail"] == null ? [] : List<NetPayable>.from(json["priceDetail"]!.map((x) => NetPayable.fromJson(x))),
    currencySymbol: json["currencySymbol"],
    netPayable: json["netPayable"] == null ? null : NetPayable.fromJson(json["netPayable"]),
    displayRemainingWalletBalance: json["displayRemainingWalletBalance"],
  );

  Map<String, dynamic> toJson() => {
    "cartSummary": cartSummary?.toJson(),
    "canBeUseRP": canBeUseRp,
    "canBeUseRPAmt": canBeUseRpAmt,
    "displayUserWalletBalance": displayUserWalletBalance,
    "rewardPoints": rewardPoints,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "totalFavouriteItems": totalFavouriteItems,
    "cartItemsCount": cartItemsCount,
    "orderNetAmount": orderNetAmount,
    "walletCharged": walletCharged,
    "remainingWalletBalance": remainingWalletBalance,
    "userWalletBalance": userWalletBalance,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "priceDetail": priceDetail == null ? [] : List<dynamic>.from(priceDetail!.map((x) => x.toJson())),
    "currencySymbol": currencySymbol,
    "netPayable": netPayable?.toJson(),
    "displayRemainingWalletBalance": displayRemainingWalletBalance,
  };
}

class CartSummary {
  final CartDiscounts? cartDiscounts;

  CartSummary({
    this.cartDiscounts,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) => CartSummary(
    cartDiscounts: json["cartDiscounts"] == null ? null : CartDiscounts.fromJson(json["cartDiscounts"]),
  );

  Map<String, dynamic> toJson() => {
    "cartDiscounts": cartDiscounts?.toJson(),
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
