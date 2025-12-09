import 'package:tajer/app/modules/home/home_model.dart';

class FilteredProduct {
  final String? msg;
  final String? responseCode;
  final String? status;
  final Data? data;

  FilteredProduct({
    this.msg,
    this.responseCode,
    this.status,
    this.data,
  });

  factory FilteredProduct.fromJson(Map<String, dynamic> json) => FilteredProduct(
    msg: json["msg"],
    responseCode: json["responseCode"],
    status: json["status"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "responseCode": responseCode,
    "status": status,
    "data": data?.toJson(),
  };
}

class Data {
  final String? cartItemsCount;
  final String? recordCount;
  final String? currencySymbol;
  final List<HomeProduct>? products;
  final String? page;
  final String? pageCount;
  final String? totalUnreadMessageCount;
  final String? totalFavouriteItems;
  final String? totalUnreadNotificationCount;
  final String? pageSize;

  Data({
    this.cartItemsCount,
    this.recordCount,
    this.currencySymbol,
    this.products,
    this.page,
    this.pageCount,
    this.totalUnreadMessageCount,
    this.totalFavouriteItems,
    this.totalUnreadNotificationCount,
    this.pageSize,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    cartItemsCount: json["cartItemsCount"],
    recordCount: json["recordCount"],
    currencySymbol: json["currencySymbol"],
    products: json["products"] == null ? [] : List<HomeProduct>.from(json["products"]!.map((x) => HomeProduct.fromJson(x))),
    page: json["page"],
    pageCount: json["pageCount"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalFavouriteItems: json["totalFavouriteItems"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    pageSize: json["pageSize"],
  );

  Map<String, dynamic> toJson() => {
    "cartItemsCount": cartItemsCount,
    "recordCount": recordCount,
    "currencySymbol": currencySymbol,
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    "page": page,
    "pageCount": pageCount,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "pageSize": pageSize,
  };
}