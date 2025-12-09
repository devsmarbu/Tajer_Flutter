// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:tajer/app/core/constants/app_constants.dart';
// import 'package:tajer/utils/pref_store.dart';
// import 'package:tajer/common/widgets/restart_widget.dart';
//
// import 'app/core/routes/app_routes.dart';
//
// class LocaleController extends GetxController {
//   final pref = PrefStore();
//
//   Rx<Locale> locale = const Locale('en', 'US').obs;
//   Rx<TextDirection> direction = TextDirection.ltr.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     loadSavedLocale();
//   }
//
//   /// Load saved language on start
//   void loadSavedLocale() {
//     final langCode = pref.loadString(AppConstants.languageCode) ?? "en";
//     final countryCode =
//         pref.loadString(AppConstants.languageCountryCode) ?? "US";
//
//     locale.value = Locale(langCode, countryCode);
//
//
//     // Apply RTL/LTR
//     _updateDirection(langCode);
//   }
//
//   Future<void> changeLocale(String langCode, String countryCode,String languageId) async {
//     await pref.saveString(AppConstants.languageCode, langCode);
//     await pref.saveString(AppConstants.languageId, languageId);
//     await pref.saveString(AppConstants.languageCountryCode, countryCode);
//
//     locale.value = Locale(langCode, countryCode);
//     _updateDirection(langCode);
//
//     Get.updateLocale(locale.value);
//
//     Future.delayed(Duration(milliseconds: 300), () {
//       Get.offAllNamed(AppRoutes.splash);
//     });
//   }
//
//   /// Detect RTL languages
//   void _updateDirection(String langCode) {
//     if (["ar", "he", "fa", "ur"].contains(langCode)) {
//       direction.value = TextDirection.rtl;
//     } else {
//       direction.value = TextDirection.ltr;
//     }
//   }
//
// }
