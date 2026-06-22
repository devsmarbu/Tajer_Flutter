import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/modules/authentication/splash/view/splash_view.dart';
import 'app/modules/chatbot/controller/chatbot_controller.dart';
import 'app/modules/chatbot/view/chatbot_overlay.dart';
import 'common/widgets/restart_widget.dart';
import 'main_extension.dart';
import 'translations/localization_service.dart';
import 'app/core/routes/app_routes.dart';


class MyRootApp extends StatefulWidget {
  @override
  _MyRootAppState createState() => _MyRootAppState();
}

class _MyRootAppState extends State<MyRootApp> {

  @override
  void initState() {

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Future.delayed(const Duration(milliseconds: 150), () {
    //     AppState.isReady = true;
    //     debugPrint('here is app ready 2');
    //
    //   });
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final chatbotController = Get.find<ChatbotController>();

    return Obx(() {
      final locale = LocalizationService.to.appLocale.value;

      final isRTL = ["ar", "ur", "fa", "he"]
          .contains(locale.languageCode.toLowerCase());

      return GetMaterialApp(
        key: UniqueKey(),
        locale: locale,
        translations: LocalizationService.to,
        fallbackLocale: const Locale("en", "US"),
        debugShowCheckedModeBanner: false,
        //  initialRoute: AppRoutes.splash,
        home: SplashView(),
        unknownRoute: GetPage(name: "/splash", page: ()=>SplashView()),
        getPages: AppRoutes.routes,
        builder: (context, child) {
          return Directionality(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            child: Stack(
              children: [
                child!,
                Obx(() {
                  if (!chatbotController.isVisible.value) {
                    return const SizedBox.shrink();
                  }

                  return const ChatbotOverlay();
                }),
              ],
            ),
          );
        },
      );
    });
  }
}
