class SplashDataModel {
  final String? currencySymbol;
  final String? totalFavouriteItems;
  final String? totalUnreadMessageCount;
  final String? totalUnreadNotificationCount;
  final String? cartItemsCount;
  final String? confEnableGeoLocation;
  final String? confDefaultCurrencySeparator;
  final String? confSingleSellerCart;
  final String? confMinOrderValueForFreeShipping;
  final String? confSmsPluginEnabled;
  final String? confSignupWithPhoneEnable;
  final String? confEnableWithdrawals;
  final LanguageLabels? languageLabels;
  final AppThemeSetting? appThemeSetting;
  final String? isWishlistEnable;
  final String? canSendSms;
  final String? canAddReview;
  final String? currencyId;
  final DefaultCountry? defaultCountry;
  final String? siteLangId;
  final String? newsletterEnabled;
  final String? appSessionId;
  final String? CONF_ENABLE_FORCE_UPDATE;

  SplashDataModel({
    this.currencySymbol,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.confEnableGeoLocation,
    this.confDefaultCurrencySeparator,
    this.confSingleSellerCart,
    this.confMinOrderValueForFreeShipping,
    this.confSmsPluginEnabled,
    this.confSignupWithPhoneEnable,
    this.confEnableWithdrawals,
    this.languageLabels,
    this.appThemeSetting,
    this.isWishlistEnable,
    this.canSendSms,
    this.canAddReview,
    this.currencyId,
    this.defaultCountry,
    this.siteLangId,
    this.newsletterEnabled,
    this.appSessionId,
    this.CONF_ENABLE_FORCE_UPDATE,
  });

  factory SplashDataModel.fromJson(Map<String, dynamic> json) {
    return SplashDataModel(
      currencySymbol: json['currencySymbol'],
      totalFavouriteItems: json['totalFavouriteItems'],
      totalUnreadMessageCount: json['totalUnreadMessageCount'],
      totalUnreadNotificationCount: json['totalUnreadNotificationCount'],
      cartItemsCount: json['cartItemsCount'],
      confEnableGeoLocation: json['CONF_ENABLE_GEO_LOCATION'],
      confDefaultCurrencySeparator: json['CONF_DEFAULT_CURRENCY_SEPARATOR'],
      confSingleSellerCart: json['CONF_SINGLE_SELLER_CART'],
      confMinOrderValueForFreeShipping:
      json['CONF_MIN_ORDER_VALUE_FOR_FREE_SHIPPING'],
      confSmsPluginEnabled: json['CONF_SMS_PLUGIN_ENABLED'],
      confSignupWithPhoneEnable: json['CONF_SIGNUP_WITH_PHONE_ENABLE'],
      confEnableWithdrawals: json['CONF_ENABLE_WITHDRAWALS'],
      languageLabels: json['languageLabels'] != null
          ? LanguageLabels.fromJson(json['languageLabels'])
          : null,
      appThemeSetting: json['appThemeSetting'] != null
          ? AppThemeSetting.fromJson(json['appThemeSetting'])
          : null,
      isWishlistEnable: json['isWishlistEnable'],
      canSendSms: json['canSendSms'],
      canAddReview: json['canAddReview'],
      currencyId: json['currency_id'],
      defaultCountry: json['defaultCountry'] != null
          ? DefaultCountry.fromJson(json['defaultCountry'])
          : null,
      siteLangId: json['siteLangId'],
      newsletterEnabled: json['newsletterEnabled'],
      appSessionId: json['app_session_id'],
      CONF_ENABLE_FORCE_UPDATE: json['CONF_ENABLE_FORCE_UPDATE'],
    );
  }

  Map<String, dynamic> toJson() => {
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "CONF_ENABLE_GEO_LOCATION": confEnableGeoLocation,
    "CONF_DEFAULT_CURRENCY_SEPARATOR": confDefaultCurrencySeparator,
    "CONF_SINGLE_SELLER_CART": confSingleSellerCart,
    "CONF_MIN_ORDER_VALUE_FOR_FREE_SHIPPING":
    confMinOrderValueForFreeShipping,
    "CONF_SMS_PLUGIN_ENABLED": confSmsPluginEnabled,
    "CONF_SIGNUP_WITH_PHONE_ENABLE": confSignupWithPhoneEnable,
    "CONF_ENABLE_WITHDRAWALS": confEnableWithdrawals,
    "languageLabels": languageLabels?.toJson(),
    "appThemeSetting": appThemeSetting?.toJson(),
    "isWishlistEnable": isWishlistEnable,
    "canSendSms": canSendSms,
    "canAddReview": canAddReview,
    "currency_id": currencyId,
    "defaultCountry": defaultCountry?.toJson(),
    "siteLangId": siteLangId,
    "newsletterEnabled": newsletterEnabled,
    "app_session_id": appSessionId,
    "CONF_ENABLE_FORCE_UPDATE": CONF_ENABLE_FORCE_UPDATE,
  };
}

class LanguageLabels {
  final String? languageCode;
  final String? languageLayoutDirection;
  final String? downloadUrl;
  final String? langLabelUpdatedAt;

  LanguageLabels({
    this.languageCode,
    this.languageLayoutDirection,
    this.downloadUrl,
    this.langLabelUpdatedAt,
  });

  factory LanguageLabels.fromJson(Map<String, dynamic> json) => LanguageLabels(
    languageCode: json['language_code'],
    languageLayoutDirection: json['language_layout_direction'],
    downloadUrl: json['downloadUrl'],
    langLabelUpdatedAt: json['langLabelUpdatedAt'],
  );

  Map<String, dynamic> toJson() => {
    "language_code": languageCode,
    "language_layout_direction": languageLayoutDirection,
    "downloadUrl": downloadUrl,
    "langLabelUpdatedAt": langLabelUpdatedAt,
  };
}

class AppThemeSetting {
  final String? primaryThemeColor;
  final String? primaryInverseThemeColor;
  final String? secondaryThemeColor;
  final String? secondaryInverseThemeColor;
  final String? lightBgColor;

  AppThemeSetting({
    this.primaryThemeColor,
    this.primaryInverseThemeColor,
    this.secondaryThemeColor,
    this.secondaryInverseThemeColor,
    this.lightBgColor,
  });

  factory AppThemeSetting.fromJson(Map<String, dynamic> json) => AppThemeSetting(
    primaryThemeColor: json['primaryThemeColor'],
    primaryInverseThemeColor: json['primaryInverseThemeColor'],
    secondaryThemeColor: json['secondaryThemeColor'],
    secondaryInverseThemeColor: json['secondaryInverseThemeColor'],
  );

  Map<String, dynamic> toJson() => {
    "primaryThemeColor": primaryThemeColor,
    "primaryInverseThemeColor": primaryInverseThemeColor,
    "secondaryThemeColor": secondaryThemeColor,
    "secondaryInverseThemeColor": secondaryInverseThemeColor,
    "lightBgColor": lightBgColor,
  };
}

class DefaultCountry {
  final String? countryId;
  final String? countryCode;

  DefaultCountry({
    this.countryId,
    this.countryCode,
  });

  factory DefaultCountry.fromJson(Map<String, dynamic> json) => DefaultCountry(
    countryId: json['country_id'],
    countryCode: json['country_code'],
  );

  Map<String, dynamic> toJson() => {
    "country_id": countryId,
    "country_code": countryCode,
  };
}
