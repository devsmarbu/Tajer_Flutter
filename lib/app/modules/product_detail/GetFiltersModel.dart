class GetFiltersModel {
  final String? responseCode;
  final String? msg;
  final GetFiltersData? data;
  final String? status;

  GetFiltersModel({
    this.responseCode,
    this.msg,
    this.data,
    this.status,
  });

  factory GetFiltersModel.fromJson(Map<String, dynamic> json) => GetFiltersModel(
    responseCode: json["responseCode"],
    msg: json["msg"],
    data: json["data"] == null ? null : GetFiltersData.fromJson(json["data"]),
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "msg": msg,
    "data": data?.toJson(),
    "status": status,
  };
}

class GetFiltersData {
  final ProductFiltersArr? productFiltersArr;
  final String? currencySymbol;
  final String? priceInFilter;
  final List<ConditionsArr>? conditionsArr;
  final String? shopCatFilters;
  final String? filterDefaultMinValue;
  final List<dynamic>? brandsCheckedArr;
  final List<dynamic>? optionValueCheckedArr;
  final String? totalUnreadMessageCount;
  final String? filterDefaultMaxValue;
  final String? totalFavouriteItems;
  final String? availability;
  final List<dynamic>? conditionsCheckedArr;
  final List<GetFilter>? filters;
  final HeaderFormParamsAssocArr? headerFormParamsAssocArr;
  final String? totalUnreadNotificationCount;
  final List<dynamic>? prodcatArr;
  final String? cartItemsCount;
  final List<AvailabilityArr>? availabilityArr;

  GetFiltersData({
    this.productFiltersArr,
    this.currencySymbol,
    this.priceInFilter,
    this.conditionsArr,
    this.shopCatFilters,
    this.filterDefaultMinValue,
    this.brandsCheckedArr,
    this.optionValueCheckedArr,
    this.totalUnreadMessageCount,
    this.filterDefaultMaxValue,
    this.totalFavouriteItems,
    this.availability,
    this.conditionsCheckedArr,
    this.filters,
    this.headerFormParamsAssocArr,
    this.totalUnreadNotificationCount,
    this.prodcatArr,
    this.cartItemsCount,
    this.availabilityArr,
  });

  factory GetFiltersData.fromJson(Map<String, dynamic> json) => GetFiltersData(
    productFiltersArr: json["productFiltersArr"] == null ? null : ProductFiltersArr.fromJson(json["productFiltersArr"]),
    currencySymbol: json["currencySymbol"],
    priceInFilter: json["priceInFilter"],
    conditionsArr: json["conditionsArr"] == null ? [] : List<ConditionsArr>.from(json["conditionsArr"]!.map((x) => ConditionsArr.fromJson(x))),
    shopCatFilters: json["shopCatFilters"],
    filterDefaultMinValue: json["filterDefaultMinValue"],
    brandsCheckedArr: json["brandsCheckedArr"] == null ? [] : List<dynamic>.from(json["brandsCheckedArr"]!.map((x) => x)),
    optionValueCheckedArr: json["optionValueCheckedArr"] == null ? [] : List<dynamic>.from(json["optionValueCheckedArr"]!.map((x) => x)),
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    filterDefaultMaxValue: json["filterDefaultMaxValue"],
    totalFavouriteItems: json["totalFavouriteItems"],
    availability: json["availability"],
    conditionsCheckedArr: json["conditionsCheckedArr"] == null ? [] : List<dynamic>.from(json["conditionsCheckedArr"]!.map((x) => x)),
    filters: json["filters"] == null ? [] : List<GetFilter>.from(json["filters"]!.map((x) => GetFilter.fromJson(x))),
    headerFormParamsAssocArr: json["headerFormParamsAssocArr"] == null ? null : HeaderFormParamsAssocArr.fromJson(json["headerFormParamsAssocArr"]),
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    prodcatArr: json["prodcatArr"] == null ? [] : List<dynamic>.from(json["prodcatArr"]!.map((x) => x)),
    cartItemsCount: json["cartItemsCount"],
    availabilityArr: json["availabilityArr"] == null ? [] : List<AvailabilityArr>.from(json["availabilityArr"]!.map((x) => AvailabilityArr.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "productFiltersArr": productFiltersArr?.toJson(),
    "currencySymbol": currencySymbol,
    "priceInFilter": priceInFilter,
    "conditionsArr": conditionsArr == null ? [] : List<dynamic>.from(conditionsArr!.map((x) => x.toJson())),
    "shopCatFilters": shopCatFilters,
    "filterDefaultMinValue": filterDefaultMinValue,
    "brandsCheckedArr": brandsCheckedArr == null ? [] : List<dynamic>.from(brandsCheckedArr!.map((x) => x)),
    "optionValueCheckedArr": optionValueCheckedArr == null ? [] : List<dynamic>.from(optionValueCheckedArr!.map((x) => x)),
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "filterDefaultMaxValue": filterDefaultMaxValue,
    "totalFavouriteItems": totalFavouriteItems,
    "availability": availability,
    "conditionsCheckedArr": conditionsCheckedArr == null ? [] : List<dynamic>.from(conditionsCheckedArr!.map((x) => x)),
    "filters": filters == null ? [] : List<dynamic>.from(filters!.map((x) => x.toJson())),
    "headerFormParamsAssocArr": headerFormParamsAssocArr?.toJson(),
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "prodcatArr": prodcatArr == null ? [] : List<dynamic>.from(prodcatArr!.map((x) => x)),
    "cartItemsCount": cartItemsCount,
    "availabilityArr": availabilityArr == null ? [] : List<dynamic>.from(availabilityArr!.map((x) => x.toJson())),
  };
}

class AvailabilityArr {
  final String? inStock;

  AvailabilityArr({
    this.inStock,
  });

  factory AvailabilityArr.fromJson(Map<String, dynamic> json) => AvailabilityArr(
    inStock: json["in_stock"],
  );

  Map<String, dynamic> toJson() => {
    "in_stock": inStock,
  };
}

class ConditionsArr {
  final String? title;
  final String? value;

  ConditionsArr({
    this.title,
    this.value,
  });

  factory ConditionsArr.fromJson(Map<String, dynamic> json) => ConditionsArr(
    title: json["title"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "value": value,
  };
}

class GetFilter {
  final String? type;
  final String? title;
  final List<FilterDatum>? data;

  GetFilter({
    this.type,
    this.title,
    this.data,
  });

  factory GetFilter.fromJson(Map<String, dynamic> json) => GetFilter(
    type: json["type"],
    title: json["title"],
    data: json["data"] == null ? [] : List<FilterDatum>.from(json["data"]!.map((x) => FilterDatum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "title": title,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class FilterDatum {
  final String? prodcatParent;
  final String? prodcatCode;
  final String? prodcatId;
  final DateTime? prodcatUpdatedOn;
  final String? prodrootcatCode;
  final String? prodcatActive;
  final String? prodcatHasChild;
  final String? prodcatName;
  final String? prodcatOrdercode;
  final List<dynamic>? children;
  final String? prodcatContentBlock;
  final String? isLastChildCategory;
  final String? priority;
  final String? brandName;
  final String? brandId;
  final String? maxPrice;
  final String? availableInLocation;
  final String? minPrice;
  final String? title;
  final String? value;
  final String? optionvalue_name;
  final String? optionvalue_id;

  FilterDatum({
    this.prodcatParent,
    this.prodcatCode,
    this.prodcatId,
    this.prodcatUpdatedOn,
    this.prodrootcatCode,
    this.prodcatActive,
    this.prodcatHasChild,
    this.prodcatName,
    this.prodcatOrdercode,
    this.children,
    this.prodcatContentBlock,
    this.isLastChildCategory,
    this.priority,
    this.brandName,
    this.brandId,
    this.maxPrice,
    this.availableInLocation,
    this.minPrice,
    this.title,
    this.value,
    this.optionvalue_name,
    this.optionvalue_id,
  });

  factory FilterDatum.fromJson(Map<String, dynamic> json) => FilterDatum(
    prodcatParent: json["prodcat_parent"],
    prodcatCode: json["prodcat_code"],
    prodcatId: json["prodcat_id"],
    prodcatUpdatedOn: json["prodcat_updated_on"] == null ? null : DateTime.parse(json["prodcat_updated_on"]),
    prodrootcatCode: json["prodrootcat_code"],
    prodcatActive: json["prodcat_active"],
    prodcatHasChild: json["prodcat_has_child"],
    prodcatName: json["prodcat_name"],
    prodcatOrdercode: json["prodcat_ordercode"],
    children: json["children"] == null ? [] : List<dynamic>.from(json["children"]!.map((x) => x)),
    prodcatContentBlock: json["prodcat_content_block"],
    isLastChildCategory: json["isLastChildCategory"],
    priority: json["priority"],
    brandName: json["brand_name"],
    brandId: json["brand_id"],
    maxPrice: json["maxPrice"],
    availableInLocation: json["availableInLocation"],
    minPrice: json["minPrice"],
    title: json["title"],
    value: json["value"],
    optionvalue_name: json["optionvalue_name"],
    optionvalue_id: json["optionvalue_id"],
  );

  Map<String, dynamic> toJson() => {
    "prodcat_parent": prodcatParent,
    "prodcat_code": prodcatCode,
    "prodcat_id": prodcatId,
    "prodcat_updated_on": prodcatUpdatedOn?.toIso8601String(),
    "prodrootcat_code": prodrootcatCode,
    "prodcat_active": prodcatActive,
    "prodcat_has_child": prodcatHasChild,
    "prodcat_name": prodcatName,
    "prodcat_ordercode": prodcatOrdercode,
    "children": children == null ? [] : List<dynamic>.from(children!.map((x) => x)),
    "prodcat_content_block": prodcatContentBlock,
    "isLastChildCategory": isLastChildCategory,
    "priority": priority,
    "brand_name": brandName,
    "brand_id": brandId,
    "maxPrice": maxPrice,
    "availableInLocation": availableInLocation,
    "minPrice": minPrice,
    "title": title,
    "value": value,
    "optionvalue_name": optionvalue_name,
    "optionvalue_id": optionvalue_id,
  };
}

class HeaderFormParamsAssocArr {
  final String? position;
  final String? category;
  final String? doNotJoinSpecialPrice;
  final String? brandId;
  final String? keyword;
  final String? featured;
  final String? topProducts;
  final String? joinWithRelationTableInstead;
  final String? shopId;

  HeaderFormParamsAssocArr({
    this.position,
    this.category,
    this.doNotJoinSpecialPrice,
    this.brandId,
    this.keyword,
    this.featured,
    this.topProducts,
    this.joinWithRelationTableInstead,
    this.shopId,
  });

  factory HeaderFormParamsAssocArr.fromJson(Map<String, dynamic> json) => HeaderFormParamsAssocArr(
    position: json["position"],
    category: json["category"],
    doNotJoinSpecialPrice: json["doNotJoinSpecialPrice"],
    brandId: json["brand_id"],
    keyword: json["keyword"],
    featured: json["featured"],
    topProducts: json["top_products"],
    joinWithRelationTableInstead: json["joinWithRelationTableInstead"],
    shopId: json["shop_id"],
  );

  Map<String, dynamic> toJson() => {
    "position": position,
    "category": category,
    "doNotJoinSpecialPrice": doNotJoinSpecialPrice,
    "brand_id": brandId,
    "keyword": keyword,
    "featured": featured,
    "top_products": topProducts,
    "joinWithRelationTableInstead": joinWithRelationTableInstead,
    "shop_id": shopId,
  };
}

class ProductFiltersArr {
  final String? countForViewMore;

  ProductFiltersArr({
    this.countForViewMore,
  });

  factory ProductFiltersArr.fromJson(Map<String, dynamic> json) => ProductFiltersArr(
    countForViewMore: json["count_for_view_more"],
  );

  Map<String, dynamic> toJson() => {
    "count_for_view_more": countForViewMore,
  };
}