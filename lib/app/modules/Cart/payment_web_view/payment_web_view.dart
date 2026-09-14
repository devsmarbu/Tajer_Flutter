import 'package:get/get.dart';
import 'package:tajer/app/data/respository/order_success_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../../utils/pref_store.dart';
import '../../../Extensions/alert.dart';
import '../../../core/constants/app_constants.dart';
import '../../../modules/chatbot/controller/chatbot_controller.dart';

class PaymentWebProcessPage extends StatefulWidget {
  final String webUrl;
  final String orderId;
  final bool isFromGift;
  final String? tokenId;
  final String? userId;

  const PaymentWebProcessPage({
    super.key,
    required this.webUrl,
    required this.orderId,
    required this.isFromGift,
    this.tokenId,
    this.userId,
  });

  @override
  State<PaymentWebProcessPage> createState() => _PaymentWebProcessPageState();
}

class _PaymentWebProcessPageState extends State<PaymentWebProcessPage> {
  late final WebViewController controller;
  final orderRepository = Get.put(OrderSuccessRepository());
  final isLoading = false.obs;
  String tempToken = "";

  /// Guard flag — ensures Get.back() is only called once even if the user
  /// taps the back button rapidly or both system-back and the AppBar button
  /// fire simultaneously.
  bool _isClosing = false;

  @override
  void initState() {
    super.initState();

    // Defer the chatbot hide to post-frame — calling setPaymentPageActive()
    // synchronously here would update an Rx observable while the Obx in
    // MyRootApp is still building, causing a "setState during build" crash.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<ChatbotController>()) {
        Get.find<ChatbotController>().setPaymentPageActive(true);
      }
    });

    _setupWebView(); // <-- create controller FIRST

    _clearWebViewData().then((_) {
      _loadWebPage();
    });
  }

  @override
  void dispose() {
    // Restore chatbot visibility when leaving the payment page.
    if (Get.isRegistered<ChatbotController>()) {
      Get.find<ChatbotController>().setPaymentPageActive(false);
    }
    super.dispose();
  }

  Future<void> _clearWebViewData() async {
    final cookieManager = WebViewCookieManager();

    try {
      await cookieManager.clearCookies();
      debugPrint("🍪 Cookies cleared");

      await controller.clearCache();
      debugPrint("🧹 Cache cleared");
    } catch (e) {
      debugPrint("❌ Failed to clear cache/cookies: $e");
    }
  }

  void _setupWebView() {
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) => debugPrint("Loading: $url"),
          onNavigationRequest: (request) {
            final url = request.url;

            if (url.contains(PaymentConstant.success)) {
              debugPrint("this is the success URL: $url");
              _handleSuccess(url);
              return NavigationDecision.prevent;
            }
            if (url.contains(PaymentConstant.fail)) {
              debugPrint("this is the failed URL: $url");
              _handleFailure();
              return NavigationDecision.prevent;
            }
            if (url.contains(PaymentConstant.cancel)) {
              debugPrint("this is the cancelled URL: $url");
              _handleCancel();
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      );
  }

  void _loadWebPage() async {
    final postData = {
      "user_id": widget.userId,
      "_token": PrefStore().loadString(AppConstants.sessionToken) ?? "",
      "ttk": tempToken,
    };

    final encoded = postData.entries
        .map((e) => "${e.key}=${e.value}")
        .join("&");

    controller.loadRequest(
      Uri.parse("${widget.webUrl}?requestFromApi=1&tokenId=${widget.tokenId}"),
      method: LoadRequestMethod.post,
      headers: {"Content-Type": "application/x-www-form-urlencoded"},
      body: Uint8List.fromList(encoded.codeUnits),
    );
  }

  Future<void> deleteCartItem(String key, String fulfilmentType) async {
    isLoading(true);
    try {
      final response = await orderRepository.getTempToken();
      if (response?.status != "0") {
        tempToken = response?.data?.tempToken ?? "";
        _loadWebPage();
        print("✅ $response");
      } else {
        isLoading(false);
        showAlertMessage(
          Get.context!,
          title: "Error",
          message: response?.msg ?? "",
        );
      }
    } catch (e) {
      isLoading(false);
      print("❌ delete cart item fetch error: $e");
    }
  }

  /// Restores chatbot visibility before navigating away from this page.
  /// Called explicitly in every exit path so the icon reappears immediately,
  /// without depending on dispose() timing during route transitions.
  void _restoreChatbot() {
    if (Get.isRegistered<ChatbotController>()) {
      Get.find<ChatbotController>().setPaymentPageActive(false);
    }
  }

  /// Single exit point for all success/failure/cancel/back paths.
  /// The [_isClosing] guard prevents double-pop if the user taps quickly.
  void _exitPage(Map<String, dynamic> result) {
    if (_isClosing) return;
    _isClosing = true;
    _restoreChatbot();
    Navigator.of(context).pop(result);
  }

  void _handleSuccess(String url) {
    _exitPage({
      "status": "success",
      "orderId": widget.orderId,
      "isGift": widget.isFromGift,
    });
  }

  void _handleFailure() {
    _exitPage({"status": "failed", "orderId": widget.orderId});
  }

  void _handleCancel() {
    _exitPage({"status": "cancel", "orderId": widget.orderId});
  }

  /// Called by the AppBar back button and the system back gesture.
  /// Always exits the payment page — does NOT navigate within WebView history.
  /// Payment redirects (3DS, bank pages, etc.) should not be navigated back
  /// through, so we always treat back as "user cancelled / went back".
  void _onBackPressed() {
    _exitPage({
      "status": "back",
      "orderId": widget.orderId,
      "isGift": widget.isFromGift,
      "message": "User pressed back",
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        // didPop is always false here because canPop: false.
        // We handle the pop manually via _onBackPressed.
        if (!didPop) {
          _onBackPressed();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Payment",
            key: Key("payment_title"),
            style: TextStyle(
              fontFamily: "Nunito",
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          leading: IconButton(
            key: const Key("payment_back_button"),
            icon: const Icon(Icons.arrow_back),
            onPressed: _onBackPressed,
          ),
        ),
        body: Semantics(
          label: "Payment WebView",
          child: WebViewWidget(
            key: const Key("payment_webview"),
            controller: controller,
          ),
        ),
      ),
    );
  }
}

class PaymentConstant {
  static const success = "payment-success";
  static const fail = "payment-fail";
  static const cancel = "payment-cancel";
}
