import '../apply_coupon_model.dart';

class PaymentSummaryModel {
  final int? displayLoginForm;
  final String? status;
  final String? responseCode;
  final String? msg;
  final Data? data;

  PaymentSummaryModel( {
    this.displayLoginForm,
    this.status,
    this.responseCode,
    this.msg,
    this.data,
  });

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) => PaymentSummaryModel(
    status: json["status"]?.toString(),
    responseCode: json["responseCode"],
    displayLoginForm: json["displayLoginForm"],
    msg: json["msg"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "responseCode": responseCode,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class Data {
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

  Data({
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

  factory Data.fromJson(Map<String, dynamic> json) => Data(
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

class CartSummary {
  final String? cartTotal;
  final String? shippingTotal;
  final String? originalShipping;
  final String? isFreeShipping;
  final String? cartTaxTotal;
  final CartDiscounts? cartDiscounts;
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
  final Map<String, List<ProdTaxOption>>? prodTaxOptions;
  final String? roundingOff;
  final String? totalSaving;

  CartSummary({
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

  factory CartSummary.fromJson(Map<String, dynamic> json) => CartSummary(
    cartTotal: json["cartTotal"],
    shippingTotal: json["shippingTotal"],
    originalShipping: json["originalShipping"],
    isFreeShipping: json["isFreeShipping"],
    cartTaxTotal: json["cartTaxTotal"],
    cartDiscounts: json["cartDiscounts"] == null ? null : CartDiscounts.fromJson(json["cartDiscounts"]),
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
    prodTaxOptions: Map.from(json["prodTaxOptions"]!).map((k, v) => MapEntry<String, List<ProdTaxOption>>(k, List<ProdTaxOption>.from(v.map((x) => ProdTaxOption.fromJson(x))))),
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
    "prodTaxOptions": Map.from(prodTaxOptions!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
    "roundingOff": roundingOff,
    "totalSaving": totalSaving,
  };
}

class CartDiscounts {
  CartDiscounts();

  factory CartDiscounts.fromJson(Map<String, dynamic> json) => CartDiscounts(
  );

  Map<String, dynamic> toJson() => {
  };
}

class ProdTaxOption {
  final String? taxstrId;
  final String? name;
  final String? percentageValue;
  final String? inPercentage;
  final String? value;

  ProdTaxOption({
    this.taxstrId,
    this.name,
    this.percentageValue,
    this.inPercentage,
    this.value,
  });

  factory ProdTaxOption.fromJson(Map<String, dynamic> json) => ProdTaxOption(
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
  final String? colorCode;

  NetPayable({
    this.key,
    this.value,
    this.colorCode,
  });

  factory NetPayable.fromJson(Map<String, dynamic> json) => NetPayable(
    key: json["key"],
    value: json["value"],
    colorCode: json["colorCode"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
    "colorCode": colorCode,
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
