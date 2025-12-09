import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:tajer/utils/app_params.dart';
import 'package:flutter/material.dart';

class WebviewController extends GetxController {
  late final WebViewController webController;

  var isLoading = true.obs;
  var title = ''.obs;
  var webUrl = ''.obs;

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
  }

  void _initWebView() {
    webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => isLoading.value = true,
          onPageFinished: (_) => isLoading.value = false,
          onWebResourceError: (_) => isLoading.value = false,
        ),
      );
  }

  void loadUrlWhenReady() {
    try {
      webController.loadRequest(Uri.parse(webUrl.value));
    } catch (e) {
      debugPrint("LOAD ERROR: $e");
    }
  }
}
