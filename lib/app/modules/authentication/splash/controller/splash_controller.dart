import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tajer/app/modules/authentication/AppStoreUpdate/AppStoreUpdate.dart';
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
import '../../../../data/service/api_service/api_service.dart';
import '../models/social_auth_status_model.dart';
import '../models/splash_data_model.dart';

class SplashController extends GetxController with AppLoader {
  final _apiClient = SplashApiClient();
  final pref = PrefStore();
  final ApiService _api = ApiService();

  var isLoading = false.obs;
  var socialAuthStatus = Rxn<SocialAuthStatusModel>();
  var splashDataStatus = Rxn<SplashDataModel>();
  String currentToken = "";
  var needRestart = false.obs;
  var fromSplash=true.obs;



  /// Single entry point called from SplashView after 2s delay
  Future<void> startAllSplashApis() async {
    isLoading.value = true;
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
          await pref.saveString(AppConstants.currencySymbol, socialAuth.currencySymbol);
          await pref.saveInt(AppConstants.googleLogin, socialAuth.status.googleLogin);
          await pref.saveInt(AppConstants.appleLogin, socialAuth.status.appleLogin);

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
      handleRedirection();
    }
  }

  Future<void> fetchSplashScreenData() async {
    if (await AppFunction.isInternetAvailable()) {
      try {
        if(!fromSplash.value){
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
            handleRedirection();
          }
        } else {
          AppDialog.showMessage(common.msg);
          handleRedirection();
        }
      } catch (e) {
        debugPrint('❌ Exception in fetchSplashScreenData: $e');
        handleRedirection();
      }
    } else {
      handleRedirection();
    }
  }

  Future<void> setSplashData(SplashDataModel splashData) async {
    if (splashData.defaultCountry != null) {
      await pref.saveString(AppConstants.countryCode, splashData.defaultCountry?.countryCode ?? "");
    }

    if (splashData.appThemeSetting != null) {
      await pref.saveString(AppConstants.themeColor, splashData.appThemeSetting?.primaryThemeColor ?? "");
      await pref.saveString(AppConstants.primaryInverseThemeColor, splashData.appThemeSetting?.primaryInverseThemeColor ?? "");
      await pref.saveString(AppConstants.secondaryThemeColor, splashData.appThemeSetting?.secondaryThemeColor ?? "");
      await pref.saveString(AppConstants.secondaryInverseThemeColor, splashData.appThemeSetting?.secondaryInverseThemeColor ?? "");
      await pref.saveString(AppConstants.lightBgColor, splashData.appThemeSetting?.lightBgColor ?? "");
    }

    await pref.saveString(AppConstants.newsletterEnabled, splashData.newsletterEnabled??"");
    await pref.saveString(AppConstants.confSingleSellerCart, splashData.confSingleSellerCart??"");
    await pref.saveString(AppConstants.isWishlistEnable, splashData.isWishlistEnable??"");
    await pref.saveString(AppConstants.canAddReview, splashData.canAddReview??"");
    await pref.saveString(AppConstants.canSendSms, splashData.canSendSms??"");
    await pref.saveString(AppConstants.confEnableGeoLocation, splashData.confEnableGeoLocation??"");
    await pref.saveString(AppConstants.confEnableWithdrawals, splashData.confEnableWithdrawals??"");
    await pref.saveString(AppConstants.siteLangId, splashData.siteLangId??"");
    await pref.saveString(AppConstants.geoLocation, splashData.confEnableGeoLocation??"");
    await pref.saveString(AppConstants.sessionId, splashData.appSessionId??"");
    await pref.saveString(AppConstants.currencyId, splashData.currencyId??"");
    await pref.saveString(AppConstants.currencySymbol, splashData.currencySymbol??"");
    await pref.saveString(AppConstants.confEnableForceUpdate, splashData.CONF_ENABLE_FORCE_UPDATE??"");

    // Handle localization download
    final labels = splashData.languageLabels;
    if (labels != null && (labels.downloadUrl?.isNotEmpty ?? false)) {
      // Save language code (so LocalizationService can pick it up)
      await pref.saveString(AppConstants.languageCode, labels.languageCode ?? "en");

      // For country code: prefer the language's country if present, else defaultCountry
      final countryCode = splashData.defaultCountry?.countryCode ?? pref.loadString(AppConstants.languageCountryCode) ?? "US";
      await pref.saveString(AppConstants.countryCode, countryCode);

      await LocalizationService.to.loadCurrentLocaleFile();
      // Download localization file and reload
      await downloadAndSaveLocalizationFile(labels.downloadUrl.toString());
    } else {
      // No labels to download -> just continue
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
            handleRedirection();
          }else{
            hideLoader(Get.context!);
          }
        }
      }
    } catch (e) {
      debugPrint("❌ Localization download error: $e");
      handleRedirection();
    }
  }



  /// Determine next screen
  void handleRedirection() async {
    currentToken = pref.loadString(AppConstants.sessionToken) ?? "";
    final skipped = pref.loadBoolean(AppConstants.skipForNow) ?? false;
    final forceUpdate = pref.loadString(AppConstants.confEnableForceUpdate) == "1";
    AppUpdateService.instance.checkForUpdate(isForceUpdate: forceUpdate);
    if (currentToken.isEmpty && !skipped) {
      goToLoginSignUp();
    } else {
      goToHomeScreen();
    }
  }

  void goToHomeScreen() {
    Future.delayed(Duration(seconds: 2), () {
      AppState.isReady = true;   // 👈 App ready!
      Get.offAllNamed(AppRoutes.bottomNavigation);
    });
    // Get.offAllNamed(AppRoutes.bottomNavigation);
  }

  void goToLoginSignUp() {
    Get.offAllNamed(AppRoutes.loginSignUp);
  }
}
