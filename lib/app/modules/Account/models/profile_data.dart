import 'package:tajer/app/modules/Account/models/bank_info.dart';

class ProfileData {
  final String currencySymbol;
  final String totalFavouriteItems;
  final String totalUnreadMessageCount;
  final String totalUnreadNotificationCount;
  final String cartItemsCount;
  final PersonalInfo? personalInfo;
  final BankInfo? bankInfo;
  final String privacyPolicyLink;
  final String faqLink;
  final String suggestionLink;
  final String termsAndConditionsLink;
  final String userAggrementLink;
  final String isUserAggrementLink;
  final String referralModuleIsEnabled;
  final String hasDigitalProducts;
  final String warrantyExchangeLink;
  final List<dynamic>? splitPaymentMethods;

  ProfileData({
    required this.currencySymbol,
    required this.totalFavouriteItems,
    required this.totalUnreadMessageCount,
    required this.totalUnreadNotificationCount,
    required this.cartItemsCount,
    this.personalInfo,
    this.bankInfo,
    required this.privacyPolicyLink,
    required this.faqLink,
    required this.suggestionLink,
    required this.termsAndConditionsLink,
    required this.userAggrementLink,
    required this.isUserAggrementLink,
    required this.referralModuleIsEnabled,
    required this.hasDigitalProducts,
    required this.warrantyExchangeLink,
    this.splitPaymentMethods,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) {
    return ProfileData(
      currencySymbol: json['currencySymbol'] ?? '',
      totalFavouriteItems: json['totalFavouriteItems'] ?? '',
      totalUnreadMessageCount: json['totalUnreadMessageCount'] ?? '',
      totalUnreadNotificationCount: json['totalUnreadNotificationCount'] ?? '',
      cartItemsCount: json['cartItemsCount'] ?? '',
      personalInfo: json['personalInfo'] != null
          ? PersonalInfo.fromJson(json['personalInfo'])
          : null,
      bankInfo: json['bankInfo'] != null
          ? BankInfo.fromJson(json['bankInfo'])
          : null,
      privacyPolicyLink: json['privacyPolicyLink'] ?? '',
      faqLink: json['faqLink'] ?? '',
      suggestionLink: json['suggestionLink'] ?? '',
      termsAndConditionsLink: json['termsAndConditionsLink'] ?? '',
      userAggrementLink: json['userAggrementLink'] ?? '',
      isUserAggrementLink: json['isUserAggrementLink'] ?? '',
      referralModuleIsEnabled: json['referralModuleIsEnabled'] ?? '',
      hasDigitalProducts: json['hasDigitalProducts'] ?? '',
      warrantyExchangeLink: json['warrantyExchangeLink'] ?? '',
      splitPaymentMethods: json['splitPaymentMethods'] ?? [],
    );
  }

  Map<String, dynamic> toJson() => {
    'currencySymbol': currencySymbol,
    'totalFavouriteItems': totalFavouriteItems,
    'totalUnreadMessageCount': totalUnreadMessageCount,
    'totalUnreadNotificationCount': totalUnreadNotificationCount,
    'cartItemsCount': cartItemsCount,
    'personalInfo': personalInfo?.toJson(),
    'bankInfo': bankInfo?.toJson(),
    'privacyPolicyLink': privacyPolicyLink,
    'faqLink': faqLink,
    'suggestionLink': suggestionLink,
    'termsAndConditionsLink': termsAndConditionsLink,
    'userAggrementLink': userAggrementLink,
    'isUserAggrementLink': isUserAggrementLink,
    'referralModuleIsEnabled': referralModuleIsEnabled,
    'hasDigitalProducts': hasDigitalProducts,
    'warrantyExchangeLink': warrantyExchangeLink,
    'splitPaymentMethods': splitPaymentMethods,
  };
}

class PersonalInfo {
  final String userId;
  final String userName;
  final String userPhoneDcode;
  final String userPhone;
  final String userProfileInfo;
  final String userRegdate;
  final String userPreferredDashboard;
  final String userRegisteredInitiallyFor;
  final String userParent;
  final String credentialUsername;
  final String credentialEmail;
  final String credentialActive;
  final String credentialVerified;
  final String userDob;
  final String userAddress1;
  final String userAddress2;
  final String userZip;
  final String userCountryId;
  final String userStateId;
  final String userCity;
  final String userIsBuyer;
  final String userIsSupplier;
  final String userIsAdvertiser;
  final String userIsAffiliate;
  final String userIsShippingCompany;
  final String userAutorenewSubscription;
  final String userFbAccessToken;
  final String userReferralCode;
  final String userReferrerUserId;
  final String userAffiliateReferrerUserId;
  final String userCompany;
  final String userProductsServices;
  final String userAffiliateCommission;
  final String userOrderTrackingUrl;
  final String userHasValidSubscription;
  final String userIsInfluencer;
  final String userUpdatedOn;
  final String userDeleted;
  final String userOddoId;
  final String countryName;
  final String stateName;
  final String userImage;
  final String userBallance;
  final String userWishlistCount;
  final String userOrderReturnRequestCount;

  PersonalInfo({
    required this.userId,
    required this.userName,
    required this.userPhoneDcode,
    required this.userPhone,
    required this.userProfileInfo,
    required this.userRegdate,
    required this.userPreferredDashboard,
    required this.userRegisteredInitiallyFor,
    required this.userParent,
    required this.credentialUsername,
    required this.credentialEmail,
    required this.credentialActive,
    required this.credentialVerified,
    required this.userDob,
    required this.userAddress1,
    required this.userAddress2,
    required this.userZip,
    required this.userCountryId,
    required this.userStateId,
    required this.userCity,
    required this.userIsBuyer,
    required this.userIsSupplier,
    required this.userIsAdvertiser,
    required this.userIsAffiliate,
    required this.userIsShippingCompany,
    required this.userAutorenewSubscription,
    required this.userFbAccessToken,
    required this.userReferralCode,
    required this.userReferrerUserId,
    required this.userAffiliateReferrerUserId,
    required this.userCompany,
    required this.userProductsServices,
    required this.userAffiliateCommission,
    required this.userOrderTrackingUrl,
    required this.userHasValidSubscription,
    required this.userIsInfluencer,
    required this.userUpdatedOn,
    required this.userDeleted,
    required this.userOddoId,
    required this.countryName,
    required this.stateName,
    required this.userImage,
    required this.userBallance,
    required this.userWishlistCount,
    required this.userOrderReturnRequestCount,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) => PersonalInfo(
    userId: json['user_id'] ?? '',
    userName: json['user_name'] ?? '',
    userPhoneDcode: json['user_phone_dcode'] ?? '',
    userPhone: json['user_phone'] ?? '',
    userProfileInfo: json['user_profile_info'] ?? '',
    userRegdate: json['user_regdate'] ?? '',
    userPreferredDashboard: json['user_preferred_dashboard'] ?? '',
    userRegisteredInitiallyFor:
    json['user_registered_initially_for'] ?? '',
    userParent: json['user_parent'] ?? '',
    credentialUsername: json['credential_username'] ?? '',
    credentialEmail: json['credential_email'] ?? '',
    credentialActive: json['credential_active'] ?? '',
    credentialVerified: json['credential_verified'] ?? '',
    userDob: json['user_dob'] ?? '',
    userAddress1: json['user_address1'] ?? '',
    userAddress2: json['user_address2'] ?? '',
    userZip: json['user_zip'] ?? '',
    userCountryId: json['user_country_id'] ?? '',
    userStateId: json['user_state_id'] ?? '',
    userCity: json['user_city'] ?? '',
    userIsBuyer: json['user_is_buyer'] ?? '',
    userIsSupplier: json['user_is_supplier'] ?? '',
    userIsAdvertiser: json['user_is_advertiser'] ?? '',
    userIsAffiliate: json['user_is_affiliate'] ?? '',
    userIsShippingCompany: json['user_is_shipping_company'] ?? '',
    userAutorenewSubscription: json['user_autorenew_subscription'] ?? '',
    userFbAccessToken: json['user_fb_access_token'] ?? '',
    userReferralCode: json['user_referral_code'] ?? '',
    userReferrerUserId: json['user_referrer_user_id'] ?? '',
    userAffiliateReferrerUserId:
    json['user_affiliate_referrer_user_id'] ?? '',
    userCompany: json['user_company'] ?? '',
    userProductsServices: json['user_products_services'] ?? '',
    userAffiliateCommission: json['user_affiliate_commission'] ?? '',
    userOrderTrackingUrl: json['user_order_tracking_url'] ?? '',
    userHasValidSubscription: json['user_has_valid_subscription'] ?? '',
    userIsInfluencer: json['user_is_influencer'] ?? '',
    userUpdatedOn: json['user_updated_on'] ?? '',
    userDeleted: json['user_deleted'] ?? '',
    userOddoId: json['user_oddo_id'] ?? '',
    countryName: json['country_name'] ?? '',
    stateName: json['state_name'] ?? '',
    userImage: json['userImage'] ?? '',
    userBallance: json['user_ballance'] ?? '',
    userWishlistCount: json['user_wishlist_count'] ?? '',
    userOrderReturnRequestCount:
    json['user_order_return_request_count'] ?? '',
  );

  Map<String, dynamic> toJson() => {
    'user_id': userId,
    'user_name': userName,
    'user_phone_dcode': userPhoneDcode,
    'user_phone': userPhone,
    'user_profile_info': userProfileInfo,
    'user_regdate': userRegdate,
    'user_preferred_dashboard': userPreferredDashboard,
    'user_registered_initially_for': userRegisteredInitiallyFor,
    'user_parent': userParent,
    'credential_username': credentialUsername,
    'credential_email': credentialEmail,
    'credential_active': credentialActive,
    'credential_verified': credentialVerified,
    'user_dob': userDob,
    'user_address1': userAddress1,
    'user_address2': userAddress2,
    'user_zip': userZip,
    'user_country_id': userCountryId,
    'user_state_id': userStateId,
    'user_city': userCity,
    'user_is_buyer': userIsBuyer,
    'user_is_supplier': userIsSupplier,
    'user_is_advertiser': userIsAdvertiser,
    'user_is_affiliate': userIsAffiliate,
    'user_is_shipping_company': userIsShippingCompany,
    'user_autorenew_subscription': userAutorenewSubscription,
    'user_fb_access_token': userFbAccessToken,
    'user_referral_code': userReferralCode,
    'user_referrer_user_id': userReferrerUserId,
    'user_affiliate_referrer_user_id': userAffiliateReferrerUserId,
    'user_company': userCompany,
    'user_products_services': userProductsServices,
    'user_affiliate_commission': userAffiliateCommission,
    'user_order_tracking_url': userOrderTrackingUrl,
    'user_has_valid_subscription': userHasValidSubscription,
    'user_is_influencer': userIsInfluencer,
    'user_updated_on': userUpdatedOn,
    'user_deleted': userDeleted,
    'user_oddo_id': userOddoId,
    'country_name': countryName,
    'state_name': stateName,
    'userImage': userImage,
    'user_ballance': userBallance,
    'user_wishlist_count': userWishlistCount,
    'user_order_return_request_count': userOrderReturnRequestCount,
  };
}
