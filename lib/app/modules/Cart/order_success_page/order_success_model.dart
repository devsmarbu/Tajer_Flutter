class OrderDetailModel {
  final String? status;
  final String? responseCode;
  final String? msg;
  final Data? data;

  OrderDetailModel({
    this.status,
    this.responseCode,
    this.msg,
    this.data,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) => OrderDetailModel(
    status: json["status"],
    responseCode: json["responseCode"],
    msg: json["msg"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "responseCode": responseCode,
    "msg": msg,
    "data": data?.toJson(),
  };
}

class Data {
  final String? currencySymbol;
  final String? totalFavouriteItems;
  final String? totalUnreadMessageCount;
  final String? totalUnreadNotificationCount;
  final String? cartItemsCount;
  final OrderDetail? orderDetail;
  final List<ChildOrderDetail>? childOrderDetail;
  final DigitalDownloadLinks? orderStatuses;
  final String? primaryOrder;
  final DigitalDownloadLinks? digitalDownloads;
  final DigitalDownloadLinks? digitalDownloadLinks;
  final Map<String, String>? languages;
  final Map<String, String>? yesNoArr;
  final List<OrderSummary>? orderSummary;

  Data({
    this.currencySymbol,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.orderDetail,
    this.childOrderDetail,
    this.orderStatuses,
    this.primaryOrder,
    this.digitalDownloads,
    this.digitalDownloadLinks,
    this.languages,
    this.yesNoArr,
    this.orderSummary,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currencySymbol: json["currencySymbol"],
    totalFavouriteItems: json["totalFavouriteItems"],
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    cartItemsCount: json["cartItemsCount"],
    orderDetail: json["orderDetail"] == null ? null : OrderDetail.fromJson(json["orderDetail"]),
    childOrderDetail: json["childOrderDetail"] == null ? [] : List<ChildOrderDetail>.from(json["childOrderDetail"]!.map((x) => ChildOrderDetail.fromJson(x))),
    orderStatuses: json["orderStatuses"] == null ? null : DigitalDownloadLinks.fromJson(json["orderStatuses"]),
    primaryOrder: json["primaryOrder"],
    digitalDownloads: json["digitalDownloads"] == null ? null : DigitalDownloadLinks.fromJson(json["digitalDownloads"]),
    digitalDownloadLinks: json["digitalDownloadLinks"] == null ? null : DigitalDownloadLinks.fromJson(json["digitalDownloadLinks"]),
    languages: Map.from(json["languages"]!).map((k, v) => MapEntry<String, String>(k, v)),
    yesNoArr: Map.from(json["yesNoArr"]!).map((k, v) => MapEntry<String, String>(k, v)),
    orderSummary: json["orderSummary"] == null ? [] : List<OrderSummary>.from(json["orderSummary"]!.map((x) => OrderSummary.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "orderDetail": orderDetail?.toJson(),
    "childOrderDetail": childOrderDetail == null ? [] : List<dynamic>.from(childOrderDetail!.map((x) => x.toJson())),
    "orderStatuses": orderStatuses?.toJson(),
    "primaryOrder": primaryOrder,
    "digitalDownloads": digitalDownloads?.toJson(),
    "digitalDownloadLinks": digitalDownloadLinks?.toJson(),
    "languages": Map.from(languages!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "yesNoArr": Map.from(yesNoArr!).map((k, v) => MapEntry<String, dynamic>(k, v)),
    "orderSummary": orderSummary == null ? [] : List<dynamic>.from(orderSummary!.map((x) => x.toJson())),
  };
}

class ChildOrderDetail {
  final String? opId;
  final String? opOrderId;
  final String? opInvoiceNumber;
  final String? opSelprodId;
  final String? opIsBatch;
  final String? opSelprodUserId;
  final String? opSelprodCode;
  final String? opBatchSelprodId;
  final String? opQty;
  final String? opSelprodPrice;
  final String? opUnitPrice;
  final String? opUnitCost;
  final String? opSelprodSku;
  final String? opCommissionCharged;
  final String? opCommissionPercentage;
  final String? opAffiliateCommissionCharged;
  final String? opAffiliateCommissionPercentage;
  final String? opSelprodCondition;
  final String? opSelprodFulfillmentFrom;
  final String? opProductModel;
  final String? opProductType;
  final String? opProductLength;
  final String? opProductWidth;
  final String? opProductHeight;
  final String? opProductDimensionUnit;
  final String? opProductWeight;
  final String? opProductWeightUnit;
  final String? opShopId;
  final String? opShopOwnerName;
  final String? opShopOwnerUsername;
  final String? opShopOwnerEmail;
  final String? opShopOwnerPhoneDcode;
  final String? opShopOwnerPhone;
  final String? opSdurationId;
  final String? opStatusId;
  final String? opRefundQty;
  final String? opRefundAmount;
  final String? opRefundCommission;
  final String? opRefundShipping;
  final String? opRefundTax;
  final String? opRefundAffiliateCommission;
  final String? opShippedDate;
  final String? opCompletionDate;
  final String? opSentReviewReminder;
  final String? opReviewReminderCount;
  final String? opSentLastReminder;
  final String? opSelprodMaxDownloadTimes;
  final String? opSelprodDownloadValidityInDays;
  final String? opFreeShipUpto;
  final String? opActualShippingCharges;
  final String? opTaxCode;
  final String? opRoundingOff;
  final String? opComments;
  final String? opIsGroupDelivery;
  final String? opPickingId;
  final String? opProductIdentifier;
  final String? opBrandIdentifier;
  final String? opWarehouseId;
  final String? opShippingCode;
  final String? oplangOpId;
  final String? oplangLangId;
  final String? opProductName;
  final String? opSelprodTitle;
  final String? opSelprodOptions;
  final String? opBrandName;
  final String? opShopName;
  final String? opShippingDurationName;
  final String? opShippingDurations;
  final String? opProductsDimensionUnitName;
  final String? opProductWeightUnitName;
  final String? opProductTaxOptions;
  final String? orderId;
  final String? orderNumber;
  final String? orderType;
  final String? orderUserId;
  final String? orderPaymentStatus;
  final String? orderStatus;
  final String? orderNetAmount;
  final String? orderIsWalletSelected;
  final String? orderWalletAmountCharge;
  final String? orderTaxCharged;
  final String? orderSiteCommission;
  final String? orderDiscountCouponCode;
  final String? orderDiscountType;
  final String? orderDiscountValue;
  final String? orderDiscountTotal;
  final String? orderDiscountInfo;
  final String? orderVolumeDiscountTotal;
  final String? orderRewardPointUsed;
  final String? orderRewardPointValue;
  final String? orderUserComments;
  final String? orderAdminComments;
  final String? orderLanguageId;
  final String? orderLanguageCode;
  final String? orderCurrencyId;
  final String? orderCurrencyCode;
  final String? orderCurrencyValue;
  final String? orderShippingapiId;
  final String? orderShippingapiCode;
  final String? orderPmethodId;
  final DateTime? orderDateAdded;
  final DateTime? orderDateConfirmed;
  final DateTime? orderDateUpdated;
  final String? orderReferrerUserId;
  final String? orderReferrerRewardPoints;
  final String? orderReferralRewardPoints;
  final String? orderAffiliateUserId;
  final String? orderAffiliateTotalCommission;
  final String? orderCartData;
  final String? orderRenew;
  final String? orderDeleted;
  final String? orderRoundingOff;
  final String? orderIsFreeShipping;
  final String? orderOriginalShippingCharged;
  final String? orderPurchasedRewardCredit;
  final String? orderPickingId;
  final String? orderstatusId;
  final String? orderstatusIdentifier;
  final String? orderstatusColorClass;
  final String? orderstatusType;
  final String? orderstatusPriority;
  final String? orderstatusIsActive;
  final String? orderstatusIsDigital;
  final String? orderstatuslangOrderstatusId;
  final String? orderstatuslangLangId;
  final String? orderstatusName;
  final String? opsettingOpId;
  final String? opCommissionIncludeTax;
  final String? opCommissionIncludeShipping;
  final String? opTaxCollectedBySeller;
  final String? opTaxAfterDiscount;
  final String? opProductInclusiveTax;
  final String? opshipOpId;
  final String? opshipOrderid;
  final String? opshipOrderNumber;
  final String? opshipShipmentId;
  final String? opshipTrackingNumber;
  final String? opshipTrackingUrl;
  final String? opshipTrackingCourierCode;
  final String? opshipTrackingPluginId;
  final String? oprOpId;
  final String? oprType;
  final String? oprResponse;
  final String? oprAddedOn;
  final String? pluginId;
  final String? pluginIdentifier;
  final String? pluginType;
  final String? pluginCode;
  final String? pluginActive;
  final String? pluginDisplayOrder;
  final String? pluginlangPluginId;
  final String? pluginlangLangId;
  final String? pluginName;
  final String? pluginDescription;
  final String? selprodId;
  final String? selprodUserId;
  final String? selprodProductId;
  final String? selprodCode;
  final String? selprodPrice;
  final String? selprodCost;
  final String? selprodStock;
  final String? selprodMinOrderQty;
  final String? selprodSubtractStock;
  final String? selprodTrackInventory;
  final String? selprodThresholdStockLevel;
  final String? selprodSku;
  final String? selprodCondition;
  final String? selprodFulfillmentFrom;
  final String? selprodExpiryDate;
  final DateTime? selprodAddedOn;
  final DateTime? selprodUpdatedOn;
  final DateTime? selprodAvailableFrom;
  final String? selprodActive;
  final String? selprodCodEnabled;
  final String? selprodFulfillmentType;
  final String? selprodSoldCount;
  final String? selprodUrlKeyword;
  final String? selprodMaxDownloadTimes;
  final String? selprodDownloadValidityInDays;
  final String? selprodUrlrewriteId;
  final String? selprodOdooId;
  final String? selprodDeleted;
  final String? selprodlangSelprodId;
  final String? selprodlangLangId;
  final String? selprodTitle;
  final String? selprodFeatures;
  final String? selprodWarranty;
  final String? selprodReturnPolicy;
  final String? selprodComments;
  final String? userId;
  final String? userName;
  final String? userPhoneDcode;
  final String? userPhone;
  final DateTime? userDob;
  final String? userProfileInfo;
  final String? userAddress1;
  final String? userAddress2;
  final String? userZip;
  final String? userCountryId;
  final String? userStateId;
  final String? userCity;
  final String? userIsBuyer;
  final String? userIsSupplier;
  final String? userParent;
  final String? userIsAdvertiser;
  final String? userIsAffiliate;
  final String? userIsShippingCompany;
  final String? userAutorenewSubscription;
  final String? userFbAccessToken;
  final String? userReferralCode;
  final String? userReferrerUserId;
  final String? userAffiliateReferrerUserId;
  final String? userPreferredDashboard;
  final DateTime? userRegdate;
  final String? userCompany;
  final String? userProductsServices;
  final String? userAffiliateCommission;
  final String? userRegisteredInitiallyFor;
  final String? userOrderTrackingUrl;
  final String? userHasValidSubscription;
  final String? userIsInfluencer;
  final DateTime? userUpdatedOn;
  final String? userDeleted;
  final String? userOddoId;
  final String? credentialUserId;
  final String? credentialUsername;
  final String? credentialEmail;
  final String? credentialPasswordOld;
  final String? credentialPassword;
  final String? credentialActive;
  final String? credentialVerified;
  final String? opchargeOpId;
  final String? opOtherCharges;
  final String? opshippingOpId;
  final String? opshippingFulfillmentType;
  final String? opshippingPluginId;
  final String? opshippingIsSellerPlugin;
  final String? opshippingPluginCharges;
  final String? opshippingCode;
  final String? opshippingRateId;
  final String? opshippingBySellerUserId;
  final String? opshippingLevel;
  final String? opshippingLabel;
  final String? opshippingCarrierCode;
  final String? opshippingServiceCode;
  final String? opshippingPickupAddrId;
  final String? opshippingDate;
  final String? opshippingTimeSlotFrom;
  final String? opshippingTimeSlotTo;
  final String? opshippingIsManual;
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
  final String? stateId;
  final String? stateCode;
  final String? stateCountryId;
  final String? stateIdentifier;
  final String? stateActive;
  final String? stateUpdatedOn;
  final String? statelangStateId;
  final String? statelangLangId;
  final String? stateName;
  final String? countryId;
  final String? countryCode;
  final String? countryCodeAlpha3;
  final String? countryDialCode;
  final String? countryActive;
  final String? countryZoneId;
  final String? countryCurrencyId;
  final String? countryLanguageId;
  final String? countryUpdatedOn;
  final String? countrylangCountryId;
  final String? countrylangLangId;
  final String? countryName;
  final String? opsOpId;
  final String? opSelprodReturnAge;
  final String? opSelprodCancellationAge;
  final String? opSelprodExchangeAge;
  final String? opProductWarranty;
  final String? opProductWarrantyUnit;
  final String? opProdcatId;
  final String? opSpecialPrice;
  final String? opHarmonizedTariffCode;
  final String? oerequestId;
  final String? oerequestUserId;
  final String? oerequestReference;
  final String? oerequestOpId;
  final String? oerequestQty;
  final String? oerequestReturnreasonId;
  final String? oerequestDate;
  final String? oerequestStatus;
  final String? oerequestAdminComment;
  final String? orrequestId;
  final String? orrequestUserId;
  final String? orrequestReference;
  final String? orrequestOpId;
  final String? orrequestQty;
  final String? orrequestReturnreasonId;
  final String? orrequestType;
  final String? orrequestDate;
  final String? orrequestStatus;
  final String? orrequestPaymentGatewayReqId;
  final String? orrequestRefundInWallet;
  final String? orrequestAdminComment;
  final String? orrequestPickingId;
  final String? ocrequestId;
  final String? ocrequestUserId;
  final String? ocrequestOpId;
  final String? ocrequestOcreasonId;
  final String? ocrequestMessage;
  final String? ocrequestDate;
  final String? ocrequestStatus;
  final String? ocrequestPaymentGatewayReqId;
  final String? ocrequestRefundInWallet;
  final String? ocrequestAdminComment;
  final String? returnRequest;
  final String? cancelRequest;
  final String? exchangeRequest;
  final Charges? charges;
  final TaxOptions? taxOptions;
  final String? orderstatusColorCode;
  final String? prodRating;
  final String? reviewsAllowed;
  final String? productImageUrl;
  final String? canCancelOrder;
  final String? canReturnOrder;
  final String? canExchangeOrder;
  final String? canSubmitFeedback;
  final List<OrderSummary>? priceDetail;
  final OrderSummary? totalAmount;

  ChildOrderDetail({
    this.opId,
    this.opOrderId,
    this.opInvoiceNumber,
    this.opSelprodId,
    this.opIsBatch,
    this.opSelprodUserId,
    this.opSelprodCode,
    this.opBatchSelprodId,
    this.opQty,
    this.opSelprodPrice,
    this.opUnitPrice,
    this.opUnitCost,
    this.opSelprodSku,
    this.opCommissionCharged,
    this.opCommissionPercentage,
    this.opAffiliateCommissionCharged,
    this.opAffiliateCommissionPercentage,
    this.opSelprodCondition,
    this.opSelprodFulfillmentFrom,
    this.opProductModel,
    this.opProductType,
    this.opProductLength,
    this.opProductWidth,
    this.opProductHeight,
    this.opProductDimensionUnit,
    this.opProductWeight,
    this.opProductWeightUnit,
    this.opShopId,
    this.opShopOwnerName,
    this.opShopOwnerUsername,
    this.opShopOwnerEmail,
    this.opShopOwnerPhoneDcode,
    this.opShopOwnerPhone,
    this.opSdurationId,
    this.opStatusId,
    this.opRefundQty,
    this.opRefundAmount,
    this.opRefundCommission,
    this.opRefundShipping,
    this.opRefundTax,
    this.opRefundAffiliateCommission,
    this.opShippedDate,
    this.opCompletionDate,
    this.opSentReviewReminder,
    this.opReviewReminderCount,
    this.opSentLastReminder,
    this.opSelprodMaxDownloadTimes,
    this.opSelprodDownloadValidityInDays,
    this.opFreeShipUpto,
    this.opActualShippingCharges,
    this.opTaxCode,
    this.opRoundingOff,
    this.opComments,
    this.opIsGroupDelivery,
    this.opPickingId,
    this.opProductIdentifier,
    this.opBrandIdentifier,
    this.opWarehouseId,
    this.opShippingCode,
    this.oplangOpId,
    this.oplangLangId,
    this.opProductName,
    this.opSelprodTitle,
    this.opSelprodOptions,
    this.opBrandName,
    this.opShopName,
    this.opShippingDurationName,
    this.opShippingDurations,
    this.opProductsDimensionUnitName,
    this.opProductWeightUnitName,
    this.opProductTaxOptions,
    this.orderId,
    this.orderNumber,
    this.orderType,
    this.orderUserId,
    this.orderPaymentStatus,
    this.orderStatus,
    this.orderNetAmount,
    this.orderIsWalletSelected,
    this.orderWalletAmountCharge,
    this.orderTaxCharged,
    this.orderSiteCommission,
    this.orderDiscountCouponCode,
    this.orderDiscountType,
    this.orderDiscountValue,
    this.orderDiscountTotal,
    this.orderDiscountInfo,
    this.orderVolumeDiscountTotal,
    this.orderRewardPointUsed,
    this.orderRewardPointValue,
    this.orderUserComments,
    this.orderAdminComments,
    this.orderLanguageId,
    this.orderLanguageCode,
    this.orderCurrencyId,
    this.orderCurrencyCode,
    this.orderCurrencyValue,
    this.orderShippingapiId,
    this.orderShippingapiCode,
    this.orderPmethodId,
    this.orderDateAdded,
    this.orderDateConfirmed,
    this.orderDateUpdated,
    this.orderReferrerUserId,
    this.orderReferrerRewardPoints,
    this.orderReferralRewardPoints,
    this.orderAffiliateUserId,
    this.orderAffiliateTotalCommission,
    this.orderCartData,
    this.orderRenew,
    this.orderDeleted,
    this.orderRoundingOff,
    this.orderIsFreeShipping,
    this.orderOriginalShippingCharged,
    this.orderPurchasedRewardCredit,
    this.orderPickingId,
    this.orderstatusId,
    this.orderstatusIdentifier,
    this.orderstatusColorClass,
    this.orderstatusType,
    this.orderstatusPriority,
    this.orderstatusIsActive,
    this.orderstatusIsDigital,
    this.orderstatuslangOrderstatusId,
    this.orderstatuslangLangId,
    this.orderstatusName,
    this.opsettingOpId,
    this.opCommissionIncludeTax,
    this.opCommissionIncludeShipping,
    this.opTaxCollectedBySeller,
    this.opTaxAfterDiscount,
    this.opProductInclusiveTax,
    this.opshipOpId,
    this.opshipOrderid,
    this.opshipOrderNumber,
    this.opshipShipmentId,
    this.opshipTrackingNumber,
    this.opshipTrackingUrl,
    this.opshipTrackingCourierCode,
    this.opshipTrackingPluginId,
    this.oprOpId,
    this.oprType,
    this.oprResponse,
    this.oprAddedOn,
    this.pluginId,
    this.pluginIdentifier,
    this.pluginType,
    this.pluginCode,
    this.pluginActive,
    this.pluginDisplayOrder,
    this.pluginlangPluginId,
    this.pluginlangLangId,
    this.pluginName,
    this.pluginDescription,
    this.selprodId,
    this.selprodUserId,
    this.selprodProductId,
    this.selprodCode,
    this.selprodPrice,
    this.selprodCost,
    this.selprodStock,
    this.selprodMinOrderQty,
    this.selprodSubtractStock,
    this.selprodTrackInventory,
    this.selprodThresholdStockLevel,
    this.selprodSku,
    this.selprodCondition,
    this.selprodFulfillmentFrom,
    this.selprodExpiryDate,
    this.selprodAddedOn,
    this.selprodUpdatedOn,
    this.selprodAvailableFrom,
    this.selprodActive,
    this.selprodCodEnabled,
    this.selprodFulfillmentType,
    this.selprodSoldCount,
    this.selprodUrlKeyword,
    this.selprodMaxDownloadTimes,
    this.selprodDownloadValidityInDays,
    this.selprodUrlrewriteId,
    this.selprodOdooId,
    this.selprodDeleted,
    this.selprodlangSelprodId,
    this.selprodlangLangId,
    this.selprodTitle,
    this.selprodFeatures,
    this.selprodWarranty,
    this.selprodReturnPolicy,
    this.selprodComments,
    this.userId,
    this.userName,
    this.userPhoneDcode,
    this.userPhone,
    this.userDob,
    this.userProfileInfo,
    this.userAddress1,
    this.userAddress2,
    this.userZip,
    this.userCountryId,
    this.userStateId,
    this.userCity,
    this.userIsBuyer,
    this.userIsSupplier,
    this.userParent,
    this.userIsAdvertiser,
    this.userIsAffiliate,
    this.userIsShippingCompany,
    this.userAutorenewSubscription,
    this.userFbAccessToken,
    this.userReferralCode,
    this.userReferrerUserId,
    this.userAffiliateReferrerUserId,
    this.userPreferredDashboard,
    this.userRegdate,
    this.userCompany,
    this.userProductsServices,
    this.userAffiliateCommission,
    this.userRegisteredInitiallyFor,
    this.userOrderTrackingUrl,
    this.userHasValidSubscription,
    this.userIsInfluencer,
    this.userUpdatedOn,
    this.userDeleted,
    this.userOddoId,
    this.credentialUserId,
    this.credentialUsername,
    this.credentialEmail,
    this.credentialPasswordOld,
    this.credentialPassword,
    this.credentialActive,
    this.credentialVerified,
    this.opchargeOpId,
    this.opOtherCharges,
    this.opshippingOpId,
    this.opshippingFulfillmentType,
    this.opshippingPluginId,
    this.opshippingIsSellerPlugin,
    this.opshippingPluginCharges,
    this.opshippingCode,
    this.opshippingRateId,
    this.opshippingBySellerUserId,
    this.opshippingLevel,
    this.opshippingLabel,
    this.opshippingCarrierCode,
    this.opshippingServiceCode,
    this.opshippingPickupAddrId,
    this.opshippingDate,
    this.opshippingTimeSlotFrom,
    this.opshippingTimeSlotTo,
    this.opshippingIsManual,
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
    this.stateId,
    this.stateCode,
    this.stateCountryId,
    this.stateIdentifier,
    this.stateActive,
    this.stateUpdatedOn,
    this.statelangStateId,
    this.statelangLangId,
    this.stateName,
    this.countryId,
    this.countryCode,
    this.countryCodeAlpha3,
    this.countryDialCode,
    this.countryActive,
    this.countryZoneId,
    this.countryCurrencyId,
    this.countryLanguageId,
    this.countryUpdatedOn,
    this.countrylangCountryId,
    this.countrylangLangId,
    this.countryName,
    this.opsOpId,
    this.opSelprodReturnAge,
    this.opSelprodCancellationAge,
    this.opSelprodExchangeAge,
    this.opProductWarranty,
    this.opProductWarrantyUnit,
    this.opProdcatId,
    this.opSpecialPrice,
    this.opHarmonizedTariffCode,
    this.oerequestId,
    this.oerequestUserId,
    this.oerequestReference,
    this.oerequestOpId,
    this.oerequestQty,
    this.oerequestReturnreasonId,
    this.oerequestDate,
    this.oerequestStatus,
    this.oerequestAdminComment,
    this.orrequestId,
    this.orrequestUserId,
    this.orrequestReference,
    this.orrequestOpId,
    this.orrequestQty,
    this.orrequestReturnreasonId,
    this.orrequestType,
    this.orrequestDate,
    this.orrequestStatus,
    this.orrequestPaymentGatewayReqId,
    this.orrequestRefundInWallet,
    this.orrequestAdminComment,
    this.orrequestPickingId,
    this.ocrequestId,
    this.ocrequestUserId,
    this.ocrequestOpId,
    this.ocrequestOcreasonId,
    this.ocrequestMessage,
    this.ocrequestDate,
    this.ocrequestStatus,
    this.ocrequestPaymentGatewayReqId,
    this.ocrequestRefundInWallet,
    this.ocrequestAdminComment,
    this.returnRequest,
    this.cancelRequest,
    this.exchangeRequest,
    this.charges,
    this.taxOptions,
    this.orderstatusColorCode,
    this.prodRating,
    this.reviewsAllowed,
    this.productImageUrl,
    this.canCancelOrder,
    this.canReturnOrder,
    this.canExchangeOrder,
    this.canSubmitFeedback,
    this.priceDetail,
    this.totalAmount,
  });

  factory ChildOrderDetail.fromJson(Map<String, dynamic> json) => ChildOrderDetail(
    opId: json["op_id"],
    opOrderId: json["op_order_id"],
    opInvoiceNumber: json["op_invoice_number"],
    opSelprodId: json["op_selprod_id"],
    opIsBatch: json["op_is_batch"],
    opSelprodUserId: json["op_selprod_user_id"],
    opSelprodCode: json["op_selprod_code"],
    opBatchSelprodId: json["op_batch_selprod_id"],
    opQty: json["op_qty"],
    opSelprodPrice: json["op_selprod_price"],
    opUnitPrice: json["op_unit_price"],
    opUnitCost: json["op_unit_cost"],
    opSelprodSku: json["op_selprod_sku"],
    opCommissionCharged: json["op_commission_charged"],
    opCommissionPercentage: json["op_commission_percentage"],
    opAffiliateCommissionCharged: json["op_affiliate_commission_charged"],
    opAffiliateCommissionPercentage: json["op_affiliate_commission_percentage"],
    opSelprodCondition: json["op_selprod_condition"],
    opSelprodFulfillmentFrom: json["op_selprod_fulfillment_from"],
    opProductModel: json["op_product_model"],
    opProductType: json["op_product_type"],
    opProductLength: json["op_product_length"],
    opProductWidth: json["op_product_width"],
    opProductHeight: json["op_product_height"],
    opProductDimensionUnit: json["op_product_dimension_unit"],
    opProductWeight: json["op_product_weight"],
    opProductWeightUnit: json["op_product_weight_unit"],
    opShopId: json["op_shop_id"],
    opShopOwnerName: json["op_shop_owner_name"],
    opShopOwnerUsername: json["op_shop_owner_username"],
    opShopOwnerEmail: json["op_shop_owner_email"],
    opShopOwnerPhoneDcode: json["op_shop_owner_phone_dcode"],
    opShopOwnerPhone: json["op_shop_owner_phone"],
    opSdurationId: json["op_sduration_id"],
    opStatusId: json["op_status_id"],
    opRefundQty: json["op_refund_qty"],
    opRefundAmount: json["op_refund_amount"],
    opRefundCommission: json["op_refund_commission"],
    opRefundShipping: json["op_refund_shipping"],
    opRefundTax: json["op_refund_tax"],
    opRefundAffiliateCommission: json["op_refund_affiliate_commission"],
    opShippedDate: json["op_shipped_date"],
    opCompletionDate: json["op_completion_date"],
    opSentReviewReminder: json["op_sent_review_reminder"],
    opReviewReminderCount: json["op_review_reminder_count"],
    opSentLastReminder: json["op_sent_last_reminder"],
    opSelprodMaxDownloadTimes: json["op_selprod_max_download_times"],
    opSelprodDownloadValidityInDays: json["op_selprod_download_validity_in_days"],
    opFreeShipUpto: json["op_free_ship_upto"],
    opActualShippingCharges: json["op_actual_shipping_charges"],
    opTaxCode: json["op_tax_code"],
    opRoundingOff: json["op_rounding_off"],
    opComments: json["op_comments"],
    opIsGroupDelivery: json["op_is_group_delivery"],
    opPickingId: json["op_picking_id"],
    opProductIdentifier: json["op_product_identifier"],
    opBrandIdentifier: json["op_brand_identifier"],
    opWarehouseId: json["op_warehouse_id"],
    opShippingCode: json["op_shipping_code"],
    oplangOpId: json["oplang_op_id"],
    oplangLangId: json["oplang_lang_id"],
    opProductName: json["op_product_name"],
    opSelprodTitle: json["op_selprod_title"],
    opSelprodOptions: json["op_selprod_options"],
    opBrandName: json["op_brand_name"],
    opShopName: json["op_shop_name"],
    opShippingDurationName: json["op_shipping_duration_name"],
    opShippingDurations: json["op_shipping_durations"],
    opProductsDimensionUnitName: json["op_products_dimension_unit_name"],
    opProductWeightUnitName: json["op_product_weight_unit_name"],
    opProductTaxOptions: json["op_product_tax_options"],
    orderId: json["order_id"],
    orderNumber: json["order_number"],
    orderType: json["order_type"],
    orderUserId: json["order_user_id"],
    orderPaymentStatus: json["order_payment_status"],
    orderStatus: json["order_status"],
    orderNetAmount: json["order_net_amount"],
    orderIsWalletSelected: json["order_is_wallet_selected"],
    orderWalletAmountCharge: json["order_wallet_amount_charge"],
    orderTaxCharged: json["order_tax_charged"],
    orderSiteCommission: json["order_site_commission"],
    orderDiscountCouponCode: json["order_discount_coupon_code"],
    orderDiscountType: json["order_discount_type"],
    orderDiscountValue: json["order_discount_value"],
    orderDiscountTotal: json["order_discount_total"],
    orderDiscountInfo: json["order_discount_info"],
    orderVolumeDiscountTotal: json["order_volume_discount_total"],
    orderRewardPointUsed: json["order_reward_point_used"],
    orderRewardPointValue: json["order_reward_point_value"],
    orderUserComments: json["order_user_comments"],
    orderAdminComments: json["order_admin_comments"],
    orderLanguageId: json["order_language_id"],
    orderLanguageCode: json["order_language_code"],
    orderCurrencyId: json["order_currency_id"],
    orderCurrencyCode: json["order_currency_code"],
    orderCurrencyValue: json["order_currency_value"],
    orderShippingapiId: json["order_shippingapi_id"],
    orderShippingapiCode: json["order_shippingapi_code"],
    orderPmethodId: json["order_pmethod_id"],
    orderDateAdded: json["order_date_added"] == null ? null : DateTime.parse(json["order_date_added"]),
    orderDateConfirmed: json["order_date_confirmed"] == null ? null : DateTime.parse(json["order_date_confirmed"]),
    orderDateUpdated: json["order_date_updated"] == null ? null : DateTime.parse(json["order_date_updated"]),
    orderReferrerUserId: json["order_referrer_user_id"],
    orderReferrerRewardPoints: json["order_referrer_reward_points"],
    orderReferralRewardPoints: json["order_referral_reward_points"],
    orderAffiliateUserId: json["order_affiliate_user_id"],
    orderAffiliateTotalCommission: json["order_affiliate_total_commission"],
    orderCartData: json["order_cart_data"],
    orderRenew: json["order_renew"],
    orderDeleted: json["order_deleted"],
    orderRoundingOff: json["order_rounding_off"],
    orderIsFreeShipping: json["order_is_free_shipping"],
    orderOriginalShippingCharged: json["order_original_shipping_charged"],
    orderPurchasedRewardCredit: json["order_purchased_reward_credit"],
    orderPickingId: json["order_picking_id"],
    orderstatusId: json["orderstatus_id"],
    orderstatusIdentifier: json["orderstatus_identifier"],
    orderstatusColorClass: json["orderstatus_color_class"],
    orderstatusType: json["orderstatus_type"],
    orderstatusPriority: json["orderstatus_priority"],
    orderstatusIsActive: json["orderstatus_is_active"],
    orderstatusIsDigital: json["orderstatus_is_digital"],
    orderstatuslangOrderstatusId: json["orderstatuslang_orderstatus_id"],
    orderstatuslangLangId: json["orderstatuslang_lang_id"],
    orderstatusName: json["orderstatus_name"],
    opsettingOpId: json["opsetting_op_id"],
    opCommissionIncludeTax: json["op_commission_include_tax"],
    opCommissionIncludeShipping: json["op_commission_include_shipping"],
    opTaxCollectedBySeller: json["op_tax_collected_by_seller"],
    opTaxAfterDiscount: json["op_tax_after_discount"],
    opProductInclusiveTax: json["op_product_inclusive_tax"],
    opshipOpId: json["opship_op_id"],
    opshipOrderid: json["opship_orderid"],
    opshipOrderNumber: json["opship_order_number"],
    opshipShipmentId: json["opship_shipment_id"],
    opshipTrackingNumber: json["opship_tracking_number"],
    opshipTrackingUrl: json["opship_tracking_url"],
    opshipTrackingCourierCode: json["opship_tracking_courier_code"],
    opshipTrackingPluginId: json["opship_tracking_plugin_id"],
    oprOpId: json["opr_op_id"],
    oprType: json["opr_type"],
    oprResponse: json["opr_response"],
    oprAddedOn: json["opr_added_on"],
    pluginId: json["plugin_id"],
    pluginIdentifier: json["plugin_identifier"],
    pluginType: json["plugin_type"],
    pluginCode: json["plugin_code"],
    pluginActive: json["plugin_active"],
    pluginDisplayOrder: json["plugin_display_order"],
    pluginlangPluginId: json["pluginlang_plugin_id"],
    pluginlangLangId: json["pluginlang_lang_id"],
    pluginName: json["plugin_name"],
    pluginDescription: json["plugin_description"],
    selprodId: json["selprod_id"],
    selprodUserId: json["selprod_user_id"],
    selprodProductId: json["selprod_product_id"],
    selprodCode: json["selprod_code"],
    selprodPrice: json["selprod_price"],
    selprodCost: json["selprod_cost"],
    selprodStock: json["selprod_stock"],
    selprodMinOrderQty: json["selprod_min_order_qty"],
    selprodSubtractStock: json["selprod_subtract_stock"],
    selprodTrackInventory: json["selprod_track_inventory"],
    selprodThresholdStockLevel: json["selprod_threshold_stock_level"],
    selprodSku: json["selprod_sku"],
    selprodCondition: json["selprod_condition"],
    selprodFulfillmentFrom: json["selprod_fulfillment_from"],
    selprodExpiryDate: json["selprod_expiry_date"],
    selprodAddedOn: json["selprod_added_on"] == null ? null : DateTime.parse(json["selprod_added_on"]),
    selprodUpdatedOn: json["selprod_updated_on"] == null ? null : DateTime.parse(json["selprod_updated_on"]),
    selprodAvailableFrom: json["selprod_available_from"] == null ? null : DateTime.parse(json["selprod_available_from"]),
    selprodActive: json["selprod_active"],
    selprodCodEnabled: json["selprod_cod_enabled"],
    selprodFulfillmentType: json["selprod_fulfillment_type"],
    selprodSoldCount: json["selprod_sold_count"],
    selprodUrlKeyword: json["selprod_url_keyword"],
    selprodMaxDownloadTimes: json["selprod_max_download_times"],
    selprodDownloadValidityInDays: json["selprod_download_validity_in_days"],
    selprodUrlrewriteId: json["selprod_urlrewrite_id"],
    selprodOdooId: json["selprod_odoo_id"],
    selprodDeleted: json["selprod_deleted"],
    selprodlangSelprodId: json["selprodlang_selprod_id"],
    selprodlangLangId: json["selprodlang_lang_id"],
    selprodTitle: json["selprod_title"],
    selprodFeatures: json["selprod_features"],
    selprodWarranty: json["selprod_warranty"],
    selprodReturnPolicy: json["selprod_return_policy"],
    selprodComments: json["selprod_comments"],
    userId: json["user_id"],
    userName: json["user_name"],
    userPhoneDcode: json["user_phone_dcode"],
    userPhone: json["user_phone"],
    userDob: json["user_dob"] == null ? null : DateTime.parse(json["user_dob"]),
    userProfileInfo: json["user_profile_info"],
    userAddress1: json["user_address1"],
    userAddress2: json["user_address2"],
    userZip: json["user_zip"],
    userCountryId: json["user_country_id"],
    userStateId: json["user_state_id"],
    userCity: json["user_city"],
    userIsBuyer: json["user_is_buyer"],
    userIsSupplier: json["user_is_supplier"],
    userParent: json["user_parent"],
    userIsAdvertiser: json["user_is_advertiser"],
    userIsAffiliate: json["user_is_affiliate"],
    userIsShippingCompany: json["user_is_shipping_company"],
    userAutorenewSubscription: json["user_autorenew_subscription"],
    userFbAccessToken: json["user_fb_access_token"],
    userReferralCode: json["user_referral_code"],
    userReferrerUserId: json["user_referrer_user_id"],
    userAffiliateReferrerUserId: json["user_affiliate_referrer_user_id"],
    userPreferredDashboard: json["user_preferred_dashboard"],
    userRegdate: json["user_regdate"] == null ? null : DateTime.parse(json["user_regdate"]),
    userCompany: json["user_company"],
    userProductsServices: json["user_products_services"],
    userAffiliateCommission: json["user_affiliate_commission"],
    userRegisteredInitiallyFor: json["user_registered_initially_for"],
    userOrderTrackingUrl: json["user_order_tracking_url"],
    userHasValidSubscription: json["user_has_valid_subscription"],
    userIsInfluencer: json["user_is_influencer"],
    userUpdatedOn: json["user_updated_on"] == null ? null : DateTime.parse(json["user_updated_on"]),
    userDeleted: json["user_deleted"],
    userOddoId: json["user_oddo_id"],
    credentialUserId: json["credential_user_id"],
    credentialUsername: json["credential_username"],
    credentialEmail: json["credential_email"],
    credentialPasswordOld: json["credential_password_old"],
    credentialPassword: json["credential_password"],
    credentialActive: json["credential_active"],
    credentialVerified: json["credential_verified"],
    opchargeOpId: json["opcharge_op_id"],
    opOtherCharges: json["op_other_charges"],
    opshippingOpId: json["opshipping_op_id"],
    opshippingFulfillmentType: json["opshipping_fulfillment_type"],
    opshippingPluginId: json["opshipping_plugin_id"],
    opshippingIsSellerPlugin: json["opshipping_is_seller_plugin"],
    opshippingPluginCharges: json["opshipping_plugin_charges"],
    opshippingCode: json["opshipping_code"],
    opshippingRateId: json["opshipping_rate_id"],
    opshippingBySellerUserId: json["opshipping_by_seller_user_id"],
    opshippingLevel: json["opshipping_level"],
    opshippingLabel: json["opshipping_label"],
    opshippingCarrierCode: json["opshipping_carrier_code"],
    opshippingServiceCode: json["opshipping_service_code"],
    opshippingPickupAddrId: json["opshipping_pickup_addr_id"],
    opshippingDate: json["opshipping_date"],
    opshippingTimeSlotFrom: json["opshipping_time_slot_from"],
    opshippingTimeSlotTo: json["opshipping_time_slot_to"],
    opshippingIsManual: json["opshipping_is_manual"],
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
    addrUpdatedOn: json["addr_updated_on"],
    stateId: json["state_id"],
    stateCode: json["state_code"],
    stateCountryId: json["state_country_id"],
    stateIdentifier: json["state_identifier"],
    stateActive: json["state_active"],
    stateUpdatedOn: json["state_updated_on"],
    statelangStateId: json["statelang_state_id"],
    statelangLangId: json["statelang_lang_id"],
    stateName: json["state_name"],
    countryId: json["country_id"],
    countryCode: json["country_code"],
    countryCodeAlpha3: json["country_code_alpha3"],
    countryDialCode: json["country_dial_code"],
    countryActive: json["country_active"],
    countryZoneId: json["country_zone_id"],
    countryCurrencyId: json["country_currency_id"],
    countryLanguageId: json["country_language_id"],
    countryUpdatedOn: json["country_updated_on"],
    countrylangCountryId: json["countrylang_country_id"],
    countrylangLangId: json["countrylang_lang_id"],
    countryName: json["country_name"],
    opsOpId: json["ops_op_id"],
    opSelprodReturnAge: json["op_selprod_return_age"],
    opSelprodCancellationAge: json["op_selprod_cancellation_age"],
    opSelprodExchangeAge: json["op_selprod_exchange_age"],
    opProductWarranty: json["op_product_warranty"],
    opProductWarrantyUnit: json["op_product_warranty_unit"],
    opProdcatId: json["op_prodcat_id"],
    opSpecialPrice: json["op_special_price"],
    opHarmonizedTariffCode: json["op_harmonized_tariff_code"],
    oerequestId: json["oerequest_id"],
    oerequestUserId: json["oerequest_user_id"],
    oerequestReference: json["oerequest_reference"],
    oerequestOpId: json["oerequest_op_id"],
    oerequestQty: json["oerequest_qty"],
    oerequestReturnreasonId: json["oerequest_returnreason_id"],
    oerequestDate: json["oerequest_date"],
    oerequestStatus: json["oerequest_status"],
    oerequestAdminComment: json["oerequest_admin_comment"],
    orrequestId: json["orrequest_id"],
    orrequestUserId: json["orrequest_user_id"],
    orrequestReference: json["orrequest_reference"],
    orrequestOpId: json["orrequest_op_id"],
    orrequestQty: json["orrequest_qty"],
    orrequestReturnreasonId: json["orrequest_returnreason_id"],
    orrequestType: json["orrequest_type"],
    orrequestDate: json["orrequest_date"],
    orrequestStatus: json["orrequest_status"],
    orrequestPaymentGatewayReqId: json["orrequest_payment_gateway_req_id"],
    orrequestRefundInWallet: json["orrequest_refund_in_wallet"],
    orrequestAdminComment: json["orrequest_admin_comment"],
    orrequestPickingId: json["orrequest_picking_id"],
    ocrequestId: json["ocrequest_id"],
    ocrequestUserId: json["ocrequest_user_id"],
    ocrequestOpId: json["ocrequest_op_id"],
    ocrequestOcreasonId: json["ocrequest_ocreason_id"],
    ocrequestMessage: json["ocrequest_message"],
    ocrequestDate: json["ocrequest_date"],
    ocrequestStatus: json["ocrequest_status"],
    ocrequestPaymentGatewayReqId: json["ocrequest_payment_gateway_req_id"],
    ocrequestRefundInWallet: json["ocrequest_refund_in_wallet"],
    ocrequestAdminComment: json["ocrequest_admin_comment"],
    returnRequest: json["return_request"],
    cancelRequest: json["cancel_request"],
    exchangeRequest: json["exchange_request"],
    charges: json["charges"] == null ? null : Charges.fromJson(json["charges"]),
    taxOptions: json["taxOptions"] == null ? null : TaxOptions.fromJson(json["taxOptions"]),
    orderstatusColorCode: json["orderstatus_color_code"],
    prodRating: json["prod_rating"],
    reviewsAllowed: json["reviewsAllowed"],
    productImageUrl: json["product_image_url"],
    canCancelOrder: json["canCancelOrder"],
    canReturnOrder: json["canReturnOrder"],
    canExchangeOrder: json["canExchangeOrder"],
    canSubmitFeedback: json["canSubmitFeedback"],
    priceDetail: json["priceDetail"] == null ? [] : List<OrderSummary>.from(json["priceDetail"]!.map((x) => OrderSummary.fromJson(x))),
    totalAmount: json["totalAmount"] == null ? null : OrderSummary.fromJson(json["totalAmount"]),
  );

  Map<String, dynamic> toJson() => {
    "op_id": opId,
    "op_order_id": opOrderId,
    "op_invoice_number": opInvoiceNumber,
    "op_selprod_id": opSelprodId,
    "op_is_batch": opIsBatch,
    "op_selprod_user_id": opSelprodUserId,
    "op_selprod_code": opSelprodCode,
    "op_batch_selprod_id": opBatchSelprodId,
    "op_qty": opQty,
    "op_selprod_price": opSelprodPrice,
    "op_unit_price": opUnitPrice,
    "op_unit_cost": opUnitCost,
    "op_selprod_sku": opSelprodSku,
    "op_commission_charged": opCommissionCharged,
    "op_commission_percentage": opCommissionPercentage,
    "op_affiliate_commission_charged": opAffiliateCommissionCharged,
    "op_affiliate_commission_percentage": opAffiliateCommissionPercentage,
    "op_selprod_condition": opSelprodCondition,
    "op_selprod_fulfillment_from": opSelprodFulfillmentFrom,
    "op_product_model": opProductModel,
    "op_product_type": opProductType,
    "op_product_length": opProductLength,
    "op_product_width": opProductWidth,
    "op_product_height": opProductHeight,
    "op_product_dimension_unit": opProductDimensionUnit,
    "op_product_weight": opProductWeight,
    "op_product_weight_unit": opProductWeightUnit,
    "op_shop_id": opShopId,
    "op_shop_owner_name": opShopOwnerName,
    "op_shop_owner_username": opShopOwnerUsername,
    "op_shop_owner_email": opShopOwnerEmail,
    "op_shop_owner_phone_dcode": opShopOwnerPhoneDcode,
    "op_shop_owner_phone": opShopOwnerPhone,
    "op_sduration_id": opSdurationId,
    "op_status_id": opStatusId,
    "op_refund_qty": opRefundQty,
    "op_refund_amount": opRefundAmount,
    "op_refund_commission": opRefundCommission,
    "op_refund_shipping": opRefundShipping,
    "op_refund_tax": opRefundTax,
    "op_refund_affiliate_commission": opRefundAffiliateCommission,
    "op_shipped_date": opShippedDate,
    "op_completion_date": opCompletionDate,
    "op_sent_review_reminder": opSentReviewReminder,
    "op_review_reminder_count": opReviewReminderCount,
    "op_sent_last_reminder": opSentLastReminder,
    "op_selprod_max_download_times": opSelprodMaxDownloadTimes,
    "op_selprod_download_validity_in_days": opSelprodDownloadValidityInDays,
    "op_free_ship_upto": opFreeShipUpto,
    "op_actual_shipping_charges": opActualShippingCharges,
    "op_tax_code": opTaxCode,
    "op_rounding_off": opRoundingOff,
    "op_comments": opComments,
    "op_is_group_delivery": opIsGroupDelivery,
    "op_picking_id": opPickingId,
    "op_product_identifier": opProductIdentifier,
    "op_brand_identifier": opBrandIdentifier,
    "op_warehouse_id": opWarehouseId,
    "op_shipping_code": opShippingCode,
    "oplang_op_id": oplangOpId,
    "oplang_lang_id": oplangLangId,
    "op_product_name": opProductName,
    "op_selprod_title": opSelprodTitle,
    "op_selprod_options": opSelprodOptions,
    "op_brand_name": opBrandName,
    "op_shop_name": opShopName,
    "op_shipping_duration_name": opShippingDurationName,
    "op_shipping_durations": opShippingDurations,
    "op_products_dimension_unit_name": opProductsDimensionUnitName,
    "op_product_weight_unit_name": opProductWeightUnitName,
    "op_product_tax_options": opProductTaxOptions,
    "order_id": orderId,
    "order_number": orderNumber,
    "order_type": orderType,
    "order_user_id": orderUserId,
    "order_payment_status": orderPaymentStatus,
    "order_status": orderStatus,
    "order_net_amount": orderNetAmount,
    "order_is_wallet_selected": orderIsWalletSelected,
    "order_wallet_amount_charge": orderWalletAmountCharge,
    "order_tax_charged": orderTaxCharged,
    "order_site_commission": orderSiteCommission,
    "order_discount_coupon_code": orderDiscountCouponCode,
    "order_discount_type": orderDiscountType,
    "order_discount_value": orderDiscountValue,
    "order_discount_total": orderDiscountTotal,
    "order_discount_info": orderDiscountInfo,
    "order_volume_discount_total": orderVolumeDiscountTotal,
    "order_reward_point_used": orderRewardPointUsed,
    "order_reward_point_value": orderRewardPointValue,
    "order_user_comments": orderUserComments,
    "order_admin_comments": orderAdminComments,
    "order_language_id": orderLanguageId,
    "order_language_code": orderLanguageCode,
    "order_currency_id": orderCurrencyId,
    "order_currency_code": orderCurrencyCode,
    "order_currency_value": orderCurrencyValue,
    "order_shippingapi_id": orderShippingapiId,
    "order_shippingapi_code": orderShippingapiCode,
    "order_pmethod_id": orderPmethodId,
    "order_date_added": orderDateAdded?.toIso8601String(),
    "order_date_confirmed": orderDateConfirmed?.toIso8601String(),
    "order_date_updated": orderDateUpdated?.toIso8601String(),
    "order_referrer_user_id": orderReferrerUserId,
    "order_referrer_reward_points": orderReferrerRewardPoints,
    "order_referral_reward_points": orderReferralRewardPoints,
    "order_affiliate_user_id": orderAffiliateUserId,
    "order_affiliate_total_commission": orderAffiliateTotalCommission,
    "order_cart_data": orderCartData,
    "order_renew": orderRenew,
    "order_deleted": orderDeleted,
    "order_rounding_off": orderRoundingOff,
    "order_is_free_shipping": orderIsFreeShipping,
    "order_original_shipping_charged": orderOriginalShippingCharged,
    "order_purchased_reward_credit": orderPurchasedRewardCredit,
    "order_picking_id": orderPickingId,
    "orderstatus_id": orderstatusId,
    "orderstatus_identifier": orderstatusIdentifier,
    "orderstatus_color_class": orderstatusColorClass,
    "orderstatus_type": orderstatusType,
    "orderstatus_priority": orderstatusPriority,
    "orderstatus_is_active": orderstatusIsActive,
    "orderstatus_is_digital": orderstatusIsDigital,
    "orderstatuslang_orderstatus_id": orderstatuslangOrderstatusId,
    "orderstatuslang_lang_id": orderstatuslangLangId,
    "orderstatus_name": orderstatusName,
    "opsetting_op_id": opsettingOpId,
    "op_commission_include_tax": opCommissionIncludeTax,
    "op_commission_include_shipping": opCommissionIncludeShipping,
    "op_tax_collected_by_seller": opTaxCollectedBySeller,
    "op_tax_after_discount": opTaxAfterDiscount,
    "op_product_inclusive_tax": opProductInclusiveTax,
    "opship_op_id": opshipOpId,
    "opship_orderid": opshipOrderid,
    "opship_order_number": opshipOrderNumber,
    "opship_shipment_id": opshipShipmentId,
    "opship_tracking_number": opshipTrackingNumber,
    "opship_tracking_url": opshipTrackingUrl,
    "opship_tracking_courier_code": opshipTrackingCourierCode,
    "opship_tracking_plugin_id": opshipTrackingPluginId,
    "opr_op_id": oprOpId,
    "opr_type": oprType,
    "opr_response": oprResponse,
    "opr_added_on": oprAddedOn,
    "plugin_id": pluginId,
    "plugin_identifier": pluginIdentifier,
    "plugin_type": pluginType,
    "plugin_code": pluginCode,
    "plugin_active": pluginActive,
    "plugin_display_order": pluginDisplayOrder,
    "pluginlang_plugin_id": pluginlangPluginId,
    "pluginlang_lang_id": pluginlangLangId,
    "plugin_name": pluginName,
    "plugin_description": pluginDescription,
    "selprod_id": selprodId,
    "selprod_user_id": selprodUserId,
    "selprod_product_id": selprodProductId,
    "selprod_code": selprodCode,
    "selprod_price": selprodPrice,
    "selprod_cost": selprodCost,
    "selprod_stock": selprodStock,
    "selprod_min_order_qty": selprodMinOrderQty,
    "selprod_subtract_stock": selprodSubtractStock,
    "selprod_track_inventory": selprodTrackInventory,
    "selprod_threshold_stock_level": selprodThresholdStockLevel,
    "selprod_sku": selprodSku,
    "selprod_condition": selprodCondition,
    "selprod_fulfillment_from": selprodFulfillmentFrom,
    "selprod_expiry_date": selprodExpiryDate,
    "selprod_added_on": selprodAddedOn?.toIso8601String(),
    "selprod_updated_on": selprodUpdatedOn?.toIso8601String(),
    "selprod_available_from": selprodAvailableFrom?.toIso8601String(),
    "selprod_active": selprodActive,
    "selprod_cod_enabled": selprodCodEnabled,
    "selprod_fulfillment_type": selprodFulfillmentType,
    "selprod_sold_count": selprodSoldCount,
    "selprod_url_keyword": selprodUrlKeyword,
    "selprod_max_download_times": selprodMaxDownloadTimes,
    "selprod_download_validity_in_days": selprodDownloadValidityInDays,
    "selprod_urlrewrite_id": selprodUrlrewriteId,
    "selprod_odoo_id": selprodOdooId,
    "selprod_deleted": selprodDeleted,
    "selprodlang_selprod_id": selprodlangSelprodId,
    "selprodlang_lang_id": selprodlangLangId,
    "selprod_title": selprodTitle,
    "selprod_features": selprodFeatures,
    "selprod_warranty": selprodWarranty,
    "selprod_return_policy": selprodReturnPolicy,
    "selprod_comments": selprodComments,
    "user_id": userId,
    "user_name": userName,
    "user_phone_dcode": userPhoneDcode,
    "user_phone": userPhone,
    "user_dob": "${userDob!.year.toString().padLeft(4, '0')}-${userDob!.month.toString().padLeft(2, '0')}-${userDob!.day.toString().padLeft(2, '0')}",
    "user_profile_info": userProfileInfo,
    "user_address1": userAddress1,
    "user_address2": userAddress2,
    "user_zip": userZip,
    "user_country_id": userCountryId,
    "user_state_id": userStateId,
    "user_city": userCity,
    "user_is_buyer": userIsBuyer,
    "user_is_supplier": userIsSupplier,
    "user_parent": userParent,
    "user_is_advertiser": userIsAdvertiser,
    "user_is_affiliate": userIsAffiliate,
    "user_is_shipping_company": userIsShippingCompany,
    "user_autorenew_subscription": userAutorenewSubscription,
    "user_fb_access_token": userFbAccessToken,
    "user_referral_code": userReferralCode,
    "user_referrer_user_id": userReferrerUserId,
    "user_affiliate_referrer_user_id": userAffiliateReferrerUserId,
    "user_preferred_dashboard": userPreferredDashboard,
    "user_regdate": userRegdate?.toIso8601String(),
    "user_company": userCompany,
    "user_products_services": userProductsServices,
    "user_affiliate_commission": userAffiliateCommission,
    "user_registered_initially_for": userRegisteredInitiallyFor,
    "user_order_tracking_url": userOrderTrackingUrl,
    "user_has_valid_subscription": userHasValidSubscription,
    "user_is_influencer": userIsInfluencer,
    "user_updated_on": userUpdatedOn?.toIso8601String(),
    "user_deleted": userDeleted,
    "user_oddo_id": userOddoId,
    "credential_user_id": credentialUserId,
    "credential_username": credentialUsername,
    "credential_email": credentialEmail,
    "credential_password_old": credentialPasswordOld,
    "credential_password": credentialPassword,
    "credential_active": credentialActive,
    "credential_verified": credentialVerified,
    "opcharge_op_id": opchargeOpId,
    "op_other_charges": opOtherCharges,
    "opshipping_op_id": opshippingOpId,
    "opshipping_fulfillment_type": opshippingFulfillmentType,
    "opshipping_plugin_id": opshippingPluginId,
    "opshipping_is_seller_plugin": opshippingIsSellerPlugin,
    "opshipping_plugin_charges": opshippingPluginCharges,
    "opshipping_code": opshippingCode,
    "opshipping_rate_id": opshippingRateId,
    "opshipping_by_seller_user_id": opshippingBySellerUserId,
    "opshipping_level": opshippingLevel,
    "opshipping_label": opshippingLabel,
    "opshipping_carrier_code": opshippingCarrierCode,
    "opshipping_service_code": opshippingServiceCode,
    "opshipping_pickup_addr_id": opshippingPickupAddrId,
    "opshipping_date": opshippingDate,
    "opshipping_time_slot_from": opshippingTimeSlotFrom,
    "opshipping_time_slot_to": opshippingTimeSlotTo,
    "opshipping_is_manual": opshippingIsManual,
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
    "state_id": stateId,
    "state_code": stateCode,
    "state_country_id": stateCountryId,
    "state_identifier": stateIdentifier,
    "state_active": stateActive,
    "state_updated_on": stateUpdatedOn,
    "statelang_state_id": statelangStateId,
    "statelang_lang_id": statelangLangId,
    "state_name": stateName,
    "country_id": countryId,
    "country_code": countryCode,
    "country_code_alpha3": countryCodeAlpha3,
    "country_dial_code": countryDialCode,
    "country_active": countryActive,
    "country_zone_id": countryZoneId,
    "country_currency_id": countryCurrencyId,
    "country_language_id": countryLanguageId,
    "country_updated_on": countryUpdatedOn,
    "countrylang_country_id": countrylangCountryId,
    "countrylang_lang_id": countrylangLangId,
    "country_name": countryName,
    "ops_op_id": opsOpId,
    "op_selprod_return_age": opSelprodReturnAge,
    "op_selprod_cancellation_age": opSelprodCancellationAge,
    "op_selprod_exchange_age": opSelprodExchangeAge,
    "op_product_warranty": opProductWarranty,
    "op_product_warranty_unit": opProductWarrantyUnit,
    "op_prodcat_id": opProdcatId,
    "op_special_price": opSpecialPrice,
    "op_harmonized_tariff_code": opHarmonizedTariffCode,
    "oerequest_id": oerequestId,
    "oerequest_user_id": oerequestUserId,
    "oerequest_reference": oerequestReference,
    "oerequest_op_id": oerequestOpId,
    "oerequest_qty": oerequestQty,
    "oerequest_returnreason_id": oerequestReturnreasonId,
    "oerequest_date": oerequestDate,
    "oerequest_status": oerequestStatus,
    "oerequest_admin_comment": oerequestAdminComment,
    "orrequest_id": orrequestId,
    "orrequest_user_id": orrequestUserId,
    "orrequest_reference": orrequestReference,
    "orrequest_op_id": orrequestOpId,
    "orrequest_qty": orrequestQty,
    "orrequest_returnreason_id": orrequestReturnreasonId,
    "orrequest_type": orrequestType,
    "orrequest_date": orrequestDate,
    "orrequest_status": orrequestStatus,
    "orrequest_payment_gateway_req_id": orrequestPaymentGatewayReqId,
    "orrequest_refund_in_wallet": orrequestRefundInWallet,
    "orrequest_admin_comment": orrequestAdminComment,
    "orrequest_picking_id": orrequestPickingId,
    "ocrequest_id": ocrequestId,
    "ocrequest_user_id": ocrequestUserId,
    "ocrequest_op_id": ocrequestOpId,
    "ocrequest_ocreason_id": ocrequestOcreasonId,
    "ocrequest_message": ocrequestMessage,
    "ocrequest_date": ocrequestDate,
    "ocrequest_status": ocrequestStatus,
    "ocrequest_payment_gateway_req_id": ocrequestPaymentGatewayReqId,
    "ocrequest_refund_in_wallet": ocrequestRefundInWallet,
    "ocrequest_admin_comment": ocrequestAdminComment,
    "return_request": returnRequest,
    "cancel_request": cancelRequest,
    "exchange_request": exchangeRequest,
    "charges": charges?.toJson(),
    "taxOptions": taxOptions?.toJson(),
    "orderstatus_color_code": orderstatusColorCode,
    "prod_rating": prodRating,
    "reviewsAllowed": reviewsAllowed,
    "product_image_url": productImageUrl,
    "canCancelOrder": canCancelOrder,
    "canReturnOrder": canReturnOrder,
    "canExchangeOrder": canExchangeOrder,
    "canSubmitFeedback": canSubmitFeedback,
    "priceDetail": priceDetail == null ? [] : List<dynamic>.from(priceDetail!.map((x) => x.toJson())),
    "totalAmount": totalAmount?.toJson(),
  };
}

class Charges {
  final Charge? the3;

  Charges({
    this.the3,
  });

  factory Charges.fromJson(Map<String, dynamic> json) => Charges(
    the3: json["3"] == null ? null : Charge.fromJson(json["3"]),
  );

  Map<String, dynamic> toJson() => {
    "3": the3?.toJson(),
  };
}

class Charge {
  final String? opchargeType;
  final String? opchargeAmount;

  Charge({
    this.opchargeType,
    this.opchargeAmount,
  });

  factory Charge.fromJson(Map<String, dynamic> json) => Charge(
    opchargeType: json["opcharge_type"],
    opchargeAmount: json["opcharge_amount"],
  );

  Map<String, dynamic> toJson() => {
    "opcharge_type": opchargeType,
    "opcharge_amount": opchargeAmount,
  };
}

class OrderSummary {
  final String? key;
  final String? value;

  OrderSummary({
    this.key,
    this.value,
  });

  factory OrderSummary.fromJson(Map<String, dynamic> json) => OrderSummary(
    key: json["key"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": value,
  };
}

class TaxOptions {
  final Tax? tax;

  TaxOptions({
    this.tax,
  });

  factory TaxOptions.fromJson(Map<String, dynamic> json) => TaxOptions(
    tax: json["Tax"] == null ? null : Tax.fromJson(json["Tax"]),
  );

  Map<String, dynamic> toJson() => {
    "Tax": tax?.toJson(),
  };
}

class Tax {
  final String? name;
  final String? value;
  final String? percentageValue;
  final String? inPercentage;

  Tax({
    this.name,
    this.value,
    this.percentageValue,
    this.inPercentage,
  });

  factory Tax.fromJson(Map<String, dynamic> json) => Tax(
    name: json["name"],
    value: json["value"],
    percentageValue: json["percentageValue"],
    inPercentage: json["inPercentage"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "value": value,
    "percentageValue": percentageValue,
    "inPercentage": inPercentage,
  };
}

class DigitalDownloadLinks {
  DigitalDownloadLinks();

  factory DigitalDownloadLinks.fromJson(Map<String, dynamic> json) => DigitalDownloadLinks(
  );

  Map<String, dynamic> toJson() => {
  };
}

class OrderDetail {
  final String? orderId;
  final String? orderNumber;
  final String? orderType;
  final String? orderUserId;
  final String? orderPaymentStatus;
  final String? orderStatus;
  final String? orderNetAmount;
  final String? orderIsWalletSelected;
  final String? orderWalletAmountCharge;
  final String? orderTaxCharged;
  final String? orderSiteCommission;
  final String? orderDiscountCouponCode;
  final String? orderDiscountType;
  final String? orderDiscountValue;
  final String? orderDiscountTotal;
  final String? orderDiscountInfo;
  final String? orderVolumeDiscountTotal;
  final String? orderRewardPointUsed;
  final String? orderRewardPointValue;
  final String? orderUserComments;
  final String? orderAdminComments;
  final String? orderLanguageId;
  final String? orderLanguageCode;
  final String? orderCurrencyId;
  final String? orderCurrencyCode;
  final String? orderCurrencyValue;
  final String? orderShippingapiId;
  final String? orderShippingapiCode;
  final String? orderPmethodId;
  final DateTime? orderDateAdded;
  final DateTime? orderDateConfirmed;
  final DateTime? orderDateUpdated;
  final String? orderReferrerUserId;
  final String? orderReferrerRewardPoints;
  final String? orderReferralRewardPoints;
  final String? orderAffiliateUserId;
  final String? orderAffiliateTotalCommission;
  final String? orderCartData;
  final String? orderRenew;
  final String? orderDeleted;
  final String? orderRoundingOff;
  final String? orderIsFreeShipping;
  final String? orderOriginalShippingCharged;
  final String? orderPurchasedRewardCredit;
  final String? orderPickingId;
  final String? orderlangOrderId;
  final String? orderlangLangId;
  final String? orderShippingapiName;
  final String? pluginId;
  final String? pluginIdentifier;
  final String? pluginType;
  final String? pluginCode;
  final String? pluginActive;
  final String? pluginDisplayOrder;
  final String? pluginlangPluginId;
  final String? pluginlangLangId;
  final String? pluginName;
  final String? pluginDescription;
  final Map<String, List<Charge>>? charges;
  final IngAddress? billingAddress;
  final IngAddress? shippingAddress;
  final DigitalDownloadLinks? pickupAddress;
  final List<dynamic>? comments;
  final List<Payment>? payments;
  final DigitalDownloadLinks? pickupDetail;

  OrderDetail({
    this.orderId,
    this.orderNumber,
    this.orderType,
    this.orderUserId,
    this.orderPaymentStatus,
    this.orderStatus,
    this.orderNetAmount,
    this.orderIsWalletSelected,
    this.orderWalletAmountCharge,
    this.orderTaxCharged,
    this.orderSiteCommission,
    this.orderDiscountCouponCode,
    this.orderDiscountType,
    this.orderDiscountValue,
    this.orderDiscountTotal,
    this.orderDiscountInfo,
    this.orderVolumeDiscountTotal,
    this.orderRewardPointUsed,
    this.orderRewardPointValue,
    this.orderUserComments,
    this.orderAdminComments,
    this.orderLanguageId,
    this.orderLanguageCode,
    this.orderCurrencyId,
    this.orderCurrencyCode,
    this.orderCurrencyValue,
    this.orderShippingapiId,
    this.orderShippingapiCode,
    this.orderPmethodId,
    this.orderDateAdded,
    this.orderDateConfirmed,
    this.orderDateUpdated,
    this.orderReferrerUserId,
    this.orderReferrerRewardPoints,
    this.orderReferralRewardPoints,
    this.orderAffiliateUserId,
    this.orderAffiliateTotalCommission,
    this.orderCartData,
    this.orderRenew,
    this.orderDeleted,
    this.orderRoundingOff,
    this.orderIsFreeShipping,
    this.orderOriginalShippingCharged,
    this.orderPurchasedRewardCredit,
    this.orderPickingId,
    this.orderlangOrderId,
    this.orderlangLangId,
    this.orderShippingapiName,
    this.pluginId,
    this.pluginIdentifier,
    this.pluginType,
    this.pluginCode,
    this.pluginActive,
    this.pluginDisplayOrder,
    this.pluginlangPluginId,
    this.pluginlangLangId,
    this.pluginName,
    this.pluginDescription,
    this.charges,
    this.billingAddress,
    this.shippingAddress,
    this.pickupAddress,
    this.comments,
    this.payments,
    this.pickupDetail,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
    orderId: json["order_id"],
    orderNumber: json["order_number"],
    orderType: json["order_type"],
    orderUserId: json["order_user_id"],
    orderPaymentStatus: json["order_payment_status"],
    orderStatus: json["order_status"],
    orderNetAmount: json["order_net_amount"],
    orderIsWalletSelected: json["order_is_wallet_selected"],
    orderWalletAmountCharge: json["order_wallet_amount_charge"],
    orderTaxCharged: json["order_tax_charged"],
    orderSiteCommission: json["order_site_commission"],
    orderDiscountCouponCode: json["order_discount_coupon_code"],
    orderDiscountType: json["order_discount_type"],
    orderDiscountValue: json["order_discount_value"],
    orderDiscountTotal: json["order_discount_total"],
    orderDiscountInfo: json["order_discount_info"],
    orderVolumeDiscountTotal: json["order_volume_discount_total"],
    orderRewardPointUsed: json["order_reward_point_used"],
    orderRewardPointValue: json["order_reward_point_value"],
    orderUserComments: json["order_user_comments"],
    orderAdminComments: json["order_admin_comments"],
    orderLanguageId: json["order_language_id"],
    orderLanguageCode: json["order_language_code"],
    orderCurrencyId: json["order_currency_id"],
    orderCurrencyCode: json["order_currency_code"],
    orderCurrencyValue: json["order_currency_value"],
    orderShippingapiId: json["order_shippingapi_id"],
    orderShippingapiCode: json["order_shippingapi_code"],
    orderPmethodId: json["order_pmethod_id"],
    orderDateAdded: json["order_date_added"] == null ? null : DateTime.parse(json["order_date_added"]),
    orderDateConfirmed: json["order_date_confirmed"] == null ? null : DateTime.parse(json["order_date_confirmed"]),
    orderDateUpdated: json["order_date_updated"] == null ? null : DateTime.parse(json["order_date_updated"]),
    orderReferrerUserId: json["order_referrer_user_id"],
    orderReferrerRewardPoints: json["order_referrer_reward_points"],
    orderReferralRewardPoints: json["order_referral_reward_points"],
    orderAffiliateUserId: json["order_affiliate_user_id"],
    orderAffiliateTotalCommission: json["order_affiliate_total_commission"],
    orderCartData: json["order_cart_data"],
    orderRenew: json["order_renew"],
    orderDeleted: json["order_deleted"],
    orderRoundingOff: json["order_rounding_off"],
    orderIsFreeShipping: json["order_is_free_shipping"],
    orderOriginalShippingCharged: json["order_original_shipping_charged"],
    orderPurchasedRewardCredit: json["order_purchased_reward_credit"],
    orderPickingId: json["order_picking_id"],
    orderlangOrderId: json["orderlang_order_id"],
    orderlangLangId: json["orderlang_lang_id"],
    orderShippingapiName: json["order_shippingapi_name"],
    pluginId: json["plugin_id"],
    pluginIdentifier: json["plugin_identifier"],
    pluginType: json["plugin_type"],
    pluginCode: json["plugin_code"],
    pluginActive: json["plugin_active"],
    pluginDisplayOrder: json["plugin_display_order"],
    pluginlangPluginId: json["pluginlang_plugin_id"],
    pluginlangLangId: json["pluginlang_lang_id"],
    pluginName: json["plugin_name"],
    pluginDescription: json["plugin_description"],
    charges: Map.from(json["charges"]!).map((k, v) => MapEntry<String, List<Charge>>(k, List<Charge>.from(v.map((x) => Charge.fromJson(x))))),
    billingAddress: json["billingAddress"] == null ? null : IngAddress.fromJson(json["billingAddress"]),
    shippingAddress: json["shippingAddress"] == null ? null : IngAddress.fromJson(json["shippingAddress"]),
    pickupAddress: json["pickupAddress"] == null ? null : DigitalDownloadLinks.fromJson(json["pickupAddress"]),
    comments: json["comments"] == null ? [] : List<dynamic>.from(json["comments"]!.map((x) => x)),
    payments: json["payments"] == null ? [] : List<Payment>.from(json["payments"]!.map((x) => Payment.fromJson(x))),
    pickupDetail: json["pickupDetail"] == null ? null : DigitalDownloadLinks.fromJson(json["pickupDetail"]),
  );

  Map<String, dynamic> toJson() => {
    "order_id": orderId,
    "order_number": orderNumber,
    "order_type": orderType,
    "order_user_id": orderUserId,
    "order_payment_status": orderPaymentStatus,
    "order_status": orderStatus,
    "order_net_amount": orderNetAmount,
    "order_is_wallet_selected": orderIsWalletSelected,
    "order_wallet_amount_charge": orderWalletAmountCharge,
    "order_tax_charged": orderTaxCharged,
    "order_site_commission": orderSiteCommission,
    "order_discount_coupon_code": orderDiscountCouponCode,
    "order_discount_type": orderDiscountType,
    "order_discount_value": orderDiscountValue,
    "order_discount_total": orderDiscountTotal,
    "order_discount_info": orderDiscountInfo,
    "order_volume_discount_total": orderVolumeDiscountTotal,
    "order_reward_point_used": orderRewardPointUsed,
    "order_reward_point_value": orderRewardPointValue,
    "order_user_comments": orderUserComments,
    "order_admin_comments": orderAdminComments,
    "order_language_id": orderLanguageId,
    "order_language_code": orderLanguageCode,
    "order_currency_id": orderCurrencyId,
    "order_currency_code": orderCurrencyCode,
    "order_currency_value": orderCurrencyValue,
    "order_shippingapi_id": orderShippingapiId,
    "order_shippingapi_code": orderShippingapiCode,
    "order_pmethod_id": orderPmethodId,
    "order_date_added": orderDateAdded?.toIso8601String(),
    "order_date_confirmed": orderDateConfirmed?.toIso8601String(),
    "order_date_updated": orderDateUpdated?.toIso8601String(),
    "order_referrer_user_id": orderReferrerUserId,
    "order_referrer_reward_points": orderReferrerRewardPoints,
    "order_referral_reward_points": orderReferralRewardPoints,
    "order_affiliate_user_id": orderAffiliateUserId,
    "order_affiliate_total_commission": orderAffiliateTotalCommission,
    "order_cart_data": orderCartData,
    "order_renew": orderRenew,
    "order_deleted": orderDeleted,
    "order_rounding_off": orderRoundingOff,
    "order_is_free_shipping": orderIsFreeShipping,
    "order_original_shipping_charged": orderOriginalShippingCharged,
    "order_purchased_reward_credit": orderPurchasedRewardCredit,
    "order_picking_id": orderPickingId,
    "orderlang_order_id": orderlangOrderId,
    "orderlang_lang_id": orderlangLangId,
    "order_shippingapi_name": orderShippingapiName,
    "plugin_id": pluginId,
    "plugin_identifier": pluginIdentifier,
    "plugin_type": pluginType,
    "plugin_code": pluginCode,
    "plugin_active": pluginActive,
    "plugin_display_order": pluginDisplayOrder,
    "pluginlang_plugin_id": pluginlangPluginId,
    "pluginlang_lang_id": pluginlangLangId,
    "plugin_name": pluginName,
    "plugin_description": pluginDescription,
    "charges": Map.from(charges!).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
    "billingAddress": billingAddress?.toJson(),
    "shippingAddress": shippingAddress?.toJson(),
    "pickupAddress": pickupAddress?.toJson(),
    "comments": comments == null ? [] : List<dynamic>.from(comments!.map((x) => x)),
    "payments": payments == null ? [] : List<dynamic>.from(payments!.map((x) => x.toJson())),
    "pickupDetail": pickupDetail?.toJson(),
  };
}

class IngAddress {
  final String? ouaOrderId;
  final String? ouaOpId;
  final String? ouaType;
  final String? ouaName;
  final String? ouaAddress1;
  final String? ouaAddress2;
  final String? ouaCity;
  final String? ouaZone;
  final String? ouaStreet;
  final String? ouaBuildingNo;
  final String? ouaUnitNo;
  final String? ouaState;
  final String? ouaStateCode;
  final String? ouaCountry;
  final String? ouaCountryCode;
  final String? ouaCountryCodeAlpha3;
  final String? ouaPhoneDcode;
  final String? ouaPhone;
  final String? ouaZip;

  IngAddress({
    this.ouaOrderId,
    this.ouaOpId,
    this.ouaType,
    this.ouaName,
    this.ouaAddress1,
    this.ouaAddress2,
    this.ouaCity,
    this.ouaZone,
    this.ouaStreet,
    this.ouaBuildingNo,
    this.ouaUnitNo,
    this.ouaState,
    this.ouaStateCode,
    this.ouaCountry,
    this.ouaCountryCode,
    this.ouaCountryCodeAlpha3,
    this.ouaPhoneDcode,
    this.ouaPhone,
    this.ouaZip,
  });

  factory IngAddress.fromJson(Map<String, dynamic> json) => IngAddress(
    ouaOrderId: json["oua_order_id"],
    ouaOpId: json["oua_op_id"],
    ouaType: json["oua_type"],
    ouaName: json["oua_name"],
    ouaAddress1: json["oua_address1"],
    ouaAddress2: json["oua_address2"],
    ouaCity: json["oua_city"],
    ouaZone: json["oua_zone"],
    ouaStreet: json["oua_street"],
    ouaBuildingNo: json["oua_building_no"],
    ouaUnitNo: json["oua_unit_no"],
    ouaState: json["oua_state"],
    ouaStateCode: json["oua_state_code"],
    ouaCountry: json["oua_country"],
    ouaCountryCode: json["oua_country_code"],
    ouaCountryCodeAlpha3: json["oua_country_code_alpha3"],
    ouaPhoneDcode: json["oua_phone_dcode"],
    ouaPhone: json["oua_phone"],
    ouaZip: json["oua_zip"],
  );

  Map<String, dynamic> toJson() => {
    "oua_order_id": ouaOrderId,
    "oua_op_id": ouaOpId,
    "oua_type": ouaType,
    "oua_name": ouaName,
    "oua_address1": ouaAddress1,
    "oua_address2": ouaAddress2,
    "oua_city": ouaCity,
    "oua_zone": ouaZone,
    "oua_street": ouaStreet,
    "oua_building_no": ouaBuildingNo,
    "oua_unit_no": ouaUnitNo,
    "oua_state": ouaState,
    "oua_state_code": ouaStateCode,
    "oua_country": ouaCountry,
    "oua_country_code": ouaCountryCode,
    "oua_country_code_alpha3": ouaCountryCodeAlpha3,
    "oua_phone_dcode": ouaPhoneDcode,
    "oua_phone": ouaPhone,
    "oua_zip": ouaZip,
  };
}

class Payment {
  final String? opaymentId;
  final String? opaymentOrderId;
  final String? opaymentMethod;
  final String? opaymentGatewayTxnId;
  final String? opaymentAmount;
  final String? opaymentTxnStatus;
  final String? opaymentComments;
  final String? opaymentGatewayResponse;
  final DateTime? opaymentDate;

  Payment({
    this.opaymentId,
    this.opaymentOrderId,
    this.opaymentMethod,
    this.opaymentGatewayTxnId,
    this.opaymentAmount,
    this.opaymentTxnStatus,
    this.opaymentComments,
    this.opaymentGatewayResponse,
    this.opaymentDate,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    opaymentId: json["opayment_id"],
    opaymentOrderId: json["opayment_order_id"],
    opaymentMethod: json["opayment_method"],
    opaymentGatewayTxnId: json["opayment_gateway_txn_id"],
    opaymentAmount: json["opayment_amount"],
    opaymentTxnStatus: json["opayment_txn_status"],
    opaymentComments: json["opayment_comments"],
    opaymentGatewayResponse: json["opayment_gateway_response"],
    opaymentDate: json["opayment_date"] == null ? null : DateTime.parse(json["opayment_date"]),
  );

  Map<String, dynamic> toJson() => {
    "opayment_id": opaymentId,
    "opayment_order_id": opaymentOrderId,
    "opayment_method": opaymentMethod,
    "opayment_gateway_txn_id": opaymentGatewayTxnId,
    "opayment_amount": opaymentAmount,
    "opayment_txn_status": opaymentTxnStatus,
    "opayment_comments": opaymentComments,
    "opayment_gateway_response": opaymentGatewayResponse,
    "opayment_date": opaymentDate?.toIso8601String(),
  };
}
