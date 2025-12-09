import 'package:get/get.dart';
import 'package:tajer/app/data/respository/order_success_repository.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';

import '../../../../utils/pref_store.dart';
import '../../../Extensions/alert.dart';
import '../../../core/constants/app_constants.dart';

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

  @override
  void initState() {
    super.initState();

    _setupWebView();        // <-- create controller FIRST

    _clearWebViewData().then((_) {
      _loadWebPage();
    });
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
      "_token": PrefStore().loadString(AppConstants.sessionToken)??"",
      "ttk": tempToken,
    };

    final encoded = postData.entries
        .map((e) => "${e.key}=${e.value}")
        .join("&");

    controller.loadRequest(
      Uri.parse("${widget.webUrl}?requestFromApi=1&tokenId=${widget.tokenId}"),
      method: LoadRequestMethod.post,
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
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


  void _handleSuccess(String url) {
    // final orderId = url.split("/").last;

    Get.back(result: {
      "status": "success",
      "orderId": widget.orderId,
      "isGift": widget.isFromGift,
    });

  }

  void _handleFailure() {
    Get.back(result: {
      "status": "failed",
      "orderId": widget.orderId,
    });
  }

  void _handleCancel() {
    Get.back(result: {
      "status": "cancel",
      "orderId": widget.orderId,
    });
  }

  void _onBackPressed() {
    Get.back(result: {
      "status": "back",
      "orderId": widget.orderId,
      "isGift": widget.isFromGift,
      "message": "User pressed back",
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // prevent default pop
      onPopInvoked: (didPop) {
        if (!didPop) {
          _onBackPressed(); // return params using Get.back()
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Payment",style: TextStyle(fontFamily: "Nunito",fontWeight: FontWeight.w600,fontSize: 16)),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _onBackPressed,
          ),
        ),
        body: WebViewWidget(controller: controller),
      ),
    );
  }
  }

  class PaymentConstant {
  static const success = "payment-success";
  static const fail = "payment-fail";
  static const cancel = "payment-cancel";
}