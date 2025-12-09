import 'package:tajer/app/modules/return/returnRequestDetail/model/request_exchange_data.dart';
import 'package:tajer/app/modules/return/returnRequestDetail/model/vendor_return_address.dart';

class ExchangeDetailData {
  String? canWithdrawRequest;
  String? cartItemsCount;
  String? currencySymbol;
  RequestExchangeData? request;
  List<String>? requestRequestStatusArr;
  ReturnRequestTypeArr? returnRequestTypeArr;
  String? totalFavouriteItems;
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  VendorReturnAddress? vendorReturnAddress;

  ExchangeDetailData({
    this.canWithdrawRequest,
    this.cartItemsCount,
    this.currencySymbol,
    this.request,
    this.requestRequestStatusArr,
    this.returnRequestTypeArr,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.vendorReturnAddress,
  });

  factory ExchangeDetailData.fromJson(Map<String, dynamic> json) =>
      ExchangeDetailData(
        canWithdrawRequest: json['canWithdrawRequest'],
        cartItemsCount: json['cartItemsCount'],
        currencySymbol: json['currencySymbol'],
        request: json['request'] != null
            ? RequestExchangeData.fromJson(json['request'])
            : null,
        requestRequestStatusArr:
        (json['requestRequestStatusArr'] as List?)?.map((e) => e.toString()).toList(),
        returnRequestTypeArr: json['returnRequestTypeArr'] != null
            ? ReturnRequestTypeArr.fromJson(json['returnRequestTypeArr'])
            : null,
        totalFavouriteItems: json['totalFavouriteItems'],
        totalUnreadMessageCount: json['totalUnreadMessageCount'],
        totalUnreadNotificationCount: json['totalUnreadNotificationCount'],
        vendorReturnAddress: json['vendorReturnAddress'] != null
            ? VendorReturnAddress.fromJson(json['vendorReturnAddress'])
            : null,
      );

  Map<String, dynamic> toJson() => {
    'canWithdrawRequest': canWithdrawRequest,
    'cartItemsCount': cartItemsCount,
    'currencySymbol': currencySymbol,
    'request': request?.toJson(),
    'requestRequestStatusArr': requestRequestStatusArr,
    'returnRequestTypeArr': returnRequestTypeArr?.toJson(),
    'totalFavouriteItems': totalFavouriteItems,
    'totalUnreadMessageCount': totalUnreadMessageCount,
    'totalUnreadNotificationCount': totalUnreadNotificationCount,
    'vendorReturnAddress': vendorReturnAddress?.toJson(),
  };
}

class ReturnRequestTypeArr {
  // Define fields as per your actual JSON
  ReturnRequestTypeArr();

  factory ReturnRequestTypeArr.fromJson(Map<String, dynamic> json) =>
      ReturnRequestTypeArr();

  Map<String, dynamic> toJson() => {};
}
