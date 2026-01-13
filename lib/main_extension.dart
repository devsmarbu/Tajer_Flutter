import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData;
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/navigation/bottom_navigation.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/pref_store.dart';
import 'app/core/routes/app_routes.dart';
import 'package:app_links/app_links.dart';

import 'app/modules/Account/controller/account_controller.dart';

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
      final formData = FormData.fromMap({"url": linkUrl});

      final response = await _dio.post(
          "${AppConstants.baseUrl}home/get-url-segments-detail",
          data: formData,
          options: Options(
              contentType: Headers.multipartFormDataContentType
          )
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
        Get.toNamed(AppRoutes.shopDetailView, arguments: {"shopId": id});
        break;

      case "3":
        debugPrint("📦 Opening PRODUCT DETAIL page");
        Get.toNamed(AppRoutes.productDetail, arguments: {"productId": id});
        break;

      case "4":
        debugPrint("📂 Opening CATEGORY PRODUCTS page");
        Get.toNamed(AppRoutes.productListPage, arguments: {"prodCatId": id});
        AppRoutes.goToProductListPage(brandId: '', prodCatId: id, productVideoAvailable: '0', titleHeader: '');
        break;

      case "5":
        debugPrint("🏷 Opening BRAND PRODUCTS page");
        AppRoutes.goToProductListPage(brandId: id, prodCatId: '', productVideoAvailable: '0', titleHeader: '');
        break;

      case "6":
        debugPrint("📚 Collection type switch → $collectionType");
        switch (collectionType) {
          case "1":
            debugPrint("🎯 Collection → Product Listing");
            AppRoutes.goToProductListPage(brandId: "", prodCatId: id, productVideoAvailable: "0", titleHeader: "");
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
            AppRoutes.goToBrandsListViewPage(collectionId: id);
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
        _waitUntilAppReady(uri);
      },
      onError: (err) {
        debugPrint("❌ uriLinkStream error: $err");
      },
    );
  }

  void _waitUntilAppReady(Uri uri) async {
    while (!AppState.isReady) {
      await Future.delayed(const Duration(milliseconds: 200));
    }
    await Future.delayed(const Duration(milliseconds: 100)); // ← ADD THIS
    _handleUri(uri);
  }

  void _handleUri(Uri uri) {
    final url = uri.toString();
    debugPrint("🎯 Handling deep link URL: $url");

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _handleDeepLink(url);
    });
  }

  void dispose() {
    _sub?.cancel();
  }


  Future<void> _handleDeepLink(String url) async {
    print("🔥 Handle DeepLink → $url");

    // ensure BottomNavController exists
    final BottomNavController nav =
    Get.isRegistered<BottomNavController>() ? Get.find() : Get.put(BottomNavController());

    // EMAIL VERIFICATION
    if (url.contains("guest-user/user-check-email-verification")) {
      nav.changeTab(4); // account tab

      final token = await UserVerifier().verify(url);
      if (token != null) {
        PrefStore().saveString(AppConstants.sessionToken, token);

        final accountCtrl = Get.find<AccountController>();
        accountCtrl.token = token;
        accountCtrl.isLogin.value = true;
        await accountCtrl.getProfileInfo();

        AppState.isReady = true;

        // go directly to account tab
        Get.offAllNamed(AppRoutes.bottomNavigation, arguments: {"tab": 4});
      }
      return;
    }

    // normal deeplinks
    nav.changeTab(0);
    await UrlHandling.shared.universalUrlDetailsAPI(url);
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


class AppState {
  static bool isReady = false;
}


