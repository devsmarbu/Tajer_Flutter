import 'package:tajer/app/modules/return/returnRequest/models/request_item.dart';

class RequestData {
  String? currencySymbol;
  String? totalFavouriteItems;
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  String? cartItemsCount;
  List<RequestItem>? requests;
  List<CancelReason>? reasons;
  String? page;
  String? pageCount;
  String? recordCount;
  Map<String, String>? returnRequestTypeArr;
  List<OrderReturnStatus>? orderReturnRequestStatusArr;
  List<OrderReturnStatus>? orderCancelRequestStatusArr;

  RequestData({
    this.currencySymbol,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.requests,
    this.reasons,
    this.page,
    this.pageCount,
    this.recordCount,
    this.returnRequestTypeArr,
    this.orderReturnRequestStatusArr,
    this.orderCancelRequestStatusArr,
  });

  /// 🔥 ADD THIS HERE (inside class)

  List<OrderReturnStatus> get allStatuses {
    if (orderReturnRequestStatusArr != null &&
        orderReturnRequestStatusArr!.isNotEmpty) {
      return orderReturnRequestStatusArr!;
    }

    if (orderCancelRequestStatusArr != null &&
        orderCancelRequestStatusArr!.isNotEmpty) {
      return orderCancelRequestStatusArr!;
    }

    return [];
  }

  factory RequestData.fromJson(Map<String, dynamic> json) => RequestData(
    currencySymbol: json['currencySymbol'],
    totalFavouriteItems: json['totalFavouriteItems'],
    totalUnreadMessageCount: json['totalUnreadMessageCount'],
    totalUnreadNotificationCount: json['totalUnreadNotificationCount'],
    cartItemsCount: json['cartItemsCount'],
    requests: json['requests'] != null
        ? List<RequestItem>.from(
            json['requests'].map((x) => RequestItem.fromJson(x)),
          )
        : [],

    /// 🔥 PARSE REASONS
    reasons: json['reasons'] != null
        ? List<CancelReason>.from(
            json['reasons'].map((x) => CancelReason.fromJson(x)),
          )
        : [],
    page: json['page'],
    pageCount: json['pageCount'],
    recordCount: json['recordCount'],
    returnRequestTypeArr: json['returnRequestTypeArr'] != null
        ? Map<String, String>.from(json['returnRequestTypeArr'])
        : {},

    orderReturnRequestStatusArr: json['OrderReturnRequestStatusArr'] != null
        ? List<OrderReturnStatus>.from(
            json['OrderReturnRequestStatusArr'].map(
              (x) => OrderReturnStatus.fromJson(x),
            ),
          )
        : [],
    orderCancelRequestStatusArr: json['OrderCancelRequestStatusArr'] != null
        ? List<OrderReturnStatus>.from(
            json['OrderCancelRequestStatusArr'].map(
              (x) => OrderReturnStatus.fromJson(x),
            ),
          )
        : [],
  );

  Map<String, dynamic> toJson() => {
    'currencySymbol': currencySymbol,
    'totalFavouriteItems': totalFavouriteItems,
    'totalUnreadMessageCount': totalUnreadMessageCount,
    'totalUnreadNotificationCount': totalUnreadNotificationCount,
    'cartItemsCount': cartItemsCount,
    'requests': requests?.map((x) => x.toJson()).toList(),
    'page': page,
    'reasons': reasons?.map((x) => x.toJson()).toList(),
    'pageCount': pageCount,
    'recordCount': recordCount,
    'returnRequestTypeArr': returnRequestTypeArr,
    'OrderReturnRequestStatusArr': orderReturnRequestStatusArr
        ?.map((x) => x.toJson())
        .toList(),
    'OrderCancelRequestStatusArr': orderCancelRequestStatusArr
        ?.map((x) => x.toJson())
        .toList(),
  };
}

class CancelReason {
  String? key;
  String? value;

  CancelReason({this.key, this.value});

  factory CancelReason.fromJson(Map<String, dynamic> json) =>
      CancelReason(key: json['key'], value: json['value']);

  Map<String, dynamic> toJson() => {'key': key, 'value': value};
}

class CancelOrderResponse {
  String? responseCode;
  String? status;
  String? msg;
  CancelOrderData? data;

  CancelOrderResponse({this.responseCode, this.status, this.msg, this.data});

  factory CancelOrderResponse.fromJson(Map<String, dynamic> json) {
    return CancelOrderResponse(
      responseCode: json['responseCode'],
      status: json['status']?.toString(),
      msg: json['msg'],
      data: json['data'] != null
          ? CancelOrderData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'responseCode': responseCode,
    'status': status,
    'msg': msg,
    'data': data?.toJson(),
  };
}

class CancelOrderData {
  String? currencySymbol;
  String? cartItemsCount;
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  String? totalFavouriteItems;

  CancelOrderData({
    this.currencySymbol,
    this.cartItemsCount,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.totalFavouriteItems,
  });

  factory CancelOrderData.fromJson(Map<String, dynamic> json) {
    return CancelOrderData(
      currencySymbol: json['currencySymbol'],
      cartItemsCount: json['cartItemsCount'],
      totalUnreadMessageCount: json['totalUnreadMessageCount'],
      totalUnreadNotificationCount: json['totalUnreadNotificationCount'],
      totalFavouriteItems: json['totalFavouriteItems'],
    );
  }

  Map<String, dynamic> toJson() => {
    'currencySymbol': currencySymbol,
    'cartItemsCount': cartItemsCount,
    'totalUnreadMessageCount': totalUnreadMessageCount,
    'totalUnreadNotificationCount': totalUnreadNotificationCount,
    'totalFavouriteItems': totalFavouriteItems,
  };
}

class OrderReturnStatusResponse {
  final List<OrderReturnStatus> statuses;

  OrderReturnStatusResponse({required this.statuses});

  factory OrderReturnStatusResponse.fromJson(Map<String, dynamic> json) {
    return OrderReturnStatusResponse(
      statuses: (json['OrderReturnRequestStatusArr'] as List)
          .map((e) => OrderReturnStatus.fromJson(e))
          .toList(),
    );
  }
}

class OrderReturnStatus {
  String? statusId;
  String? label;
  String? color;

  OrderReturnStatus({this.statusId, this.label, this.color});

  factory OrderReturnStatus.fromJson(Map<String, dynamic> json) {
    return OrderReturnStatus(
      statusId: json['status_id'],
      label: json['label'],
      color: json['color'],
    );
  }

  Map<String, dynamic> toJson() => {
    'status_id': statusId,
    'label': label,
    'color': color,
  };
}
