import 'dart:convert';

class CouponData {
  List<CouponsItem>? offers;
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  String? cartItemsCount;
  String? currencySymbol;
  String? totalFavouriteItems;

  CouponData({
    this.offers,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.currencySymbol,
    this.totalFavouriteItems,
  });

  factory CouponData.fromJson(Map<String, dynamic> json) {
    return CouponData(
      offers: (json['offers'] as List?)
          ?.map((item) => CouponsItem.fromJson(item))
          .toList(),
      totalUnreadMessageCount: json['totalUnreadMessageCount']?.toString(),
      totalUnreadNotificationCount:
      json['totalUnreadNotificationCount']?.toString(),
      cartItemsCount: json['cartItemsCount']?.toString(),
      currencySymbol: json['currencySymbol']?.toString(),
      totalFavouriteItems: json['totalFavouriteItems']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offers': offers?.map((item) => item.toJson()).toList(),
      'totalUnreadMessageCount': totalUnreadMessageCount,
      'totalUnreadNotificationCount': totalUnreadNotificationCount,
      'cartItemsCount': cartItemsCount,
      'currencySymbol': currencySymbol,
      'totalFavouriteItems': totalFavouriteItems,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}

class CouponsItem {
  String? couponTitle;
  String? couponlangCouponId;
  String? couponCode;
  String? couponUsesCoustomer;
  String? couponEndDate;
  String? couponIdentifier;
  String? couponValidFor;
  String? couponDiscountValue;
  String? couponUsesCount;
  String? couponDeleted;
  String? couponDescription;
  String? couponStartDate;
  String? couponId;
  String? couponlangLangId;
  String? offerImage;
  String? couponMaxDiscountValue;
  String? couponActive;
  String? userCouponUsedCount;
  String? couponMinOrderValue;
  String? couponUsedCount;
  String? couponType;
  String? couponDiscountInPercent;
  String? couponHoldCount;
  bool selected;

  CouponsItem({
    this.couponTitle,
    this.couponlangCouponId,
    this.couponCode,
    this.couponUsesCoustomer,
    this.couponEndDate,
    this.couponIdentifier,
    this.couponValidFor,
    this.couponDiscountValue,
    this.couponUsesCount,
    this.couponDeleted,
    this.couponDescription,
    this.couponStartDate,
    this.couponId,
    this.couponlangLangId,
    this.offerImage,
    this.couponMaxDiscountValue,
    this.couponActive,
    this.userCouponUsedCount,
    this.couponMinOrderValue,
    this.couponUsedCount,
    this.couponType,
    this.couponDiscountInPercent,
    this.couponHoldCount,
    this.selected = false,
  });

  factory CouponsItem.fromJson(Map<String, dynamic> json) {
    return CouponsItem(
      couponTitle: json['coupon_title']?.toString(),
      couponlangCouponId: json['couponlang_coupon_id']?.toString(),
      couponCode: json['coupon_code']?.toString(),
      couponUsesCoustomer: json['coupon_uses_coustomer']?.toString(),
      couponEndDate: json['coupon_end_date']?.toString(),
      couponIdentifier: json['coupon_identifier']?.toString(),
      couponValidFor: json['coupon_valid_for']?.toString(),
      couponDiscountValue: json['coupon_discount_value']?.toString(),
      couponUsesCount: json['coupon_uses_count']?.toString(),
      couponDeleted: json['coupon_deleted']?.toString(),
      couponDescription: json['coupon_description']?.toString(),
      couponStartDate: json['coupon_start_date']?.toString(),
      couponId: json['coupon_id']?.toString(),
      couponlangLangId: json['couponlang_lang_id']?.toString(),
      offerImage: json['offerImage']?.toString(),
      couponMaxDiscountValue: json['coupon_max_discount_value']?.toString(),
      couponActive: json['coupon_active']?.toString(),
      userCouponUsedCount: json['user_coupon_used_count']?.toString(),
      couponMinOrderValue: json['coupon_min_order_value']?.toString(),
      couponUsedCount: json['coupon_used_count']?.toString(),
      couponType: json['coupon_type']?.toString(),
      couponDiscountInPercent: json['coupon_discount_in_percent']?.toString(),
      couponHoldCount: json['coupon_hold_count']?.toString(),
      selected: json['selected'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coupon_title': couponTitle,
      'couponlang_coupon_id': couponlangCouponId,
      'coupon_code': couponCode,
      'coupon_uses_coustomer': couponUsesCoustomer,
      'coupon_end_date': couponEndDate,
      'coupon_identifier': couponIdentifier,
      'coupon_valid_for': couponValidFor,
      'coupon_discount_value': couponDiscountValue,
      'coupon_uses_count': couponUsesCount,
      'coupon_deleted': couponDeleted,
      'coupon_description': couponDescription,
      'coupon_start_date': couponStartDate,
      'coupon_id': couponId,
      'couponlang_lang_id': couponlangLangId,
      'offerImage': offerImage,
      'coupon_max_discount_value': couponMaxDiscountValue,
      'coupon_active': couponActive,
      'user_coupon_used_count': userCouponUsedCount,
      'coupon_min_order_value': couponMinOrderValue,
      'coupon_used_count': couponUsedCount,
      'coupon_type': couponType,
      'coupon_discount_in_percent': couponDiscountInPercent,
      'coupon_hold_count': couponHoldCount,
      'selected': selected,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
