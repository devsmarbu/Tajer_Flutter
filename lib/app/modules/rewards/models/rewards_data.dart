import 'dart:convert';

class RewardsData {
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  String? pageCount;
  RewardPointsDetail? rewardPointsDetail;
  String? cartItemsCount;
  String? recordCount;
  String? currencySymbol;
  String? pageSize;
  List<RewardPointsStatementItem>? rewardPointsStatement;
  String? page;
  String? convertReward;
  String? totalFavouriteItems;

  RewardsData({
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.pageCount,
    this.rewardPointsDetail,
    this.cartItemsCount,
    this.recordCount,
    this.currencySymbol,
    this.pageSize,
    this.rewardPointsStatement,
    this.page,
    this.convertReward,
    this.totalFavouriteItems,
  });

  factory RewardsData.fromJson(Map<String, dynamic> json) => RewardsData(
    totalUnreadMessageCount: json['totalUnreadMessageCount'] as String?,
    totalUnreadNotificationCount:
    json['totalUnreadNotificationCount'] as String?,
    pageCount: json['pageCount'] as String?,
    rewardPointsDetail: json['rewardPointsDetail'] != null
        ? RewardPointsDetail.fromJson(
        json['rewardPointsDetail'] as Map<String, dynamic>)
        : null,
    cartItemsCount: json['cartItemsCount'] as String?,
    recordCount: json['recordCount'] as String?,
    currencySymbol: json['currencySymbol'] as String?,
    pageSize: json['pageSize'] as String?,
    rewardPointsStatement: (json['rewardPointsStatement'] as List?)
        ?.map((e) =>
        RewardPointsStatementItem.fromJson(e as Map<String, dynamic>))
        .toList(),
    page: json['page'] as String?,
    convertReward: json['convertReward'] as String?,
    totalFavouriteItems: json['totalFavouriteItems'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'totalUnreadMessageCount': totalUnreadMessageCount,
    'totalUnreadNotificationCount': totalUnreadNotificationCount,
    'pageCount': pageCount,
    'rewardPointsDetail': rewardPointsDetail?.toJson(),
    'cartItemsCount': cartItemsCount,
    'recordCount': recordCount,
    'currencySymbol': currencySymbol,
    'pageSize': pageSize,
    'rewardPointsStatement':
    rewardPointsStatement?.map((e) => e.toJson()).toList(),
    'page': page,
    'convertReward': convertReward,
    'totalFavouriteItems': totalFavouriteItems,
  };

  static RewardsData fromJsonString(String str) =>
      RewardsData.fromJson(json.decode(str));

  String toJsonString() => json.encode(toJson());
}

class RewardPointsDetail {
  String? balance;
  String? convertedValue;

  RewardPointsDetail({this.balance, this.convertedValue});

  factory RewardPointsDetail.fromJson(Map<String, dynamic> json) =>
      RewardPointsDetail(
        balance: json['balance'] as String?,
        convertedValue: json['convertedValue'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'balance': balance,
    'convertedValue': convertedValue,
  };
}

class RewardPointsStatementItem {
  String? urpReferralUserId;
  String? urpDateAdded;
  String? urpPoints;
  String? urpId;
  String? urpUserId;
  String? urpComments;
  String? urpUsedOrderId;
  String? urpUsed;
  String? credentialUsername;
  String? urpDateExpiry;

  RewardPointsStatementItem({
    this.urpReferralUserId,
    this.urpDateAdded,
    this.urpPoints,
    this.urpId,
    this.urpUserId,
    this.urpComments,
    this.urpUsedOrderId,
    this.urpUsed,
    this.credentialUsername,
    this.urpDateExpiry,
  });

  factory RewardPointsStatementItem.fromJson(Map<String, dynamic> json) =>
      RewardPointsStatementItem(
        urpReferralUserId: json['urp_referral_user_id'] as String?,
        urpDateAdded: json['urp_date_added'] as String?,
        urpPoints: json['urp_points'] as String?,
        urpId: json['urp_id'] as String?,
        urpUserId: json['urp_user_id'] as String?,
        urpComments: json['urp_comments'] as String?,
        urpUsedOrderId: json['urp_used_order_id'] as String?,
        urpUsed: json['urp_used'] as String?,
        credentialUsername: json['credential_username'] as String?,
        urpDateExpiry: json['urp_date_expiry'] as String?,
      );

  Map<String, dynamic> toJson() => {
    'urp_referral_user_id': urpReferralUserId,
    'urp_date_added': urpDateAdded,
    'urp_points': urpPoints,
    'urp_id': urpId,
    'urp_user_id': urpUserId,
    'urp_comments': urpComments,
    'urp_used_order_id': urpUsedOrderId,
    'urp_used': urpUsed,
    'credential_username': credentialUsername,
    'urp_date_expiry': urpDateExpiry,
  };
}
