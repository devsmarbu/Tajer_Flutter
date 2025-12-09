import 'package:tajer/app/modules/return/returnRequest/models/request_item.dart';

class RequestData {
  String? currencySymbol;
  String? totalFavouriteItems;
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  String? cartItemsCount;
  List<RequestItem>? requests;
  String? page;
  String? pageCount;
  String? recordCount;
  Map<String, String>? returnRequestTypeArr;
  List<String>? orderReturnRequestStatusArr;

  RequestData({
    this.currencySymbol,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.requests,
    this.page,
    this.pageCount,
    this.recordCount,
    this.returnRequestTypeArr,
    this.orderReturnRequestStatusArr,
  });

  factory RequestData.fromJson(Map<String, dynamic> json) => RequestData(
    currencySymbol: json['currencySymbol'],
    totalFavouriteItems: json['totalFavouriteItems'],
    totalUnreadMessageCount: json['totalUnreadMessageCount'],
    totalUnreadNotificationCount: json['totalUnreadNotificationCount'],
    cartItemsCount: json['cartItemsCount'],
    requests: json['requests'] != null
        ? List<RequestItem>.from(
        json['requests'].map((x) => RequestItem.fromJson(x)))
        : [],
    page: json['page'],
    pageCount: json['pageCount'],
    recordCount: json['recordCount'],
    returnRequestTypeArr: json['returnRequestTypeArr'] != null
        ? Map<String, String>.from(json['returnRequestTypeArr'])
        : {},
    orderReturnRequestStatusArr: json['OrderReturnRequestStatusArr'] != null
        ? List<String>.from(json['OrderReturnRequestStatusArr'])
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
    'pageCount': pageCount,
    'recordCount': recordCount,
    'returnRequestTypeArr': returnRequestTypeArr,
    'OrderReturnRequestStatusArr': orderReturnRequestStatusArr,
  };
}