class ApplyCouponModel {
  final String? status;
  final String? responseCode;
  final String? msg;
  final ApplyCouponData? data;

  ApplyCouponModel({
    this.status,
    this.responseCode,
    this.msg,
    this.data,
  });

  factory ApplyCouponModel.fromJson(Map<String, dynamic> json) => ApplyCouponModel(
    status: json["status"]?.toString(),
    responseCode: json["responseCode"] ?? "",
    msg: json["msg"] ?? "",
    data: json["data"] == null ? null : ApplyCouponData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "responseCode": responseCode,
    "msg": msg,
     "data": data?.toJson(),
  };
}

class ApplyCouponData {
  final String? currencySymbol;
  final String? totalFavouriteItems;
  final String? totalUnreadMessageCount;
  final String? totalUnreadNotificationCount;
  final String? cartItemsCount;
  final String? orderId;
  final String? orderType;
  final String? canUseWalletForPayment;
  final ApplyCouponCartSummary? cartSummary;
  final List<PaymentMethod>? paymentMethods;
  final String? isFreeDelCoupon;
  final String? userWalletBalance;
  final String? displayUserWalletBalance;
  final String? rewardPoints;
  final String? canBeUseRp;
  final String? canBeUseRpAmt;
  final String? walletCharged;
  final String? remainingWalletBalance;
  final String? displayRemainingWalletBalance;
  final String? orderNetAmount;
  final List<NetPayable>? priceDetail;
  final NetPayable? netPayable;

  ApplyCouponData({
    this.currencySymbol,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.orderId,
    this.orderType,
    this.canUseWalletForPayment,
    this.cartSummary,
    this.paymentMethods,
    this.isFreeDelCoupon,
    this.userWalletBalance,
    this.displayUserWalletBalance,
    this.rewardPoints,
    this.canBeUseRp,
    this.canBeUseRpAmt,
    this.walletCharged,
    this.remainingWalletBalance,
    this.displayRemainingWalletBalance,
    this.orderNetAmount,
    this.priceDetail,
    this.netPayable,
  });

  factory ApplyCouponData.fromJson(Map<String, dynamic> json) => ApplyCouponData(
    currencySymbol: json["currencySymbol"],
    totalFavouriteItems: json["totalFavouriteItems"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    cartItemsCount: json["cartItemsCount"],
    orderId: json["orderId"],
    orderType: json["orderType"],
    canUseWalletForPayment: json["canUseWalletForPayment"],
    cartSummary: json["cartSummary"] == null ? null : ApplyCouponCartSummary.fromJson(json["cartSummary"]),
    paymentMethods: json["paymentMethods"] == null ? [] : List<PaymentMethod>.from(json["paymentMethods"]!.map((x) => PaymentMethod.fromJson(x))),
    isFreeDelCoupon: json["isFreeDelCoupon"],
    userWalletBalance: json["userWalletBalance"],
    displayUserWalletBalance: json["displayUserWalletBalance"],
    rewardPoints: json["rewardPoints"],
    canBeUseRp: json["canBeUseRP"],
    canBeUseRpAmt: json["canBeUseRPAmt"],
    walletCharged: json["walletCharged"],
    remainingWalletBalance: json["remainingWalletBalance"],
    displayRemainingWalletBalance: json["displayRemainingWalletBalance"],
    orderNetAmount: json["orderNetAmount"],
    priceDetail: json["priceDetail"] == null ? [] : List<NetPayable>.from(json["priceDetail"]!.map((x) => NetPayable.fromJson(x))),
    netPayable: json["netPayable"] == null ? null : NetPayable.fromJson(json["netPayable"]),
  );

  Map<String, dynamic> toJson() => {
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "orderId": orderId,
    "orderType": orderType,
    "canUseWalletForPayment": canUseWalletForPayment,
    "cartSummary": cartSummary?.toJson(),
    "paymentMethods": paymentMethods == null ? [] : List<dynamic>.from(paymentMethods!.map((x) => x.toJson())),
    "isFreeDelCoupon": isFreeDelCoupon,
    "userWalletBalance": userWalletBalance,
    "displayUserWalletBalance": displayUserWalletBalance,
    "rewardPoints": rewardPoints,
    "canBeUseRP": canBeUseRp,
    "canBeUseRPAmt": canBeUseRpAmt,
    "walletCharged": walletCharged,
    "remainingWalletBalance": remainingWalletBalance,
    "displayRemainingWalletBalance": displayRemainingWalletBalance,
    "orderNetAmount": orderNetAmount,
    "priceDetail": priceDetail == null ? [] : List<dynamic>.from(priceDetail!.map((x) => x.toJson())),
    "netPayable": netPayable?.toJson(),
  };
}

class ApplyCouponCartSummary {
  final String? cartTotal;
  final String? shippingTotal;
  final String? originalShipping;
  final String? isFreeShipping;
  final String? cartTaxTotal;
  final ApplyCouponCartDiscounts? cartDiscounts;
  final String? cartVolumeDiscount;
  final String? cartRewardPoints;
  final String? cartWalletSelected;
  final String? siteCommission;
  final String? orderNetAmount;
  final String? walletAmountCharge;
  final String? isCodEnabled;
  final String? isCodValidForNetAmt;
  final String? minCodOrderLimit;
  final String? maxCodOrderLimit;
  final String? orderPaymentGatewayCharges;
  final String? netChargeAmount;
  final List<dynamic>? taxOptions;
  final ProdTaxOptions? prodTaxOptions;
  final String? roundingOff;
  final String? totalSaving;

  ApplyCouponCartSummary({
    this.cartTotal,
    this.shippingTotal,
    this.originalShipping,
    this.isFreeShipping,
    this.cartTaxTotal,
    this.cartDiscounts,
    this.cartVolumeDiscount,
    this.cartRewardPoints,
    this.cartWalletSelected,
    this.siteCommission,
    this.orderNetAmount,
    this.walletAmountCharge,
    this.isCodEnabled,
    this.isCodValidForNetAmt,
    this.minCodOrderLimit,
    this.maxCodOrderLimit,
    this.orderPaymentGatewayCharges,
    this.netChargeAmount,
    this.taxOptions,
    this.prodTaxOptions,
    this.roundingOff,
    this.totalSaving,
  });

  factory ApplyCouponCartSummary.fromJson(Map<String, dynamic> json) => ApplyCouponCartSummary(
    cartTotal: json["cartTotal"],
    shippingTotal: json["shippingTotal"],
    originalShipping: json["originalShipping"],
    isFreeShipping: json["isFreeShipping"],
    cartTaxTotal: json["cartTaxTotal"],
    cartDiscounts: json["cartDiscounts"] == null ? null : ApplyCouponCartDiscounts.fromJson(json["cartDiscounts"]),
    cartVolumeDiscount: json["cartVolumeDiscount"],
    cartRewardPoints: json["cartRewardPoints"],
    cartWalletSelected: json["cartWalletSelected"],
    siteCommission: json["siteCommission"],
    orderNetAmount: json["orderNetAmount"],
    walletAmountCharge: json["WalletAmountCharge"],
    isCodEnabled: json["isCodEnabled"],
    isCodValidForNetAmt: json["isCodValidForNetAmt"],
    minCodOrderLimit: json["min_cod_order_limit"],
    maxCodOrderLimit: json["max_cod_order_limit"],
    orderPaymentGatewayCharges: json["orderPaymentGatewayCharges"],
    netChargeAmount: json["netChargeAmount"],
    taxOptions: json["taxOptions"] == null ? [] : List<dynamic>.from(json["taxOptions"]!.map((x) => x)),
    prodTaxOptions: json["prodTaxOptions"] == null ? null : ProdTaxOptions.fromJson(json["prodTaxOptions"]),
    roundingOff: json["roundingOff"],
    totalSaving: json["totalSaving"],
  );

  Map<String, dynamic> toJson() => {
    "cartTotal": cartTotal,
    "shippingTotal": shippingTotal,
    "originalShipping": originalShipping,
    "isFreeShipping": isFreeShipping,
    "cartTaxTotal": cartTaxTotal,
    "cartDiscounts": cartDiscounts?.toJson(),
    "cartVolumeDiscount": cartVolumeDiscount,
    "cartRewardPoints": cartRewardPoints,
    "cartWalletSelected": cartWalletSelected,
    "siteCommission": siteCommission,
    "orderNetAmount": orderNetAmount,
    "WalletAmountCharge": walletAmountCharge,
    "isCodEnabled": isCodEnabled,
    "isCodValidForNetAmt": isCodValidForNetAmt,
    "min_cod_order_limit": minCodOrderLimit,
    "max_cod_order_limit": maxCodOrderLimit,
    "orderPaymentGatewayCharges": orderPaymentGatewayCharges,
    "netChargeAmount": netChargeAmount,
    "taxOptions": taxOptions == null ? [] : List<dynamic>.from(taxOptions!.map((x) => x)),
    "prodTaxOptions": prodTaxOptions?.toJson(),
    "roundingOff": roundingOff,
    "totalSaving": totalSaving,
  };
}

class ApplyCouponCartDiscounts {
  final String? couponDiscountType;
  final String? couponCode;
  final String? couponDiscountValue;
  final String? couponDiscountTotal;
  final CouponInfo? couponInfo;
  final DiscountedSelProdIds? discountedSelProdIds;
  final List<dynamic>? discountedProdGroupIds;

  ApplyCouponCartDiscounts({
    this.couponDiscountType,
    this.couponCode,
    this.couponDiscountValue,
    this.couponDiscountTotal,
    this.couponInfo,
    this.discountedSelProdIds,
    this.discountedProdGroupIds,
  });

  factory ApplyCouponCartDiscounts.fromJson(Map<String, dynamic> json) => ApplyCouponCartDiscounts(
    couponDiscountType: json["coupon_discount_type"],
    couponCode: json["coupon_code"],
    couponDiscountValue: json["coupon_discount_value"],
    couponDiscountTotal: json["coupon_discount_total"],
    couponInfo: json["coupon_info"] == null ? null : CouponInfo.fromJson(json["coupon_info"]),
    discountedSelProdIds: json["discountedSelProdIds"] == null ? null : DiscountedSelProdIds.fromJson(json["discountedSelProdIds"]),
    discountedProdGroupIds: json["discountedProdGroupIds"] == null ? [] : List<dynamic>.from(json["discountedProdGroupIds"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "coupon_discount_type": couponDiscountType,
    "coupon_code": couponCode,
    "coupon_discount_value": couponDiscountValue,
    "coupon_discount_total": couponDiscountTotal,
    "coupon_info": couponInfo?.toJson(),
    "discountedSelProdIds": discountedSelProdIds?.toJson(),
    "discountedProdGroupIds": discountedProdGroupIds == null ? [] : List<dynamic>.from(discountedProdGroupIds!.map((x) => x)),
  };
}

class CouponInfo {
  final String? couponLabel;
  final String? couponId;
  final String? couponDiscountInPercent;
  final String? maxDiscountValue;

  CouponInfo({
    this.couponLabel,
    this.couponId,
    this.couponDiscountInPercent,
    this.maxDiscountValue,
  });

  factory CouponInfo.fromJson(Map<String, dynamic> json) => CouponInfo(
    couponLabel: json["coupon_label"],
    couponId: json["coupon_id"],
    couponDiscountInPercent: json["coupon_discount_in_percent"],
    maxDiscountValue: json["max_discount_value"],
  );

  Map<String, dynamic> toJson() => {
    "coupon_label": couponLabel,
    "coupon_id": couponId,
    "coupon_discount_in_percent": couponDiscountInPercent,
    "max_discount_value": maxDiscountValue,
  };
}

class DiscountedSelProdIds {
  final String? the8297;

  DiscountedSelProdIds({
    this.the8297,
  });

  factory DiscountedSelProdIds.fromJson(Map<String, dynamic> json) => DiscountedSelProdIds(
    the8297: json["8297"],
  );

  Map<String, dynamic> toJson() => {
    "8297": the8297,
  };
}

class ProdTaxOptions {
  final List<The8297>? the8297;

  ProdTaxOptions({
    this.the8297,
  });

  factory ProdTaxOptions.fromJson(Map<String, dynamic> json) => ProdTaxOptions(
    the8297: json["8297"] == null ? [] : List<The8297>.from(json["8297"]!.map((x) => The8297.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "8297": the8297 == null ? [] : List<dynamic>.from(the8297!.map((x) => x.toJson())),
  };
}

class The8297 {
  final String? taxstrId;
  final String? name;
  final String? percentageValue;
  final String? inPercentage;
  final String? value;

  The8297({
    this.taxstrId,
    this.name,
    this.percentageValue,
    this.inPercentage,
    this.value,
  });

  factory The8297.fromJson(Map<String, dynamic> json) => The8297(
    taxstrId: json["taxstr_id"],
    name: json["name"],
    percentageValue: json["percentageValue"],
    inPercentage: json["inPercentage"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "taxstr_id": taxstrId,
    "name": name,
    "percentageValue": percentageValue,
    "inPercentage": inPercentage,
    "value": value,
  };
}

class NetPayable {
  final String? key;
  final String? value;

  NetPayable({
    this.key,
    this.value,
  });

  factory NetPayable.fromJson(Map<String, dynamic> json) => NetPayable(
    key: json["key"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}

class PaymentMethod {
  final String? pluginId;
  final String? pluginCode;
  final String? pluginType;
  final String? pluginDescription;
  final String? pluginName;
  final String? pluginActive;
  final List<Token>? tokens;
  final String? image;

  PaymentMethod({
    this.pluginId,
    this.pluginCode,
    this.pluginType,
    this.pluginDescription,
    this.pluginName,
    this.pluginActive,
    this.tokens,
    this.image,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) => PaymentMethod(
    pluginId: json["plugin_id"],
    pluginCode: json["plugin_code"],
    pluginType: json["plugin_type"],
    pluginDescription: json["plugin_description"],
    pluginName: json["plugin_name"],
    pluginActive: json["plugin_active"],
    tokens: json["tokens"] == null ? [] : List<Token>.from(json["tokens"]!.map((x) => Token.fromJson(x))),
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "plugin_id": pluginId,
    "plugin_code": pluginCode,
    "plugin_type": pluginType,
    "plugin_description": pluginDescription,
    "plugin_name": pluginName,
    "plugin_active": pluginActive,
    "tokens": tokens == null ? [] : List<dynamic>.from(tokens!.map((x) => x.toJson())),
    "image": image,
  };
}

class Token {
  final String? cardNumber;
  final String? cardType;
  final String? cardExpiry;
  final String? token;

  Token({
    this.cardNumber,
    this.cardType,
    this.cardExpiry,
    this.token,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
    cardNumber: json["cardNumber"],
    cardType: json["cardType"],
    cardExpiry: json["cardExpiry"],
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "cardNumber": cardNumber,
    "cardType": cardType,
    "cardExpiry": cardExpiry,
    "token": token,
  };
}
