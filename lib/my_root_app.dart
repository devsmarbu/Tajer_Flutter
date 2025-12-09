import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'common/widgets/restart_widget.dart';
import 'translations/localization_service.dart';
import 'app/core/routes/app_routes.dart';

class MyRootApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final locale = LocalizationService.to.appLocale.value;

      final isRTL = ["ar", "ur", "fa", "he"]
          .contains(locale.languageCode.toLowerCase());

      return GetMaterialApp(
        key: Key(DateTime.now().millisecondsSinceEpoch.toString()), // ensures rebuild
        locale: locale,
        translations: LocalizationService.to,
        fallbackLocale: const Locale("en", "US"),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoutes.splash,
        getPages: AppRoutes.routes,
        builder: (context, child) {
          return Directionality(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            child: child!,
          );
        },
      );
    });
  }
}
