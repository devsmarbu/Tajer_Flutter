// To parse this JSON data, do
//
//     final setupHomeModel = setupHomeModelFromJson(jsonString);

import 'dart:convert';

import '../product_detail/product_detail_model.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:flutter/material.dart';

HomeModel setupHomeModelFromJson(dynamic jsonInput) {
  if (jsonInput is String) {
    return HomeModel.fromJson(json.decode(jsonInput));
  } else if (jsonInput is Map<String, dynamic>) {
    return HomeModel.fromJson(jsonInput);
  } else {
    throw Exception('Unsupported JSON input type');
  }
}

String setupHomeModelToJson(HomeModel data) => json.encode(data.toJson());

class HomeModel {
  final String? status;
  final String? msg;
  final HomeData? data;
  final String? responseCode;

  HomeModel({this.status, this.msg, this.data, this.responseCode});

  factory HomeModel.fromJson(Map<String, dynamic> json) => HomeModel(
    status: json["status"],
    msg: json["msg"],
    data: json["data"] == null ? null : HomeData.fromJson(json["data"]),
    responseCode: json["responseCode"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data?.toJson(),
    "responseCode": responseCode,
  };
}

class HomeData {
  final String? totalUnreadNotificationCount;
  final String? pageCount;
  final String? totalUnreadMessageCount;
  final String? cartItemsCount;
  final String? pageSize;
  final String? totalFavouriteItems;
  final String? page;
  final List<Collection>? collections;
  final String? currencySymbol;
  final String? home_promotion_popup_available;
  final String? home_promotion_popup_image_url;
  final String? home_promotion_popup_redirect_url;
  final String? promo_banner_enabled;
  final String? promo_banner_text;

  HomeData({
    this.totalUnreadNotificationCount,
    this.pageCount,
    this.totalUnreadMessageCount,
    this.cartItemsCount,
    this.pageSize,
    this.totalFavouriteItems,
    this.page,
    this.collections,
    this.currencySymbol,
    this.home_promotion_popup_available,
    this.home_promotion_popup_image_url,
    this.home_promotion_popup_redirect_url,
    this.promo_banner_text,
    this.promo_banner_enabled,
  });

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    pageCount: json["pageCount"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    cartItemsCount: json["cartItemsCount"],
    pageSize: json["pageSize"],
    totalFavouriteItems: json["totalFavouriteItems"],
    page: json["page"],
    collections: json["collections"] == null
        ? []
        : List<Collection>.from(
            json["collections"]!.map((x) => Collection.fromJson(x)),
          ),
    currencySymbol: json["currencySymbol"],
    home_promotion_popup_available: json["home_promotion_popup_available"],
    home_promotion_popup_image_url: json["home_promotion_popup_image_url"],
    home_promotion_popup_redirect_url:
        json["home_promotion_popup_redirect_url"],
    promo_banner_enabled: json["promo_banner_enabled"],
    promo_banner_text: json["promo_banner_text"],
  );

  Map<String, dynamic> toJson() => {
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "pageCount": pageCount,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "cartItemsCount": cartItemsCount,
    "pageSize": pageSize,
    "totalFavouriteItems": totalFavouriteItems,
    "page": page,
    "collections": collections == null
        ? []
        : List<dynamic>.from(collections!.map((x) => x.toJson())),
    "currencySymbol": currencySymbol,
    "home_promotion_popup_available": home_promotion_popup_available,
    "home_promotion_popup_image_url": home_promotion_popup_image_url,
    "home_promotion_popup_redirect_url": home_promotion_popup_redirect_url,
    "promo_banner_text": promo_banner_text,
    "promo_banner_enabled": promo_banner_enabled,
  };
}

class Collection {
  final String? collectionDescription;
  final String? collectionPrimaryRecords;
  final String? collectionType;
  final String? collectionForWeb;
  final String? collectionForApp;
  final String? collectionLinkUrl;
  final String? collectionChildRecords;
  final String? collectionCriteria;
  final String? collectionId;
  final String? collectionFullWidth;
  final String? collectionDisplayOrder;
  final String? collectionLinkCaption;
  final List<Slide>? slides;
  final String? collectionName;
  final String? collectionDisplayMediaOnly;
  final DateTime? collectionUpdatedOn;
  final CollectionLayoutType? layoutType; // ✅ Enum instead of String
  final Banners? banners;
  final List<HomePageShops>? shops;
  final List<HomeProduct> products;
  final List<HomeBrand>? brands;
  final String? totProducts;
  final String? collectionUrlTitle;
  final String? collectionUrlType;
  final String? homePageStripeSVGUrl;

  Collection({
    this.collectionDescription,
    this.collectionPrimaryRecords,
    this.collectionType,
    this.collectionForWeb,
    this.collectionForApp,
    this.collectionLinkUrl,
    this.collectionChildRecords,
    this.collectionCriteria,
    this.collectionId,
    this.collectionFullWidth,
    this.collectionDisplayOrder,
    this.collectionLinkCaption,
    this.slides,
    this.collectionName,
    this.collectionDisplayMediaOnly,
    this.collectionUpdatedOn,
    this.layoutType,
    this.banners,
    this.shops,
    required this.products,
    this.totProducts,
    this.collectionUrlTitle,
    this.collectionUrlType,
    this.brands,
    this.homePageStripeSVGUrl,
  });

  factory Collection.fromJson(Map<String, dynamic> json) => Collection(
    collectionDescription: json["collection_description"],
    collectionPrimaryRecords: json["collection_primary_records"],
    collectionType: json["collection_type"],
    collectionForWeb: json["collection_for_web"],
    collectionForApp: json["collection_for_app"],
    collectionLinkUrl: json["collection_link_url"],
    collectionChildRecords: json["collection_child_records"],
    collectionCriteria: json["collection_criteria"],
    collectionId: json["collection_id"],
    collectionFullWidth: json["collection_full_width"],
    collectionDisplayOrder: json["collection_display_order"],
    collectionLinkCaption: json["collection_link_caption"],
    slides: json["slides"] == null
        ? []
        : List<Slide>.from(json["slides"]!.map((x) => Slide.fromJson(x))),
    shops: json["shops"] == null
        ? []
        : List<HomePageShops>.from(
            json["shops"]!.map((x) => HomePageShops.fromJson(x)),
          ),
    collectionName: json["collection_name"],
    collectionDisplayMediaOnly: json["collection_display_media_only"],
    collectionUpdatedOn: json["collection_updated_on"] == null
        ? null
        : DateTime.parse(json["collection_updated_on"]),
    layoutType: CollectionLayoutType.fromValue(json["collection_layout_type"]),

    banners: json["banners"] == null ? null : Banners.fromJson(json["banners"]),
    brands: json["brands"] == null
        ? null
        : List<HomeBrand>.from(
            json["brands"]!.map((x) => HomeBrand.fromJson(x)),
          ),
    products: json["products"] == null
        ? []
        : List<HomeProduct>.from(
            json["products"]!.map((x) => HomeProduct.fromJson(x)),
          ),
    totProducts: json["totProducts"],
    collectionUrlTitle: json["collection_url_title"],
    collectionUrlType: json["collection_url_type"],
    homePageStripeSVGUrl: json["home_page_stripe_svg_url"],
  );

  Map<String, dynamic> toJson() => {
    "collection_description": collectionDescription,
    "collection_primary_records": collectionPrimaryRecords,
    "collection_type": collectionType,
    "collection_for_web": collectionForWeb,
    "collection_for_app": collectionForApp,
    "collection_link_url": collectionLinkUrl,
    "collection_child_records": collectionChildRecords,
    "collection_criteria": collectionCriteria,
    "collection_id": collectionId,
    "collection_full_width": collectionFullWidth,
    "collection_display_order": collectionDisplayOrder,
    "collection_link_caption": collectionLinkCaption,
    "slides": slides == null
        ? []
        : List<dynamic>.from(slides!.map((x) => x.toJson())),
    "shops": shops == null
        ? []
        : List<dynamic>.from(shops!.map((x) => x.toJson())),
    "collection_name": collectionName,
    "collection_display_media_only": collectionDisplayMediaOnly,
    "collection_updated_on": collectionUpdatedOn?.toIso8601String(),
    "collection_layout_type": layoutType?.value, // ✅ serialize enum
    "banners": banners?.toJson(),
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toJson())),
    "totProducts": totProducts,
    "collection_url_title": collectionUrlTitle,
    "collection_url_type": collectionUrlType,
    "home_page_stripe_svg_url": homePageStripeSVGUrl,
  };
}

class HomeBrand {
  final String? brandName;
  final String? brandImage;
  final String? brandId;

  HomeBrand({this.brandName, this.brandImage, this.brandId});

  factory HomeBrand.fromJson(Map<String, dynamic> json) => HomeBrand(
    brandName: json["brand_name"],
    brandImage: json["brand_image"],
    brandId: json["brand_id"],
  );

  Map<String, dynamic> toJson() => {
    "brand_name": brandName,
    "brand_image": brandImage,
    "brand_id": brandId,
  };
}

class Banners {
  final String? bldimensionBlocationId;
  final String? blocationIdentifier;
  final String? bldimensionDeviceType;
  final List<HomeBanner>? banners;
  final String? blocationPromotionCost;
  final String? blocationId;
  final String? blocationActive;
  final String? blocationBannerHeight;
  final String? blocationBannerWidth;
  final String? blocationBannerCount;
  final String? blocationCollectionId;

  Banners({
    this.bldimensionBlocationId,
    this.blocationIdentifier,
    this.bldimensionDeviceType,
    this.banners,
    this.blocationPromotionCost,
    this.blocationId,
    this.blocationActive,
    this.blocationBannerHeight,
    this.blocationBannerWidth,
    this.blocationBannerCount,
    this.blocationCollectionId,
  });

  factory Banners.fromJson(Map<String, dynamic> json) => Banners(
    bldimensionBlocationId: json["bldimension_blocation_id"],
    blocationIdentifier: json["blocation_identifier"],
    bldimensionDeviceType: json["bldimension_device_type"],
    banners: json["banners"] == null
        ? []
        : List<HomeBanner>.from(
            json["banners"]!.map((x) => HomeBanner.fromJson(x)),
          ),
    blocationPromotionCost: json["blocation_promotion_cost"],
    blocationId: json["blocation_id"],
    blocationActive: json["blocation_active"],
    blocationBannerHeight: json["blocation_banner_height"],
    blocationBannerWidth: json["blocation_banner_width"],
    blocationBannerCount: json["blocation_banner_count"],
    blocationCollectionId: json["blocation_collection_id"],
  );

  Map<String, dynamic> toJson() => {
    "bldimension_blocation_id": bldimensionBlocationId,
    "blocation_identifier": blocationIdentifier,
    "bldimension_device_type": bldimensionDeviceType,
    "banners": banners == null
        ? []
        : List<dynamic>.from(banners!.map((x) => x.toJson())),
    "blocation_promotion_cost": blocationPromotionCost,
    "blocation_id": blocationId,
    "blocation_active": blocationActive,
    "blocation_banner_height": blocationBannerHeight,
    "blocation_banner_width": blocationBannerWidth,
    "blocation_banner_count": blocationBannerCount,
    "blocation_collection_id": blocationCollectionId,
  };
}

class HomeBanner {
  final String? bannerId;
  final String? promotionBudget;
  final String? userBalance;
  final String? promotionName;
  final String? bannerTarget;
  final String? monthlyCost;
  final DateTime? bannerUpdatedOn;
  final String? bannerUrlTitle;
  final String? bannerBlocationId;
  final String? dailyCost;
  final String? promotionId;
  final String? bannerType;
  final String? totalCost;
  final String? bannerUrlType;
  final String? bannerImage;
  final String? bannerTitle;
  final String? bannerUrl;
  final String? bannerRecordId;
  final String? promotionDuration;
  final String? weeklyCost;

  HomeBanner({
    this.bannerId,
    this.promotionBudget,
    this.userBalance,
    this.promotionName,
    this.bannerTarget,
    this.monthlyCost,
    this.bannerUpdatedOn,
    this.bannerUrlTitle,
    this.bannerBlocationId,
    this.dailyCost,
    this.promotionId,
    this.bannerType,
    this.totalCost,
    this.bannerUrlType,
    this.bannerImage,
    this.bannerTitle,
    this.bannerUrl,
    this.bannerRecordId,
    this.promotionDuration,
    this.weeklyCost,
  });

  factory HomeBanner.fromJson(Map<String, dynamic> json) => HomeBanner(
    bannerId: json["banner_id"],
    promotionBudget: json["promotion_budget"],
    userBalance: json["userBalance"],
    promotionName: json["promotion_name"],
    bannerTarget: json["banner_target"],
    monthlyCost: json["monthly_cost"],
    bannerUpdatedOn: json["banner_updated_on"] == null
        ? null
        : DateTime.parse(json["banner_updated_on"]),
    bannerUrlTitle: json["banner_url_title"],
    bannerBlocationId: json["banner_blocation_id"],
    dailyCost: json["daily_cost"],
    promotionId: json["promotion_id"],
    bannerType: json["banner_type"],
    totalCost: json["total_cost"],
    bannerUrlType: json["banner_url_type"],
    bannerImage: json["banner_image"],
    bannerTitle: json["banner_title"],
    bannerUrl: json["banner_url"],
    bannerRecordId: json["banner_record_id"],
    promotionDuration: json["promotion_duration"],
    weeklyCost: json["weekly_cost"],
  );

  Map<String, dynamic> toJson() => {
    "banner_id": bannerId,
    "promotion_budget": promotionBudget,
    "userBalance": userBalance,
    "promotion_name": promotionName,
    "banner_target": bannerTarget,
    "monthly_cost": monthlyCost,
    "banner_updated_on": bannerUpdatedOn?.toIso8601String(),
    "banner_url_title": bannerUrlTitle,
    "banner_blocation_id": bannerBlocationId,
    "daily_cost": dailyCost,
    "promotion_id": promotionId,
    "banner_type": bannerType,
    "total_cost": totalCost,
    "banner_url_type": bannerUrlType,
    "banner_image": bannerImage,
    "banner_title": bannerTitle,
    "banner_url": bannerUrl,
    "banner_record_id": bannerRecordId,
    "promotion_duration": promotionDuration,
    "weekly_cost": weeklyCost,
  };
}

class HomeProduct {
  final String? prodcatName;
  final String? splpriceDisplayDisType;
  final String? productId;
  final String? productImageUrl;
  final DateTime? productUpdatedOn;
  final String? selprodMinOrderQty;
  final String? brandId;
  final String? shopName;
  final String? selprodSoldCount;
  final String? productDetailUrl;
  final String? selprodStock;
  final String? theprice;
  final String? selprodCondition;
  final List<ProductOptions>? productOptions;
  final String? prodRating;
  final String? shopId;
  final String? selprod_user_id;
  final String? selprodId;
  final String? splpriceDisplayListPrice;
  final String? brandName;
  final String? productName;
  final String? prodcatId;
  final String? discount;
  final String? afilePhysicalPath;
  final String? isComingsoon;
  final String? shopLogoUrl;
  final String? inStock;
  final String? selprodPrice;
  final String? selprodTitle;
  final String? specialPriceFound;
  final String? splpriceDisplayDisVal;
  final String? availableInLocation;
  final String? productVideoUrl;
  final String? product_video_gif_url;
  final String? is_in_any_wishlist;
  final List<dynamic>? ribbons;

  HomeProduct({
    this.prodcatName,
    this.splpriceDisplayDisType,
    this.productId,
    this.productImageUrl,
    this.productUpdatedOn,
    this.selprodMinOrderQty,
    this.brandId,
    this.shopName,
    this.selprodSoldCount,
    this.productDetailUrl,
    this.selprodStock,
    this.theprice,
    this.selprodCondition,
    this.productOptions,
    this.prodRating,
    this.shopId,
    this.selprod_user_id,
    this.selprodId,
    this.splpriceDisplayListPrice,
    this.brandName,
    this.productName,
    this.prodcatId,
    this.discount,
    this.afilePhysicalPath,
    this.isComingsoon,
    this.shopLogoUrl,
    this.inStock,
    this.selprodPrice,
    this.selprodTitle,
    this.specialPriceFound,
    this.splpriceDisplayDisVal,
    this.availableInLocation,
    this.productVideoUrl,
    this.product_video_gif_url,
    this.ribbons,
    this.is_in_any_wishlist,
  });

  factory HomeProduct.fromJson(Map<String, dynamic> json) => HomeProduct(
    prodcatName: json["prodcat_name"],
    splpriceDisplayDisType: json["splprice_display_dis_type"],
    productId: json["product_id"],
    productImageUrl: json["product_image_url"],
    productUpdatedOn: json["product_updated_on"] == null
        ? null
        : DateTime.parse(json["product_updated_on"]),
    selprodMinOrderQty: json["selprod_min_order_qty"],
    brandId: json["brand_id"],
    shopName: json["shop_name"],
    selprodSoldCount: json["selprod_sold_count"],
    productDetailUrl: json["product_detail_url"],
    selprodStock: json["selprod_stock"],
    theprice: json["theprice"],
    selprodCondition: json["selprod_condition"],
    productOptions: json["product_options"] == null
        ? []
        : List<ProductOptions>.from(
            json["product_options"]!.map((x) => ProductOptions.fromJson(x)),
          ),
    prodRating: json["prod_rating"],
    shopId: json["shop_id"],
    selprod_user_id: json["selprod_user_id"],
    selprodId: json["selprod_id"],
    splpriceDisplayListPrice: json["splprice_display_list_price"],
    brandName: json["brand_name"],
    productName: json["product_name"],
    prodcatId: json["prodcat_id"],
    discount: json["discount"],
    afilePhysicalPath: json["afile_physical_path"],
    isComingsoon: json["isComingsoon"],
    shopLogoUrl: json["shop_logo_url"],
    inStock: json["in_stock"],
    selprodPrice: json["selprod_price"],
    selprodTitle: json["selprod_title"],
    specialPriceFound: json["special_price_found"],
    splpriceDisplayDisVal: json["splprice_display_dis_val"],
    availableInLocation: json["availableInLocation"],
    productVideoUrl: json["product_video_url"],
    product_video_gif_url: json["product_video_gif_url"],
    is_in_any_wishlist: json["is_in_any_wishlist"],
    ribbons: json["ribbons"] == null
        ? []
        : List<dynamic>.from(json["ribbons"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "prodcat_name": prodcatName,
    "splprice_display_dis_type": splpriceDisplayDisType,
    "product_id": productId,
    "product_image_url": productImageUrl,
    "product_updated_on": productUpdatedOn?.toIso8601String(),
    "selprod_min_order_qty": selprodMinOrderQty,
    "brand_id": brandId,
    "shop_name": shopName,
    "selprod_sold_count": selprodSoldCount,
    "product_detail_url": productDetailUrl,
    "selprod_stock": selprodStock,
    "theprice": theprice,
    "selprod_condition": selprodCondition,
    "product_options": productOptions == null
        ? []
        : List<dynamic>.from(productOptions!.map((x) => x.toJson())),
    "prod_rating": prodRating,
    "shop_id": shopId,
    "selprod_user_id": selprod_user_id,
    "selprod_id": selprodId,
    "splprice_display_list_price": splpriceDisplayListPrice,
    "brand_name": brandName,
    "product_name": productName,
    "prodcat_id": prodcatId,
    "discount": discount,
    "afile_physical_path": afilePhysicalPath,
    "isComingsoon": isComingsoon,
    "shop_logo_url": shopLogoUrl,
    "in_stock": inStock,
    "selprod_price": selprodPrice,
    "selprod_title": selprodTitle,
    "special_price_found": specialPriceFound,
    "splprice_display_dis_val": splpriceDisplayDisVal,
    "availableInLocation": availableInLocation,
    "product_video_url": productVideoUrl,
    "product_video_gif_url": product_video_gif_url,
    "is_in_any_wishlist": is_in_any_wishlist,
    "ribbons": ribbons == null
        ? []
        : List<dynamic>.from(ribbons!.map((x) => x)),
  };
}

class ProductOption {
  final String? optionIsColor;
  final String? optionId;
  final OptionName? optionName;
  final List<Value>? values;

  ProductOption({
    this.optionIsColor,
    this.optionId,
    this.optionName,
    this.values,
  });

  factory ProductOption.fromJson(Map<String, dynamic> json) => ProductOption(
    optionIsColor: json["option_is_color"],
    optionId: json["option_id"],
    // ✅ Safely map option name
    optionName:
        optionNameValues.map[json["option_name"]] ??
        OptionName.UNKNOWN, // default fallback
    // ✅ Guard null values list
    values: json["values"] == null
        ? []
        : List<Value>.from(
            (json["values"] as List).whereType<Map<String, dynamic>>().map(
              (x) => Value.fromJson(x),
            ),
          ),
  );

  Map<String, dynamic> toJson() => {
    "option_is_color": optionIsColor,
    "option_id": optionId,
    "option_name": optionNameValues.reverse[optionName],
    "values": values == null
        ? []
        : List<dynamic>.from(values!.map((x) => x.toJson())),
  };
}

enum OptionName { SELECT_SIZE, COLOR, MATERIAL, UNKNOWN }

final optionNameValues = EnumValues({
  "Select Size": OptionName.SELECT_SIZE,
  "Color": OptionName.COLOR,
  "Material": OptionName.MATERIAL,
});

class Value {
  final String? optionId;
  final String? optionvalueColorCode;
  final String? optionvalueId;
  final String? selprodId;
  final String? selprodUserId;
  final String? isAvailable;
  final String? productName;
  final String? optionvalueName;
  final String? theprice;
  final String? selprodCode;

  Value({
    this.optionId,
    this.optionvalueColorCode,
    this.optionvalueId,
    this.selprodId,
    this.selprodUserId,
    this.isAvailable,
    this.productName,
    this.optionvalueName,
    this.theprice,
    this.selprodCode,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
    optionId: json["option_id"],
    optionvalueColorCode: json["optionvalue_color_code"],
    optionvalueId: json["optionvalue_id"],
    selprodId: json["selprod_id"],
    selprodUserId: json["selprod_user_id"],
    isAvailable: json["isAvailable"],
    productName: json["product_name"],
    optionvalueName: json["optionvalue_name"],
    theprice: json["theprice"],
    selprodCode: json["selprod_code"],
  );

  Map<String, dynamic> toJson() => {
    "option_id": optionId,
    "optionvalue_color_code": optionvalueColorCode,
    "optionvalue_id": optionvalueId,
    "selprod_id": selprodId,
    "selprod_user_id": selprodUserId,
    "isAvailable": isAvailable,
    "product_name": productName,
    "optionvalue_name": optionvalueName,
    "theprice": theprice,
    "selprod_code": selprodCode,
  };
}

class MakeupViewModel {
  final String? collectionLayoutType;
  final String? collectionDisplayOrder;
  final String? collectionLinkCaption;
  final String? collectionPrimaryRecords;
  final String? collectionId;
  final String? collectionUrlTitle;
  final String? collectionForWeb;
  final String? collectionDescription;
  final String? collectionDisplayMediaOnly;
  final String? collectionLinkUrl;
  final String? collectionForApp;
  final String? collectionType;
  final String? totProducts;
  final String? collectionUrlType;
  final String? collectionCriteria;
  final String? collectionFullWidth;
  final List<Product>? products;
  final String? collectionChildRecords;
  final String? collectionName;
  final DateTime? collectionUpdatedOn;

  MakeupViewModel({
    this.collectionLayoutType,
    this.collectionDisplayOrder,
    this.collectionLinkCaption,
    this.collectionPrimaryRecords,
    this.collectionId,
    this.collectionUrlTitle,
    this.collectionForWeb,
    this.collectionDescription,
    this.collectionDisplayMediaOnly,
    this.collectionLinkUrl,
    this.collectionForApp,
    this.collectionType,
    this.totProducts,
    this.collectionUrlType,
    this.collectionCriteria,
    this.collectionFullWidth,
    this.products,
    this.collectionChildRecords,
    this.collectionName,
    this.collectionUpdatedOn,
  });

  factory MakeupViewModel.fromJson(Map<String, dynamic> json) =>
      MakeupViewModel(
        collectionLayoutType: json["collection_layout_type"],
        collectionDisplayOrder: json["collection_display_order"],
        collectionLinkCaption: json["collection_link_caption"],
        collectionPrimaryRecords: json["collection_primary_records"],
        collectionId: json["collection_id"],
        collectionUrlTitle: json["collection_url_title"],
        collectionForWeb: json["collection_for_web"],
        collectionDescription: json["collection_description"],
        collectionDisplayMediaOnly: json["collection_display_media_only"],
        collectionLinkUrl: json["collection_link_url"],
        collectionForApp: json["collection_for_app"],
        collectionType: json["collection_type"],
        totProducts: json["totProducts"],
        collectionUrlType: json["collection_url_type"],
        collectionCriteria: json["collection_criteria"],
        collectionFullWidth: json["collection_full_width"],
        products: json["products"] == null
            ? []
            : List<Product>.from(
                json["products"]!.map((x) => Product.fromJson(x)),
              ),
        collectionChildRecords: json["collection_child_records"],
        collectionName: json["collection_name"],
        collectionUpdatedOn: json["collection_updated_on"] == null
            ? null
            : DateTime.parse(json["collection_updated_on"]),
      );

  Map<String, dynamic> toJson() => {
    "collection_layout_type": collectionLayoutType,
    "collection_display_order": collectionDisplayOrder,
    "collection_link_caption": collectionLinkCaption,
    "collection_primary_records": collectionPrimaryRecords,
    "collection_id": collectionId,
    "collection_url_title": collectionUrlTitle,
    "collection_for_web": collectionForWeb,
    "collection_description": collectionDescription,
    "collection_display_media_only": collectionDisplayMediaOnly,
    "collection_link_url": collectionLinkUrl,
    "collection_for_app": collectionForApp,
    "collection_type": collectionType,
    "totProducts": totProducts,
    "collection_url_type": collectionUrlType,
    "collection_criteria": collectionCriteria,
    "collection_full_width": collectionFullWidth,
    "products": products == null
        ? []
        : List<dynamic>.from(products!.map((x) => x.toJson())),
    "collection_child_records": collectionChildRecords,
    "collection_name": collectionName,
    "collection_updated_on": collectionUpdatedOn?.toIso8601String(),
  };
}

class Product {
  final String? splpriceDisplayListPrice;
  final String? selprodCondition;
  final String? brandName;
  final String? splpriceDisplayDisVal;
  final List<dynamic>? productOptions;
  final DateTime? productUpdatedOn;
  final String? selprodSoldCount;
  final String? selprodPrice;
  final String? productId;
  final String? brandId;
  final String? prodcatId;
  final String? productName;
  final String? inStock;
  final String? specialPriceFound;
  final String? prodRating;
  final String? selprodTitle;
  final String? shopId;
  final String? prodcatName;
  final String? selprodStock;
  final List<dynamic>? ribbons;
  final String? splpriceDisplayDisType;
  final String? selprodMinOrderQty;
  final String? theprice;
  final String? shopName;
  final String? discount;
  final String? productImageUrl;
  final String? isComingsoon;
  final String? availableInLocation;
  final String? selprodId;

  Product({
    this.splpriceDisplayListPrice,
    this.selprodCondition,
    this.brandName,
    this.splpriceDisplayDisVal,
    this.productOptions,
    this.productUpdatedOn,
    this.selprodSoldCount,
    this.selprodPrice,
    this.productId,
    this.brandId,
    this.prodcatId,
    this.productName,
    this.inStock,
    this.specialPriceFound,
    this.prodRating,
    this.selprodTitle,
    this.shopId,
    this.prodcatName,
    this.selprodStock,
    this.ribbons,
    this.splpriceDisplayDisType,
    this.selprodMinOrderQty,
    this.theprice,
    this.shopName,
    this.discount,
    this.productImageUrl,
    this.isComingsoon,
    this.availableInLocation,
    this.selprodId,
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    splpriceDisplayListPrice: json["splprice_display_list_price"],
    selprodCondition: json["selprod_condition"],
    brandName: json["brand_name"],
    splpriceDisplayDisVal: json["splprice_display_dis_val"],
    productOptions: json["product_options"] == null
        ? []
        : List<dynamic>.from(json["product_options"]!.map((x) => x)),
    productUpdatedOn: json["product_updated_on"] == null
        ? null
        : DateTime.parse(json["product_updated_on"]),
    selprodSoldCount: json["selprod_sold_count"],
    selprodPrice: json["selprod_price"],
    productId: json["product_id"],
    brandId: json["brand_id"],
    prodcatId: json["prodcat_id"],
    productName: json["product_name"],
    inStock: json["in_stock"],
    specialPriceFound: json["special_price_found"],
    prodRating: json["prod_rating"],
    selprodTitle: json["selprod_title"],
    shopId: json["shop_id"],
    prodcatName: json["prodcat_name"],
    selprodStock: json["selprod_stock"],
    ribbons: json["ribbons"] == null
        ? []
        : List<dynamic>.from(json["ribbons"]!.map((x) => x)),
    splpriceDisplayDisType: json["splprice_display_dis_type"],
    selprodMinOrderQty: json["selprod_min_order_qty"],
    theprice: json["theprice"],
    shopName: json["shop_name"],
    discount: json["discount"],
    productImageUrl: json["product_image_url"],
    isComingsoon: json["isComingsoon"],
    availableInLocation: json["availableInLocation"],
    selprodId: json["selprod_id"],
  );

  Map<String, dynamic> toJson() => {
    "splprice_display_list_price": splpriceDisplayListPrice,
    "selprod_condition": selprodCondition,
    "brand_name": brandName,
    "splprice_display_dis_val": splpriceDisplayDisVal,
    "product_options": productOptions == null
        ? []
        : List<dynamic>.from(productOptions!.map((x) => x)),
    "product_updated_on": productUpdatedOn?.toIso8601String(),
    "selprod_sold_count": selprodSoldCount,
    "selprod_price": selprodPrice,
    "product_id": productId,
    "brand_id": brandId,
    "prodcat_id": prodcatId,
    "product_name": productName,
    "in_stock": inStock,
    "special_price_found": specialPriceFound,
    "prod_rating": prodRating,
    "selprod_title": selprodTitle,
    "shop_id": shopId,
    "prodcat_name": prodcatName,
    "selprod_stock": selprodStock,
    "ribbons": ribbons == null
        ? []
        : List<dynamic>.from(ribbons!.map((x) => x)),
    "splprice_display_dis_type": splpriceDisplayDisType,
    "selprod_min_order_qty": selprodMinOrderQty,
    "theprice": theprice,
    "shop_name": shopName,
    "discount": discount,
    "product_image_url": productImageUrl,
    "isComingsoon": isComingsoon,
    "availableInLocation": availableInLocation,
    "selprod_id": selprodId,
  };
}

class Slide {
  final String? totalCost;
  final String? slideLayout;
  final String? promotionBudget;
  final String? slideType;
  final String? userBalance;
  final String? slideRecordId;
  final String? slideImageUrl;
  final String? slideTitle;
  final String? dailyCost;
  final String? slideId;
  final String? slideTarget;
  final String? promotionDuration;
  final String? promotionId;
  final String? slideUrlType;
  final String? slideUrlTitle;
  final String? monthlyCost;
  final String? slideUrl;
  final String? slideImgUpdatedOn;
  final String? weeklyCost;

  Slide({
    this.totalCost,
    this.slideLayout,
    this.promotionBudget,
    this.slideType,
    this.userBalance,
    this.slideRecordId,
    this.slideImageUrl,
    this.slideTitle,
    this.dailyCost,
    this.slideId,
    this.slideTarget,
    this.promotionDuration,
    this.promotionId,
    this.slideUrlType,
    this.slideUrlTitle,
    this.monthlyCost,
    this.slideUrl,
    this.slideImgUpdatedOn,
    this.weeklyCost,
  });

  factory Slide.fromJson(Map<String, dynamic> json) => Slide(
    totalCost: json["total_cost"],
    slideLayout: json["slide_layout"],
    promotionBudget: json["promotion_budget"],
    slideType: json["slide_type"],
    userBalance: json["userBalance"],
    slideRecordId: json["slide_record_id"],
    slideImageUrl: json["slide_image_url"],
    slideTitle: json["slide_title"],
    dailyCost: json["daily_cost"],
    slideId: json["slide_id"],
    slideTarget: json["slide_target"],
    promotionDuration: json["promotion_duration"],
    promotionId: json["promotion_id"],
    slideUrlType: json["slide_url_type"],
    slideUrlTitle: json["slide_url_title"],
    monthlyCost: json["monthly_cost"],
    slideUrl: json["slide_url"],
    slideImgUpdatedOn: json["slide_img_updated_on"],
    weeklyCost: json["weekly_cost"],
  );

  Map<String, dynamic> toJson() => {
    "total_cost": totalCost,
    "slide_layout": slideLayout,
    "promotion_budget": promotionBudget,
    "slide_type": slideType,
    "userBalance": userBalance,
    "slide_record_id": slideRecordId,
    "slide_image_url": slideImageUrl,
    "slide_title": slideTitle,
    "daily_cost": dailyCost,
    "slide_id": slideId,
    "slide_target": slideTarget,
    "promotion_duration": promotionDuration,
    "promotion_id": promotionId,
    "slide_url_type": slideUrlType,
    "slide_url_title": slideUrlTitle,
    "monthly_cost": monthlyCost,
    "slide_url": slideUrl,
    "slide_img_updated_on": slideImgUpdatedOn,
    "weekly_cost": weeklyCost,
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

enum CollectionLayoutType {
  productLayout1('1'),
  productLayout2('2'),
  productLayout3('3'),
  categoryLayout1('4'),
  categoryLayout2('5'),
  shopLayout('6'),
  homeSliderNew('38'),
  brandLayout('7'),
  blogLayout('8'),
  smallBrandLayout('35'),
  sliderBanner('36'),
  sponsoredProductLayout('9'),
  sponsoredShopLayout('10'),
  topBanner('11'),
  middleBanner('12'),
  bottomBanner('13'),
  faqLayout('14'),
  testimonialLayout('15'),
  pendingReviewLayout('17'),
  aboutUs('16'),
  perfume('24'),
  newPrediction1('18'),
  parentCategory('26'),
  homeSlider('25'),
  newCategory('27'),
  newTopBrand('28'),
  trendingProduct('29'),
  newProductLayout('30'),
  newCategoryLayout('31'),
  dualSquareBanner('39'),
  reelCollectionLayout('40'),
  spacer('50'),
  homePageBannerStripe('42'),
  smallBrandLayoutNew('43'),
  unknown('0'); // fallback for unrecognized values

  final String value;

  const CollectionLayoutType(this.value);

  /// Factory to create enum from API string value
  static CollectionLayoutType fromValue(String? value) {
    return CollectionLayoutType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => CollectionLayoutType.unknown,
    );
  }
}

class HomePageShops {
  final String? ctrDisplayOrder;
  final String? shopId;
  final String? shopUserId;
  final String? shopName;
  final String? countryName;
  final String? stateName;
  final String? rating;
  final String? shopLogo;
  final String? shopBanner;

  HomePageShops({
    this.ctrDisplayOrder,
    this.shopId,
    this.shopUserId,
    this.shopName,
    this.countryName,
    this.stateName,
    this.rating,
    this.shopLogo,
    this.shopBanner,
  });

  factory HomePageShops.fromJson(Map<String, dynamic> json) {
    return HomePageShops(
      ctrDisplayOrder: json['ctr_display_order'] as String?,
      shopId: json['shop_id'] as String?,
      shopUserId: json['shop_user_id'] as String?,
      shopName: json['shop_name'] as String?,
      countryName: json['country_name'] as String?,
      stateName: json['state_name'] as String?,
      rating: json['rating'] as String?,
      shopLogo: json['shop_logo'] as String?,
      shopBanner: json['shop_banner'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ctr_display_order': ctrDisplayOrder,
      'shop_id': shopId,
      'shop_user_id': shopUserId,
      'shop_name': shopName,
      'country_name': countryName,
      'state_name': stateName,
      'rating': rating,
      'shop_logo': shopLogo,
      'shop_banner': shopBanner,
    };
  }
}

extension HomeProductCopy on HomeProduct {
  HomeProduct copyWith({String? is_in_any_wishlist}) {
    return HomeProduct(
      prodcatName: prodcatName,
      splpriceDisplayDisType: splpriceDisplayDisType,
      productId: productId,
      productImageUrl: productImageUrl,
      productUpdatedOn: productUpdatedOn,
      selprodMinOrderQty: selprodMinOrderQty,
      brandId: brandId,
      shopName: shopName,
      selprodSoldCount: selprodSoldCount,
      productDetailUrl: productDetailUrl,
      selprodStock: selprodStock,
      theprice: theprice,
      selprodCondition: selprodCondition,
      productOptions: productOptions,
      prodRating: prodRating,
      shopId: shopId,
      selprod_user_id: selprod_user_id,
      selprodId: selprodId,
      splpriceDisplayListPrice: splpriceDisplayListPrice,
      brandName: brandName,
      productName: productName,
      prodcatId: prodcatId,
      discount: discount,
      afilePhysicalPath: afilePhysicalPath,
      isComingsoon: isComingsoon,
      shopLogoUrl: shopLogoUrl,
      inStock: inStock,
      selprodPrice: selprodPrice,
      selprodTitle: selprodTitle,
      specialPriceFound: specialPriceFound,
      splpriceDisplayDisVal: splpriceDisplayDisVal,
      availableInLocation: availableInLocation,
      productVideoUrl: productVideoUrl,
      product_video_gif_url: product_video_gif_url,
      ribbons: ribbons,
      is_in_any_wishlist: is_in_any_wishlist ?? this.is_in_any_wishlist,
    );
  }
}

// extension MarqueeWidgetExtension on Widget {
//   Widget marqueeWidget({
//     double height = 30,
//
//     Color backgroundColor = Colors.transparent,
//
//     EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 12),
//   }) {
//     return Container(
//       width: double.infinity,
//
//       height: height,
//
//       color: backgroundColor,
//
//       alignment: Alignment.centerLeft,
//
//       padding: padding,
//
//       child: Marquee(
//         animationDuration: const Duration(seconds: 20),
//         child: this,
//       ),
//     );
//   }
// }

class InfiniteScrollBanner extends StatefulWidget {
  final Widget child;
  final double height;
  final Duration duration;

  const InfiniteScrollBanner({
    super.key,
    required this.child,
    this.height = 40,
    this.duration = const Duration(seconds: 8),
  });

  @override
  State<InfiniteScrollBanner> createState() =>
      _InfiniteScrollBannerState();
}

class _InfiniteScrollBannerState
    extends State<InfiniteScrollBanner>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  // total scrolling distance
  final double scrollDistance = 2000;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  Widget build(BuildContext context) {
    final isRTL =
        Directionality.of(context) == TextDirection.rtl;
    return SizedBox(
      height: widget.height,
      width: double.infinity,
      child: ClipRect(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return OverflowBox(
              alignment: Alignment.centerRight,
              minWidth: 0,
              maxWidth: double.infinity,
              child: Transform.translate(
                offset: Offset(
                  (scrollDistance * _controller.value),
                  0,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(
                    20,
                        (index) => Padding(
                      padding:
                      const EdgeInsets.only(right: 0),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}