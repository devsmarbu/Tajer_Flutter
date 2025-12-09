import 'package:dio/dio.dart';
import 'package:tajer/app/modules/home/home_model.dart';

import '../../../product_detail/product_detail_model.dart';

class CartListingModel {
  final String? status;
  final String? responseCode;
  final String? msg;
  final CartListingData? data;

  CartListingModel({this.status, this.responseCode, this.msg, this.data});

  factory CartListingModel.fromJson(Map<String, dynamic> json) =>
      CartListingModel(
        status: json["status"]?.toString(),
        responseCode: json["responseCode"],
        msg: json["msg"],
        data: json["data"] == null ? null : CartListingData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "responseCode": responseCode,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class CartListingData {
  final String? currencySymbol;
  final String? totalFavouriteItems;
  final String? totalUnreadMessageCount;
  final String? totalUnreadNotificationCount;
  final String? cartItemsCount;
  final Products? products;
  final CartSummary? cartSummary;
  final IngAddress? cartSelectedBillingAddress;
  final IngAddress? cartSelectedShippingAddress;
  final String? hasPhysicalProduct;
  final String? isShippingSameAsBilling;
  final String? selectedBillingAddressId;
  final String? selectedShippingAddressId;
  final String? cartProductsCount;
  final String? shipProductsCount;
  final String? pickUpProductsCount;
  final ShippingGuidelines? shippingGuidelines;
  final ShippingRatesResponse? rates;
  final String? isDTVisible;
  final String? userWalletBalance;
  final String? displayUserWalletBalance;
  final String? rewardPoints;
  final String? canBeUseRp;
  final String? canBeUseRpAmt;
  final String? walletCharged;
  final String? remainingWalletBalance;
  final String? displayRemainingWalletBalance;
  final String? orderNetAmount;
  final List<NetPayable>? priceDetail;
  final NetPayable? netPayable;

  CartListingData({
    this.currencySymbol,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.products,
    this.cartSummary,
    this.cartSelectedBillingAddress,
    this.cartSelectedShippingAddress,
    this.hasPhysicalProduct,
    this.isShippingSameAsBilling,
    this.selectedBillingAddressId,
    this.selectedShippingAddressId,
    this.cartProductsCount,
    this.shipProductsCount,
    this.pickUpProductsCount,
    this.shippingGuidelines,
    this.rates,
    this.isDTVisible,
    this.userWalletBalance,
    this.displayUserWalletBalance,
    this.rewardPoints,
    this.canBeUseRp,
    this.canBeUseRpAmt,
    this.walletCharged,
    this.remainingWalletBalance,
    this.displayRemainingWalletBalance,
    this.orderNetAmount,
    this.priceDetail,
    this.netPayable,
  });

  factory CartListingData.fromJson(Map<String, dynamic> json) => CartListingData(
    currencySymbol: json["currencySymbol"],
    totalFavouriteItems: json["totalFavouriteItems"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    cartItemsCount: json["cartItemsCount"],
    products: json["products"] == null
        ? null
        : Products.fromJson(json["products"]),
    cartSummary: json["cartSummary"] == null
        ? null
        : CartSummary.fromJson(json["cartSummary"]),
    cartSelectedBillingAddress: json["cartSelectedBillingAddress"] == null
        ? null
        : IngAddress.fromJson(json["cartSelectedBillingAddress"]),
    cartSelectedShippingAddress: json["cartSelectedShippingAddress"] == null
        ? null
        : IngAddress.fromJson(json["cartSelectedShippingAddress"]),
    hasPhysicalProduct: json["hasPhysicalProduct"],
    isShippingSameAsBilling: json["isShippingSameAsBilling"],
    selectedBillingAddressId: json["selectedBillingAddressId"],
    selectedShippingAddressId: json["selectedShippingAddressId"],
    cartProductsCount: json["cartProductsCount"],
    shipProductsCount: json["shipProductsCount"],
    pickUpProductsCount: json["pickUpProductsCount"],
    shippingGuidelines: json["shippingGuidelines"] == null
        ? null
        : ShippingGuidelines.fromJson(json["shippingGuidelines"]),
    rates: json["rates"] == null
        ? null
        : ShippingRatesResponse.fromJson(json["rates"]),
    isDTVisible: json["isDTVisible"],
    userWalletBalance: json["userWalletBalance"],
    displayUserWalletBalance: json["displayUserWalletBalance"],
    rewardPoints: json["rewardPoints"],
    canBeUseRp: json["canBeUseRP"],
    canBeUseRpAmt: json["canBeUseRPAmt"],
    walletCharged: json["walletCharged"],
    remainingWalletBalance: json["remainingWalletBalance"],
    displayRemainingWalletBalance: json["displayRemainingWalletBalance"],
    orderNetAmount: json["orderNetAmount"],
    priceDetail: json["priceDetail"] == null
        ? []
        : List<NetPayable>.from(
            json["priceDetail"]!.map((x) => NetPayable.fromJson(x)),
          ),
    netPayable: json["netPayable"] == null
        ? null
        : NetPayable.fromJson(json["netPayable"]),
  );

  Map<String, dynamic> toJson() => {
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "products": products?.toJson(),
    "cartSummary": cartSummary?.toJson(),
    "cartSelectedBillingAddress": cartSelectedBillingAddress?.toJson(),
    "cartSelectedShippingAddress": cartSelectedShippingAddress?.toJson(),
    "hasPhysicalProduct": hasPhysicalProduct,
    "isShippingSameAsBilling": isShippingSameAsBilling,
    "selectedBillingAddressId": selectedBillingAddressId,
    "selectedShippingAddressId": selectedShippingAddressId,
    "cartProductsCount": cartProductsCount,
    "shipProductsCount": shipProductsCount,
    "pickUpProductsCount": pickUpProductsCount,
    "shippingGuidelines": shippingGuidelines?.toJson(),
    "rates": rates,
    "isDTVisible": isDTVisible,
    "userWalletBalance": userWalletBalance,
    "displayUserWalletBalance": displayUserWalletBalance,
    "rewardPoints": rewardPoints,
    "canBeUseRP": canBeUseRp,
    "canBeUseRPAmt": canBeUseRpAmt,
    "walletCharged": walletCharged,
    "remainingWalletBalance": remainingWalletBalance,
    "displayRemainingWalletBalance": displayRemainingWalletBalance,
    "orderNetAmount": orderNetAmount,
    "priceDetail": priceDetail == null
        ? []
        : List<dynamic>.from(priceDetail!.map((x) => x.toJson())),
    "netPayable": netPayable?.toJson(),
  };
}

class IngAddress {
  final String? addrId;
  final String? addrType;
  final String? addrRecordId;
  final String? addrAddedBy;
  final String? addrLangId;
  final String? addrTitle;
  final String? addrName;
  final String? addrAddress1;
  final String? addrAddress2;
  final String? addrZone;
  final String? addrStreet;
  final String? addrBuildingNo;
  final String? addrUnitNo;
  final String? addrCity;
  final String? addrStateId;
  final String? addrCountryId;
  final String? addrPhoneDcode;
  final String? addrPhone;
  final String? addrZip;
  final String? addrLat;
  final String? addrLng;
  final String? addrIsDefault;
  final String? addrDeleted;
  final String? addrUpdatedOn;
  final String? stateCode;
  final String? countryCode;
  final String? countryCodeAlpha3;
  final String? countryName;
  final String? stateName;

  IngAddress({
    this.addrId,
    this.addrType,
    this.addrRecordId,
    this.addrAddedBy,
    this.addrLangId,
    this.addrTitle,
    this.addrName,
    this.addrAddress1,
    this.addrAddress2,
    this.addrZone,
    this.addrStreet,
    this.addrBuildingNo,
    this.addrUnitNo,
    this.addrCity,
    this.addrStateId,
    this.addrCountryId,
    this.addrPhoneDcode,
    this.addrPhone,
    this.addrZip,
    this.addrLat,
    this.addrLng,
    this.addrIsDefault,
    this.addrDeleted,
    this.addrUpdatedOn,
    this.stateCode,
    this.countryCode,
    this.countryCodeAlpha3,
    this.countryName,
    this.stateName,
  });

  factory IngAddress.fromJson(Map<String, dynamic> json) => IngAddress(
    addrId: json["addr_id"],
    addrType: json["addr_type"],
    addrRecordId: json["addr_record_id"],
    addrAddedBy: json["addr_added_by"],
    addrLangId: json["addr_lang_id"],
    addrTitle: json["addr_title"],
    addrName: json["addr_name"],
    addrAddress1: json["addr_address1"],
    addrAddress2: json["addr_address2"],
    addrZone: json["addr_zone"],
    addrStreet: json["addr_street"],
    addrBuildingNo: json["addr_building_no"],
    addrUnitNo: json["addr_unit_no"],
    addrCity: json["addr_city"],
    addrStateId: json["addr_state_id"],
    addrCountryId: json["addr_country_id"],
    addrPhoneDcode: json["addr_phone_dcode"],
    addrPhone: json["addr_phone"],
    addrZip: json["addr_zip"],
    addrLat: json["addr_lat"],
    addrLng: json["addr_lng"],
    addrIsDefault: json["addr_is_default"],
    addrDeleted: json["addr_deleted"],
    addrUpdatedOn: json["addr_updated_on"] ,
    stateCode: json["state_code"],
    countryCode: json["country_code"],
    countryCodeAlpha3: json["country_code_alpha3"],
    countryName: json["country_name"],
    stateName: json["state_name"],
  );

  Map<String, dynamic> toJson() => {
    "addr_id": addrId,
    "addr_type": addrType,
    "addr_record_id": addrRecordId,
    "addr_added_by": addrAddedBy,
    "addr_lang_id": addrLangId,
    "addr_title": addrTitle,
    "addr_name": addrName,
    "addr_address1": addrAddress1,
    "addr_address2": addrAddress2,
    "addr_zone": addrZone,
    "addr_street": addrStreet,
    "addr_building_no": addrBuildingNo,
    "addr_unit_no": addrUnitNo,
    "addr_city": addrCity,
    "addr_state_id": addrStateId,
    "addr_country_id": addrCountryId,
    "addr_phone_dcode": addrPhoneDcode,
    "addr_phone": addrPhone,
    "addr_zip": addrZip,
    "addr_lat": addrLat,
    "addr_lng": addrLng,
    "addr_is_default": addrIsDefault,
    "addr_deleted": addrDeleted,
    "addr_updated_on": addrUpdatedOn,
    "state_code": stateCode,
    "country_code": countryCode,
    "country_code_alpha3": countryCodeAlpha3,
    "country_name": countryName,
    "state_name": stateName,
  };
}

class CartSummary {
  final String? cartTotal;
  final String? shippingTotal;
  final String? originalShipping;
  final String? isFreeShipping;
  final String? cartTaxTotal;
  final CartDiscounts? cartDiscounts;
  final String? cartVolumeDiscount;
  String? cartRewardPoints;
  final String? cartWalletSelected;
  final String? siteCommission;
  final String? orderNetAmount;
  final String? walletAmountCharge;
  final String? isCodEnabled;
  final String? isCodValidForNetAmt;
  final String? minCodOrderLimit;
  final String? maxCodOrderLimit;
  final String? orderPaymentGatewayCharges;
  final String? netChargeAmount;
  final List<dynamic>? taxOptions;
  final List<dynamic>? prodTaxOptions;
  final String? roundingOff;
  final String? totalSaving;

  CartSummary({
    this.cartTotal,
    this.shippingTotal,
    this.originalShipping,
    this.isFreeShipping,
    this.cartTaxTotal,
    this.cartDiscounts,
    this.cartVolumeDiscount,
    this.cartRewardPoints,
    this.cartWalletSelected,
    this.siteCommission,
    this.orderNetAmount,
    this.walletAmountCharge,
    this.isCodEnabled,
    this.isCodValidForNetAmt,
    this.minCodOrderLimit,
    this.maxCodOrderLimit,
    this.orderPaymentGatewayCharges,
    this.netChargeAmount,
    this.taxOptions,
    this.prodTaxOptions,
    this.roundingOff,
    this.totalSaving,
  });

  factory CartSummary.fromJson(Map<String, dynamic> json) => CartSummary(
    cartTotal: json["cartTotal"],
    shippingTotal: json["shippingTotal"],
    originalShipping: json["originalShipping"],
    isFreeShipping: json["isFreeShipping"],
    cartTaxTotal: json["cartTaxTotal"],
    cartDiscounts: json["cartDiscounts"] == null
        ? null
        : CartDiscounts.fromJson(json["cartDiscounts"]),
    cartVolumeDiscount: json["cartVolumeDiscount"],
    cartRewardPoints: json["cartRewardPoints"],
    cartWalletSelected: json["cartWalletSelected"],
    siteCommission: json["siteCommission"],
    orderNetAmount: json["orderNetAmount"],
    walletAmountCharge: json["WalletAmountCharge"],
    isCodEnabled: json["isCodEnabled"],
    isCodValidForNetAmt: json["isCodValidForNetAmt"],
    minCodOrderLimit: json["min_cod_order_limit"],
    maxCodOrderLimit: json["max_cod_order_limit"],
    orderPaymentGatewayCharges: json["orderPaymentGatewayCharges"],
    netChargeAmount: json["netChargeAmount"],
    taxOptions: json["taxOptions"] == null
        ? []
        : List<dynamic>.from(json["taxOptions"]!.map((x) => x)),
    prodTaxOptions: json["prodTaxOptions"] == null
        ? []
        : List<dynamic>.from(json["prodTaxOptions"]!.map((x) => x)),
    roundingOff: json["roundingOff"],
    totalSaving: json["totalSaving"],
  );

  Map<String, dynamic> toJson() => {
    "cartTotal": cartTotal,
    "shippingTotal": shippingTotal,
    "originalShipping": originalShipping,
    "isFreeShipping": isFreeShipping,
    "cartTaxTotal": cartTaxTotal,
    "cartDiscounts": cartDiscounts?.toJson(),
    "cartVolumeDiscount": cartVolumeDiscount,
    "cartRewardPoints": cartRewardPoints,
    "cartWalletSelected": cartWalletSelected,
    "siteCommission": siteCommission,
    "orderNetAmount": orderNetAmount,
    "WalletAmountCharge": walletAmountCharge,
    "isCodEnabled": isCodEnabled,
    "isCodValidForNetAmt": isCodValidForNetAmt,
    "min_cod_order_limit": minCodOrderLimit,
    "max_cod_order_limit": maxCodOrderLimit,
    "orderPaymentGatewayCharges": orderPaymentGatewayCharges,
    "netChargeAmount": netChargeAmount,
    "taxOptions": taxOptions == null
        ? []
        : List<dynamic>.from(taxOptions!.map((x) => x)),
    "prodTaxOptions": prodTaxOptions == null
        ? []
        : List<dynamic>.from(prodTaxOptions!.map((x) => x)),
    "roundingOff": roundingOff,
    "totalSaving": totalSaving,
  };
}

class CartDiscounts {
  CartDiscounts();

  factory CartDiscounts.fromJson(Map<String, dynamic> json) => CartDiscounts();

  Map<String, dynamic> toJson() => {};
}

class NetPayable {
  final String? key;
  final String? value;

  NetPayable({this.key, this.value});

  factory NetPayable.fromJson(Map<String, dynamic> json) =>
      NetPayable(key: json["key"], value: json["value"]);

  Map<String, dynamic> toJson() => {"key": key, "value": value};
}

class Products {
  final List<Available>? notAvailable;
  final List<Available>? available;
  final List<Available>? saveForLater;

  Products({this.notAvailable, this.available, this.saveForLater});

  factory Products.fromJson(Map<String, dynamic> json) => Products(
    notAvailable: json["notAvailable"] == null
        ? []
        : List<Available>.from(
      json["notAvailable"]
          .where((x) => x != null)
          .map((x) => Available.fromJson(x)),
    ),
    available: json["available"] == null
        ? []
        : List<Available>.from(
      json["available"]
          .where((x) => x != null)
          .map((x) => Available.fromJson(x)),
    ),
    saveForLater: json["saveForLater"] == null
        ? []
        : List<Available>.from(
      json["saveForLater"]
          .where((x) => x != null)
          .map((x) => Available.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "notAvailable": notAvailable == null
        ? []
        : List<dynamic>.from(notAvailable!.map((x) => x.toJson())),
    "available": available == null
        ? []
        : List<dynamic>.from(available!.map((x) => x.toJson())),
    "saveForLater": saveForLater == null
        ? []
        : List<dynamic>.from(saveForLater!.map((x) => x.toJson())),
  };
}

class Available {
  final String? productId;
  final String? productType;
  final String? productLength;
  final String? productWidth;
  final String? productHeight;
  final String? productShipFree;
  final String? productDimensionUnit;
  final String? productHarmonizedTariffCode;
  final String? productWeight;
  final String? productWeightUnit;
  final String? productFulfillmentType;
  final String? selprodId;
  final String? selprodCode;
  final String? selprodStock;
  final String? selprodUserId;
  final String? inStock;
  final String? selprodMinOrderQty;
  final String? specialPriceFound;
  final String? theprice;
  final String? shopId;
  final String? shopFreeShipUpto;
  final String? shopStateId;
  final String? shopCountryId;
  final String? shopFulfillmentBy;
  final String? shopShipmentDays;
  final String? splpriceDisplayListPrice;
  final String? splpriceDisplayDisVal;
  final String? splpriceDisplayDisType;
  final String? selprodPrice;
  final String? selprodCost;
  final String? selprodFulfillmentFrom;
  final String? selprodCondition;
  final String? psbsUserId;
  final String? productSellerId;
  final String? productCodEnabled;
  final String? shopFulfillmentType;
  final String? selprodFulfillmentType;
  final String? selprodCodEnabled;
  final String? shippackLength;
  final String? shippackWidth;
  final String? shippackHeight;
  final String? shippackUnits;
  final String? prodcatName;
  final DateTime? productUpdatedOn;
  final String? selprodTrackInventory;
  final String? shopShipCharges;
  final String? productName;
  final String? selprodTitle;
  final String? brandName;
  final String? shopName;
  final String? brandId;
  final String? isInAnyWishlist;
  final String? uwlpUwlistId;
  final String? actualPrice;
  final String? volumeDiscount;
  final String? volumeDiscountPercentage;
  final String? volumeDiscountTotal;
  final String? shippingCost;
  final String? opshippingRateId;
  final String? commissionPercentage;
  final String? commission;
  final String? roundingOff;
  final String? tax;
  final String? optionsTaxSum;
  final String? taxCode;
  final String? total;
  final String? netTotal;
  final String? isDigitalProduct;
  final String? isPhysicalProduct;
  final String? isServiceProduct;
  final List<ProductOptions>? options;
  final String? isProductShippedBySeller;
  final String? fulfillmentType;
  final String? quantity;
  final IngAddress? shippingAddress;
  final List<dynamic>? taxOptions;
  final String? key;
  final String? isBatch;
  final String? isCodEnabled;
  final String? hasPhysicalProduct;
  final String? hasDigitalProduct;
  final String? affiliateCommissionPercentage;
  final String? affiliateCommission;
  final String? isDeliverTogether;
  final String? affiliateUserId;
  final Map<String, String>? sellerAddress;
  final String? productUrl;
  final String? shopUrl;
  final String? imageUrl;
  final String? discount;
  final String? isDeliverable;
  final String? notDelevryReason;

  Available({
    this.productId,
    this.productType,
    this.productLength,
    this.productWidth,
    this.productHeight,
    this.productShipFree,
    this.productDimensionUnit,
    this.productHarmonizedTariffCode,
    this.productWeight,
    this.productWeightUnit,
    this.productFulfillmentType,
    this.selprodId,
    this.selprodCode,
    this.selprodStock,
    this.selprodUserId,
    this.inStock,
    this.selprodMinOrderQty,
    this.specialPriceFound,
    this.theprice,
    this.shopId,
    this.shopFreeShipUpto,
    this.shopStateId,
    this.shopCountryId,
    this.shopFulfillmentBy,
    this.shopShipmentDays,
    this.splpriceDisplayListPrice,
    this.splpriceDisplayDisVal,
    this.splpriceDisplayDisType,
    this.selprodPrice,
    this.selprodCost,
    this.selprodFulfillmentFrom,
    this.selprodCondition,
    this.psbsUserId,
    this.productSellerId,
    this.productCodEnabled,
    this.shopFulfillmentType,
    this.selprodFulfillmentType,
    this.selprodCodEnabled,
    this.shippackLength,
    this.shippackWidth,
    this.shippackHeight,
    this.shippackUnits,
    this.prodcatName,
    this.productUpdatedOn,
    this.selprodTrackInventory,
    this.shopShipCharges,
    this.productName,
    this.selprodTitle,
    this.brandName,
    this.shopName,
    this.brandId,
    this.isInAnyWishlist,
    this.uwlpUwlistId,
    this.actualPrice,
    this.volumeDiscount,
    this.volumeDiscountPercentage,
    this.volumeDiscountTotal,
    this.shippingCost,
    this.opshippingRateId,
    this.commissionPercentage,
    this.commission,
    this.roundingOff,
    this.tax,
    this.optionsTaxSum,
    this.taxCode,
    this.total,
    this.netTotal,
    this.isDigitalProduct,
    this.isPhysicalProduct,
    this.isServiceProduct,
    this.options,
    this.isProductShippedBySeller,
    this.fulfillmentType,
    this.quantity,
    this.shippingAddress,
    this.taxOptions,
    this.key,
    this.isBatch,
    this.isCodEnabled,
    this.hasPhysicalProduct,
    this.hasDigitalProduct,
    this.affiliateCommissionPercentage,
    this.affiliateCommission,
    this.isDeliverTogether,
    this.affiliateUserId,
    this.sellerAddress,
    this.productUrl,
    this.shopUrl,
    this.imageUrl,
    this.discount,
    this.isDeliverable,
    this.notDelevryReason
  });

  factory Available.fromJson(Map<String, dynamic> json) => Available(
    productId: json["product_id"] ?? "",
    productType: json["product_type"] ?? "",
    productLength: json["product_length"] ?? "",
    productWidth: json["product_width"] ?? "",
    productHeight: json["product_height"] ?? "",
    productShipFree: json["product_ship_free"] ?? "",
    productDimensionUnit: json["product_dimension_unit"] ?? "",
    productHarmonizedTariffCode: json["product_harmonized_tariff_code"] ?? "",
    productWeight: json["product_weight"] ?? "",
    productWeightUnit: json["product_weight_unit"] ?? "",
    productFulfillmentType: json["product_fulfillment_type"] ?? "",
    selprodId: json["selprod_id"] ?? "",
    selprodCode: json["selprod_code"] ?? "",
    selprodStock: json["selprod_stock"] ?? "",
    selprodUserId: json["selprod_user_id"] ?? "",
    inStock: json["in_stock"] ?? "",
    selprodMinOrderQty: json["selprod_min_order_qty"] ?? "",
    specialPriceFound: json["special_price_found"] ?? "",
    theprice: json["theprice"] ?? "",
    shopId: json["shop_id"] ?? "",
    shopFreeShipUpto: json["shop_free_ship_upto"] ?? "",
    shopStateId: json["shop_state_id"] ?? "",
    shopCountryId: json["shop_country_id"] ?? "",
    shopFulfillmentBy: json["shop_fulfillment_by"] ?? "",
    shopShipmentDays: json["shop_shipment_days"] ?? "",
    splpriceDisplayListPrice: json["splprice_display_list_price"] ?? "",
    splpriceDisplayDisVal: json["splprice_display_dis_val"] ?? "",
    splpriceDisplayDisType: json["splprice_display_dis_type"] ?? "",
    selprodPrice: json["selprod_price"] ?? "",
    selprodCost: json["selprod_cost"] ?? "",
    selprodFulfillmentFrom: json["selprod_fulfillment_from"] ?? "",
    selprodCondition: json["selprod_condition"] ?? "",
    psbsUserId: json["psbs_user_id"] ?? "",
    productSellerId: json["product_seller_id"] ?? "",
    productCodEnabled: json["product_cod_enabled"] ?? "",
    shopFulfillmentType: json["shop_fulfillment_type"] ?? "",
    selprodFulfillmentType: json["selprod_fulfillment_type"] ?? "",
    selprodCodEnabled: json["selprod_cod_enabled"] ?? "",
    shippackLength: json["shippack_length"] ?? "",
    shippackWidth: json["shippack_width"] ?? "",
    shippackHeight: json["shippack_height"] ?? "",
    shippackUnits: json["shippack_units"] ?? "",
    prodcatName: json["prodcat_name"] ?? "",
    productUpdatedOn: json["product_updated_on"] == null
        ? null
        : DateTime.parse(json["product_updated_on"]),
    selprodTrackInventory: json["selprod_track_inventory"] ?? "",
    shopShipCharges: json["shop_ship_charges"] ?? "",
    productName: json["product_name"] ?? "",
    selprodTitle: json["selprod_title"] ?? "",
    brandName: json["brand_name"] ?? "",
    shopName: json["shop_name"] ?? "",
    brandId: json["brand_id"] ?? "",
    isInAnyWishlist: json["is_in_any_wishlist"] ?? "",
    uwlpUwlistId: json["uwlp_uwlist_id"] ?? "",
    actualPrice: json["actualPrice"] ?? "",
    volumeDiscount: json["volume_discount"] ?? "",
    volumeDiscountPercentage: json["volume_discount_percentage"] ?? "",
    volumeDiscountTotal: json["volume_discount_total"] ?? "",
    shippingCost: json["shipping_cost"] ?? "",
    opshippingRateId: json["opshipping_rate_id"] ?? "",
    commissionPercentage: json["commission_percentage"] ?? "",
    commission: json["commission"] ?? "",
    roundingOff: json["rounding_off"] ?? "",
    tax: json["tax"] ?? "",
    optionsTaxSum: json["optionsTaxSum"] ?? "",
    taxCode: json["taxCode"] ?? "",
    total: json["total"] ?? "",
    netTotal: json["netTotal"] ?? "",
    isDigitalProduct: json["is_digital_product"] ?? "",
    isPhysicalProduct: json["is_physical_product"] ?? "",
    isServiceProduct: json["is_service_product"] ?? "",
    options: json["options"] == null
        ? []
        : List<ProductOptions>.from(
            json["options"]!.map((x) => ProductOptions.fromJson(x)),
          ),
    isProductShippedBySeller: json["isProductShippedBySeller"] ?? "",
    fulfillmentType: json["fulfillment_type"] ?? "",
    quantity: json["quantity"] ?? "",
    shippingAddress: () {
      final sa = json["shipping_address"];
      if (sa is Map<String, dynamic>) {
        return IngAddress.fromJson(sa);
      }
      return null;
    }(),
    taxOptions: json["taxOptions"] == null
        ? []
        : List<dynamic>.from(json["taxOptions"]!.map((x) => x)),
    key: json["key"] ?? "",
    isBatch: json["is_batch"] ?? "",
    isCodEnabled: json["is_cod_enabled"] ?? "",
    hasPhysicalProduct: json["has_physical_product"] ?? "",
    hasDigitalProduct: json["has_digital_product"] ?? "",
    affiliateCommissionPercentage: json["affiliate_commission_percentage"] ?? "",
    affiliateCommission: json["affiliate_commission"] ?? "",
    isDeliverTogether: json["is_deliver_together"] ?? "",
    affiliateUserId: json["affiliate_user_id"] ?? "",
    sellerAddress: json["seller_address"] == null
        ? null
        : Map<String, String>.from(json["seller_address"]),
    productUrl: json["productUrl"] ?? "",
    shopUrl: json["shopUrl"] ?? "",
    imageUrl: json["imageUrl"] ?? "",
    discount: json["discount"] ?? "",
    isDeliverable: json["isDeliverable"] ?? "",
    notDelevryReason: json["notDelevryReason"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "product_type": productType,
    "product_length": productLength,
    "product_width": productWidth,
    "product_height": productHeight,
    "product_ship_free": productShipFree,
    "product_dimension_unit": productDimensionUnit,
    "product_harmonized_tariff_code": productHarmonizedTariffCode,
    "product_weight": productWeight,
    "product_weight_unit": productWeightUnit,
    "product_fulfillment_type": productFulfillmentType,
    "selprod_id": selprodId,
    "selprod_code": selprodCode,
    "selprod_stock": selprodStock,
    "selprod_user_id": selprodUserId,
    "in_stock": inStock,
    "selprod_min_order_qty": selprodMinOrderQty,
    "special_price_found": specialPriceFound,
    "theprice": theprice,
    "shop_id": shopId,
    "shop_free_ship_upto": shopFreeShipUpto,
    "shop_state_id": shopStateId,
    "shop_country_id": shopCountryId,
    "shop_fulfillment_by": shopFulfillmentBy,
    "shop_shipment_days": shopShipmentDays,
    "splprice_display_list_price": splpriceDisplayListPrice,
    "splprice_display_dis_val": splpriceDisplayDisVal,
    "splprice_display_dis_type": splpriceDisplayDisType,
    "selprod_price": selprodPrice,
    "selprod_cost": selprodCost,
    "selprod_fulfillment_from": selprodFulfillmentFrom,
    "selprod_condition": selprodCondition,
    "psbs_user_id": psbsUserId,
    "product_seller_id": productSellerId,
    "product_cod_enabled": productCodEnabled,
    "shop_fulfillment_type": shopFulfillmentType,
    "selprod_fulfillment_type": selprodFulfillmentType,
    "selprod_cod_enabled": selprodCodEnabled,
    "shippack_length": shippackLength,
    "shippack_width": shippackWidth,
    "shippack_height": shippackHeight,
    "shippack_units": shippackUnits,
    "prodcat_name": prodcatName,
    "product_updated_on": productUpdatedOn?.toIso8601String(),
    "selprod_track_inventory": selprodTrackInventory,
    "shop_ship_charges": shopShipCharges,
    "product_name": productName,
    "selprod_title": selprodTitle,
    "brand_name": brandName,
    "shop_name": shopName,
    "brand_id": brandId,
    "is_in_any_wishlist": isInAnyWishlist,
    "uwlp_uwlist_id": uwlpUwlistId,
    "actualPrice": actualPrice,
    "volume_discount": volumeDiscount,
    "volume_discount_percentage": volumeDiscountPercentage,
    "volume_discount_total": volumeDiscountTotal,
    "shipping_cost": shippingCost,
    "opshipping_rate_id": opshippingRateId,
    "commission_percentage": commissionPercentage,
    "commission": commission,
    "rounding_off": roundingOff,
    "tax": tax,
    "optionsTaxSum": optionsTaxSum,
    "taxCode": taxCode,
    "total": total,
    "netTotal": netTotal,
    "is_digital_product": isDigitalProduct,
    "is_physical_product": isPhysicalProduct,
    "is_service_product": isServiceProduct,
    "options": options == null
        ? []
        : List<dynamic>.from(options!.map((x) => x.toJson())),
    "isProductShippedBySeller": isProductShippedBySeller,
    "fulfillment_type": fulfillmentType,
    "quantity": quantity,
    "shipping_address": shippingAddress?.toJson(),
    "taxOptions": taxOptions == null
        ? []
        : List<dynamic>.from(taxOptions!.map((x) => x)),
    "key": key,
    "is_batch": isBatch,
    "is_cod_enabled": isCodEnabled,
    "has_physical_product": hasPhysicalProduct,
    "has_digital_product": hasDigitalProduct,
    "affiliate_commission_percentage": affiliateCommissionPercentage,
    "affiliate_commission": affiliateCommission,
    "is_deliver_together": isDeliverTogether,
    "affiliate_user_id": affiliateUserId,
    "seller_address": Map.from(
      sellerAddress!,
    ).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "productUrl": productUrl,
    "shopUrl": shopUrl,
    "imageUrl": imageUrl,
    "discount": discount,
    "isDeliverable": isDeliverable,
    "notDelevryReason": notDelevryReason,
  };
}

class ShippingGuidelines {
  final String? epageId;
  final String? epageIdentifier;
  final String? epageType;
  final String? epageContentFor;
  final String? epageActive;
  final String? epageDefault;
  final String? epageDefaultContent;
  final String? epageExtraInfo;
  final DateTime? epageUpdatedOn;
  final String? epagelangEpageId;
  final String? epagelangLangId;
  final String? epageLabel;
  final String? epageContent;

  ShippingGuidelines({
    this.epageId,
    this.epageIdentifier,
    this.epageType,
    this.epageContentFor,
    this.epageActive,
    this.epageDefault,
    this.epageDefaultContent,
    this.epageExtraInfo,
    this.epageUpdatedOn,
    this.epagelangEpageId,
    this.epagelangLangId,
    this.epageLabel,
    this.epageContent,
  });

  factory ShippingGuidelines.fromJson(Map<String, dynamic> json) =>
      ShippingGuidelines(
        epageId: json["epage_id"],
        epageIdentifier: json["epage_identifier"],
        epageType: json["epage_type"],
        epageContentFor: json["epage_content_for"],
        epageActive: json["epage_active"],
        epageDefault: json["epage_default"],
        epageDefaultContent: json["epage_default_content"],
        epageExtraInfo: json["epage_extra_info"],
        epageUpdatedOn: json["epage_updated_on"] == null
            ? null
            : DateTime.parse(json["epage_updated_on"]),
        epagelangEpageId: json["epagelang_epage_id"],
        epagelangLangId: json["epagelang_lang_id"],
        epageLabel: json["epage_label"],
        epageContent: json["epage_content"],
      );

  Map<String, dynamic> toJson() => {
    "epage_id": epageId,
    "epage_identifier": epageIdentifier,
    "epage_type": epageType,
    "epage_content_for": epageContentFor,
    "epage_active": epageActive,
    "epage_default": epageDefault,
    "epage_default_content": epageDefaultContent,
    "epage_extra_info": epageExtraInfo,
    "epage_updated_on": epageUpdatedOn?.toIso8601String(),
    "epagelang_epage_id": epagelangEpageId,
    "epagelang_lang_id": epagelangLangId,
    "epage_label": epageLabel,
    "epage_content": epageContent,
  };
}

class ShippingRatesResponse {
  final Map<String, RateModel>? rates;

  ShippingRatesResponse({required this.rates});

  factory ShippingRatesResponse.fromJson(Map<String, dynamic> json) {
    final map = <String, RateModel>{};

    json.forEach((key, value) {
      map[key] = RateModel.fromJson(value);
    });

    return ShippingRatesResponse(rates: map);
  }
}

class RateModel {
  String? selectedServiceCode;
  final String? shippingCode;
  final String? shippingSelected;
  final Map<String, HomeProduct>? productInfo;
  final List<ShippingMethod>? shippingMethods;

  RateModel({
    required this.shippingCode,
    required this.productInfo,
    required this.shippingMethods,
    required this.shippingSelected,
  });

  factory RateModel.fromJson(Map<String, dynamic> json) {
    final prodMap = <String, HomeProduct>{};

    json["product_info"].forEach((key, value) {
      prodMap[key] = HomeProduct.fromJson(value);
    });

    // ✅ Fix here
    List<ShippingMethod> methods = [];
    final sm = json["shipping_methods"];

    if (sm is List) {
      methods = sm.map((e) => ShippingMethod.fromJson(e)).toList();
    } else if (sm is Map && sm.isEmpty) {
      methods = []; // empty map → return empty list
    }

    return RateModel(
      shippingCode: json["shipping_code"],
      shippingSelected: json["shipping_selected"],
      productInfo: prodMap,
      shippingMethods: methods,
    )..selectedServiceCode = json["shipping_selected"];
  }
}

class ShippingMethod {
  final String? title;
  final String? cost;
  final String? id;
  final String? carrierCode;
  final String? serviceCode;

  ShippingMethod({
    this.id,
    this.carrierCode,
    this.serviceCode,
    this.title,
    this.cost,
  });

  factory ShippingMethod.fromJson(Map<String, dynamic> json) => ShippingMethod(
    title: json["title"],
    cost: json["cost"],
    id: json["id"],
    carrierCode: json["carrier_code"],
    serviceCode: json["service_code"],
  );
}
