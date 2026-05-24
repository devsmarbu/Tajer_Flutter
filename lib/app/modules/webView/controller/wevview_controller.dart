import 'package:get/get.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tajer/utils/app_params.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:tajer/app/core/routes/app_routes.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tajer/utils/app_params.dart';
import 'package:flutter/material.dart';

class WebviewController extends GetxController {
  late final WebViewController webController;

  var isLoading = true.obs;
  var title = ''.obs;
  var webUrl = ''.obs;

  bool _isPageLoadedOnce = false;

  @override
  void onInit() {
    super.onInit();

    title.value = Get.arguments[AppParams.title] ?? '';
    webUrl.value = Get.arguments[AppParams.webViewUrl] ?? '';

    _initWebView();
  }

  @override
  void onReady() {
    super.onReady();

    // Load URL AFTER view is fully attached
    Future.delayed(const Duration(milliseconds: 100), () {
      loadUrlWhenReady();
    });

    // 👇 Safety fallback (prevents infinite loader)
    Future.delayed(const Duration(seconds: 10), () {
      if (isLoading.value) {
        isLoading.value = false;
      }
    });
  }


  void _initWebView() {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            if (!_isPageLoadedOnce) {
              isLoading.value = true;
            }
          },

          onPageFinished: (url) async {
            // 👇 Prevent multiple triggers due to redirects
            if (!_isPageLoadedOnce) {
              isLoading.value = false;
              _isPageLoadedOnce = true;
            }

           // Get.snackbar("Success URL finished", url);
            debugPrint("Success URL finished: $url");

            // 👇 Run JS after slight delay (avoids UI blocking)
            Future.delayed(const Duration(milliseconds: 300), () async {
              try {
                final result = await webController
                    .runJavaScriptReturningResult(
                    "document.body.innerText");

                if (result
                    .toString()
                    .contains("Password reset successful")) {
                  _handleSuccess();
                }
              } catch (e) {
                debugPrint("JS ERROR: $e");
              }
            });
          },

          onNavigationRequest: (request) {
           // Get.snackbar("Success URL", request.url);
            debugPrint("Success URL: ${request.url}");

            if (request.url.contains("/guest-user/login-form")) {
              isLoading.value = false; // 👈 stop loader immediately
              _handleSuccess();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },

          onWebResourceError: (_) {
            isLoading.value = false;
          },
        ),
      );
  }

  void _handleSuccess() {
    Get.snackbar("Success", "Password reset successful");
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.offAllNamed(AppRoutes.login);
    });
  }

  void loadUrlWhenReady() {
    try {
      final webViewURL = '${webUrl.value}?requestFromApi=1';
      webController.loadRequest(Uri.parse(webViewURL));
    } catch (e) {
      debugPrint("LOAD ERROR: $e");
    }
  }
}
