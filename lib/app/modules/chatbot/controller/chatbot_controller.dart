import 'dart:convert';

import 'package:flutter/material.dart' show Colors;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/widgets.dart' show Locale, Rect;
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';

import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/app/data/respository/cart_listing_repository.dart';
import 'package:tajer/app/data/service/order_success_api_client.dart';
import 'package:tajer/app/modules/Account/controller/account_controller.dart';
import 'package:tajer/app/modules/Cart/cart_shipping/regular_products/regular_product_controller.dart';
import 'package:tajer/translations/localization_service.dart';
import 'package:tajer/utils/pref_store.dart';

/// Drives the embedded Tajer web chatbot inside a transparent, full-screen
/// [WebView]. The chatbot renders its OWN floating bubble/panel directly (same
/// as the website); this controller only injects config, syncs app state, and
/// tracks the widget's live bounds so the overlay can make just that region
/// interactive while letting every other touch fall through to the app.
class ChatbotController extends GetxController {
  static const String _chatOrigin = 'https://chatbot.tajershops.com';
  static const String _version = '2026060499';
  static const String _bridgeChannel = 'TajerBridge';
  static const String _assetPath = 'assets/chatbot_html/index.html';
  final isVisible = false.obs;

  /// True while [PaymentWebProcessPage] is on screen — chatbot must be hidden
  /// during payment to avoid WebView overlay conflicts.
  final isOnPaymentPage = false.obs;

  final _pref = PrefStore();
  final OrderSuccessApiClient _orderApi = OrderSuccessApiClient();

  WebViewController? webController;

  final isLoading = true.obs; // webview still loading?
  final isReady = false.obs; // widget initialized?

  /// Live bounding box (in logical pixels) of the chatbot's visible UI, as
  /// reported by the page. `null` => nothing visible / not interactive.
  final Rx<Rect?> widgetRect = Rx<Rect?>(null);

  /// Whether the chat panel is open (vs just the floating bubble). When open we
  /// make the whole WebView interactive so the message input reliably receives
  /// taps/typing; when closed only the bubble region is interactive.
  final isChatOpen = false.obs;

  @override
  void onInit() {
    super.onInit();
    updateVisibility();
    _createWebView();
    _bindAppStateListeners();
  }


  void updateVisibility() {
    final enableChatBot =
        PrefStore().loadString(AppConstants.enableChatBot) ?? "0";

    isVisible.value = enableChatBot == "1" && !isOnPaymentPage.value;

    debugPrint("🤖 Chatbot visible = ${isVisible.value} (enableChatBot=$enableChatBot, onPaymentPage=${isOnPaymentPage.value})");
  }

  /// Called by [PaymentWebProcessPage] to hide/restore the chatbot overlay
  /// while the payment WebView is active.
  void setPaymentPageActive(bool active) {
    isOnPaymentPage.value = active;
    updateVisibility();
  }


  // ---------------------------------------------------------------------------
  // WebView setup
  // ---------------------------------------------------------------------------

  /// Website host for the current environment (e.g. beta.tajershops.com).
  String get _webHost {
    final uri = Uri.tryParse(AppConstants.baseUrl);
    return (uri != null && uri.host.isNotEmpty) ? uri.host : 'beta.tajershops.com';
  }

  void _createWebView() {
    isLoading.value = true;
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        _bridgeChannel,
        onMessageReceived: (msg) => _onBridgeMessage(msg.message),
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            isLoading.value = false;
            _injectInit();
          },
          onWebResourceError: (_) => isLoading.value = false,
        ),
      );

    webController = controller;
    _enableFileUpload(controller);
    _loadHost(controller);
  }

  /// Wire the native photo/file picker into the WebView's HTML file input
  /// (`<input type="file">`) so the chat's "change my photo" upload works.
  /// Without this, tapping the file input does nothing on Android.
  void _enableFileUpload(WebViewController controller) {
    final platform = controller.platform;
    if (platform is AndroidWebViewController) {
      platform.setOnShowFileSelector(_onShowFileSelector);
    }
  }

  Future<List<String>> _onShowFileSelector(FileSelectorParams params) async {
    try {
      final image = await ImagePicker()
          .pickImage(source: ImageSource.gallery, imageQuality: 85);
      if (image == null) return const [];
      return [Uri.file(image.path).toString()];
    } catch (e) {
      debugPrint('Chatbot: file selector failed: $e');
      return const [];
    }
  }

  Future<void> _loadHost(WebViewController controller) async {
    try {
      final html = await rootBundle.loadString(_assetPath);
      // Host the page on the WEBSITE origin (e.g. beta.tajershops.com), exactly
      // like the real site does. This makes the chat's website API calls
      // (addresses, orders, wishlist, token-refresh) SAME-origin so they carry
      // the logged-in session cookie. The chatbot ES module is imported
      // cross-origin from chatbot.tajershops.com — which the website already
      // does successfully.
      await controller.loadHtmlString(html, baseUrl: 'https://$_webHost/');
    } catch (e) {
      debugPrint('Chatbot: failed to load host page: $e');
      isLoading.value = false;
    }
  }

  /// Establishes a logged-in WEBSITE session directly inside the CHAT WebView
  /// via a same-origin `fetch` of the temp-token SSO (`_token` + `ttk`, the same
  /// mechanism the payment web view uses). Because the chat is hosted on the
  /// website origin, this POST is same-origin and its Set-Cookie (PHPSESSID)
  /// lands in the chat WebView's own cookie store — so the chat's subsequent
  /// website calls (orders/addresses/wishlist) are authenticated. No reload, so
  /// the chat login is preserved.
  Future<void> _establishWebsiteSession() async {
    if (!_isLoggedIn || webController == null) return;
    final token = _pref.loadString(AppConstants.sessionToken) ?? '';
    if (token.isEmpty) return;
    final ttk = await _fetchAuthToken();
    if (ttk.isEmpty) return;
    final userId = _pref.loadString(AppConstants.userId) ?? '';
    final body = 'user_id=$userId&_token=$token&ttk=$ttk';

    // SSO POST establishes a live logged-in WEBSITE session cookie in the chat
    // WebView, so the chatbot's server-side token re-exchange can authenticate
    // the user's data calls.
    final js =
        "fetch('https://$_webHost/?requestFromApi=1',{method:'POST',"
        "headers:{'Content-Type':'application/x-www-form-urlencoded'},"
        "body:'$body',credentials:'include'})"
        ".then(function(r){return r.text();}).catch(function(){});";
    try {
      await webController!.runJavaScript(js);
    } catch (e) {
      debugPrint('Chatbot: website SSO failed: $e');
    }
  }

  Future<void> _injectInit() async {
    if (webController == null) return;
    final cfg = await _buildConfig();
    try {
      await webController!.runJavaScript('window.__initChatbot(${jsonEncode(cfg)});');
    } catch (e) {
      debugPrint('Chatbot: init injection failed: $e');
    }
  }

  // ---------------------------------------------------------------------------
  // Config (matches the web embed's chatbotConfig)
  // ---------------------------------------------------------------------------

  Future<Map<String, dynamic>> _buildConfig() async {
    final token = await _fetchAuthToken();
    final langCode = _pref.loadString(AppConstants.languageCode) ?? 'en';

    return {
      'apiBase': '$_chatOrigin?v=$_version',
      'chatbotUrl': '$_chatOrigin/tajer-chatbot.es.js?v=$_version',
      'position': 'bottom-right',
      'theme': 'light',
      'language': langCode,
      'primaryColor': '#0069ff',
      'countryId': _asInt(_pref.loadString(AppConstants.countryId), 173),
      'countryCode': _pref.loadString(AppConstants.countryCode) ?? 'QA',
      'currencyId': _asInt(_pref.loadString(AppConstants.currencyId), 1),
      'currencySymbol': _pref.loadString(AppConstants.currencySymbol) ?? 'QR',
      'token': token,
      'phpSessionId': _pref.loadString('PHPSESSID') ?? '',
      'mobileBottomOffset': 90, // lift the bubble above the bottom nav bar
      'cartCount': _asInt(cartItemCounts.value, 0),
      'isGuest': !_isLoggedIn,
      'storeInfo': {
        'name': 'Tajer',
        'phone': '+974 5208 8820',
        'whatsapp': '+974 5208 8820',
        'email': 'help@tajershops.com',
        'hours': 'Sun-Thu 8:30AM-5:00PM, Ramadan: Sun-Thu 9:30AM-3:30PM',
        'location': 'Doha, Qatar',
        'website': 'https://$_webHost', // env-aware (beta or production)
        'instagram': 'https://instagram.com/tajershops',
        'facebook': 'https://facebook.com/tajershops',
        'returnPolicy':
            '7 days return, 14 days exchange, items must be unused in original packaging',
        'shippingPolicy':
            'Delivery across Qatar and GCC, select international shipping available',
      },
    };
  }

  bool get _isLoggedIn =>
      (_pref.loadString(AppConstants.sessionToken) ?? '').isNotEmpty;

  /// The widget authenticates with a temp-token (same as the web embed).
  /// Guests get an empty token.
  Future<String> _fetchAuthToken() async {
    if (!_isLoggedIn) return '';
    try {
      final response = await _orderApi.getTempToken();
      final data = response.data;
      if (data is Map) {
        final inner = data['data'];
        if (inner is Map) {
          final tk = inner['tempToken'] ?? inner['token'];
          if (tk != null) return tk.toString();
        }
      }
    } catch (e) {
      debugPrint('Chatbot: temp-token fetch failed: $e');
    }
    return '';
  }

  // ---------------------------------------------------------------------------
  // Widget -> app bridge
  // ---------------------------------------------------------------------------

  void _onBridgeMessage(String raw) {
    Map<String, dynamic> data;
    try {
      data = jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return;
    }

    final type = data['type'];
    // `bounds` fires several times a second — keep it out of the log.
    if (type != 'bounds') {
      // ignore: avoid_print
      print('[CHATBOT-BRIDGE] <- $raw');
    }

    switch (type) {
      case 'page-ready':
        _injectInit();
        break;
      case 'ready':
        isReady.value = true;
        // If the app is already logged in, make sure the chat reflects it and
        // has a website session for orders/addresses/wishlist.
        if (_isLoggedIn) {
          _pushAppLoginToChat();
          _establishWebsiteSession();
        }
        break;
      case 'bounds':
        _onBounds(data);
        break;
      case 'evt':
        _onWidgetEvent(data['name'] as String?, data['detail']);
        break;
      case 'chat-state':
        _onChatState(data['open'] == true);
        break;
      case 'cookie':
        // ignore: avoid_print
        print('[CHATBOT-COOKIE] ${data['cookie']}');
        break;
      case 'login-required':
        Get.find<AccountController>().login();
        break;
      case 'error':
        debugPrint('Chatbot JS error: ${data['message']}');
        break;
    }
  }

  /// Handles the DOM events the widget actually fires (captured globally in the
  /// page via a dispatchEvent hook).
  void _onWidgetEvent(String? name, dynamic detail) {
    if (name == null) return;
    // Ignore the events we dispatch ourselves (outbound echoes).
    if (name.startsWith('tajer:site-') || name == 'tajer:auth-response') return;

    switch (name) {
      case 'tajer:chat-login':
      case 'tajer:user:login':
        _handleChatLogin(detail);
        break;
      case 'tajer:chat-logout':
      case 'tajer:user:logout':
        _handleChatLogout();
        break;
      case 'tajer:request-auth':
        _respondAuth();
        break;
      case 'tajer:cart-changed':
        _onWidgetCartChanged(detail);
        break;
      default:
        if (name.toLowerCase().contains('cart')) _refreshCartFromServer();
    }
  }

  void _onChatState(bool open) {
    isChatOpen.value = open;
    // NOTE: do NOT re-establish the website session here — each SSO POST creates
    // a NEW session and invalidates the one the chat already authenticated with
    // (which broke address). The session is established once, after login.
    // When the chat closes, reconcile the app's cart with the server — but only
    // when logged in with a valid app token (otherwise the call returns
    // displayLoginForm:1 and bounces the user to login).
    if (!open && _isLoggedIn) {
      _refreshCartFromServer();
    }
  }

  /// The chat authenticates against the same backend/environment the app uses,
  /// so the token it returns IS a valid app session. Persist it and refresh the
  /// app so the account screen reflects the logged-in user.
  Future<void> _handleChatLogin(dynamic detail) async {
    if (detail is! Map) return;
    final token = (detail['token'] ?? '').toString();
    if (token.isEmpty) return;

    await _pref.saveString(AppConstants.sessionToken, token);
    final uid = detail['userId'];
    final uname = detail['userName'];
    if (uid != null) await _pref.saveString(AppConstants.userId, uid.toString());
    if (uname != null) await _pref.saveString(AppConstants.userName, uname.toString());

    try {
      Get.find<AccountController>().refreshAccount();
    } catch (e) {
      debugPrint('Chatbot: refreshAccount failed: $e');
    }
    await _refreshCartFromServer();
    // Give the chat a real website session (orders/addresses/wishlist) via a
    // hidden WebView. Non-destructive — does not reload/relogin the chat.
    await _establishWebsiteSession();
  }

  /// Mirror a chat logout into the app so both stay in sync.
  Future<void> _handleChatLogout() async {
    await _pref.saveString(AppConstants.sessionToken, '');
    try {
      Get.find<AccountController>().refreshAccount();
    } catch (e) {
      debugPrint('Chatbot: refreshAccount (logout) failed: $e');
    }
  }

  /// Pushes the app's valid auth (temp-token + userId) into the chat so it acts
  /// as the logged-in app user — mirroring the website's setToken() bridge.
  Future<void> _pushAppLoginToChat() async {
    final token = await _fetchAuthToken();
    if (token.isNotEmpty) {
      _callJs('window.tajerSetToken(${jsonEncode(token)});');
    }
    final uid = _pref.loadString(AppConstants.userId) ?? '';
    if (uid.isNotEmpty) {
      _callJs('window.tajerSetUserId(${jsonEncode(uid)});');
    }
  }

  void _onBounds(Map<String, dynamic> data) {
    final w = (data['w'] as num?)?.toDouble() ?? 0;
    final h = (data['h'] as num?)?.toDouble() ?? 0;
    if (w <= 0 || h <= 0) {
      widgetRect.value = null;
      return;
    }
    final x = (data['x'] as num?)?.toDouble() ?? 0;
    final y = (data['y'] as num?)?.toDouble() ?? 0;
    widgetRect.value = Rect.fromLTWH(x, y, w, h);
  }

  void _onWidgetCartChanged(dynamic detail) {
    // Snappy badge update if the widget told us the new count.
    if (detail is Map && detail['cartCount'] != null) {
      cartItemCounts.value = detail['cartCount'].toString();
    }
    // Authoritative refresh from the server (updates the global badge and,
    // if the cart page is open, its contents) — same intent as the web embed's
    // cart.loadCartSummary().
    _refreshCartFromServer();
  }

  Future<void> _refreshCartFromServer() async {
    try {
      // Updates the global `cartItemCounts` used by the badge everywhere.
      await CartListingRepository()
          .getCartListingData(cartType: '5', isDeliverAllTogether: '0');
    } catch (e) {
      debugPrint('Chatbot: cart refresh failed: $e');
    }
    // If the cart page is currently open, reload its visible contents.
    if (Get.isRegistered<RegularProductController>()) {
      try {
        Get.find<RegularProductController>().getCartListing('0', '5');
      } catch (e) {
        debugPrint('Chatbot: cart page reload failed: $e');
      }
    }
  }

  Future<void> _respondAuth() async {
    final token = await _fetchAuthToken();
    if (token.isNotEmpty) {
      _callJs("window.tajerSetToken(${jsonEncode(token)});");
    }
  }

  // ---------------------------------------------------------------------------
  // App -> widget bridge
  // ---------------------------------------------------------------------------

  void _bindAppStateListeners() {
    ever<String>(cartItemCounts, (_) {
      _callJs("window.tajerSiteCartChanged('update');");
    });

    final account = Get.find<AccountController>();
    ever<bool>(account.isLogin, (loggedIn) async {
      if (!isReady.value) return;
      if (loggedIn) {
        // App is the source of truth: when the app logs in, hand the chat a
        // VALID app token (+ userId) so it operates as the same user. Then the
        // cart is shared because both use the same accepted session.
        await _pushAppLoginToChat();
        await _refreshCartFromServer();
      }
      // NOTE: intentionally do NOT push app logout into the chat — the chat
      // owns its session, and force-logging it out caused a login/logout loop.
    });

    // Currency / country / language re-read on language change.
    ever<Locale>(LocalizationService.to.appLocale, (_) => _reinit());
  }

  void updateCurrency(int currencyId) {
    _callJs('window.tajerUpdateCurrency($currencyId);');
  }

  Future<void> _reinit() async {
    if (webController == null || !isReady.value) return;
    final cfg = await _buildConfig();
    _callJs('window.tajerReinit(${jsonEncode(cfg)});');
  }

  void _callJs(String js) {
    if (webController == null) return;
    webController!.runJavaScript(js).catchError((e) {
      debugPrint('Chatbot: JS call failed ($js): $e');
    });
  }

  int _asInt(String? value, int fallback) {
    if (value == null || value.isEmpty) return fallback;
    return int.tryParse(value) ?? fallback;
  }
}
