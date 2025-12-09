class ShopDetailModel {
  final String? status;
  final String? responseCode;
  final String? msg;
  final ShopData? data;

  ShopDetailModel({
    this.status,
    this.responseCode,
    this.msg,
    this.data,
  });

  factory ShopDetailModel.fromJson(Map<String, dynamic> json) => ShopDetailModel(
    status: json["status"],
    responseCode: json["responseCode"],
    msg: json["msg"],
    data: json["data"] == null ? null : ShopData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "responseCode": responseCode,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class ShopData {
  final String? currencySymbol;
  final String? totalFavouriteItems;
  final String? totalUnreadMessageCount;
  final String? totalUnreadNotificationCount;
  final String? cartItemsCount;
  final Shop? shop;
  final String? page;
  final String? pageSize;
  final String? pageCount;
  final String? recordCount;
  final String? shopId;
  final PostedData? postedData;
  final String? siteLangId;
  final String? pageTitle;

  ShopData({
    this.currencySymbol,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.shop,
    this.page,
    this.pageSize,
    this.pageCount,
    this.recordCount,
    this.shopId,
    this.postedData,
    this.siteLangId,
    this.pageTitle,
  });

  factory ShopData.fromJson(Map<String, dynamic> json) => ShopData(
    currencySymbol: json["currencySymbol"],
    totalFavouriteItems: json["totalFavouriteItems"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    cartItemsCount: json["cartItemsCount"],
    shop: json["shop"] == null ? null : Shop.fromJson(json["shop"]),
    page: json["page"],
    pageSize: json["pageSize"],
    pageCount: json["pageCount"],
    recordCount: json["recordCount"],
    shopId: json["shopId"],
    postedData: json["postedData"] == null ? null : PostedData.fromJson(json["postedData"]),
    siteLangId: json["siteLangId"],
    pageTitle: json["pageTitle"],
  );

  Map<String, dynamic> toJson() => {
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "shop": shop?.toJson(),
    "page": page,
    "pageSize": pageSize,
    "pageCount": pageCount,
    "recordCount": recordCount,
    "shopId": shopId,
    "postedData": postedData?.toJson(),
    "siteLangId": siteLangId,
    "pageTitle": pageTitle,
  };
}

class PostedData {
  final String? shopId;
  final String? page;
  final String? pageSize;
  final String? pageRecordCount;

  PostedData({
    this.shopId,
    this.page,
    this.pageSize,
    this.pageRecordCount,
  });

  factory PostedData.fromJson(Map<String, dynamic> json) => PostedData(
    shopId: json["shop_id"],
    page: json["page"],
    pageSize: json["pageSize"],
    pageRecordCount: json["pageRecordCount"],
  );

  Map<String, dynamic> toJson() => {
    "shop_id": shopId,
    "page": page,
    "pageSize": pageSize,
    "pageRecordCount": pageRecordCount,
  };
}





class Shop {
  final String? shopId;
  final String? userName;
  final DateTime? userRegdate;
  final String? shopUserId;
  final String? shopLtemplateId;
  final DateTime? shopCreatedOn;
  final String? shopName;
  final String? shopDescription;
  final String? shopCountryName;
  final String? shopStateName;
  final String? shopCity;
  final String? isFavorite;
  final String? shopOwnerName;
  final String? shopOwnerUsername;
  final Description? description;
  final String? rating;
  final String? shopLogo;
  final String? shopBanner;
  final List<Badge>? badges;
  final List<dynamic>? policies;
  final List<dynamic>? socialPlatforms;

  Shop({
    this.shopId,
    this.userName,
    this.userRegdate,
    this.shopUserId,
    this.shopLtemplateId,
    this.shopCreatedOn,
    this.shopName,
    this.shopDescription,
    this.shopCountryName,
    this.shopStateName,
    this.shopCity,
    this.isFavorite,
    this.shopOwnerName,
    this.shopOwnerUsername,
    this.description,
    this.rating,
    this.shopLogo,
    this.shopBanner,
    this.badges,
    this.policies,
    this.socialPlatforms,
  });

  factory Shop.fromJson(Map<String, dynamic> json) => Shop(
    shopId: json["shop_id"],
    userName: json["user_name"],
    userRegdate: json["user_regdate"] == null ? null : DateTime.parse(json["user_regdate"]),
    shopUserId: json["shop_user_id"],
    shopLtemplateId: json["shop_ltemplate_id"],
    shopCreatedOn: json["shop_created_on"] == null ? null : DateTime.parse(json["shop_created_on"]),
    shopName: json["shop_name"],
    shopDescription: json["shop_description"],
    shopCountryName: json["shop_country_name"],
    shopStateName: json["shop_state_name"],
    shopCity: json["shop_city"],
    isFavorite: json["is_favorite"],
    shopOwnerName: json["shop_owner_name"],
    shopOwnerUsername: json["shop_owner_username"],
    description: json["description"] == null ? null : Description.fromJson(json["description"]),
    rating: json["rating"],
    shopLogo: json["shop_logo"],
    shopBanner: json["shop_banner"],
    badges: json["badges"] == null ? [] : List<Badge>.from(json["badges"]!.map((x) => Badge.fromJson(x))),
    policies: json["policies"] == null ? [] : List<dynamic>.from(json["policies"]!.map((x) => x)),
    socialPlatforms: json["socialPlatforms"] == null ? [] : List<dynamic>.from(json["socialPlatforms"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "shop_id": shopId,
    "user_name": userName,
    "user_regdate": userRegdate?.toIso8601String(),
    "shop_user_id": shopUserId,
    "shop_ltemplate_id": shopLtemplateId,
    "shop_created_on": shopCreatedOn?.toIso8601String(),
    "shop_name": shopName,
    "shop_description": shopDescription,
    "shop_country_name": shopCountryName,
    "shop_state_name": shopStateName,
    "shop_city": shopCity,
    "is_favorite": isFavorite,
    "shop_owner_name": shopOwnerName,
    "shop_owner_username": shopOwnerUsername,
    "description": description?.toJson(),
    "rating": rating,
    "shop_logo": shopLogo,
    "shop_banner": shopBanner,
    "badges": badges == null ? [] : List<dynamic>.from(badges!.map((x) => x.toJson())),
    "policies": policies == null ? [] : List<dynamic>.from(policies!.map((x) => x)),
    "socialPlatforms": socialPlatforms == null ? [] : List<dynamic>.from(socialPlatforms!.map((x) => x)),
  };
}

class Badge {
  final String? url;
  final String? badgeName;

  Badge({
    this.url,
    this.badgeName,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    url: json["url"],
    badgeName: json["badge_name"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "badge_name": badgeName,
  };
}

class Description {
  final String? title;
  final String? description;

  Description({
    this.title,
    this.description,
  });

  factory Description.fromJson(Map<String, dynamic> json) => Description(
    title: json["title"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "description": description,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}