import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import '../../common/functions/app_function.dart';
import '../../utils/pref_store.dart';
import '../core/constants/app_constants.dart';
import '../core/routes/app_routes.dart' as Routes;

class NotificationService {
  NotificationService._private();
  static final NotificationService _instance = NotificationService._private();
  factory NotificationService() => _instance;

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // --------------------------
    // 🔔 LOCAL NOTIFICATIONS INIT
    // --------------------------
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
    );

    await _local.initialize(
      initSettings,
      // ❗ FIX: this is the correct API now
      onDidReceiveNotificationResponse: _onSelectNotificationResponse,
    );

    // --------------------------
    // 🔥 FCM PERMISSIONS
    // --------------------------
    await _fcm.requestPermission(alert: true, badge: true, sound: true);

    // --------------------------
    // 🔥 SAVE TOKEN
    // --------------------------
    String? token = await _fcm.getToken();
    if (token != null) {
      PrefStore().saveString(AppConstants.fcmToken ?? 'fcm_token', token);
      await AppFunction.saveFcmTokenIfReady();
    }

    // --------------------------
    // 📲 FOREGROUND MESSAGE
    // --------------------------
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("📨 Foreground message: ${message.data}");
      await _handleMessage(message, openedFromNotification: false);
    });

    // --------------------------
    // 📬 BACKGROUND TAP
    // --------------------------
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      debugPrint("📬 Message opened app: ${message.data}");
      await _handleMessage(message, openedFromNotification: true);
    });

    // --------------------------
    // 🚀 TERMINATED STATE
    // --------------------------
    RemoteMessage? initial = await _fcm.getInitialMessage();
    if (initial != null) {
      await _handleMessage(initial, openedFromNotification: true);
    }

    // --------------------------
    // 🔁 TOKEN REFRESH
    // --------------------------
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
      PrefStore().saveString(AppConstants.fcmToken ?? 'fcm_token', newToken);
      await AppFunction.saveFcmTokenIfReady();
    });
  }

  // ===========================================================================
  // 🔍 MESSAGE HANDLER (shared for foreground, background, terminated)
  // ===========================================================================
  Future<void> _handleMessage(RemoteMessage message, {required bool openedFromNotification}) async {
    final data = message.data;

    try {
      // --------------------------
      // CUSTOM JAVA SERVICE FORMAT
      // --------------------------
      if (data.containsKey('isCustomPushNotification') || data.containsKey('urlDetail')) {
        final urlDetailRaw = data['urlDetail'];
        if (urlDetailRaw != null && urlDetailRaw.toString().isNotEmpty) {
          final object = _safeJson(urlDetailRaw.toString());
          if (object.containsKey('urlType')) {
            await _handleUrlDetail(
              object,
              data['body'] ?? data['message'] ?? '',
              object['recordId']?.toString() ?? '',
              data['title'] ?? '',
              data['image'],
            );
            return;
          }
        }
      }

      // --------------------------
      // TEXT TYPE
      // --------------------------
      if (data.containsKey('text')) {
        await _showNotification(
          id: _genId(),
          title: data['title'] ?? AppConstants.appName,
          body: data['text'],
          payload: jsonEncode({'route': Routes.AppRoutes.home}),
        );
        return;
      }

      // --------------------------
      // TRANSACTION TYPE
      // --------------------------
      if (data['type'] == 'TXN') {
        await _showNotification(
          id: _genId(),
          title: data['title'] ?? AppConstants.appName,
          body: data['message'] ?? '',
          payload: jsonEncode({'route': Routes.AppRoutes.walletScreen}),
        );
        return;
      }

      // --------------------------
      // DEFAULT NOTIFICATION
      // --------------------------
      await _showNotification(
        id: _genId(),
        title: data['title'] ?? AppConstants.appName,
        body: data['message'] ?? '',
        payload: jsonEncode({
          'route': Routes.AppRoutes.home,
        }),
        imageUrl: data['image'],
      );
    } catch (e, st) {
      debugPrint("⚠️ _handleMessage: $e\n$st");
    }

    // --------------------------
    // TAP EVENT
    // --------------------------
    if (openedFromNotification) {
      await _handleTapPayload(data);
    }
  }

  // ===========================================================================
  // 🔗 DEEP LINK HANDLER (urlDetail)
  // ===========================================================================
  Future<void> _handleUrlDetail(
      Map<String, dynamic> object,
      String body,
      String recordId,
      String title,
      dynamic image,
      ) async {
    final urlType = object['urlType']?.toString() ?? '';

    String route = Routes.AppRoutes.home;
    Map<String, dynamic> params = {};

    switch (urlType) {
      case 'PRODUCT':
        route = Routes.AppRoutes.productDetail;
        params = {'productId': recordId};
        break;

      case 'CATEGORY':
        route = Routes.AppRoutes.productListPage;
        params = {'parentId': recordId};
        break;

      case 'BRAND':
        route = Routes.AppRoutes.productListPage;
        params = {'brandId': recordId};
        break;

      case 'CONTACT_US':
        route = Routes.AppRoutes.contactUsScreen;
        break;

      case 'SIGN_IN':
        route = Routes.AppRoutes.login;
        break;

      case 'REGISTER':
        route = Routes.AppRoutes.signUp;
        break;

      default:
        route = Routes.AppRoutes.home;
    }

    final payload = jsonEncode({'route': route, 'params': params});
    await _showNotification(
      id: _genId(),
      title: title.isNotEmpty ? title : AppConstants.appName,
      body: body,
      payload: payload,
      imageUrl: image?.toString(),
    );
  }

  // ===========================================================================
  // 🔔 SHOW LOCAL NOTIFICATION
  // ===========================================================================
  Future<void> _showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
    String? imageUrl,
  }) async {
    try {
      AndroidNotificationDetails android;

      if (imageUrl != null && imageUrl.isNotEmpty) {
        Uint8List? bytes = await _downloadImage(imageUrl);

        if (bytes != null) {
          android = AndroidNotificationDetails(
            'default_channel',
            'Default',
            channelDescription: 'Default Notifications',
            importance: Importance.max,
            priority: Priority.high,
            styleInformation: BigPictureStyleInformation(
              ByteArrayAndroidBitmap(bytes),
              contentTitle: title,
              summaryText: body,
            ),
          );
        } else {
          android = AndroidNotificationDetails(
            'default_channel',
            'Default',
            channelDescription: 'Default Notifications',
            importance: Importance.max,
            priority: Priority.high,
          );
        }
      } else {
        android = AndroidNotificationDetails(
          'default_channel',
          'Default',
          channelDescription: 'Default Notifications',
          importance: Importance.max,
          priority: Priority.high,
        );
      }

      await _local.show(
        id,
        title,
        body,
        NotificationDetails(android: android),
        payload: payload,
      );
    } catch (e) {
      debugPrint("⚠️ Notification error: $e");
    }
  }

  // ===========================================================================
  // 📥 DOWNLOAD IMAGE
  // ===========================================================================
  Future<Uint8List?> _downloadImage(String url) async {
    try {
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) return res.bodyBytes;
    } catch (_) {}
    return null;
  }

  // ===========================================================================
  // 🟦 NOTIFICATION TAP HANDLER (NEW API)
  // ===========================================================================
  void _onSelectNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) return;

    try {
      final map = jsonDecode(payload);
      final route = map['route']?.toString();
      final params = map['params'];

      if (route != null && route.isNotEmpty) {
        if (params != null) {
          Get.toNamed(route, arguments: params);
        } else {
          Get.toNamed(route);
        }
      }
    } catch (e) {
      debugPrint("⚠️ Tap decode error: $e");
    }
  }

  // ===========================================================================
  // TAP HANDLER FOR DATA PAYLOADS
  // ===========================================================================
  Future<void> _handleTapPayload(Map<String, dynamic> payload) async {
    if (payload.containsKey('route')) {
      final route = payload['route'].toString();
      final params = payload['params'] ?? {};
      Get.toNamed(route, arguments: params);
      return;
    }
  }

  // ===========================================================================
  // UTILITY FUNCTIONS
  // ===========================================================================
  Map<String, dynamic> _safeJson(String raw) {
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map<String, dynamic>) return decoded;
    } catch (_) {}
    return {};
  }

  int _genId() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
}
