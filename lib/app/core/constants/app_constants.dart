import 'dart:async';

import 'package:get/get_rx/src/rx_types/rx_types.dart';

//global cart item count
RxString cartItemCounts = "0".obs;
var deepLinkURL = '';
bool isEmployeeVerificationFlow = false;
final Completer<void> splashCompleter = Completer<void>();

class AppConstants {
 // Base URL
 static String get baseUrl => AppConfig.baseUrl;
 static String get imageBaseURLPath => AppConfig.imageBaseURLPath;

 static const String oneSignalAppId = "5652c9b5-8841-4a8e-8961-6e0cea0dfcf2";
 static const String privacyPolicy = "cms/view/3";

 static const String LOGOUT = "-1";
 static const String SUCCESS = "1";
 static const String WARNING = "0";
 static const String ERROR = "0";

 // public static final String TEMP_USER_ID = "TEMP_USER_ID";
 static const String buyerUserType = "1";
 static const String deviceOS = "1";

 //

 //Preference keys
 static const String socialAuthStatusKey = 'social_auth_status';
 static const String cartItemCount = 'cartItemCount';
 static const String googleLogin = 'googleLogin';
 static const String currencySymbol = 'currencySymbol';
 static const String confEnableForceUpdate = 'CONF_ENABLE_FORCE_UPDATE';
 static const String appleLogin = 'appleLogin';
 static const String countryCode = 'countryCode';
 static const String countryId = 'countryId';
 static const String countryName = 'countryName';
 static const String themeColor = 'themeColor';
 static const String promoBannerEnabled = 'promoBannerEnabled';
 static const String promoBannerText = 'promoBannerText';
 static const String primaryInverseThemeColor = 'primaryInverseThemeColor';
 static const String secondaryThemeColor = 'secondaryThemeColor';
 static const String secondaryInverseThemeColor = 'secondaryInverseThemeColor';
 static const String lightBgColor = 'lightBgColor';
 static const String newsletterEnabled = 'newsletterEnabled';
 static const String confSingleSellerCart = 'confSingleSellerCart';
 static const String isWishlistEnable = 'isWishlistEnable';
 static const String canAddReview = 'canAddReview';
 static const String canSendSms = 'canSendSms';
 static const String confEnableGeoLocation = 'confEnableGeoLocation';
 static const String confEnableWithdrawals = 'confEnableWithdrawals';
 static const String confSigninWithPhoneEnable = 'confSigninWithPhoneEnable';
 static const String siteLangId = 'siteLangId';
 static const String loginData = 'loginData';
 static const String sessionToken = 'sessionToken';
 static const String sessionId = 'sessionId';
 static const String localizationFilePath = 'localizationFilePath';
 static const String geoLocation = 'geoLocation';
 static const String skipForNow = 'skipForNow';
 static const String fcmToken = 'fcmToken';
 static const String currencyId = 'currencyId';
 static const String languageId = 'languageId';
 static const String languageCode = 'languageCode';
 static const String languageCountryCode = 'languageCountryCode';
 static const String userId = 'userId';
 static const String userName = 'userName';
 static const String userEmail = 'userEmail';
 static const String userPhone = 'userPhone';
 static const String userDialCode = 'userDialCode';
 static const String userImage = 'userImage';
 static const String all = 'All';
 static const String credit = 'Credit';
 static const String debit = 'Debit';
 static const String refreshProfile = 'refreshProfile';
 static const String exchange = "Exchange";
 static const String returnOrder = "Return";
 static const String missing = "Missing";

 // Timeouts
 static const int connectTimeout = 10000; // 10 seconds
 static const int receiveTimeout = 10000;

 // App Strings
 static const String appName = "Tajer";
 static const String homeTitle = "Home Screen";

 // Other constants (headers, tokens, etc.)
 static const String contentType = "application/json";

 // Endpoints
 static const String getStatus = "social-media-auth/get-status";
 static const String splashScreenData = "home/splash-screen-data";
 static const String signUpApi = "guest-user/register";
 static const String loginUser = "guest-user/login";
 static const String loginWithOtp = "guest-user/get-login-otp";
 static const String forgotPassword = "guest-user/forgot-password";
 static const String googleLoginApi = "google-login";
 static const String appleLoginApi = "apple-login";
 static const String saveFirebaseToken =
     "guest-user/set-user-push-notification-token";
 static const String logoutUser = "guest-user/logout";
 static const String accountDelete =
     "/dashboard/account/send-truncate-request";
 static const String verifyOtp = "guest-user/validate-otp-api/{";
 static const String home = "home";
 static const String categories = "category/structure";
 static const String brands = "brands";
 static const String shops = "shops/search";
 static const String productDetail = "/products/view/";
 static const String productSizeGuide = "products/size-guide";
 static const String reportForm = "/products/setup-product-report";
 static const String filteredProducts = "/products/get-filtered-products";
 static const String getFilters = "/products/filters";
 static const String shopDetail = "/shops/view/";
 static const String shopSendMessage = "/shops/set-up-send-message";
 static const String shopReviews = "/reviews/search-for-shop/";
 static const String collectionSearch = "/collections/search/";
 static const String shopMarkHelpful = "/reviews/mark-helpful/";
 static const String autoCompleteSearch =
     "/products/search-producttags-autocomplete/";
 static const String searchImageRecordId = "home/upload-search-image/";
 static const String searchFavListItems =
     "/dashboard/account/search-favourite-list-items";
 static const String wishlistItems =
     "/dashboard/account/search-wish-list-items";
 static const String wishListSearch = "/dashboard/account/wish-list-search";
 static const String createWishList = "/dashboard/account/setup-wish-list";
 static const String addToWishlist =
     "/dashboard/account/add-remove-wish-list-product";
 static const String deleteWishList = "/dashboard/account/delete-wish-list";
 static const String addToCart = "/cart/add";
 static const String cartUpdate = "/cart/update";
 static const String cartListing = "/cart/listing/2";
 static const String saveForLater = "dashboard/account/move-to-save-for-later";
 static const String moveCartItemToWishlist =
     "/account/add-remove-wish-list-product";
 static const String cartRemove = "/cart/remove";
 static const String paymentSummaryWithShippingSelection =
     "checkout/payment-summary-with-shipping-selection";
 static const String paymentSummary = "checkout/payment-summary";
 static const String reviewCart = "checkout/review-cart";
 static const String applyCoupon = "cart/apply-promo-code";
 static const String removeCoupon = "cart/remove-promo-code";
 static const String removeReward = "checkout/remove-reward-points";
 static const String payFromWallet = "wallet-pay/charge";
 static const String viewOrder = "dashboard/buyer/view-order";
 static const String getTempToken = "dashboard/account/get-temp-token";
 static const String confirmOrder = "checkout/confirm-order";
 static const String usersEndpoint = "/users";
 static const String resendOtp = "guest-user/resend-otp/";
 static const String accountResendOtp = "account/resend-otp";
 static const String getProfileInfo = "dashboard/account/profile-info";
 static const String signUpAgreementUrl = "custom/signup-agreement-urls";
 static const String getCurrency = "home/currencies";
 static const String getCountries = "home/countries-autocomplete";
 static const String setCountry = "home/set-up-ip-loc";
 static const String getLanguage = "home/languages";
 static const String getMyOrderList = "dashboard/buyer/order-search-listing";
 static const String getOrderDetail = "dashboard/buyer/view-order/";
 static const String returnRequestSearch =
     "dashboard/buyer/order-return-request-search";
 static const String returnRequestDetail =
     "dashboard/buyer/view-order-return-request/";
 static const String requestSearch =
     "dashboard/buyer/order-request-search";
 static const String exchangeRequestDetail =
     "dashboard/buyer/view-order-exchange-request/";
 static const String orderCancelRequestDetail =
     "dashboard/buyer/view-order-cancellation-request/";
 static const String orderMissingRequestDetail =
     "dashboard/buyer/view-order-missing-product-request/";
 static const String withdrawOrderReturnRequest =
     "dashboard/buyer/withdraw-order-return-request/";
 static const String withdrawMissingReturnRequest =
     "dashboard/buyer/withdraw-order-missing-request/";
 static const String orderReturnRequestSearch =
     "dashboard/buyer/order-exchange-request-search";
 static const String withdrawOrderExchangeReturnRequest =
     "dashboard/buyer/withdraw-order-exchange-request/";
 static const String orderCancellationRequestSearch =
     "dashboard/buyer/order-cancellation-request-search";
 static const String orderMissingRequestSearch =
     "dashboard/buyer/order-missing-product-request-search";
 static const String cancelOrderReason = "dashboard/buyer/order-cancellation-reasons";
 static const String cancelOrder = "dashboard/buyer/setup-order-cancel-request";
 static const String searchAddress = "dashboard/account/search-addresses";
 static const String setDefaultAddress = "dashboard/addresses/set-default";
 static const String deleteRecord = "dashboard/addresses/delete-record";
 static const String setUpAddress = "dashboard/addresses/set-up-address";
 static const String getCountryList = "home/countries";
 static const String getStateList = "home/states/";
 static const String verifyPhoneApi = "checkout/verify-phone";
 static const String creditSearch = "dashboard/account/credit-search";
 static const String payouts = "dashboard/account/payouts";
 static const String redeemGiftCard = "dashboard/account/reedem-giftcard";
 static const String setUpRequestWithdrawal =
     "dashboard/account/setup-request-withdrawal";
 static const String paypalPayoutSetUp = "dashboard/pay-pal-payout/setup";
 static const String messageSearch = "dashboard/account/message-search";
 static const String threadMessageSearch =
     "dashboard/account/thread-message-search";
 static const String orderReturnRequestMessageSearch =
     "dashboard/account/order-return-request-message-search";
 static const String orderExchangeRequestMessageSearch =
     "dashboard/account/order-exchange-request-message-search";
 static const String sendMessage = "dashboard/account/send-message";
 static const String sendMessageReturnOrder =
     "dashboard/buyer/set-up-return-order-request-message";
 static const String sendMessageExchangeOrder =
     "dashboard/buyer/set-up-exchange-order-request-message";
 static const String searchGiftCards = "dashboard/buyer/search-gift-cards";
 static const String setUpGiftCard = "dashboard/buyer/setup-gift-card";
 static const String searchOffers = "dashboard/buyer/search-offers";
 static const String rewardPointsSearch =
     "dashboard/buyer/reward-points-search";
 static const String updateBankInfo = "dashboard/account/update-bank-info";
 static const String setUpRequestData = "dashboard/account/setup-request-data";
 static const String changeEmail = "dashboard/account/update-email";
 static const String updatePassword = "dashboard/account/update-password";
 static const String getOtp = "dashboard/account/get-otp/{";
 static const String updateProfileInfo =
     "dashboard/account/update-profile-info";
 static const String uploadProfileImage =
     "dashboard/account/upload-profile-image";
 static const String removeProfileImage =
     "dashboard/account/remove-profile-image";
 static const String contactSubmit = "custom/contact-submit";
 static const String orderReceipt = "dashboard/buyer/order-receipt/{";
 static const String reOrderProduct = "dashboard/buyer/add-items-to-cart/";
 static const String orderExchangeRequest =
     "dashboard/buyer/setup-order-exchange-request";
 static const String orderReturnRequest =
     "dashboard/buyer/setup-order-return-request";
 static const String returnRequestReason= "dashboard/buyer/order-return-requests-reasons/";
 static const String exchangeRequestReason= "dashboard/buyer/order-exchange-requests-reasons/";
 static const String missingProductRequestReason= "dashboard/buyer/order-missing-product-request-reasons/";
 static const String notificationList = "dashboard/account/notifications";
 static const String pushNotificationsList =
     "dashboard/account/push-notifications";
 static const String readAllNotification =
     "dashboard/account/read-all-notifications";
 static const String orderFeedback = "dashboard/buyer/order-feedback/";
 static const String setUpWalletRecharge =
     "dashboard/account/set-up-wallet-recharge";
 static const String walletGiftSelection = "checkout/wallet-gift-selection";
 static const String setUpOrderFeedback =
     "dashboard/buyer/setup-order-feedback";
 static const String setUpOrderMissingRequest= "dashboard/buyer/setup-order-missing-product-request";
 static const String deleteCard= "checkout/delete-card";
 static const String verifyPhone= "dashboard/account/verify-phone";
 static const String saveProfilePhoneNumber= "dashboard/account/save-profile-phone-number";
 static const String getVerifiedNumbers= "dashboard/account/change-profile-phone-form";
 static const String employeeRegistrationStatus= "employee-registerations/status/";


 static const String privacyLink = "privacy_link";
 static const String termsConditionLink = "termsConditionLink";
 static const String phoneSectionEnabled = "phone_section_enabled";
}

class AppConfig {
 static AppEnvironment env = AppEnvironment.DEVELOPMENT; // change once

 static String get baseUrl {
  switch (env) {
   case AppEnvironment.PRODUCTION:
    return "https://tajershops.com/app-api/3.1/";
   case AppEnvironment.DEVELOPMENT:
    return "https://beta.tajershops.com/app-api/3.1/";
  }
 }

 static String get imageBaseURLPath {
  switch (env) {
   case AppEnvironment.PRODUCTION:
    return "https://tajershops.com";
   case AppEnvironment.DEVELOPMENT:
    return "https://beta.tajershops.com";
  }
 }
}

enum AppEnvironment { DEVELOPMENT, PRODUCTION }
