import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/modules/Account/models/language.dart';
import 'package:tajer/utils/app_loader.dart';
import 'package:tajer/utils/app_strings.dart';
import '../../../../../utils/app_colors.dart';
import '../../../translations/localization_service.dart';
import '../../../utils/app_params.dart';
import '../../../utils/pref_store.dart';
import '../authentication/splash/controller/splash_controller.dart';

class ChangeLanguagePopover extends StatefulWidget with AppLoader{
  final List<Language> languages;
  final pref = PrefStore();

  ChangeLanguagePopover({
    Key? key,
    required this.languages,
  }) : super(key: key);

  @override
  State<ChangeLanguagePopover> createState() => _ChangeLanguagePopoverState();
}

class _ChangeLanguagePopoverState extends State<ChangeLanguagePopover> {
  String? selectedLanguage;

  @override
  void initState() {
    super.initState();

    if (widget.languages.isNotEmpty) {
      selectedLanguage = widget.languages.first.languageName;

      // Load saved language
      final savedLangId = widget.pref.loadString(AppConstants.languageId);
      for (var lang in widget.languages) {
        if (lang.languageId == savedLangId) {
          selectedLanguage = lang.languageName;
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.only(top: 16, bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.app_change_language.tr,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Nunito",
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close, color: Colors.black, size: 26),
                ),
              ],
            ),
          ),
          const Divider(),

          // Language List
          ...widget.languages.map((lang) {
            return RadioListTile<String>(
              value: lang.languageName,
              groupValue: selectedLanguage,
              onChanged: (value) async {
                setState(() => selectedLanguage = value);
                await widget.pref.saveString(AppConstants.languageCode, lang.languageCode);
                await widget.pref.saveString(AppConstants.languageId, lang.languageId);
                await widget.pref.saveString(AppConstants.languageCountryCode,
                    lang.languageCountryCode ?? "US");

                // safe get or put
                final controller = Get.isRegistered<SplashController>()
                    ? Get.find<SplashController>()
                    : Get.put(SplashController(), permanent: true);

                controller.fromSplash.value = false;

                // 1️⃣ Change locale
                await LocalizationService.to.changeLocale(
                  Locale(lang.languageCode, lang.languageCountryCode ?? "US"),
                );
                Get.back();

                await controller.fetchSplashScreenData();
                await LocalizationService.to.loadCurrentLocaleFile();

                await PrefStore().saveBoolean(AppParams.refreshHome, true);
              },
              title: Text(
                lang.languageName,
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: "Nunito",
                  fontWeight: FontWeight.w500,
                ),
              ),
              activeColor: AppColors.black1,
            );
          }),
        ],
      ),
    );
  }
}
