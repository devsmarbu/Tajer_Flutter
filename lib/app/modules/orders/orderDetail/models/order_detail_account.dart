import 'package:tajer/app/modules/orders/orderDetail/models/shipping_address.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/shipping_comments.dart';
import 'pickup_detail.dart';

class OrderDetailAccount {
  String? orderDateUpdated;
  String? orderRewardPointValue;
  String? orderNetAmount;
  String? orderIsWalletSelected;
  String? orderAffiliateUserId;
  String? orderDiscountCouponCode;
  String? orderDiscountValue;
  String? orderCurrencyValue;
  String? orderShippingapiCode;
  String? orderIsPaid;
  String? orderNumber;
  String? orderReferrerRewardPoints;
  String? orderShippingapiName;
  String? orderReferrerUserId;
  String? orderStatus;
  String? orderDiscountType;
  String? orderRewardPointUsed;
  String? orderAdminComments;
  String? orderRenew;
  String? orderTaxCharged;
  String? orderCurrencyId;
  String? orderCartData;
  String? orderlangLangId;
  String? orderlangOrderId;
  String? orderReferralRewardPoints;
  String? orderType;
  String? orderUserId;
  String? orderSiteCommission;
  String? orderDateAdded;
  List<ShippingComments>? comments;
  String? orderAffiliateTotalCommission;
  String? orderDiscountTotal;
  String? orderLanguageCode;
  String? orderDiscountInfo;
  String? orderUserComments;
  String? orderPmethodId;
  String? orderLanguageId;
  String? orderVolumeDiscountTotal;
  String? orderShippingapiId;
  ShippingAddress? shippingAddress;
  ShippingAddress? pickupAddress;
  ShippingAddress? billingAddress;
  String? orderWalletAmountCharge;
  String? orderId;
  String? orderCurrencyCode;
  PickupDetail? pickupDetail;

  OrderDetailAccount({
    this.orderDateUpdated,
    this.orderRewardPointValue,
    this.orderNetAmount,
    this.orderIsWalletSelected,
    this.orderAffiliateUserId,
    this.orderDiscountCouponCode,
    this.orderDiscountValue,
    this.orderCurrencyValue,
    this.orderShippingapiCode,
    this.orderIsPaid,
    this.orderNumber,
    this.orderReferrerRewardPoints,
    this.orderShippingapiName,
    this.orderReferrerUserId,
    this.orderStatus,
    this.orderDiscountType,
    this.orderRewardPointUsed,
    this.orderAdminComments,
    this.orderRenew,
    this.orderTaxCharged,
    this.orderCurrencyId,
    this.orderCartData,
    this.orderlangLangId,
    this.orderlangOrderId,
    this.orderReferralRewardPoints,
    this.orderType,
    this.orderUserId,
    this.orderSiteCommission,
    this.orderDateAdded,
    this.comments,
    this.orderAffiliateTotalCommission,
    this.orderDiscountTotal,
    this.orderLanguageCode,
    this.orderDiscountInfo,
    this.orderUserComments,
    this.orderPmethodId,
    this.orderLanguageId,
    this.orderVolumeDiscountTotal,
    this.orderShippingapiId,
    this.shippingAddress,
    this.pickupAddress,
    this.billingAddress,
    this.orderWalletAmountCharge,
    this.orderId,
    this.orderCurrencyCode,
    this.pickupDetail,
  });

  factory OrderDetailAccount.fromJson(Map<String, dynamic> json) {
    return OrderDetailAccount(
      orderDateUpdated: json['order_date_updated'],
      orderRewardPointValue: json['order_reward_point_value'],
      orderNetAmount: json['order_net_amount'],
      orderIsWalletSelected: json['order_is_wallet_selected'],
      orderAffiliateUserId: json['order_affiliate_user_id'],
      orderDiscountCouponCode: json['order_discount_coupon_code'],
      orderDiscountValue: json['order_discount_value'],
      orderCurrencyValue: json['order_currency_value'],
      orderShippingapiCode: json['order_shippingapi_code'],
      orderIsPaid: json['order_is_paid'],
      orderNumber: json['order_number'],
      orderReferrerRewardPoints: json['order_referrer_reward_points'],
      orderShippingapiName: json['order_shippingapi_name'],
      orderReferrerUserId: json['order_referrer_user_id'],
      orderStatus: json['order_status'],
      orderDiscountType: json['order_discount_type'],
      orderRewardPointUsed: json['order_reward_point_used'],
      orderAdminComments: json['order_admin_comments'],
      orderRenew: json['order_renew'],
      orderTaxCharged: json['order_tax_charged'],
      orderCurrencyId: json['order_currency_id'],
      orderCartData: json['order_cart_data'],
      orderlangLangId: json['orderlang_lang_id'],
      orderlangOrderId: json['orderlang_order_id'],
      orderReferralRewardPoints: json['order_referral_reward_points'],
      orderType: json['order_type'],
      orderUserId: json['order_user_id'],
      orderSiteCommission: json['order_site_commission'],
      orderDateAdded: json['order_date_added'],
      comments: json['comments'] != null
          ? (json['comments'] as List)
          .map((e) => ShippingComments.fromJson(e))
          .toList()
          : null,
      orderAffiliateTotalCommission: json['order_affiliate_total_commission'],
      orderDiscountTotal: json['order_discount_total'],
      orderLanguageCode: json['order_language_code'],
      orderDiscountInfo: json['order_discount_info'],
      orderUserComments: json['order_user_comments'],
      orderPmethodId: json['order_pmethod_id'],
      orderLanguageId: json['order_language_id'],
      orderVolumeDiscountTotal: json['order_volume_discount_total'],
      orderShippingapiId: json['order_shippingapi_id'],
      shippingAddress: json['shippingAddress'] != null
          ? ShippingAddress.fromJson(json['shippingAddress'])
          : null,
      pickupAddress: json['pickupAddress'] != null
          ? ShippingAddress.fromJson(json['pickupAddress'])
          : null,
      billingAddress: json['billingAddress'] != null
          ? ShippingAddress.fromJson(json['billingAddress'])
          : null,
      orderWalletAmountCharge: json['order_wallet_amount_charge'],
      orderId: json['order_id'],
      orderCurrencyCode: json['order_currency_code'],
      pickupDetail: json['pickupDetail'] != null
          ? PickupDetail.fromJson(json['pickupDetail'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'order_date_updated': orderDateUpdated,
    'order_reward_point_value': orderRewardPointValue,
    'order_net_amount': orderNetAmount,
    'order_is_wallet_selected': orderIsWalletSelected,
    'order_affiliate_user_id': orderAffiliateUserId,
    'order_discount_coupon_code': orderDiscountCouponCode,
    'order_discount_value': orderDiscountValue,
    'order_currency_value': orderCurrencyValue,
    'order_shippingapi_code': orderShippingapiCode,
    'order_is_paid': orderIsPaid,
    'order_number': orderNumber,
    'order_referrer_reward_points': orderReferrerRewardPoints,
    'order_shippingapi_name': orderShippingapiName,
    'order_referrer_user_id': orderReferrerUserId,
    'order_status': orderStatus,
    'order_discount_type': orderDiscountType,
    'order_reward_point_used': orderRewardPointUsed,
    'order_admin_comments': orderAdminComments,
    'order_renew': orderRenew,
    'order_tax_charged': orderTaxCharged,
    'order_currency_id': orderCurrencyId,
    'order_cart_data': orderCartData,
    'orderlang_lang_id': orderlangLangId,
    'orderlang_order_id': orderlangOrderId,
    'order_referral_reward_points': orderReferralRewardPoints,
    'order_type': orderType,
    'order_user_id': orderUserId,
    'order_site_commission': orderSiteCommission,
    'order_date_added': orderDateAdded,
    'comments': comments?.map((e) => e.toJson()).toList(),
    'order_affiliate_total_commission': orderAffiliateTotalCommission,
    'order_discount_total': orderDiscountTotal,
    'order_language_code': orderLanguageCode,
    'order_discount_info': orderDiscountInfo,
    'order_user_comments': orderUserComments,
    'order_pmethod_id': orderPmethodId,
    'order_language_id': orderLanguageId,
    'order_volume_discount_total': orderVolumeDiscountTotal,
    'order_shippingapi_id': orderShippingapiId,
    'shippingAddress': shippingAddress?.toJson(),
    'pickupAddress': pickupAddress?.toJson(),
    'billingAddress': billingAddress?.toJson(),
    'order_wallet_amount_charge': orderWalletAmountCharge,
    'order_id': orderId,
    'order_currency_code': orderCurrencyCode,
    'pickupDetail': pickupDetail?.toJson(),
  };
}
