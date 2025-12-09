class GiftModel {
  final String cartItemsCount;
  final String currencySymbol;
  final List<GiftCard> giftCards;
  final List<String> orderPaymentStatusArr;
  final String page;
  final String pageCount;
  final String pageSize;
  final String recordCount;
  final String totalFavouriteItems;
  final String totalUnreadMessageCount;
  final String totalUnreadNotificationCount;
  final List<String> useStatusArr;

  GiftModel({
    required this.cartItemsCount,
    required this.currencySymbol,
    required this.giftCards,
    required this.orderPaymentStatusArr,
    required this.page,
    required this.pageCount,
    required this.pageSize,
    required this.recordCount,
    required this.totalFavouriteItems,
    required this.totalUnreadMessageCount,
    required this.totalUnreadNotificationCount,
    required this.useStatusArr,
  });

  factory GiftModel.fromJson(Map<String, dynamic> json) {
    return GiftModel(
      cartItemsCount: json['cartItemsCount'] ?? '',
      currencySymbol: json['currencySymbol'] ?? '',
      giftCards: (json['giftCards'] as List<dynamic>?)
          ?.map((e) => GiftCard.fromJson(e))
          .toList() ??
          [],
      orderPaymentStatusArr: (json['orderPaymentStatusArr'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
      page: json['page'] ?? '',
      pageCount: json['pageCount'] ?? '',
      pageSize: json['pageSize'] ?? '',
      recordCount: json['recordCount'] ?? '',
      totalFavouriteItems: json['totalFavouriteItems'] ?? '',
      totalUnreadMessageCount: json['totalUnreadMessageCount'] ?? '',
      totalUnreadNotificationCount:
      json['totalUnreadNotificationCount'] ?? '',
      useStatusArr: (json['useStatusArr'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cartItemsCount': cartItemsCount,
      'currencySymbol': currencySymbol,
      'giftCards': giftCards.map((e) => e.toJson()).toList(),
      'orderPaymentStatusArr': orderPaymentStatusArr,
      'page': page,
      'pageCount': pageCount,
      'pageSize': pageSize,
      'recordCount': recordCount,
      'totalFavouriteItems': totalFavouriteItems,
      'totalUnreadMessageCount': totalUnreadMessageCount,
      'totalUnreadNotificationCount': totalUnreadNotificationCount,
      'useStatusArr': useStatusArr,
    };
  }
}

class GiftCard {
  final String ogcardsCode;
  final String ogcardsCreatedOn;
  final String ogcardsId;
  final String ogcardsOrderId;
  final String ogcardsReceiverEmail;
  final String ogcardsReceiverName;
  final String ogcardsSenderId;
  final String? ogcardsStatus;
  final String? orderPaymentStatus;
  final String? orderNetAmount;

  GiftCard({
    required this.ogcardsCode,
    required this.ogcardsCreatedOn,
    required this.ogcardsId,
    required this.ogcardsOrderId,
    required this.ogcardsReceiverEmail,
    required this.ogcardsReceiverName,
    required this.ogcardsSenderId,
    this.ogcardsStatus,
    this.orderPaymentStatus,
    this.orderNetAmount,
  });

  factory GiftCard.fromJson(Map<String, dynamic> json) {
    return GiftCard(
      ogcardsCode: json['ogcards_code'] ?? '',
      ogcardsCreatedOn: json['ogcards_created_on'] ?? '',
      ogcardsId: json['ogcards_id'] ?? '',
      ogcardsOrderId: json['ogcards_order_id'] ?? '',
      ogcardsReceiverEmail: json['ogcards_receiver_email'] ?? '',
      ogcardsReceiverName: json['ogcards_receiver_name'] ?? '',
      ogcardsSenderId: json['ogcards_sender_id'] ?? '',
      ogcardsStatus: json['ogcards_status'],
      orderPaymentStatus: json['order_payment_status'],
      orderNetAmount: json['order_net_amount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ogcards_code': ogcardsCode,
      'ogcards_created_on': ogcardsCreatedOn,
      'ogcards_id': ogcardsId,
      'ogcards_order_id': ogcardsOrderId,
      'ogcards_receiver_email': ogcardsReceiverEmail,
      'ogcards_receiver_name': ogcardsReceiverName,
      'ogcards_sender_id': ogcardsSenderId,
      'ogcards_status': ogcardsStatus,
      'order_payment_status': orderPaymentStatus,
      'order_net_amount': orderNetAmount,
    };
  }
}
