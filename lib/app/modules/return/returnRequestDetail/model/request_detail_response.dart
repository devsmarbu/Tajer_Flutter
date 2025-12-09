import 'dart:convert';
import '../../returnRequest/models/request_item.dart';
import 'vendor_return_address.dart';

RequestDetailResponse requestDataFromJson(String str) =>
    RequestDetailResponse.fromJson(json.decode(str));

String requestDataToJson(RequestDetailResponse data) => json.encode(data.toJson());

class RequestDetailResponse {
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  String? pageCount;
  String? cartItemsCount;
  String? recordCount;
  List<String>? orderCancelRequestStatusArr;
  String? currencySymbol;
  List<RequestItem>? requests;
  String? canWithdrawRequest;
  RequestItem? requestdetail;
  VendorReturnAddress? vendorReturnAddress;
  String? page;
  String? totalFavouriteItems;

  RequestDetailResponse({
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.pageCount,
    this.cartItemsCount,
    this.recordCount,
    this.orderCancelRequestStatusArr,
    this.currencySymbol,
    this.requests,
    this.canWithdrawRequest,
    this.requestdetail,
    this.vendorReturnAddress,
    this.page,
    this.totalFavouriteItems,
  });

  factory RequestDetailResponse.fromJson(Map<String, dynamic> json) => RequestDetailResponse(
    totalUnreadMessageCount: json["totalUnreadMessageCount"]?.toString(),
    totalUnreadNotificationCount:
    json["totalUnreadNotificationCount"]?.toString(),
    pageCount: json["pageCount"]?.toString(),
    cartItemsCount: json["cartItemsCount"]?.toString(),
    recordCount: json["recordCount"]?.toString(),
    orderCancelRequestStatusArr:
    (json["OrderCancelRequestStatusArr"] as List?)
        ?.map((x) => x.toString())
        .toList(),
    currencySymbol: json["currencySymbol"]?.toString(),
    requests: (json["requests"] as List?)
        ?.map((x) => RequestItem.fromJson(x))
        .toList(),
    canWithdrawRequest: json["canWithdrawRequest"]?.toString(),
    requestdetail: json["request"] != null
        ? RequestItem.fromJson(json["request"])
        : null,
    vendorReturnAddress: json["vendorReturnAddress"] != null
        ? VendorReturnAddress.fromJson(json["vendorReturnAddress"])
        : null,
    page: json["page"]?.toString(),
    totalFavouriteItems: json["totalFavouriteItems"]?.toString(),
  );

  Map<String, dynamic> toJson() => {
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "pageCount": pageCount,
    "cartItemsCount": cartItemsCount,
    "recordCount": recordCount,
    "OrderCancelRequestStatusArr": orderCancelRequestStatusArr,
    "currencySymbol": currencySymbol,
    "requests": requests?.map((x) => x.toJson()).toList(),
    "canWithdrawRequest": canWithdrawRequest,
    "request": requestdetail?.toJson(),
    "vendorReturnAddress": vendorReturnAddress?.toJson(),
    "page": page,
    "totalFavouriteItems": totalFavouriteItems,
  };
}
