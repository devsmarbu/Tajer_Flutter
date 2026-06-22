// To parse this JSON data, do
//
//     final productDetailModel = productDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:tajer/app/modules/home/home_model.dart';

ProductDetailModel productDetailModelFromJson(String str) =>
    ProductDetailModel.fromJson(json.decode(str));

String productDetailModelToJson(ProductDetailModel data) =>
    json.encode(data.toJson());

class ProductDetailModel {
  final String? responseCode;
  final ProductDetailData? data;
  final String? msg;
  final String? status;

  ProductDetailModel({this.responseCode, this.data, this.msg, this.status});

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) =>
      ProductDetailModel(
        responseCode: json["responseCode"],
        data: json["data"] == null
            ? null
            : ProductDetailData.fromJson(json["data"]),
        msg: json["msg"],
        status: json["status"].toString(),
      );

  Map<String, dynamic> toJson() => {
    "responseCode": responseCode,
    "data": data?.toJson(),
    "msg": msg,
    "status": status,
  };
}

class ProductDetailData {
  final String? cartItemsCount;
  final String? totalFavouriteItems;
  final String? cartSellerId;
  final String? cartHasProducts;
  final String? totalUnreadNotificationCount;
  final String? pageCount;
  final String? currencySymbol;
  final List<Datum>? data;
  final String? totalUnreadMessageCount;

  ProductDetailData({
    this.cartItemsCount,
    this.totalFavouriteItems,
    this.cartSellerId,
    this.cartHasProducts,
    this.totalUnreadNotificationCount,
    this.pageCount,
    this.currencySymbol,
    this.data,
    this.totalUnreadMessageCount,
  });

  factory ProductDetailData.fromJson(Map<String, dynamic> json) =>
      ProductDetailData(
        cartItemsCount: json["cartItemsCount"],
        totalFavouriteItems: json["totalFavouriteItems"],
        cartSellerId: json["cartSellerId"],
        cartHasProducts: json["cartHasProducts"],
        totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
        pageCount: json["pageCount"],
        currencySymbol: json["currencySymbol"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        totalUnreadMessageCount: json["totalUnreadMessageCount"],
      );

  Map<String, dynamic> toJson() => {
    "cartItemsCount": cartItemsCount,
    "totalFavouriteItems": totalFavouriteItems,
    "cartSellerId": cartSellerId,
    "cartHasProducts": cartHasProducts,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "pageCount": pageCount,
    "currencySymbol": currencySymbol,
    "data": data == null
        ? []
        : List<dynamic>.from(data!.map((x) => x.toJson())),
    "totalUnreadMessageCount": totalUnreadMessageCount,
  };
}

class Datum {
  final String? title;
  final Content? content;
  final String? type;
  final String? sizeChartImage;
  final String? isSizeChartAvailable;
  final ProductDetailType customType;

  Datum({
    this.title,
    this.content,
    this.type,
    this.sizeChartImage,
    this.isSizeChartAvailable,
  }) : customType = productTypeFromString(type);

  factory Datum.fromJson(Map<String, dynamic> json) {
    final type = json["type"] as String?;
    final customType = productTypeFromString(type);

    return Datum(
      type: type,
      title: json["title"],
      isSizeChartAvailable: json["isSizeChartAvailable"],
      sizeChartImage: json["sizeChartImage"],
      content: Content.fromJson(json, customType),
    );
  }

  Map<String, dynamic> toJson() => {
    "title": title,
    "content": content,
    "type": type,
    "sizeChartImage": sizeChartImage,
    "isSizeChartAvailable": isSizeChartAvailable,
  };
}

enum ProductDetailType {
  productImages, // type = "2"
  productDetail, // type = "1"
  boxContent, // type = "18"
  productOption, // type = "3"
  productSpecifications, // type = "4"
  volumeDiscount, // type = "5"
  productDescription, // type = "15"
  productPolicies, // type = "14"
  banner, // type = "10"
  similarProducts, // type = "7"
  recommendedProducts, // type = "8"
  buyTogether, // type = "6"
  shop, // type = "13"
  reviews, // type = "9"
  previewFiles, // type = "16"
  modelMesurement, // type = "16"
  unknown, // default
}

ProductDetailType productTypeFromString(String? type) {
  switch (type) {
    case "1":
      return ProductDetailType.productDetail;
    case "2":
      return ProductDetailType.productImages;
    case "3":
      return ProductDetailType.productOption;
    case "4":
      return ProductDetailType.productSpecifications;
    case "5":
      return ProductDetailType.volumeDiscount;
    case "6":
      return ProductDetailType.buyTogether;
    case "7":
      return ProductDetailType.similarProducts;
    case "8":
      return ProductDetailType.recommendedProducts;
    case "9":
      return ProductDetailType.reviews;
    case "10":
      return ProductDetailType.banner;
    case "13":
      return ProductDetailType.shop;
    case "14":
      return ProductDetailType.productPolicies;
    case "15":
      return ProductDetailType.productDescription;
    case "16":
      return ProductDetailType.previewFiles;
    case "17":
      return ProductDetailType.modelMesurement;
    case "18":
      return ProductDetailType.boxContent;
    default:
      return ProductDetailType.unknown;
  }
}

class OptionValue {
  final String? productName;
  final String? selprodId;
  final String? optionvalueName;
  final String? optionvalueColorCode;
  final String? productImageUrl;
  final String? selprodUserId;
  final String? theprice;
  final String? selprodCode;
  final String? optionUrlValue;
  final String? isAvailable;
  final String? optionvalueId;
  final String? optionId;
  final String? isSelected;
  final String? stock;

  OptionValue({
    this.productName,
    this.selprodId,
    this.optionvalueName,
    this.optionvalueColorCode,
    this.productImageUrl,
    this.selprodUserId,
    this.theprice,
    this.selprodCode,
    this.optionUrlValue,
    this.isAvailable,
    this.optionvalueId,
    this.optionId,
    this.isSelected,
    this.stock,
  });

  factory OptionValue.fromJson(Map<String, dynamic> json) => OptionValue(
    productName: json["product_name"],
    selprodId: json["selprod_id"],
    optionvalueName: json["optionvalue_name"],
    optionvalueColorCode: json["optionvalue_color_code"],
    productImageUrl: json["product_image_url"],
    selprodUserId: json["selprod_user_id"],
    theprice: json["theprice"],
    selprodCode: json["selprod_code"],
    optionUrlValue: json["optionUrlValue"],
    isAvailable: json["isAvailable"],
    optionvalueId: json["optionvalue_id"],
    optionId: json["option_id"],
    isSelected: json["isSelected"],
    stock: json["stock"],
  );

  Map<String, dynamic> toJson() => {
    "product_name": productName,
    "selprod_id": selprodId,
    "optionvalue_name": optionvalueName,
    "optionvalue_color_code": optionvalueColorCode,
    "product_image_url": productImageUrl, // <-- Add this
    "selprod_user_id": selprodUserId,
    "theprice": theprice,
    "selprod_code": selprodCode,
    "optionUrlValue": optionUrlValue,
    "isAvailable": isAvailable,
    "optionvalue_id": optionvalueId,
    "option_id": optionId,
    "isSelected": isSelected,
    "stock": stock,
  };
}

class ProductDetail {
  final String? shopFulfillmentBy;
  final DateTime? productUpdatedOn;
  final String? productYoutubeVideo;
  final String? userName;
  final String? isInAnyWishlist;
  final String? productUpc;
  final List<dynamic>? moreSellersArr;
  final String? productWarranty;
  final String? isComingsoon;
  final String? totReviews;
  final SelprodReturnPolicies? selprodReturnPolicies;
  final String? brandId;
  final String? selprodThresholdStockLevel;
  final String? discount;
  final String? youtubeUrlThumbnail;
  final String? productWarrantyUnitLabel;
  final String? selprodFulfillmentFrom;
  final String? selprodExchangeAge;
  final String? shopCountryName;
  final String? splpriceDisplayListPrice;
  final String? selprodFulfillmentType;
  final String? productType;
  final String? productDescription;
  final String? selprodWarranty;
  final String? shopCancellationAge;
  final String? productModel;
  final String? codEnabled;
  final String? productShortDescription;
  final String? prodcatName;
  final String? productName;
  final String? selprodComments;
  final String? brandShortDescription;
  final String? inclusiveTax;
  final String? selprodProductId;
  final String? isNotified;
  final String? productIdentifier;
  final String? splpriceStartDate;
  final String? selprodCode;
  final String? selprodSku;
  final String? productSellerId;
  final String? productAttachementsWithInventory;
  final String? shopReturnAge;
  final String? selprodTitle;
  final String? splpriceDisplayDisVal;
  final String? productAttrgrpId;
  final String? selprodPrice;
  final String? theprice;
  final String? selprodUserId;
  final String? prodcatId;
  final String? productUrl;
  final SelprodReturnPolicies? shippingDetails;
  final String? productCodEnabled;
  final DateTime? selprodAvailableFrom;
  final String? shopId;
  final String? selprodReturnPolicy;
  final SocialShareContent? socialShareContent;
  final String? isOutOfMinOrderQty;
  final String? brandName;
  final String? selprodCodEnabled;
  final String? prodRating;
  final String? specialPriceFound;
  final String? selprodId;
  final String? selprodCondition;
  final String? selprodReturnAge;
  final String? shopFulfillmentType;
  final String? reportProduct;
  final List<Badge>? badges;
  final String? productId;
  final String? inStock;
  final String? shopExchangeAge;
  final String? selprodStock;
  final List<dynamic>? ribbons;
  final String? productWarrantyUnit;
  final String? splpriceDisplayDisType;
  final SelprodReturnPolicies? selprodWarrantyPolicies;
  final String? selprodConditionTitle;
  final String? productIsbn;
  final String? shopShipmentDays;
  final String? splpriceEndDate;
  final String? availableInLocation;
  final String? selprodCancellationAge;
  final String? shopStateName;
  final String? productFulfillmentType;
  final String? selprodMinOrderQty;
  final String? shopName;
  final String? shopRating;
  final String? shopDescription;
  final String? shopDeliveryPolicy;
  final String? shopCity;
  final String? shopRefundPolicy;
  final DateTime? shopCreatedOn;
  final String? shopPaymentPolicy;
  final String? shopTotalReviews;
  final String? shopLtemplateId;
  final String? shopUserId;

  ProductDetail({
    this.shopFulfillmentBy,
    this.productUpdatedOn,
    this.productYoutubeVideo,
    this.userName,
    this.isInAnyWishlist,
    this.productUpc,
    this.moreSellersArr,
    this.productWarranty,
    this.isComingsoon,
    this.totReviews,
    this.selprodReturnPolicies,
    this.brandId,
    this.selprodThresholdStockLevel,
    this.discount,
    this.youtubeUrlThumbnail,
    this.productWarrantyUnitLabel,
    this.selprodFulfillmentFrom,
    this.selprodExchangeAge,
    this.shopCountryName,
    this.splpriceDisplayListPrice,
    this.selprodFulfillmentType,
    this.productType,
    this.productDescription,
    this.selprodWarranty,
    this.shopCancellationAge,
    this.productModel,
    this.codEnabled,
    this.productShortDescription,
    this.prodcatName,
    this.productName,
    this.selprodComments,
    this.brandShortDescription,
    this.inclusiveTax,
    this.selprodProductId,
    this.isNotified,
    this.productIdentifier,
    this.splpriceStartDate,
    this.selprodCode,
    this.selprodSku,
    this.productSellerId,
    this.productAttachementsWithInventory,
    this.shopReturnAge,
    this.selprodTitle,
    this.splpriceDisplayDisVal,
    this.productAttrgrpId,
    this.selprodPrice,
    this.theprice,
    this.selprodUserId,
    this.prodcatId,
    this.productUrl,
    this.shippingDetails,
    this.productCodEnabled,
    this.selprodAvailableFrom,
    this.shopId,
    this.selprodReturnPolicy,
    this.socialShareContent,
    this.isOutOfMinOrderQty,
    this.brandName,
    this.selprodCodEnabled,
    this.prodRating,
    this.specialPriceFound,
    this.selprodId,
    this.selprodCondition,
    this.selprodReturnAge,
    this.shopFulfillmentType,
    this.reportProduct,
    this.badges,
    this.productId,
    this.inStock,
    this.shopExchangeAge,
    this.selprodStock,
    this.ribbons,
    this.productWarrantyUnit,
    this.splpriceDisplayDisType,
    this.selprodWarrantyPolicies,
    this.selprodConditionTitle,
    this.productIsbn,
    this.shopShipmentDays,
    this.splpriceEndDate,
    this.availableInLocation,
    this.selprodCancellationAge,
    this.shopStateName,
    this.productFulfillmentType,
    this.selprodMinOrderQty,
    this.shopName,
    this.shopRating,
    this.shopDescription,
    this.shopDeliveryPolicy,
    this.shopCity,
    this.shopRefundPolicy,
    this.shopCreatedOn,
    this.shopPaymentPolicy,
    this.shopTotalReviews,
    this.shopLtemplateId,
    this.shopUserId,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) => ProductDetail(
    shopFulfillmentBy: json["shop_fulfillment_by"],
    productUpdatedOn: json["product_updated_on"] == null
        ? null
        : DateTime.parse(json["product_updated_on"]),
    productYoutubeVideo: json["product_youtube_video"],
    userName: json["user_name"],
    isInAnyWishlist: json["is_in_any_wishlist"],
    productUpc: json["product_upc"],
    moreSellersArr: json["moreSellersArr"] == null
        ? []
        : List<dynamic>.from(json["moreSellersArr"]!.map((x) => x)),
    productWarranty: json["product_warranty"],
    isComingsoon: json["isComingsoon"],
    totReviews: json["totReviews"],
    selprodReturnPolicies: json["selprod_return_policies"] == null
        ? null
        : SelprodReturnPolicies.fromJson(json["selprod_return_policies"]),
    brandId: json["brand_id"],
    selprodThresholdStockLevel: json["selprod_threshold_stock_level"],
    discount: json["discount"],
    youtubeUrlThumbnail: json["youtubeUrlThumbnail"],
    productWarrantyUnitLabel: json["product_warranty_unit_label"],
    selprodFulfillmentFrom: json["selprod_fulfillment_from"],
    selprodExchangeAge: json["selprod_exchange_age"],
    shopCountryName: json["shop_country_name"],
    splpriceDisplayListPrice: json["splprice_display_list_price"],
    selprodFulfillmentType: json["selprod_fulfillment_type"],
    productType: json["product_type"],
    productDescription: json["product_description"],
    selprodWarranty: json["selprod_warranty"],
    shopCancellationAge: json["shop_cancellation_age"],
    productModel: json["product_model"],
    codEnabled: json["codEnabled"],
    productShortDescription: json["product_short_description"],
    prodcatName: json["prodcat_name"],
    productName: json["product_name"],
    selprodComments: json["selprodComments"],
    brandShortDescription: json["brand_short_description"],
    inclusiveTax: json["inclusiveTax"],
    selprodProductId: json["selprod_product_id"],
    isNotified: json["isNotified"],
    productIdentifier: json["product_identifier"],
    splpriceStartDate: json["splprice_start_date"],
    selprodCode: json["selprod_code"],
    selprodSku: json["selprod_sku"],
    productSellerId: json["product_seller_id"],
    productAttachementsWithInventory:
        json["product_attachements_with_inventory"],
    shopReturnAge: json["shop_return_age"],
    selprodTitle: json["selprod_title"],
    splpriceDisplayDisVal: json["splprice_display_dis_val"],
    productAttrgrpId: json["product_attrgrp_id"],
    selprodPrice: json["selprod_price"],
    theprice: json["theprice"],
    selprodUserId: json["selprod_user_id"],
    prodcatId: json["prodcat_id"],
    productUrl: json["productUrl"],
    shippingDetails: json["shippingDetails"] == null
        ? null
        : SelprodReturnPolicies.fromJson(json["shippingDetails"]),
    productCodEnabled: json["product_cod_enabled"],
    selprodAvailableFrom: json["selprod_available_from"] == null
        ? null
        : DateTime.parse(json["selprod_available_from"]),
    shopId: json["shop_id"],
    selprodReturnPolicy: json["selprod_return_policy"],
    socialShareContent: json["socialShareContent"] == null
        ? null
        : SocialShareContent.fromJson(json["socialShareContent"]),
    isOutOfMinOrderQty: json["isOutOfMinOrderQty"],
    brandName: json["brand_name"],
    selprodCodEnabled: json["selprod_cod_enabled"],
    prodRating: json["prod_rating"],
    specialPriceFound: json["special_price_found"],
    selprodId: json["selprod_id"],
    selprodCondition: json["selprod_condition"],
    selprodReturnAge: json["selprod_return_age"],
    shopFulfillmentType: json["shop_fulfillment_type"],
    reportProduct: json["reportProduct"],
    badges: json["badges"] == null
        ? []
        : List<Badge>.from(json["badges"]!.map((x) => Badge.fromJson(x))),
    productId: json["product_id"],
    inStock: json["in_stock"],
    shopExchangeAge: json["shop_exchange_age"],
    selprodStock: json["selprod_stock"],
    ribbons: json["ribbons"] == null
        ? []
        : List<dynamic>.from(json["ribbons"]!.map((x) => x)),
    productWarrantyUnit: json["product_warranty_unit"],
    splpriceDisplayDisType: json["splprice_display_dis_type"],
    selprodWarrantyPolicies: json["selprod_warranty_policies"] == null
        ? null
        : SelprodReturnPolicies.fromJson(json["selprod_warranty_policies"]),
    selprodConditionTitle: json["selprod_condition_title"],
    productIsbn: json["product_isbn"],
    shopShipmentDays: json["shop_shipment_days"],
    splpriceEndDate: json["splprice_end_date"],
    availableInLocation: json["availableInLocation"],
    selprodCancellationAge: json["selprod_cancellation_age"],
    shopStateName: json["shop_state_name"],
    productFulfillmentType: json["product_fulfillment_type"],
    selprodMinOrderQty: json["selprod_min_order_qty"],
    shopName: json["shop_name"],
    shopRating: json["shop_rating"],
    shopDescription: json["shop_description"],
    shopDeliveryPolicy: json["shop_delivery_policy"],
    shopCity: json["shop_city"],
    shopRefundPolicy: json["shop_refund_policy"],
    shopCreatedOn: json["shop_created_on"] == null
        ? null
        : DateTime.parse(json["shop_created_on"]),
    shopPaymentPolicy: json["shop_payment_policy"],
    shopTotalReviews: json["shopTotalReviews"],
    shopLtemplateId: json["shop_ltemplate_id"],
    shopUserId: json["shop_user_id"],
  );

  Map<String, dynamic> toJson() => {
    "shop_fulfillment_by": shopFulfillmentBy,
    "product_updated_on": productUpdatedOn?.toIso8601String(),
    "product_youtube_video": productYoutubeVideo,
    "user_name": userName,
    "is_in_any_wishlist": isInAnyWishlist,
    "product_upc": productUpc,
    "moreSellersArr": moreSellersArr == null
        ? []
        : List<dynamic>.from(moreSellersArr!.map((x) => x)),
    "product_warranty": productWarranty,
    "isComingsoon": isComingsoon,
    "totReviews": totReviews,
    "selprod_return_policies": selprodReturnPolicies?.toJson(),
    "brand_id": brandId,
    "selprod_threshold_stock_level": selprodThresholdStockLevel,
    "discount": discount,
    "youtubeUrlThumbnail": youtubeUrlThumbnail,
    "product_warranty_unit_label": productWarrantyUnitLabel,
    "selprod_fulfillment_from": selprodFulfillmentFrom,
    "selprod_exchange_age": selprodExchangeAge,
    "shop_country_name": shopCountryName,
    "splprice_display_list_price": splpriceDisplayListPrice,
    "selprod_fulfillment_type": selprodFulfillmentType,
    "product_type": productType,
    "product_description": productDescription,
    "selprod_warranty": selprodWarranty,
    "shop_cancellation_age": shopCancellationAge,
    "product_model": productModel,
    "codEnabled": codEnabled,
    "product_short_description": productShortDescription,
    "prodcat_name": prodcatName,
    "product_name": productName,
    "selprodComments": selprodComments,
    "brand_short_description": brandShortDescription,
    "inclusiveTax": inclusiveTax,
    "selprod_product_id": selprodProductId,
    "isNotified": isNotified,
    "product_identifier": productIdentifier,
    "splprice_start_date": splpriceStartDate,
    "selprod_code": selprodCode,
    "selprod_sku": selprodSku,
    "product_seller_id": productSellerId,
    "product_attachements_with_inventory": productAttachementsWithInventory,
    "shop_return_age": shopReturnAge,
    "selprod_title": selprodTitle,
    "splprice_display_dis_val": splpriceDisplayDisVal,
    "product_attrgrp_id": productAttrgrpId,
    "selprod_price": selprodPrice,
    "theprice": theprice,
    "selprod_user_id": selprodUserId,
    "prodcat_id": prodcatId,
    "productUrl": productUrl,
    "shippingDetails": shippingDetails?.toJson(),
    "product_cod_enabled": productCodEnabled,
    "selprod_available_from": selprodAvailableFrom?.toIso8601String(),
    "shop_id": shopId,
    "selprod_return_policy": selprodReturnPolicy,
    "socialShareContent": socialShareContent?.toJson(),
    "isOutOfMinOrderQty": isOutOfMinOrderQty,
    "brand_name": brandName,
    "selprod_cod_enabled": selprodCodEnabled,
    "prod_rating": prodRating,
    "special_price_found": specialPriceFound,
    "selprod_id": selprodId,
    "selprod_condition": selprodCondition,
    "selprod_return_age": selprodReturnAge,
    "shop_fulfillment_type": shopFulfillmentType,
    "reportProduct": reportProduct,
    "badges": badges == null
        ? []
        : List<dynamic>.from(badges!.map((x) => x.toJson())),
    "product_id": productId,
    "in_stock": inStock,
    "shop_exchange_age": shopExchangeAge,
    "selprod_stock": selprodStock,
    "ribbons": ribbons == null
        ? []
        : List<dynamic>.from(ribbons!.map((x) => x)),
    "product_warranty_unit": productWarrantyUnit,
    "splprice_display_dis_type": splpriceDisplayDisType,
    "selprod_warranty_policies": selprodWarrantyPolicies?.toJson(),
    "selprod_condition_title": selprodConditionTitle,
    "product_isbn": productIsbn,
    "shop_shipment_days": shopShipmentDays,
    "splprice_end_date": splpriceEndDate,
    "availableInLocation": availableInLocation,
    "selprod_cancellation_age": selprodCancellationAge,
    "shop_state_name": shopStateName,
    "product_fulfillment_type": productFulfillmentType,
    "selprod_min_order_qty": selprodMinOrderQty,
    "shop_name": shopName,
    "shop_rating": shopRating,
    "shop_description": shopDescription,
    "shop_delivery_policy": shopDeliveryPolicy,
    "shop_city": shopCity,
    "shop_refund_policy": shopRefundPolicy,
    "shop_created_on": shopCreatedOn?.toIso8601String(),
    "shop_payment_policy": shopPaymentPolicy,
    "shopTotalReviews": shopTotalReviews,
    "shop_ltemplate_id": shopLtemplateId,
    "shop_user_id": shopUserId,
  };
}

class Badge {
  final String? badgeName;
  final String? url;

  Badge({this.badgeName, this.url});

  factory Badge.fromJson(Map<String, dynamic> json) =>
      Badge(badgeName: json["badge_name"], url: json["url"]);

  Map<String, dynamic> toJson() => {"badge_name": badgeName, "url": url};
}

class SelprodReturnPolicies {
  SelprodReturnPolicies();

  factory SelprodReturnPolicies.fromJson(Map<String, dynamic> json) =>
      SelprodReturnPolicies();

  Map<String, dynamic> toJson() => {};
}

class SocialShareContent {
  final String? title;
  final String? image;
  final String? description;
  final String? type;

  SocialShareContent({this.title, this.image, this.description, this.type});

  factory SocialShareContent.fromJson(Map<String, dynamic> json) =>
      SocialShareContent(
        title: json["title"],
        image: json["image"],
        description: json["description"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
    "title": title,
    "image": image,
    "description": description,
    "type": type,
  };
}

class ProductImages {
  final String? afileDownloadedTimes;
  final String? afileRecordId;
  final String? afileName;
  final String? afileAttributeTitle;
  final String? afileScreen;
  final String? afileType;
  final String? afileDisplayOrder;
  final String? afilePhysicalPath;
  final String? afileAspectRatio;
  final String? afileLangId;
  final DateTime? afileUpdatedAt;
  final String? afileRecordSubid;
  final String? afileAttributeAlt;
  final String? afileId;
  String? productImageUrl;

  ProductImages({
    this.afileDownloadedTimes,
    this.afileRecordId,
    this.afileName,
    this.afileAttributeTitle,
    this.afileScreen,
    this.afileType,
    this.afileDisplayOrder,
    this.afilePhysicalPath,
    this.afileAspectRatio,
    this.afileLangId,
    this.afileUpdatedAt,
    this.afileRecordSubid,
    this.afileAttributeAlt,
    this.afileId,
    this.productImageUrl,
  });

  factory ProductImages.fromJson(Map<String, dynamic> json) => ProductImages(
    afileDownloadedTimes: json["afile_downloaded_times"],
    afileRecordId: json["afile_record_id"],
    afileName: json["afile_name"],
    afileAttributeTitle: json["afile_attribute_title"],
    afileScreen: json["afile_screen"],
    afileType: json["afile_type"],
    afileDisplayOrder: json["afile_display_order"],
    afilePhysicalPath: json["afile_physical_path"],
    afileAspectRatio: json["afile_aspect_ratio"],
    afileLangId: json["afile_lang_id"],
    afileUpdatedAt: json["afile_updated_at"] == null
        ? null
        : DateTime.parse(json["afile_updated_at"]),
    afileRecordSubid: json["afile_record_subid"],
    afileAttributeAlt: json["afile_attribute_alt"],
    afileId: json["afile_id"],
    productImageUrl: json["product_image_url"],
  );

  Map<String, dynamic> toJson() => {
    "afile_downloaded_times": afileDownloadedTimes,
    "afile_record_id": afileRecordId,
    "afile_name": afileName,
    "afile_attribute_title": afileAttributeTitle,
    "afile_screen": afileScreen,
    "afile_type": afileType,
    "afile_display_order": afileDisplayOrder,
    "afile_physical_path": afilePhysicalPath,
    "afile_aspect_ratio": afileAspectRatio,
    "afile_lang_id": afileLangId,
    "afile_updated_at": afileUpdatedAt?.toIso8601String(),
    "afile_record_subid": afileRecordSubid,
    "afile_attribute_alt": afileAttributeAlt,
    "afile_id": afileId,
    "product_image_url": productImageUrl,
  };
}

class ProductOptions {
  final String? optionName;
  final List<OptionValue>? values;
  final String? optionId;
  final String? optionIsColor;
  final String? optionValueName;

  ProductOptions({
    this.optionValueName,
    this.optionName,
    this.values,
    this.optionId,
    this.optionIsColor,
  });

  factory ProductOptions.fromJson(Map<String, dynamic> json) => ProductOptions(
    optionName: json["option_name"],
    optionValueName: json["optionvalue_name"],
    values: json["values"] == null
        ? []
        : List<OptionValue>.from(
            json["values"]!.map((x) => OptionValue.fromJson(x)),
          ),
    optionId: json["option_id"],
    optionIsColor: json["option_is_color"],
  );

  Map<String, dynamic> toJson() => {
    "option_name": optionName,
    "values": values == null
        ? []
        : List<dynamic>.from(values!.map((x) => x.toJson())),
    "option_id": optionId,
    "option_is_color": optionIsColor,
  };
}

class ProductPolicy {
  final String? isSvg;
  final String? icon;
  final String? title;

  ProductPolicy({this.isSvg, this.icon, this.title});

  factory ProductPolicy.fromJson(Map<String, dynamic> json) => ProductPolicy(
    isSvg: json["isSvg"],
    icon: json["icon"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "isSvg": isSvg,
    "icon": icon,
    "title": title,
  };
}

class SoldBy {
  final String? shopUserId;
  final String? shopCountryName;
  final String? shopRating;
  final DateTime? shopCreatedOn;
  final String? shopFulfillmentBy;
  final String? shopName;
  final String? shopLtemplateId;
  final String? shopRefundPolicy;
  final String? shopId;
  final String? shopStateName;
  final String? shopDeliveryPolicy;
  final String? shopTotalReviews;
  final String? shopCity;
  final String? shopDescription;
  final String? shopPaymentPolicy;

  SoldBy({
    this.shopUserId,
    this.shopCountryName,
    this.shopRating,
    this.shopCreatedOn,
    this.shopFulfillmentBy,
    this.shopName,
    this.shopLtemplateId,
    this.shopRefundPolicy,
    this.shopId,
    this.shopStateName,
    this.shopDeliveryPolicy,
    this.shopTotalReviews,
    this.shopCity,
    this.shopDescription,
    this.shopPaymentPolicy,
  });

  factory SoldBy.fromJson(Map<String, dynamic> json) => SoldBy(
    shopUserId: json["shop_user_id"],
    shopCountryName: json["shop_country_name"],
    shopRating: json["shop_rating"],
    shopCreatedOn: json["shop_created_on"] == null
        ? null
        : DateTime.parse(json["shop_created_on"]),
    shopFulfillmentBy: json["shop_fulfillment_by"],
    shopName: json["shop_name"],
    shopLtemplateId: json["shop_ltemplate_id"],
    shopRefundPolicy: json["shop_refund_policy"],
    shopId: json["shop_id"],
    shopStateName: json["shop_state_name"],
    shopDeliveryPolicy: json["shop_delivery_policy"],
    shopTotalReviews: json["shopTotalReviews"],
    shopCity: json["shop_city"],
    shopDescription: json["shop_description"],
    shopPaymentPolicy: json["shop_payment_policy"],
  );

  Map<String, dynamic> toJson() => {
    "shop_user_id": shopUserId,
    "shop_country_name": shopCountryName,
    "shop_rating": shopRating,
    "shop_created_on": shopCreatedOn?.toIso8601String(),
    "shop_fulfillment_by": shopFulfillmentBy,
    "shop_name": shopName,
    "shop_ltemplate_id": shopLtemplateId,
    "shop_refund_policy": shopRefundPolicy,
    "shop_id": shopId,
    "shop_state_name": shopStateName,
    "shop_delivery_policy": shopDeliveryPolicy,
    "shopTotalReviews": shopTotalReviews,
    "shop_city": shopCity,
    "shop_description": shopDescription,
    "shop_payment_policy": shopPaymentPolicy,
  };
}

class Content {
  final List<ProductImages>? productImagesArr;
  final ProductDetail? productDetail;
  final List<ProductOptions>? optionRows;
  final List<ProductPolicy>? productPolicies;
  final String? description;
  final SoldBy? shop;
  final List<ProductContent>? modelMeasurement;
  final List<BoxContent>? boxContent;

  // final List<ProductPolicies>? policies;
  // final List<Banners>? banners;
  // final List<WishListProductsModel>? similarProduct;
  final List<HomeProduct>? recommendedProduct;

  // final List<WishListProductsModel>? buyTogether;
  // final ReviewData? reviewData;
  // final PreviewFilesData? previewFilesData;
  // final List<VolumeDiscountRows>? volumeDiscount;

  Content({
    this.productImagesArr,
    this.optionRows,
    this.productDetail,
    this.productPolicies,
    this.description,
    this.shop,
    this.boxContent,
    // this.volumeDiscount,
    // this.policies,
    // this.banners,
    // this.similarProduct,
    this.recommendedProduct,
    this.modelMeasurement,
    // this.buyTogether,
    // this.reviewData,
    // this.previewFilesData,
  });

  factory Content.fromJson(Map<String, dynamic> json, ProductDetailType type) {
    switch (type) {
      case ProductDetailType.productImages:
        return Content(
          productImagesArr: (json["content"] as List?)
              ?.map((e) => ProductImages.fromJson(e))
              .toList(),
        );
      case ProductDetailType.productDetail:
        return Content(productDetail: ProductDetail.fromJson(json["content"]));
      case ProductDetailType.boxContent:
        return Content(boxContent: (json["content"] as List?)
            ?.map((e) => BoxContent.fromJson(e))
            .toList());
      case ProductDetailType.productOption:
        return Content(
          optionRows: (json["content"] as List?)
              ?.map((e) => ProductOptions.fromJson(e))
              .toList(),
        );
      case ProductDetailType.productSpecifications:
        return Content(
          productPolicies: (json["content"] as List?)
              ?.map((e) => ProductPolicy.fromJson(e))
              .toList(),
        );
      case ProductDetailType.shop:
        return Content(shop: SoldBy.fromJson(json["content"]));
      case ProductDetailType.productDescription:
        return Content(description: json["content"]);
      // case ProductDetailType.volumeDiscount:
      //   return Content(
      //     volumeDiscount: (json["content"] as List?)
      //         ?.map((e) => VolumeDiscountRows.fromJson(e))
      //         .toList(),
      //   );
      case ProductDetailType.productPolicies:
        return Content(
          productPolicies: (json["content"] as List?)
              ?.map((e) => ProductPolicy.fromJson(e))
              .toList(),
        );
      // case ProductDetailType.banner:
      //   return Content(
      //     banners: (json["content"] as List?)
      //         ?.map((e) => Banners.fromJson(e))
      //         .toList(),
      //   );
      // case ProductDetailType.similarProducts:
      //   return Content(
      //     similarProduct: (json["content"] as List?)
      //         ?.map((e) => WishListProductsModel.fromJson(e))
      //         .toList(),
      //   );
      case ProductDetailType.recommendedProducts:
        return Content(
          recommendedProduct: (json["content"] as List?)
              ?.map((e) => HomeProduct.fromJson(e))
              .toList(),
        );
      // case ProductDetailType.buyTogether:
      //   return Content(
      //     buyTogether: (json["content"] as List?)
      //         ?.map((e) => WishListProductsModel.fromJson(e))
      //         .toList(),
      //   );
      // case ProductDetailType.reviews:
      //   return Content(
      //     reviewData: ReviewData.fromJson(json["content"]),
      //   );
      // case ProductDetailType.previewFiles:
      //   return Content(
      //     previewFilesData: PreviewFilesData.fromJson(json["content"]),
      //   );
      case ProductDetailType.modelMesurement:
        return Content(
          modelMeasurement: (json["content"] as List?)
              ?.map((e) => ProductContent.fromJson(e))
              .toList(),
        );
      default:
        return Content();
    }
  }

  Map<String, dynamic> toJson() => {
    "productImagesArr": productImagesArr?.map((x) => x.toJson()).toList(),
    "optionRows": optionRows?.map((x) => x.toJson()).toList(),
    "productDetail": productDetail?.toJson(),
    "productSpecification": productPolicies?.map((x) => x.toJson()).toList(),
    "description": description,
    "shop": shop?.toJson(),
    // "volumeDiscount": volumeDiscount?.map((x) => x.toJson()).toList(),
    "policies": productPolicies?.map((x) => x.toJson()).toList(),
    // "banners": banners?.map((x) => x?.toJson()).toList(),
    // "similarProduct": similarProduct?.map((x) => x.toJson()).toList(),
    "recommendedProduct": recommendedProduct?.map((x) => x.toJson()).toList(),
    // "buyTogether": buyTogether?.map((x) => x.toJson()).toList(),
    // "reviewData": reviewData?.toJson(),
    // "previewFilesData": previewFilesData?.toJson(),
  };
}

class ProductContent {
  final String? title;
  final List<Adjective>? adjectives;

  ProductContent({this.title, this.adjectives});

  factory ProductContent.fromJson(Map<String, dynamic> json) {
    return ProductContent(
      title: json['title'],
      adjectives: (json['adjectives'] as List?)
          ?.map((e) => Adjective.fromJson(e))
          .toList(),
    );
  }
}

class Adjective {
  final int? id;
  final String? value;
  final String? extra;

  Adjective({this.id, this.value, this.extra});

  factory Adjective.fromJson(Map<String, dynamic> json) {
    return Adjective(
      id: int.tryParse(json['id']?.toString() ?? ''),
      value: json['value'],
      extra: json['extra'],
    );
  }
}

class BoxContent {
  final String? boxSelprodId;
  final String? boxDiscountPercentage;
  final String? selprodId;
  final String? selprodProductId;
  final String? selprodPrice;
  final String? selprodStock;
  final String? selprodMinOrderQty;
  final String? selprodUserId;
  final String? selprodSku;
  final String? selprodTitle;
  final String? productName;
  final String? productId;
  final String? productIdentifier;
  final String? productType;
  final String? specialPriceFound;
  final String? theprice;
  final String? inStock;
  final String? boxDiscountedPrice;
  final String? boxDiscountAmount;
  final BoxContentImage? image;
  final String? imageURL;
  final String? hasVariants;
  final List<VariantOption>? variantOptions;
  final List<AvailableVariant>? availableVariants;
  List<AvailableOptionValue>? currentOptionValues;
  final String? hasSizechart;


  BoxContent({
    this.boxSelprodId,
    this.boxDiscountPercentage,
    this.selprodId,
    this.selprodProductId,
    this.selprodPrice,
    this.selprodStock,
    this.selprodMinOrderQty,
    this.selprodUserId,
    this.selprodSku,
    this.selprodTitle,
    this.productName,
    this.productId,
    this.productIdentifier,
    this.productType,
    this.specialPriceFound,
    this.theprice,
    this.inStock,
    this.boxDiscountedPrice,
    this.boxDiscountAmount,
    this.image,
    this.imageURL,
    this.hasVariants,
    this.variantOptions,
    this.availableVariants,
    this.currentOptionValues,
    this.hasSizechart,

  });

  factory BoxContent.fromJson(Map<String, dynamic> json) => BoxContent(
    boxSelprodId: json["box_selprod_id"],
    boxDiscountPercentage: json["box_discount_percentage"],
    selprodId: json["selprod_id"],
    selprodProductId: json["selprod_product_id"],
    selprodPrice: json["selprod_price"],
    selprodStock: json["selprod_stock"],
    selprodMinOrderQty: json["selprod_min_order_qty"],
    selprodUserId: json["selprod_user_id"],
    selprodSku: json["selprod_sku"],
    selprodTitle: json["selprod_title"],
    productName: json["product_name"],
    productId: json["product_id"],
    productIdentifier: json["product_identifier"],
    productType: json["product_type"],
    specialPriceFound: json["special_price_found"],
    theprice: json["theprice"],
    inStock: json["in_stock"],
    boxDiscountedPrice: json["box_discounted_price"],
    boxDiscountAmount: json["box_discount_amount"],
    imageURL: json["image_url"],
    image: json["image"] == null ? null : BoxContentImage.fromJson(json["image"]),
    hasVariants: json["has_variants"],
    variantOptions: List<VariantOption>.from(json["variant_options"].map((x) => VariantOption.fromJson(x))),
    availableVariants: List<AvailableVariant>.from(json["available_variants"].map((x) => AvailableVariant.fromJson(x))),
    currentOptionValues: List<AvailableOptionValue>.from(json["current_option_values"].map((x) => AvailableOptionValue.fromJson(x))),
    hasSizechart: json["has_sizechart"]
  );

  Map<String, dynamic> toJson() => {
    "box_selprod_id": boxSelprodId,
    "box_discount_percentage": boxDiscountPercentage,
    "selprod_id": selprodId,
    "selprod_product_id": selprodProductId,
    "selprod_price": selprodPrice,
    "selprod_stock": selprodStock,
    "selprod_min_order_qty": selprodMinOrderQty,
    "selprod_user_id": selprodUserId,
    "selprod_sku": selprodSku,
    "selprod_title": selprodTitle,
    "product_name": productName,
    "product_id": productId,
    "product_identifier": productIdentifier,
    "product_type": productType,
    "special_price_found": specialPriceFound,
    "theprice": theprice,
    "in_stock": inStock,
    "box_discounted_price": boxDiscountedPrice,
    "box_discount_amount": boxDiscountAmount,
    "image_url": imageURL,
    "image": image?.toJson(),
    "has_variants": hasVariants,
    "variant_options": List<dynamic>.from((variantOptions ?? []).map((x) => x.toJson())),
    "available_variants": List<dynamic>.from((availableVariants ?? []).map((x) => x.toJson())),
    "current_option_values": List<dynamic>.from((currentOptionValues ?? []).map((x) => x.toJson())),
    "has_sizechart": hasSizechart,
  };
}

class BoxContentImage {
  final String? afileId;
  final String? afileType;
  final String? afileRecordId;
  final String? afileRecordSubid;
  final String? afileLangId;
  final String? afileScreen;
  final String? afilePhysicalPath;
  final String? afileName;
  final String? afileAttributeTitle;
  final String? afileAttributeAlt;
  final String? afileAspectRatio;
  final String? afileDisplayOrder;
  final DateTime? afileUpdatedAt;
  final String? afileDownloadedTimes;

  BoxContentImage({
    this.afileId,
    this.afileType,
    this.afileRecordId,
    this.afileRecordSubid,
    this.afileLangId,
    this.afileScreen,
    this.afilePhysicalPath,
    this.afileName,
    this.afileAttributeTitle,
    this.afileAttributeAlt,
    this.afileAspectRatio,
    this.afileDisplayOrder,
    this.afileUpdatedAt,
    this.afileDownloadedTimes,
  });

  factory BoxContentImage.fromJson(Map<String, dynamic> json) => BoxContentImage(
    afileId: json["afile_id"],
    afileType: json["afile_type"],
    afileRecordId: json["afile_record_id"],
    afileRecordSubid: json["afile_record_subid"],
    afileLangId: json["afile_lang_id"],
    afileScreen: json["afile_screen"],
    afilePhysicalPath: json["afile_physical_path"],
    afileName: json["afile_name"],
    afileAttributeTitle: json["afile_attribute_title"],
    afileAttributeAlt: json["afile_attribute_alt"],
    afileAspectRatio: json["afile_aspect_ratio"],
    afileDisplayOrder: json["afile_display_order"],
    afileUpdatedAt: json["afile_updated_at"] == null ? null : DateTime.parse(json["afile_updated_at"]),
    afileDownloadedTimes: json["afile_downloaded_times"],
  );

  Map<String, dynamic> toJson() => {
    "afile_id": afileId,
    "afile_type": afileType,
    "afile_record_id": afileRecordId,
    "afile_record_subid": afileRecordSubid,
    "afile_lang_id": afileLangId,
    "afile_screen": afileScreen,
    "afile_physical_path": afilePhysicalPath,
    "afile_name": afileName,
    "afile_attribute_title": afileAttributeTitle,
    "afile_attribute_alt": afileAttributeAlt,
    "afile_aspect_ratio": afileAspectRatio,
    "afile_display_order": afileDisplayOrder,
    "afile_updated_at": afileUpdatedAt?.toIso8601String(),
    "afile_downloaded_times": afileDownloadedTimes,
  };
}

class AvailableVariant {
  String selprodId;
  String selprodCode;
  String selprodStock;
  String selprodPrice;
  String selprodTitle;
  String theprice;
  String specialPriceFound;
  String inStock;
  List<AvailableOptionValue> optionValues;

  AvailableVariant({
    required this.selprodId,
    required this.selprodCode,
    required this.selprodStock,
    required this.selprodPrice,
    required this.selprodTitle,
    required this.theprice,
    required this.specialPriceFound,
    required this.inStock,
    required this.optionValues,
  });

  factory AvailableVariant.fromJson(Map<String, dynamic> json) => AvailableVariant(
    selprodId: json["selprod_id"],
    selprodCode: json["selprod_code"],
    selprodStock: json["selprod_stock"],
    selprodPrice: json["selprod_price"],
    selprodTitle: json["selprod_title"],
    theprice: json["theprice"],
    specialPriceFound: json["special_price_found"],
    inStock: json["in_stock"],
    optionValues: List<AvailableOptionValue>.from(json["option_values"].map((x) => AvailableOptionValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "selprod_id": selprodId,
    "selprod_code": selprodCode,
    "selprod_stock": selprodStock,
    "selprod_price": selprodPrice,
    "selprod_title": selprodTitle,
    "theprice": theprice,
    "special_price_found": specialPriceFound,
    "in_stock": inStock,
    "option_values": List<dynamic>.from(optionValues.map((x) => x.toJson())),
  };
}

class VariantOption {
  String? optionId;
  String? optionIdentifier;
  String? prodoptionOptionvalueIds;
  String? optionIsSeparateImages;
  String? optionName;
  Map<String, String> optionValues;

  VariantOption({
    required this.optionId,
    required this.optionIdentifier,
    required this.prodoptionOptionvalueIds,
    required this.optionIsSeparateImages,
    required this.optionName,
    required this.optionValues,
  });

  factory VariantOption.fromJson(Map<String, dynamic> json) => VariantOption(
    optionId: json["option_id"],
    optionIdentifier: json["option_identifier"],
    prodoptionOptionvalueIds: json["prodoption_optionvalue_ids"],
    optionIsSeparateImages: json["option_is_separate_images"],
    optionName: json["option_name"],
    optionValues: Map.from(json["optionValues"]).map((k, v) => MapEntry<String, String>(k, v)),
  );

  Map<String, dynamic> toJson() => {
    "option_id": optionId,
    "option_identifier": optionIdentifier,
    "prodoption_optionvalue_ids": prodoptionOptionvalueIds,
    "option_is_separate_images": optionIsSeparateImages,
    "option_name": optionName,
    "optionValues": Map.from(optionValues).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}

class BoxOptionValue {
  int? selprodoptionSelprodId;
  int? optionId;
  int? optionvalueId;
  String? optionName;
  String? optionvalueName;

  BoxOptionValue({
    required this.selprodoptionSelprodId,
    required this.optionId,
    required this.optionvalueId,
    required this.optionName,
    required this.optionvalueName,
  });

  factory BoxOptionValue.fromJson(Map<String, dynamic> json) => BoxOptionValue(
    selprodoptionSelprodId: json["selprodoption_selprod_id"],
    optionId: json["option_id"],
    optionvalueId: json["optionvalue_id"],
    optionName: json["option_name"],
    optionvalueName: json["optionvalue_name"],
  );

  Map<String, dynamic> toJson() => {
    "selprodoption_selprod_id": selprodoptionSelprodId,
    "option_id": optionId,
    "optionvalue_id": optionvalueId,
    "option_name": optionName,
    "optionvalue_name": optionvalueName,
  };
}

class AvailableOptionValue {
  String? selprodoptionSelprodId;
  String? optionId;
  String? optionvalueId;
  String? optionName;
  String? optionvalueName;
  String? isSelected;
  String? inStock;

  AvailableOptionValue({
    required this.selprodoptionSelprodId,
    required this.optionId,
    required this.optionvalueId,
    required this.optionName,
    required this.optionvalueName,
    required isSelected,
    required inStock,
  });

  factory AvailableOptionValue.fromJson(Map<String, dynamic> json) => AvailableOptionValue(
    selprodoptionSelprodId: json["selprodoption_selprod_id"],
    optionId: json["option_id"],
    optionvalueId: json["optionvalue_id"],
    optionName: json["option_name"],
    optionvalueName: json["optionvalue_name"],
    isSelected: json['isSelected'],
    inStock: json['inStock']
  );

  Map<String, dynamic> toJson() => {
    "selprodoption_selprod_id": selprodoptionSelprodId,
    "option_id": optionId,
    "optionvalue_id": optionvalueId,
    "option_name": optionName,
    "optionvalue_name": optionvalueName,
    "isSelected": isSelected,
    "inStock": inStock
  };
}

extension ProductDetailTypeExt on ProductDetailType {
  String get apiValue {
    switch (this) {
      case ProductDetailType.productImages:
        return "2";
      case ProductDetailType.productDetail:
        return "1";
      case ProductDetailType.boxContent:
        return "18";
      case ProductDetailType.productOption:
        return "3";
      case ProductDetailType.productSpecifications:
        return "4";
      case ProductDetailType.volumeDiscount:
        return "5";
      case ProductDetailType.productDescription:
        return "15";
      case ProductDetailType.productPolicies:
        return "14";
      case ProductDetailType.banner:
        return "10";
      case ProductDetailType.similarProducts:
        return "7";
      case ProductDetailType.recommendedProducts:
        return "8";
      case ProductDetailType.buyTogether:
        return "6";
      case ProductDetailType.shop:
        return "13";
      case ProductDetailType.reviews:
        return "9";
      case ProductDetailType.previewFiles:
        return "16";
      case ProductDetailType.modelMesurement:
        return "16";
      default:
        return "";
    }
  }
}