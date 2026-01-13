import 'package:tajer/app/modules/home/home_model.dart';

class WishListSearchModel {
  final String? msg;
  final String? responseCode;
  final String? status;
  final WishListData? data;

  WishListSearchModel({
    this.msg,
    this.responseCode,
    this.status,
    this.data,
  });

  factory WishListSearchModel.fromJson(Map<String, dynamic> json) => WishListSearchModel(
    msg: json["msg"],
    responseCode: json["responseCode"],
    status: json["status"],
    data: json["data"] == null ? null : WishListData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "msg": msg,
    "responseCode": responseCode,
    "status": status,
    "data": data?.toJson(),
  };
}

class WishListData {
  final String? cartItemsCount;
  final String? totalUnreadMessageCount;
  final String? totalFavouriteItems;
  final List<WishList>? wishLists;
  final String? currencySymbol;
  final String? totalUnreadNotificationCount;

  WishListData({
    this.cartItemsCount,
    this.totalUnreadMessageCount,
    this.totalFavouriteItems,
    this.wishLists,
    this.currencySymbol,
    this.totalUnreadNotificationCount,
  });

  factory WishListData.fromJson(Map<String, dynamic> json) => WishListData(
    cartItemsCount: json["cartItemsCount"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalFavouriteItems: json["totalFavouriteItems"],
    wishLists: json["wishLists"] == null ? [] : List<WishList>.from(json["wishLists"]!.map((x) => WishList.fromJson(x))),
    currencySymbol: json["currencySymbol"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
  );

  Map<String, dynamic> toJson() => {
    "cartItemsCount": cartItemsCount,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalFavouriteItems": totalFavouriteItems,
    "wishLists": wishLists == null ? [] : List<dynamic>.from(wishLists!.map((x) => x.toJson())),
    "currencySymbol": currencySymbol,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
  };
}

class WishList {
  final String? totalProducts;
  final String? uwlistType;
  final String? uwlistTitle;
  final DateTime? uwlistAddedOn;
  final String? uwlpUwlistId;
  final String? wishlistItemsProductCnt;
  final List<WishListProduct>? products;
  final String? uwlistUserId;
  final String? uwlistId;

  WishList({
    this.totalProducts,
    this.uwlistType,
    this.uwlistTitle,
    this.uwlistAddedOn,
    this.uwlpUwlistId,
    this.wishlistItemsProductCnt,
    this.products,
    this.uwlistUserId,
    this.uwlistId,
  });

  factory WishList.fromJson(Map<String, dynamic> json) => WishList(
    totalProducts: json["totalProducts"],
    uwlistType: json["uwlist_type"],
    uwlistTitle: json["uwlist_title"],
    uwlistAddedOn: json["uwlist_added_on"] == null ? null : DateTime.parse(json["uwlist_added_on"]),
    uwlpUwlistId: json["uwlp_uwlist_id"],
    wishlistItemsProductCnt: json["WishlistItemsProductCnt"],
    products: json["products"] == null ? [] : List<WishListProduct>.from(json["products"]!.map((x) => WishListProduct.fromJson(x))),
    uwlistUserId: json["uwlist_user_id"],
    uwlistId: json["uwlist_id"],
  );

  Map<String, dynamic> toJson() => {
    "totalProducts": totalProducts,
    "uwlist_type": uwlistType,
    "uwlist_title": uwlistTitle,
    "uwlist_added_on": uwlistAddedOn?.toIso8601String(),
    "uwlp_uwlist_id": uwlpUwlistId,
    "WishlistItemsProductCnt": wishlistItemsProductCnt,
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    "uwlist_user_id": uwlistUserId,
    "uwlist_id": uwlistId,
  };
}

class WishListProduct {
  final String? productName;
  final DateTime? productUpdatedOn;
  final String? productId;
  final String? selprodId;
  final String? selprodTitle;
  final String? inStock;

  WishListProduct({
    this.productName,
    this.productUpdatedOn,
    this.productId,
    this.selprodId,
    this.selprodTitle,
    this.inStock,
  });

  factory WishListProduct.fromJson(Map<String, dynamic> json) => WishListProduct(
    productName: json["product_name"],
    productUpdatedOn: json["product_updated_on"] == null ? null : DateTime.parse(json["product_updated_on"]),
    productId: json["product_id"],
    selprodId: json["selprod_id"],
    selprodTitle: json["selprod_title"],
    inStock: json["in_stock"],
  );

  Map<String, dynamic> toJson() => {
    "product_name": productName,
    "product_updated_on": productUpdatedOn?.toIso8601String(),
    "product_id": productId,
    "selprod_id": selprodId,
    "selprod_title": selprodTitle,
    "in_stock": inStock,
  };
}

class CommonResponseModel {
  final String? status;
  final String? responseCode;
  final String? msg;
  final CreateWishListData? data;

  CommonResponseModel({
    this.status,
    this.responseCode,
    this.msg,
    this.data,
  });

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) => CommonResponseModel(
    status: json["status"],
    responseCode: json["responseCode"],
    msg: json["msg"],
    data: json["data"] == null ? null : CreateWishListData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "responseCode": responseCode,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class UploadImageModel {
  final int? status;
  final String? msg;
  final int? recordId;

  UploadImageModel({
    this.status,
    this.msg,
    this.recordId,
  });

  factory UploadImageModel.fromJson(Map<String, dynamic> json) => UploadImageModel(
    status: json["status"],
    msg: json["msg"],
    recordId: json["recordId"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "recordId": recordId,
    "msg": msg,
  };
}


class CreateWishListData {
  final String? currencySymbol;
  final String? totalFavouriteItems;
  final String? cartItemsCount;
  final String? totalUnreadMessageCount;
  final String? totalUnreadNotificationCount;
  final String? wishListId;
  final String? tempToken;

  CreateWishListData({
    this.currencySymbol,
    this.totalFavouriteItems,
    this.cartItemsCount,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.wishListId,
    this.tempToken
  });

  factory CreateWishListData.fromJson(Map<String, dynamic> json) => CreateWishListData(
    currencySymbol: json["currencySymbol"],
    totalFavouriteItems: json["totalFavouriteItems"],
    cartItemsCount: json["cartItemsCount"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    wishListId: json["wish_list_id"],
    tempToken: json["tempToken"],
  );

  Map<String, dynamic> toJson() => {
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
    "cartItemsCount": cartItemsCount,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "wish_list_id": wishListId,
    "tempToken": tempToken,
  };
}

class WishListItemModel {
  final String? responseCode;
  final WishListItemData? data;
  final String? msg;
  final String? status;

  WishListItemModel({
    this.responseCode,
    this.data,
    this.msg,
    this.status,
  });

  factory WishListItemModel.fromJson(Map<String, dynamic> json) => WishListItemModel(
    responseCode: json["responseCode"],
    data: json["data"] == null ? null : WishListItemData.fromJson(json["data"]),
    msg: json["msg"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "data": data?.toJson(),
    "msg": msg,
    "status": status,
  };
}

class WishListItemData {
  final String? totalFavouriteItems;
  final String? cartItemsCount;
  final List<HomeProduct>? products;
  final String? showProductShortDescription;
  final String? pageCount;
  final String? totalUnreadMessageCount;
  final String? recordCount;
  final String? page;
  final String? showProductReturnPolicy;
  final String? currencySymbol;
  final String? totalUnreadNotificationCount;

  WishListItemData({
    this.totalFavouriteItems,
    this.cartItemsCount,
    this.products,
    this.showProductShortDescription,
    this.pageCount,
    this.totalUnreadMessageCount,
    this.recordCount,
    this.page,
    this.showProductReturnPolicy,
    this.currencySymbol,
    this.totalUnreadNotificationCount,
  });

  factory WishListItemData.fromJson(Map<String, dynamic> json) => WishListItemData(
    totalFavouriteItems: json["totalFavouriteItems"],
    cartItemsCount: json["cartItemsCount"],
    products: json["products"] == null ? [] : List<HomeProduct>.from(json["products"]!.map((x) => HomeProduct.fromJson(x))),
    showProductShortDescription: json["showProductShortDescription"],
    pageCount: json["pageCount"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    recordCount: json["recordCount"],
    page: json["page"],
    showProductReturnPolicy: json["showProductReturnPolicy"],
    currencySymbol: json["currencySymbol"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
  );

  Map<String, dynamic> toJson() => {
    "totalFavouriteItems": totalFavouriteItems,
    "cartItemsCount": cartItemsCount,
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    "showProductShortDescription": showProductShortDescription,
    "pageCount": pageCount,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "recordCount": recordCount,
    "page": page,
    "showProductReturnPolicy": showProductReturnPolicy,
    "currencySymbol": currencySymbol,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
  };
}