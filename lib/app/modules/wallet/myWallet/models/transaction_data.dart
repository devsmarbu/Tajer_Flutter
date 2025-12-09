import 'dart:convert';

import 'credit_listing_item.dart';

class TransactionData {
  String? totalUnreadMessageCount;
  String? pageCount;
  String? canRedeemGiftCard;
  String? promotionWalletToBeCharged;
  String? recordCount;
  String? currencySymbol;
  List<String>? txnStatusArr;
  String? userWalletBalance;
  String? displayUserWalletBalance;
  List<CreditsListingItem>? creditsListing;
  String? totalUnreadNotificationCount;
  String? cartItemsCount;
  String? withdrawlRequestAmount;
  String? page;
  String? totalFavouriteItems;
  String? userTotalWalletBalance;

  TransactionData({
    this.totalUnreadMessageCount,
    this.pageCount,
    this.canRedeemGiftCard,
    this.promotionWalletToBeCharged,
    this.recordCount,
    this.currencySymbol,
    this.txnStatusArr,
    this.userWalletBalance,
    this.displayUserWalletBalance,
    this.creditsListing,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.withdrawlRequestAmount,
    this.page,
    this.totalFavouriteItems,
    this.userTotalWalletBalance,
  });

  factory TransactionData.fromJson(Map<String, dynamic> json) {
    return TransactionData(
      totalUnreadMessageCount: json['totalUnreadMessageCount'],
      pageCount: json['pageCount'],
      canRedeemGiftCard: json['canRedeemGiftCard'],
      promotionWalletToBeCharged: json['promotionWalletToBeCharged'],
      recordCount: json['recordCount'],
      currencySymbol: json['currencySymbol'],
      txnStatusArr: (json['txnStatusArr'] != null)
          ? List<String>.from(json['txnStatusArr'])
          : null,
      userWalletBalance: json['userWalletBalance'],
      displayUserWalletBalance: json['displayUserWalletBalance'],
      creditsListing: json['creditsListing'] != null
          ? (json['creditsListing'] as List)
          .map((e) => CreditsListingItem.fromJson(e))
          .toList()
          : null,
      totalUnreadNotificationCount: json['totalUnreadNotificationCount'],
      cartItemsCount: json['cartItemsCount'],
      withdrawlRequestAmount: json['withdrawlRequestAmount'],
      page: json['page'],
      totalFavouriteItems: json['totalFavouriteItems'],
      userTotalWalletBalance: json['userTotalWalletBalance'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUnreadMessageCount': totalUnreadMessageCount,
      'pageCount': pageCount,
      'canRedeemGiftCard': canRedeemGiftCard,
      'promotionWalletToBeCharged': promotionWalletToBeCharged,
      'recordCount': recordCount,
      'currencySymbol': currencySymbol,
      'txnStatusArr': txnStatusArr,
      'userWalletBalance': userWalletBalance,
      'displayUserWalletBalance': displayUserWalletBalance,
      'creditsListing': creditsListing?.map((e) => e.toJson()).toList(),
      'totalUnreadNotificationCount': totalUnreadNotificationCount,
      'cartItemsCount': cartItemsCount,
      'withdrawlRequestAmount': withdrawlRequestAmount,
      'page': page,
      'totalFavouriteItems': totalFavouriteItems,
      'userTotalWalletBalance': userTotalWalletBalance,
    };
  }

  static TransactionData fromJsonString(String str) =>
      TransactionData.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());
}


