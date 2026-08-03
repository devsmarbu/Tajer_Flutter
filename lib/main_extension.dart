import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' hide FormData;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/firebase/one_signal_notification.dart';
import 'package:tajer/app/modules/authentication/splash/controller/splash_controller.dart';
import 'package:tajer/app/modules/navigation/bottom_navigation.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/app_params.dart';
import 'package:tajer/utils/app_strings.dart';
import 'package:tajer/utils/pref_store.dart';
import 'app/core/routes/app_routes.dart';
import 'package:app_links/app_links.dart';

import 'app/data/events/app_analytics_service.dart';
import 'app/modules/Account/controller/account_controller.dart';
import 'package:flutter/services.dart';

import 'app/modules/orders/orderDetail/view/order_details_screen.dart';

class UrlHandling {
  UrlHandling._();

  static final UrlHandling shared = UrlHandling._();

  final Dio _dio = Dio();

  Future<void> universalUrlDetailsAPI(String linkUrl) async {
    debugPrint("------------------------------------------------");
    debugPrint("🌐 universalUrlDetailsAPI() → START");
    debugPrint("📩 Incoming URL = $linkUrl");
    debugPrint("------------------------------------------------");

    try {
      debugPrint("📡 Sending API request...");
      debugPrint("URL → ${AppConstants.baseUrl}home/get-url-segments-detail");
      debugPrint(Uri.decodeFull(linkUrl));
      final formData = FormData.fromMap({"url": Uri.decodeFull(linkUrl)});

      final response = await _dio.post(
        "${AppConstants.baseUrl}home/get-url-segments-detail",
        data: formData,
        options: Options(contentType: Headers.multipartFormDataContentType),
      );

      debugPrint("📥 API Response received");
      debugPrint("Status Code → ${response.statusCode}");

      if (response.statusCode == 200) {
        debugPrint("✔ API Status OK");

        final Map<String, dynamic> json = response.data;

        debugPrint("🔍 Full JSON Response:");
        debugPrint(json.toString());

        if (json["status"].toString() != "1") {
          debugPrint("❌ API Returned status != 1 → stopping");
          return;
        }

        final data = json["data"]["urlSegmentsDetail"];
        debugPrint("🔎 urlSegmentsDetail: $data");

        final id = data["recordId"]?.toString() ?? "";
        final type = data["urlType"]?.toString() ?? "";
        final title = data["title"]?.toString() ?? "";

        debugPrint("🆔 Parsed ID = $id");
        debugPrint("📌 Parsed type = $type");

        final extra = data["extra"] ?? {};
        debugPrint("📦 Extra block: $extra");

        final collectionType = extra["collectionType"]?.toString() ?? "";
        final referralToken = extra["referralToken"]?.toString() ?? "";

        debugPrint("📚 collectionType = $collectionType");
        debugPrint("🎫 referralToken = $referralToken");

        debugPrint("➡ Passing to setUniversalLinkingRoot()");

        setUniversalLinkingRoot(
          id: id,
          type: type,
          collectionType: collectionType,
          referralToken: referralToken,
          title: title,
        );
      } else {
        debugPrint("❌ API ERROR");
        debugPrint("Message → ${response.statusMessage}");
        debugPrint("Code → ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("❌ universalUrlDetailsAPI Exception: $e");
    }
  }

  Future<void> setUniversalLinkingRoot({
    required String id,
    required String type,
    required String collectionType,
    required String referralToken,
    String? title,
  }) async {
    debugPrint("------------------------------------------------");
    debugPrint("🎯 ENTER setUniversalLinkingRoot()");
    debugPrint("🆔 ID = $id");
    debugPrint("📌 Type = $type");
    debugPrint("📚 CollectionType = $collectionType");
    debugPrint("🎫 ReferralToken = $referralToken");
    debugPrint("------------------------------------------------");

    await Future.delayed(const Duration(milliseconds: 100));

    debugPrint("🧹 Clearing navigation stack to BottomNavigation()");
    Get.until((route) => route.settings.name == AppRoutes.bottomNavigation);

    debugPrint("🚦 SWITCH → Deep link type = $type");

    switch (type) {
      case "2":
        debugPrint("🛍 Opening SHOP DETAIL page");
        Get.toNamed(
          AppRoutes.shopDetailView,
          arguments: {"shopId": id, 'productName': title},
        );
        break;

      case "3":
        debugPrint("📦 Opening PRODUCT DETAIL page");
        Get.toNamed(
          AppRoutes.productDetail,
          arguments: {"productId": id, 'productName': title},
        );
        break;

      case "4":
        debugPrint("📂 Opening CATEGORY PRODUCTS page");
        AppRoutes.goToProductListPage(
          brandId: '',
          prodCatId: id,
          productVideoAvailable: '0',
          titleHeader: title ?? '',
        );
        break;

      case "5":
        debugPrint("🏷 Opening BRAND PRODUCTS page");
        AppRoutes.goToProductListPage(
          brandId: id,
          prodCatId: '',
          productVideoAvailable: '0',
          titleHeader: title ?? '',
        );
        break;

      case "6":
        debugPrint("📚 Collection type switch → $collectionType");
        switch (collectionType) {
          case "1":
            debugPrint("🎯 Collection → Product Listing");
            AppRoutes.goToProductListPage(
              brandId: "",
              prodCatId: id,
              productVideoAvailable: "0",
              titleHeader: title ?? '',
            );
            break;

          case "2":
            debugPrint("📁 Collection → Category Listing");
            break;

          case "3":
            debugPrint("🏪 Collection → Shops Listing");
            AppRoutes.goToShopListViewPage(collectionId: id);
            break;

          case "4":
            debugPrint("🏷 Collection → Brand Listing");
            AppRoutes.goToBrandsListViewPage(collectionId: id, title: title);
            break;

          default:
            debugPrint("❓ Unknown collectionType → Returning Home");
        }
        break;

      case "7":
        debugPrint("📞 Opening CONTACT US page");
        Get.toNamed(AppRoutes.contactUsScreen);
        break;

      case "8":
        debugPrint("🔐 Opening LOGIN page");
        if (!isUserLoggedIn()) {
          Get.toNamed(AppRoutes.login);
        }
        break;

      case "9":
        debugPrint("📝 Opening REGISTER page");
        if (!isUserLoggedIn()) {
          if (referralToken.isNotEmpty) {
            debugPrint("💾 Saving referral token: $referralToken");
            saveReferralToken(referralToken);
          }
          Get.toNamed(AppRoutes.signUp);
        }
        break;

      case "11":
        debugPrint("📰 Opening BLOG DETAIL page");
        break;

      default:
        debugPrint("❓ UNKNOWN TYPE → Going HOME");
        break;
    }

    debugPrint("🏁 END setUniversalLinkingRoot()");
  }

  bool isUserLoggedIn() {
    return false;
  }

  void saveReferralToken(String token) {
    debugPrint("💾 Referral token saved → $token");
  }
}

class UserVerifier {
  Future<String?> verify(String url) async {
    try {
      Dio dio = Dio();

      Uri? finalURL;

      // Intercept redirect changes
      dio.interceptors.add(
        InterceptorsWrapper(
          onResponse: (response, handler) {
            // Dio automatically follows redirect
            // Track the last effective URL
            final effectiveUri = response.realUri;
            finalURL = effectiveUri;
            return handler.next(response);
          },
        ),
      );

      print("🌐 Requesting: $url");
      await dio.get(url);

      if (finalURL == null) {
        print("❌ No redirect detected");
        return null;
      }

      print("🔗 Final URL after redirects: $finalURL");

      // Extract token from ?r=TOKEN
      final token = finalURL!.queryParameters["r"];
      print("🎫 Extracted token: $token");

      return token;
    } catch (e) {
      print("❌ Dio error: $e");
      return null;
    }
  }
}

class DeepLinkService {
  DeepLinkService._();

  static final DeepLinkService instance = DeepLinkService._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  Future<void> init() async {
    debugPrint("🔗 DeepLinkService.init()");

    // Initialize required controllers
    if (!Get.isRegistered<AccountController>()) {
      Get.put(AccountController());
    }
    if (!Get.isRegistered<BottomNavController>()) {
      Get.put(BottomNavController());
    }

    // 1) Handle initial link (cold start)
    try {
      final initialUri = await _appLinks.getInitialAppLink();
      if (initialUri != null) {
        debugPrint("🚀 Initial deep link (cold start): $initialUri");
        if (_isUtmLink(initialUri)) {
          saveUTMData(initialUri);
          return; // ⛔ Stop normal deep link flow
        }
        // Delay slightly to allow GetX initialization
        Future.microtask(() => _handleUri(initialUri));
      } else {
        debugPrint("ℹ️ No initial deep link");
      }
    } catch (e) {
      debugPrint("❌ Error getting initial app link: $e");
    }

    // 2) Listen for new links while app is running (foreground/background)
    _sub = _appLinks.uriLinkStream.listen(
          (uri) {
        debugPrint("📥 Deep link received (stream): $uri");
        if (_isUtmLink(uri)) {
          saveUTMData(uri);
          return; // ⛔ Stop normal deep link flow
        }
        _waitUntilAppReady(uri);
      },
      onError: (err) {
        debugPrint("❌ uriLinkStream error: $err");
      },
    );
  }

  bool _isUtmLink(Uri uri) {
    return uri.queryParameters.keys.any((key) => key.startsWith("utm_"));
  }

  void _waitUntilAppReady(Uri uri) async {
    final url = uri.toString();
    /// EMPLOYEE FLOW SHOULD NOT WAIT
    if (url.contains("employee-registerations/confirm")) {
      debugPrint("⚡ Employee flow bypassing AppState wait");
      _handleUri(uri);
      return;
    }

    while (!AppState.isReady) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    await Future.delayed(const Duration(milliseconds: 200)); // ← ADD THIS
    _handleUri(uri);
  }

  void _handleUri(Uri uri) async {
    final url = uri.toString();
    deepLinkURL = url;
    debugPrint("🎯 Handling deep link URL: $url");

    /// EMPLOYEE FLOW
    if (url.contains("employee-registerations/confirm")) {

      isEmployeeVerificationFlow = true;

      while (!Get.isRegistered<SplashController>()) {
        await Future.delayed(const Duration(milliseconds: 50));
      }

      final splash = Get.find<SplashController>();

      splash.allowNavigation.value = false;

      debugPrint("⛔ Splash navigation disabled");
    }

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _handleDeepLink(url);
    });
  }

  /// Public method to handle a URL string from any file.
  /// Usage: DeepLinkService.instance.handleUrl('https://tajershops.com/...');
  void handleUrl(String urlString) {
    final uri = Uri.tryParse(urlString);
    if (uri != null) {
      _handleUri(uri);
    } else {
      debugPrint('❌ DeepLinkService.handleUrl: Invalid URL → $urlString');
    }
  }

  void dispose() {
    _sub?.cancel();
  }

  Future<void> _handleDeepLink(String url) async {
    print("🔥 Handle DeepLink → $url");

    // ensure BottomNavController exists
    final BottomNavController nav = Get.isRegistered<BottomNavController>()
        ? Get.find()
        : Get.put(BottomNavController());

    //reset password
    if (url.contains("/guest-user/reset-password/")) {
      debugPrint("🔐 Reset Password DeepLink");

      Get.toNamed(
        AppRoutes.webViewScreen,
        arguments: {
          AppParams.title: AppStrings.resetPassword.toUpperCase().tr,
          AppParams.webViewUrl: url,
        },
      );

      return;
    }

    // Affiliate Referral
    if (url.contains("/home/affiliate-referral/")) {
      try {
        final uri = Uri.parse(url);

        // Gets: 63089fab0be35
        final referralId = uri.pathSegments.last;

        if (referralId.isNotEmpty) {
          PrefStore().saveString("affiliate_referral_id", referralId);
          debugPrint("✅ Affiliate Referral ID Saved: $referralId");
        }
      } catch (e) {
        debugPrint("❌ Affiliate referral parse error: $e");
      }

      return;
    }

    if (AppState.isReady) {
      if (url.contains("/buyer/order-feedback")) {
        final currentToken = PrefStore().loadString(AppConstants.sessionToken) ?? "";
        if (currentToken.isNotEmpty) {
          if (Get.overlayContext == null) {
            await Future.delayed(Duration(milliseconds: 100));
          }
          nav.changeTab(4);
          final uri = Uri.parse(url);
          final segments = uri.pathSegments;

          final orderProductId = segments[3]; //order product id
          final orderId = segments[4]; //order id
          final selProdId = segments[5]; // sel product id

          Get.to(() =>
              OrderDetailsScreen(
                orderId: orderId,
                orderProductId: orderProductId,
                orderNumber: '',
                quantity: '1',
                selProdId: selProdId,
              ));
        }
        else {
          nav.changeTab(4);
          Get.offAllNamed(AppRoutes.login);

        }
        return;
      }
    }

    // EMAIL VERIFICATION
    if ((url.contains("guest-user/user-check-email-verification")) || (url.contains("guest-user/change-email-verification"))) {
      if (Get.overlayContext == null) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      OverlayLoader.show();
      //   nav.changeTab(4);
      final token = await UserVerifier().verify(url);
      OverlayLoader.hide();
      if (token != null) {
        PrefStore().saveString(AppConstants.sessionToken, token);
        AccountController accountCtrl;

        if (Get.isRegistered<AccountController>()) {
          accountCtrl = Get.find<AccountController>();
        } else {
          accountCtrl = Get.put(AccountController());
        }
        accountCtrl.token = token;
        accountCtrl.isLogin.value = true;
        // await accountCtrl.getProfileInfo();
        if (Get.currentRoute == AppRoutes.login ||
            Get.currentRoute == AppRoutes.signUp || Get.currentRoute == AppRoutes.registrationSuccessScreen || (url.contains("guest-user/change-email-verification"))){
          // Remove login/signup and go to account tab
          nav.changeTab(0);
          await Get.offAllNamed(
            AppRoutes.bottomNavigation,
            arguments: {"tab": 0}, // home tab index
          );

        }
        AppState.isReady = true;
        debugPrint('here is app ready 3');
      }
      return;
    }

    if (url.contains("employee-registerations/confirm")) {

      debugPrint("👨‍💼 Employee Registration DeepLink....$url");

      try {

        /// Prevent splash/home navigation
        if (Get.isRegistered<SplashController>()) {
          Get.find<SplashController>().allowNavigation.value = false;
        }

        final uri = Uri.parse(url);
        final path = uri.path.replaceFirst("/", "");

        debugPrint(" Employee url: $path");

        /// IMPORTANT:
        /// DO NOT WAIT FOR SPLASH
        Future.microtask(() async {

          while (!Get.isRegistered<SplashController>()) {
            await Future.delayed(const Duration(milliseconds: 100));
          }

          final splashController = Get.find<SplashController>();

          await splashController.employeeRegistrationStatus(path);

        });

      } catch (e) {
        debugPrint(" Employee deep link error: $e");
      }

      return;
    }

    // normal deeplinks
    nav.changeTab(0);
    redirectionURL = url;
    if (AppState.isReady == true) {
      debugPrint('this is universal navigation 1');
      await UrlHandling.shared.universalUrlDetailsAPI(redirectionURL);
    }
  }

  Future<void> _ensureBottomNavReady() async {
    if (Get.currentRoute != AppRoutes.bottomNavigation) {
      await Get.offAllNamed(AppRoutes.bottomNavigation);
    }

    // while (Get.currentRoute != AppRoutes.bottomNavigation) {
    //   await Future.delayed(const Duration(milliseconds: 150));
    // }
  }
}

Future<bool> isFreshInstall() async {
  final prefs = await SharedPreferences.getInstance();

  bool? alreadyLaunched = prefs.getBool('already_launched');

  if (alreadyLaunched == null) {
    // First launch
    await prefs.setBool('already_launched', true);
    return true;
  }

  return false;
}

Future<void> captureUtmFromClipboard() async {
  // ✅ Check if already captured once
  final isFirstInstall = PrefStore().loadBoolean("utm_captured") ?? false;

  if (isFirstInstall) {
    debugPrint("⛔ UTM already captured. Skipping.");
    return;
  }

  ClipboardData? clipboardData = await Clipboard.getData(Clipboard.kTextPlain);

  if (clipboardData == null ||
      clipboardData.text == null ||
      clipboardData.text!.isEmpty) {
    debugPrint("❌ Clipboard empty.");
    return;
  }

  final link = clipboardData.text!.trim();
  debugPrint("🔗 Clipboard Text: $link");

  try {
    final uri = Uri.tryParse(link);

    if (uri == null) {
      debugPrint("❌ Invalid URL format.");
      return;
    }
    saveUTMData(uri);
  } catch (e) {
    debugPrint("❌ URL parse error: $e");
  }
}

Future<void> saveUTMData(Uri uri) async {
  final hasUtm = uri.queryParameters.keys.any((key) => key.startsWith("utm_"));

  if (!hasUtm) {
    debugPrint("⛔ Not a UTM link. Skipping.");
    return;
  }

  final utmCampaign = uri.queryParameters["utm_campaign"];
  final utmSource = uri.queryParameters["utm_source"];
  final utmId = uri.queryParameters["utm_id"];

  if (utmCampaign?.isNotEmpty ?? false) {
    PrefStore().saveString("utm_campaign", utmCampaign!);
  }

  if (utmSource?.isNotEmpty ?? false) {
    PrefStore().saveString("utmSource", utmSource!);
  }

  if (utmId?.isNotEmpty ?? false) {
    PrefStore().saveString("utm_id", utmId!);
  }

  // ✅ Mark as captured (first install done)
  PrefStore().saveBoolean("utm_captured", true);

  debugPrint("✅ UTM Saved Successfully.");
  await AppAnalyticsService.setCampaignUserProperty();
}
