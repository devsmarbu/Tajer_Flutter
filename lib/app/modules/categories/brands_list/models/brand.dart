class BrandModel {
  final BrandData? data;
  final String? msg;
  final String? status;
  final String? responseCode;

  BrandModel({
    this.data,
    this.msg,
    this.status,
    this.responseCode,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
    data: json["data"] == null ? null : BrandData.fromJson(json["data"]),
    msg: json["msg"],
    status: json["status"],
    responseCode: json["responseCode"],
  );

  Map<String, dynamic> toJson() => {
    "data": data?.toJson(),
    "msg": msg,
    "status": status,
    "responseCode": responseCode,
  };
}

class BrandData {
  final String? totalFavouriteItems;
  final String? totalUnreadNotificationCount;
  final String? layoutDirection;
  final String? totalUnreadMessageCount;
  final String? currencySymbol;
  final List<AllBrand>? allBrands;
  final String? cartItemsCount;

  BrandData({
    this.totalFavouriteItems,
    this.totalUnreadNotificationCount,
    this.layoutDirection,
    this.totalUnreadMessageCount,
    this.currencySymbol,
    this.allBrands,
    this.cartItemsCount,
  });

  factory BrandData.fromJson(Map<String, dynamic> json) {
    // 🔹 Handle both "allBrands" and "collectionItems"
    final brandList = json["allBrands"] ?? json["collectionItems"] ?? [];

    return BrandData(
      totalFavouriteItems: json["totalFavouriteItems"],
      totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
      layoutDirection: json["layoutDirection"],
      totalUnreadMessageCount: json["totalUnreadMessageCount"],
      currencySymbol: json["currencySymbol"],
      allBrands: List<AllBrand>.from(brandList.map((x) => AllBrand.fromJson(x))),
      cartItemsCount: json["cartItemsCount"],
    );
  }

  Map<String, dynamic> toJson() => {
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "layoutDirection": layoutDirection,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "currencySymbol": currencySymbol,
    "allBrands": allBrands == null
        ? []
        : List<dynamic>.from(allBrands!.map((x) => x.toJson())),
    "cartItemsCount": cartItemsCount,
  };
}

class AllBrand {
  final String? brandId;
  final String? seoPageDesc;
  final String? brandImage;
  final String? brandName;

  AllBrand({
    this.brandId,
    this.seoPageDesc,
    this.brandImage,
    this.brandName,
  });

  factory AllBrand.fromJson(Map<String, dynamic> json) => AllBrand(
    brandId: json["brand_id"],
    seoPageDesc: json["seo_page_desc"],
    brandImage: json["brand_image"],
    brandName: json["brand_name"],
  );

  Map<String, dynamic> toJson() => {
    "brand_id": brandId,
    "seo_page_desc": seoPageDesc,
    "brand_image": brandImage,
    "brand_name": brandName,
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

//SHOP MODEL
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

class ShopModel {
  final String? status;
  final CategoryShopData? data;
  final String? responseCode;
  final String? msg;

  ShopModel({
    this.status,
    this.data,
    this.responseCode,
    this.msg,
  });

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
    status: json["status"],
    data: json["data"] == null ? null : CategoryShopData.fromJson(json["data"]),
    responseCode: json["responseCode"],
    msg: json["msg"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "responseCode": responseCode,
    "msg": msg,
  };
}

class CategoryShopData {
  final String? pageCount;
  final String? cartItemsCount;
  final List<AllShop>? allShops;
  final String? totalUnreadMessageCount;
  final String? recordCount;
  final String? currencySymbol;
  final String? totalUnreadNotificationCount;
  final String? page;
  final String? pageSize;
  final String? totalFavouriteItems;

  CategoryShopData({
    this.pageCount,
    this.cartItemsCount,
    this.allShops,
    this.totalUnreadMessageCount,
    this.recordCount,
    this.currencySymbol,
    this.totalUnreadNotificationCount,
    this.page,
    this.pageSize,
    this.totalFavouriteItems,
  });

  factory CategoryShopData.fromJson(Map<String, dynamic> json) {
    // 🔹 Pick whichever list exists first (allShops or collectionItems)
    final shopList = json["allShops"] ?? json["collectionItems"] ?? [];

    return CategoryShopData(
      pageCount: json["pageCount"],
      cartItemsCount: json["cartItemsCount"],
      allShops: List<AllShop>.from(shopList.map((x) => AllShop.fromJson(x))),
      totalUnreadMessageCount: json["totalUnreadMessageCount"],
      recordCount: json["recordCount"],
      currencySymbol: json["currencySymbol"],
      totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
      page: json["page"],
      pageSize: json["pageSize"],
      totalFavouriteItems: json["totalFavouriteItems"],
    );
  }

  Map<String, dynamic> toJson() =>
      {
        "pageCount": pageCount,
        "cartItemsCount": cartItemsCount,
        "allShops": allShops == null ? [] : List<dynamic>.from(
            allShops!.map((x) => x.toJson())),
        "totalUnreadMessageCount": totalUnreadMessageCount,
        "recordCount": recordCount,
        "currencySymbol": currencySymbol,
        "totalUnreadNotificationCount": totalUnreadNotificationCount,
        "page": page,
        "pageSize": pageSize,
        "totalFavouriteItems": totalFavouriteItems,
      };
}

class AllShop {
  final String? shopTotalReviews;
  final String? shopLogo;
  final String? shopCreatedOn;
  final String? shopDescription;
  final String? countryName;
  final String? stateName;
  final String? shopCity;
  final List<dynamic>? tRightRibbons;
  final String? shopUpdatedOn;
  final String? shopRating;
  final String? shopUserId;
  final String? shopLtemplateId;
  final String? shopName;
  final String? totalProducts;
  final List<Product>? products;
  final String? shopId;

  AllShop({
    this.shopTotalReviews,
    this.shopLogo,
    this.shopCreatedOn,
    this.shopDescription,
    this.countryName,
    this.stateName,
    this.shopCity,
    this.tRightRibbons,
    this.shopUpdatedOn,
    this.shopRating,
    this.shopUserId,
    this.shopLtemplateId,
    this.shopName,
    this.totalProducts,
    this.products,
    this.shopId,
  });

  factory AllShop.fromJson(Map<String, dynamic> json) => AllShop(
    shopTotalReviews: json["shopTotalReviews"],
    shopLogo: json["shop_logo"],
    shopCreatedOn: json["shop_created_on"],
    shopDescription: json["shop_description"],
    countryName: json["country_name"],
    stateName: json["state_name"],
    shopCity: json["shop_city"],
    tRightRibbons: json["tRightRibbons"],
    shopUpdatedOn: json["shop_updated_on"],
    shopRating: json["shopRating"],
    shopUserId: json["shop_user_id"],
    shopLtemplateId: json["shop_ltemplate_id"],
    shopName: json["shop_name"],
    totalProducts: json["totalProducts"],
    products: json["products"] == null ? [] : List<Product>.from(json["products"]!.map((x) => Product.fromJson(x))),
    shopId: json["shop_id"],
  );

  Map<String, dynamic> toJson() => {
    "shopTotalReviews": shopTotalReviews,
    "shop_logo": shopLogo,
    "shop_created_on": shopCreatedOn,
    "shop_description": shopDescription,
    "country_name": countryName,
    "state_name": stateName,
    "shop_city": shopCity,
    "tRightRibbons": tRightRibbons == null ? [] : List<dynamic>.from(tRightRibbons!.map((x) => x)),
    "shop_updated_on": shopUpdatedOn,
    "shopRating": shopRating,
    "shop_user_id": shopUserId,
    "shop_ltemplate_id": shopLtemplateId,
    "shop_name": shopName,
    "totalProducts": totalProducts,
    "products": products == null ? [] : List<dynamic>.from(products!.map((x) => x.toJson())),
    "shop_id": shopId,
  };
}

class Product {
  final String? theprice;
  final String? selprodTitle;
  final String? splpriceDisplayDisType;
  final String? specialPriceFound;
  final String? availableInLocation;
  final String? selprodId;
  final String? productName;
  final String? selprodStock;
  final String? splpriceDisplayListPrice;
  final String? productUpdatedOn;
  final String? brandName;
  final String? prodcatName;
  final String? inStock;
  final String? brandId;
  final String? splpriceDisplayDisVal;
  final String? productId;
  final String? selprodSoldCount;
  final String? selprodCondition;
  final String? selprodPrice;
  final String? prodcatId;

  Product({
    this.theprice,
    this.selprodTitle,
    this.splpriceDisplayDisType,
    this.specialPriceFound,
    this.availableInLocation,
    this.selprodId,
    this.productName,
    this.selprodStock,
    this.splpriceDisplayListPrice,
    this.productUpdatedOn,
    this.brandName,
    this.prodcatName,
    this.inStock,
    this.brandId,
    this.splpriceDisplayDisVal,
    this.productId,
    this.selprodSoldCount,
    this.selprodCondition,
    this.selprodPrice,
    this.prodcatId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    theprice: json["theprice"],
    selprodTitle: json["selprod_title"],
    splpriceDisplayDisType: json["splprice_display_dis_type"],
    specialPriceFound: json["special_price_found"],
    availableInLocation: json["availableInLocation"],
    selprodId: json["selprod_id"],
    productName: json["product_name"],
    selprodStock: json["selprod_stock"],
    splpriceDisplayListPrice: json["splprice_display_list_price"],
    productUpdatedOn: json["product_updated_on"],
    brandName: json["brand_name"],
    prodcatName: json["prodcat_name"],
    inStock: json["in_stock"],
    brandId: json["brand_id"],
    splpriceDisplayDisVal: json["splprice_display_dis_val"],
    productId: json["product_id"],
    selprodSoldCount: json["selprod_sold_count"],
    selprodCondition: json["selprod_condition"],
    selprodPrice: json["selprod_price"],
    prodcatId: json["prodcat_id"],
  );

  Map<String, dynamic> toJson() => {
    "theprice": theprice,
    "selprod_title": selprodTitle,
    "splprice_display_dis_type": splpriceDisplayDisType,
    "special_price_found": specialPriceFound,
    "availableInLocation": availableInLocation,
    "selprod_id": selprodId,
    "product_name": productName,
    "selprod_stock": selprodStock,
    "splprice_display_list_price": splpriceDisplayListPrice,
    "product_updated_on": productUpdatedOn,
    "brand_name": brandName,
    "prodcat_name": prodcatName,
    "in_stock": inStock,
    "brand_id": brandId,
    "splprice_display_dis_val": splpriceDisplayDisVal,
    "product_id": productId,
    "selprod_sold_count": selprodSoldCount,
    "selprod_condition": selprodCondition,
    "selprod_price": selprodPrice,
    "prodcat_id": prodcatId,
  };
}

