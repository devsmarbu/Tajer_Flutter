import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../utils/pref_store.dart';
import '../app/core/constants/app_constants.dart';

class LocalizationService extends GetxService implements Translations {
  static LocalizationService get to => Get.find();

  final Rx<Locale> appLocale = const Locale("en", "US").obs;

  final Map<String, Map<String, String>> _localizedMap = {};

  @override
  Map<String, Map<String, String>> get keys => _localizedMap;

  Future<LocalizationService> init() async {
    await _loadSavedLocale();
    await loadCurrentLocaleFile();
    return this;
  }

  Future<void> _loadSavedLocale() async {
    final pref = PrefStore();
    final lang = pref.loadString(AppConstants.languageCode) ?? "en";
    final country = pref.loadString(AppConstants.languageCountryCode) ?? "US";
    appLocale.value = Locale(lang, country);
  }

  Future<void> loadCurrentLocaleFile() async {
    final pref = PrefStore();
    final filePath = pref.loadString(AppConstants.localizationFilePath);

    if (filePath == null || filePath.isEmpty) return;

    final file = File(filePath);
    if (!file.existsSync()) return;

    try {
      final jsonStr = await file.readAsString();
      final decoded = json.decode(jsonStr);

      final localeKey =
          "${appLocale.value.languageCode}_${appLocale.value.countryCode}";

      final converted = <String, String>{};

      (decoded as Map<String, dynamic>).forEach((key, value) {
        converted[key] = value.toString();
      });

      // IMPORTANT: Don't clear all languages — only update this locale
      _localizedMap[localeKey] = converted;

      // Tell GetX to refresh translations
      Get.updateLocale(appLocale.value);

      debugPrint("✅ Translations updated for $localeKey");

    } catch (e) {
      debugPrint("❌ Error loading localization: $e");
    }
  }

  Future<void> changeLocale(Locale locale) async {
    final pref = PrefStore();
    await pref.saveString(AppConstants.languageCode, locale.languageCode);
    await pref.saveString(AppConstants.languageCountryCode,
        locale.countryCode ?? "US");

    appLocale.value = locale;

    await loadCurrentLocaleFile();
    Get.updateLocale(locale);
  }
}

