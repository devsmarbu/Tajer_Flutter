import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tajer/app/modules/authentication/AppStoreUpdate/AppStoreUpdate.dart';
import 'package:tajer/app/modules/authentication/splash/models/employee_verification_data.dart';
import 'package:tajer/utils/app_loader.dart';
import '../../../../../common/functions/app_function.dart';
import '../../../../../common/widgets/app_dialog.dart';
import '../../../../../main_extension.dart';
import '../../../../../translations/localization_service.dart';
import '../../../../../utils/base_response.dart';
import '../../../../../utils/pref_store.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../data/service/api_service/api_service.dart';
import '../../../../data/service/splash_api_client.dart';
import '../../../../firebase/one_signal_notification.dart';
import '../../../chatbot/controller/chatbot_controller.dart';
import '../../../navigation/bottom_navigation.dart';
import '../../../orders/orderDetail/view/order_details_screen.dart';
import '../models/social_auth_status_model.dart';
import '../models/splash_data_model.dart';
import 'employee_verification_status.dart';

class GlobalLoader {
  static bool disable = false; // true only on SplashView
}

class SplashController extends GetxController with AppLoader {
  final _apiClient = SplashApiClient();
  final pref = PrefStore();
  final ApiService _api = ApiService();


  var isLoading = false.obs;
  var socialAuthStatus = Rxn<SocialAuthStatusModel>();
  var splashDataStatus = Rxn<SplashDataModel>();
  String currentToken = "";
  var needRestart = false.obs;
  var fromSplash = true.obs;
  var shouldStopVideo = false.obs;
  var allowNavigation = true.obs;


  @override
  void onReady() {
    super.onReady();
    debugPrint('THIS IS GETTING CALLED SPLASH CONTROLLER');
    startAllSplashApis();
    debugPrint('starting all apis');
  }

  /// Single entry point called from SplashView after 2s delay
  Future<void> startAllSplashApis() async {
    // isLoading.value = true;
    try {
      await fetchSocialAuthStatus();
    } catch (e) {
      debugPrint("❌ startAllSplashApis error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch social auth status (and if success, it will call fetchSplashScreenData internally)
  Future<void> fetchSocialAuthStatus() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        final response = await _apiClient.getStatus();
        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final common = BaseResponse<SocialAuthStatusModel>.fromJson(
          body,
          fromJsonT: (data) => SocialAuthStatusModel.fromJson(data),
        );

        if (common.status == AppConstants.ERROR) {
          Get.snackbar("Failed", common.msg);
          return;
        }

        if (common.isSuccess && common.data != null) {
          final socialAuth = common.data!;
          socialAuthStatus.value = socialAuth;

          // Save preferences
          await pref.saveString(
            AppConstants.currencySymbol,
            socialAuth.currencySymbol,
          );
          await pref.saveInt(
            AppConstants.googleLogin,
            socialAuth.status.googleLogin,
          );
          await pref.saveInt(
            AppConstants.appleLogin,
            socialAuth.status.appleLogin,
          );

          // Then fetch splash screen data (labels/downloads)
          await fetchSplashScreenData();
        } else {
          AppDialog.showMessage(common.msg);
        }
      } catch (e) {
        debugPrint('❌ Exception in fetchSocialAuthStatus: $e');
      }
    } else {
      // No internet — still try to handle redirection (maybe offline)
      debugPrint('handle redirection 8');
      handleRedirection();
    }
  }

  Future<void> fetchSplashScreenData() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        if (!fromSplash.value) {
          showLoader(Get.context!);
        }

        final response = await _apiClient.getSplashScreenData();
        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final common = BaseResponse<SplashDataModel>.fromJson(
          body,
          fromJsonT: (data) => SplashDataModel.fromJson(data),
        );

        if (common.responseCode == "200") {
          if (common.status == AppConstants.SUCCESS && common.data != null) {
            final splashData = common.data!;
            splashDataStatus.value = splashData;
            await setSplashData(splashData);
          } else if (common.status == AppConstants.LOGOUT) {
            await pref.clearAll();
            goToLoginSignUp();
          } else {
            AppDialog.showMessage(common.msg);
            debugPrint('handle redirection 1');
            handleRedirection();
          }
        } else {
          AppDialog.showMessage(common.msg);
          debugPrint('handle redirection 2');
          handleRedirection();
        }
      } catch (e) {
        debugPrint('❌ Exception in fetchSplashScreenData: $e');
        debugPrint('handle redirection 3');
        handleRedirection();
      }
    } else {
      debugPrint('handle redirection 4');
      handleRedirection();
    }
  }

  Future<void> employeeRegistrationStatus(String token) async {
    if (await AppFunction.isInternetAvailable()) {
      try {

        final response = await _apiClient.employeeRegistrationStatusApi(token);
        dynamic body = response.data;
        if (body is String) body = json.decode(body);

        final common = BaseResponse<EmployeeVerificationData>.fromJson(
          body,
          fromJsonT: (data) => EmployeeVerificationData.fromJson(data),
        );

        if (common.responseCode == "200") {

          final verificationStatus =
          EmployeeVerificationStatusExtension.fromString(
            common.data?.verificationStatus,
          );

          debugPrint("check verification status....$verificationStatus");
          final currentToken =
              PrefStore().loadString(AppConstants.sessionToken) ?? "";

          if (verificationStatus == EmployeeVerificationStatus.expired) {

            await Get.offAllNamed(
              AppRoutes.bottomNavigation,
              arguments: {
                "tab": 0,
                "msg": common.msg,
              },
            );
            isEmployeeVerificationFlow = false;
            return;

          }

          if(verificationStatus == EmployeeVerificationStatus.verified){
            await Get.offAllNamed(
              AppRoutes.bottomNavigation,
              arguments: {"tab": 4},
            );
            isEmployeeVerificationFlow=false;
            return;
          }

          if (verificationStatus ==
              EmployeeVerificationStatus.emailConfirmed) {

            await Get.offAllNamed(
              AppRoutes.employeeSuccessScreen,
              arguments: {
                "isEmployeeFlow": true,
              },
            );
            isEmployeeVerificationFlow=false;
            return;
          }


        } else {
         // AppDialog.showMessage(common.msg);

          if (currentToken.isNotEmpty) {
            //nav.changeTab(4);
            await Get.offAllNamed(
              AppRoutes.bottomNavigation,
              arguments: {"tab": 0,"msg": common.msg,},
            );
          } else {
            await Get.offAllNamed(
              AppRoutes.login,
              arguments: {
                "msg": common.msg,
              },
            );
          }
        }
      } catch (e) {
        handleRedirection();
      }
    }
  }

  Future<void> setSplashData(SplashDataModel splashData) async {

    if (splashData.defaultCountry != null) {
      await pref.saveString(
        AppConstants.countryCode,
        splashData.defaultCountry?.countryCode ?? "",
      );
    }

    if (splashData.confEnableChatBot != null) {
      await pref.saveString(
        AppConstants.enableChatBot,
        splashData.confEnableChatBot ?? "",
      );

      if (Get.isRegistered<ChatbotController>()) {
        Get.find<ChatbotController>().updateVisibility();
      }
    }

    if (splashData.appThemeSetting != null) {
      await pref.saveString(
        AppConstants.themeColor,
        splashData.appThemeSetting?.primaryThemeColor ?? "",
      );
      await pref.saveString(
        AppConstants.primaryInverseThemeColor,
        splashData.appThemeSetting?.primaryInverseThemeColor ?? "",
      );
      await pref.saveString(
        AppConstants.secondaryThemeColor,
        splashData.appThemeSetting?.secondaryThemeColor ?? "",
      );
      await pref.saveString(
        AppConstants.secondaryInverseThemeColor,
        splashData.appThemeSetting?.secondaryInverseThemeColor ?? "",
      );
      await pref.saveString(
        AppConstants.lightBgColor,
        splashData.appThemeSetting?.lightBgColor ?? "",
      );
    }

    await pref.saveString(
      AppConstants.newsletterEnabled,
      splashData.newsletterEnabled ?? "",
    );
    await pref.saveString(
      AppConstants.confSingleSellerCart,
      splashData.confSingleSellerCart ?? "",
    );
    await pref.saveString(
      AppConstants.isWishlistEnable,
      splashData.isWishlistEnable ?? "",
    );
    await pref.saveString(
      AppConstants.canAddReview,
      splashData.canAddReview ?? "",
    );
    await pref.saveString(AppConstants.canSendSms, splashData.canSendSms ?? "");
    await pref.saveString(
      AppConstants.confEnableGeoLocation,
      splashData.confEnableGeoLocation ?? "",
    );
    await pref.saveString(
      AppConstants.confEnableWithdrawals,
      splashData.confEnableWithdrawals ?? "",
    );
    await pref.saveString(
      AppConstants.confSigninWithPhoneEnable,
      splashData.confSigninWithPhoneEnable ?? "",
    );
    await pref.saveString(AppConstants.siteLangId, splashData.siteLangId ?? "");
    await pref.saveString(
      AppConstants.geoLocation,
      splashData.confEnableGeoLocation ?? "",
    );
    await pref.saveString(
      AppConstants.sessionId,
      splashData.appSessionId ?? "",
    );
    await pref.saveString(AppConstants.currencyId, splashData.currencyId ?? "");
    await pref.saveString(
      AppConstants.currencySymbol,
      splashData.currencySymbol ?? "",
    );
    await pref.saveString(
      AppConstants.confEnableForceUpdate,
      splashData.CONF_ENABLE_FORCE_UPDATE ?? "",
    );

    // Handle localization download
    final labels = splashData.languageLabels;
    if (labels != null && (labels.downloadUrl?.isNotEmpty ?? false)) {
      // Save language code (so LocalizationService can pick it up)
      await pref.saveString(
        AppConstants.languageCode,
        labels.languageCode ?? "en",
      );

      final langCode = labels.languageCode ?? "en";

      await OneSignalNotification.setLanguage(langCode);

      // For country code: prefer the language's country if present, else defaultCountry
      final countryCode =
          splashData.defaultCountry?.countryCode ??
          pref.loadString(AppConstants.languageCountryCode) ??
          "US";
      await pref.saveString(AppConstants.countryCode, countryCode);

      await LocalizationService.to.loadCurrentLocaleFile();
      // Download localization file and reload
      await downloadAndSaveLocalizationFile(labels.downloadUrl.toString());
    } else {
      // No labels to download -> just continue
      debugPrint('handle redirection 5');
      handleRedirection();
    }
  }

  Future<void> downloadAndSaveLocalizationFile(String fileUrl) async {
    try {
      if (fileUrl.isEmpty) return;

      final dir = await getApplicationDocumentsDirectory();
      final filePath = '${dir.path}/localization.json';
      final file = File(filePath);

      debugPrint("🌍 Downloading localization from: $fileUrl");

      final response = await _api.dio.get(fileUrl);

      if (response.statusCode == 200) {
        dynamic raw = response.data;
        if (raw is String) raw = json.decode(raw);

        if (raw is Map<String, dynamic>) {
          await file.writeAsString(json.encode(raw));

          await pref.saveString(AppConstants.localizationFilePath, filePath);

          // IMPORTANT: Load keys NOW
          await LocalizationService.to.loadCurrentLocaleFile();

          // update locale in GetMaterialApp
          final locale = LocalizationService.to.appLocale.value;
          Get.updateLocale(locale);

          debugPrint("🌍 Localization updated & UI refreshed");

          if (fromSplash.value) {
            debugPrint('handle redirection 6');
            handleRedirection();
          } else {
            hideLoader(Get.context!);
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Localization download error: $e");
      debugPrint('handle redirection 7');

      handleRedirection();
    }
  }

  /// Determine next screen
  void handleRedirection() async {
    debugPrint("🚦 handleRedirection called");

    if (isEmployeeVerificationFlow) {
      debugPrint("⛔ Employee flow active → skip splash redirection");
      return;
    }

    if (!allowNavigation.value) {
      debugPrint("⛔ Login navigation blocked");
      return;
    }

    currentToken = pref.loadString(AppConstants.sessionToken) ?? "";
    debugPrint("check current token..$currentToken");
    final skipped = pref.loadBoolean(AppConstants.skipForNow) ?? false;
    if (currentToken.isEmpty && !skipped) {
      if (deepLinkURL.contains('/guest-user/user-check-email-verification')) {
        debugPrint('it contains deepLink URL /guest-user/user-check-email-verification');
        goToHomeScreen();
        deepLinkURL = '';
      } else {
        debugPrint('it is coming here');
        goToLoginSignUp();
      }
    }
    else if (deepLinkURL.contains("/buyer/order-feedback")) {
      debugPrint('it contains deepLink URL buyer/order-feedback');
      goToFeedBackPage();
      deepLinkURL = '';
    }
    else if (deepLinkURL.contains("employee-registerations/confirm")) {
      debugPrint('it contains deepLink URL employee-registerations');
      return;
    }
    else {
      debugPrint('This should call only once.');
      goToHomeScreen();
    }
    final forceUpdate =
        pref.loadString(AppConstants.confEnableForceUpdate) == "1";
    Future.delayed(Duration(seconds: 5), () {
      AppUpdateService.instance.checkForUpdate(isForceUpdate: forceUpdate);
    });

    AppState.isReady = true;
  }

  void goToHomeScreen() {

    if (isEmployeeVerificationFlow) {
      debugPrint("⛔ Employee flow active → skip home");
      return;
    }

    if (Get.currentRoute == AppRoutes.bottomNavigation) {
      return;
    }

    Future.delayed(Duration(seconds: 4), () async {
      AppState.isReady = true;


      // If WebView is open, DO NOT reset navigation
      if (Get.currentRoute == AppRoutes.webViewScreen) {
        debugPrint("⚠️ WebView active. Skipping home navigation.");
        return;
      }
      if (!allowNavigation.value) return;

      if (Get.currentRoute == AppRoutes.bottomNavigation) {
        return;
      }

      shouldStopVideo.value = true;

      Get.offAllNamed(AppRoutes.bottomNavigation);
      debugPrint('here is app ready 1');

      if (redirectionURL != "") {
        await Future.delayed(Duration(seconds: 1));
        debugPrint('this is universal navigation 3');
        UrlHandling.shared.universalUrlDetailsAPI(redirectionURL);
        redirectionURL = "";
      }
    });
  }

  void goToLoginSignUp() {

    if (isEmployeeVerificationFlow) {
      debugPrint("⛔ Employee flow active → skip login/signup");
      return;
    }

    Future.delayed(Duration(seconds: 4), () async {
      AppState.isReady = true;
      if (!allowNavigation.value) return;
      debugPrint('here is app ready 1');
      if (Get.currentRoute == AppRoutes.login ||
          Get.currentRoute == AppRoutes.loginSignUp ||
          Get.currentRoute == AppRoutes.registrationSuccessScreen ||
          Get.currentRoute == AppRoutes.signUp ||
          Get.currentRoute == AppRoutes.webViewScreen) {
        return;
      }
      shouldStopVideo.value = true;
      final skipped = pref.loadBoolean(AppConstants.skipForNow) ?? false;

      if (!skipped) {
        Get.offAllNamed(AppRoutes.loginSignUp);
      }
      if (redirectionURL != "") {
        await Future.delayed(Duration(seconds: 1));
        debugPrint('this is universal navigation 3');
        UrlHandling.shared.universalUrlDetailsAPI(redirectionURL);
        redirectionURL = "";
      }
    });
  }

  void goToFeedBackPage() async {
    final BottomNavController nav = Get.isRegistered<BottomNavController>()
        ? Get.find()
        : Get.put(BottomNavController());
    final currentToken =
        PrefStore().loadString(AppConstants.sessionToken) ?? "";
    if (currentToken.isNotEmpty) {
      if (Get.overlayContext == null) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      nav.changeTab(4);
      final uri = Uri.parse(deepLinkURL);
      final segments = uri.pathSegments;

      final orderProductId = segments[3]; //order product id
      final orderId = segments[4]; //order id
      final selProdId = segments[5]; // sel product id

      Get.to(
        () => OrderDetailsScreen(
          orderId: orderId,
          orderProductId: orderProductId,
          orderNumber: '',
          quantity: '1',
          selProdId: selProdId,
        ),
      );
    } else {
      nav.changeTab(4);
      Get.offAllNamed(AppRoutes.login);
    }
    return;
  }
}


