import '../../../orders/orderDetail/models/price_detail.dart';
import '../../../Cart/cart_shipping/apply_coupon_model.dart';
import '../../../wallet/myWallet/models/payout_plugin.dart';

class PaymentMethodsData {
  String? orderType;
  String? totalUnreadMessageCount;
  String? orderId;
  String? canUseWalletForPayment;
  String? currencySymbol;
  String? userWalletBalance;
  String? displayUserWalletBalance;
  String? confirmOrder;
  String? totalUnreadNotificationCount;
  String? cartItemsCount;
  List<PayoutPlugin>? paymentMethods;
  String? canBeUseRPAmt;
  String? rewardPoints;
  String? canBeUseRP;
  String? totalFavouriteItems;
  String? remainingWalletBalance;
  String? orderNetAmount;
  List<PriceDetail>? priceDetail;
  NetPayable? netPayable;

  PaymentMethodsData({
    this.orderType,
    this.totalUnreadMessageCount,
    this.orderId,
    this.canUseWalletForPayment,
    this.currencySymbol,
    this.userWalletBalance,
    this.displayUserWalletBalance,
    this.confirmOrder,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.paymentMethods,
    this.canBeUseRPAmt,
    this.rewardPoints,
    this.canBeUseRP,
    this.totalFavouriteItems,
    this.remainingWalletBalance,
    this.orderNetAmount,
    this.priceDetail,
    this.netPayable,
  });

  factory PaymentMethodsData.fromJson(Map<String, dynamic> json) {
    return PaymentMethodsData(
      orderType: json['orderType']?.toString(),
      totalUnreadMessageCount: json['totalUnreadMessageCount']?.toString(),
      orderId: json['orderId']?.toString(),
      canUseWalletForPayment: json['canUseWalletForPayment']?.toString(),
      currencySymbol: json['currencySymbol']?.toString(),
      userWalletBalance: json['userWalletBalance']?.toString(),
      displayUserWalletBalance: json['displayUserWalletBalance']?.toString(),
      confirmOrder: json['confirmOrder']?.toString(),
      totalUnreadNotificationCount: json['totalUnreadNotificationCount']?.toString(),
      cartItemsCount: json['cartItemsCount']?.toString(),

      /// Convert list of payment methods
      paymentMethods: json['paymentMethods'] != null
          ? (json['paymentMethods'] as List)
          .map((e) => PayoutPlugin.fromJson(e))
          .toList()
          : null,

      canBeUseRPAmt: json['canBeUseRPAmt']?.toString(),
      rewardPoints: json['rewardPoints']?.toString(),
      canBeUseRP: json['canBeUseRP']?.toString(),
      totalFavouriteItems: json['totalFavouriteItems']?.toString(),
      remainingWalletBalance: json['remainingWalletBalance']?.toString(),
      orderNetAmount: json['orderNetAmount']?.toString(),

      /// Convert list of price details
      priceDetail: json['priceDetail'] != null
          ? (json['priceDetail'] as List)
          .map((e) => PriceDetail.fromJson(e))
          .toList()
          : null,

      /// NetPayable object
      netPayable:
      json['netPayable'] != null ? NetPayable.fromJson(json['netPayable']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderType': orderType,
      'totalUnreadMessageCount': totalUnreadMessageCount,
      'orderId': orderId,
      'canUseWalletForPayment': canUseWalletForPayment,
      'currencySymbol': currencySymbol,
      'userWalletBalance': userWalletBalance,
      'displayUserWalletBalance': displayUserWalletBalance,
      'confirmOrder': confirmOrder,
      'totalUnreadNotificationCount': totalUnreadNotificationCount,
      'cartItemsCount': cartItemsCount,

      'paymentMethods': paymentMethods?.map((e) => e.toJson()).toList(),
      'canBeUseRPAmt': canBeUseRPAmt,
      'rewardPoints': rewardPoints,
      'canBeUseRP': canBeUseRP,
      'totalFavouriteItems': totalFavouriteItems,
      'remainingWalletBalance': remainingWalletBalance,
      'orderNetAmount': orderNetAmount,

      'priceDetail': priceDetail?.map((e) => e.toJson()).toList(),
      'netPayable': netPayable?.toJson(),
    };
  }
}
