import 'dart:async';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:tajer/app/firebase/one_signal_notification.dart';
import 'package:tajer/common/functions/app_function.dart';
import 'package:tajer/translations/localization_service.dart';
import 'package:tajer/utils/pref_store.dart';
import 'package:tiktok_events_sdk/tiktok_events_sdk.dart';

import 'app/core/constants/app_constants.dart';
import 'app/modules/Account/controller/account_controller.dart';
import 'app/modules/authentication/splash/controller/splash_controller.dart';
import 'app/modules/navigation/bottom_navigation.dart';
import 'common/widgets/restart_widget.dart';
import 'main_extension.dart';
import 'my_root_app.dart';

StreamSubscription? _sub;

// --------------------------------------------------
// 🔥 REQUIRED: FCM BACKGROUND HANDLER
// --------------------------------------------------
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Background Message: ${message.messageId}");
}

// --------------------------------------------------
// 🔔 Local Notification Plugin
// --------------------------------------------------
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

// --------------------------------------------------
// LOCAL NOTIFICATION INITIALIZATION
// --------------------------------------------------
Future<void> _initLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings settings = InitializationSettings(
    android: androidSettings,
    iOS: iosSettings,
  );

  await flutterLocalNotificationsPlugin.initialize(
    settings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      final payload = response.payload;
      print("🔔 Notification tapped. Payload = $payload");
    },
  );
}
//
// --------------------------------------------------

// --------------------------------------------------
void main() async {

  AppConfig.env = AppEnvironment.DEVELOPMENT;
  WidgetsFlutterBinding.ensureInitialized();
  // await captureUtmFromClipboard();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await PrefStore.init();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _initLocalNotifications();
  await _initializeFirebaseAsync();
  await OneSignalNotification.init();

  // INIT LOCALIZATION FIRST
  final localization = LocalizationService();
  await localization.init();
  Get.put(localization, permanent: true);

  // REGISTER CONTROLLERS BEFORE UI BUILDS
  Get.put(AccountController(), permanent: true);
  Get.put(SplashController(), permanent: true);
  Get.put(BottomNavController(), permanent: true);

  DeepLinkService.instance.init();

  // iOS options example
  final iosOptions = TikTokIosOptions(
    disableTracking: false, // true would disable ALL tracking
    disableAutomaticTracking: false,
    disableSKAdNetworkSupport: false,
  );

// Android options example
  final androidOptions = TikTokAndroidOptions(
    disableAutoStart: false,
    disableAutoEvents: true,
    enableAutoIapTrack: false, // enable IAP tracking
    disableAdvertiserIDCollection: false,
  );

  await TikTokEventsSdk.initSdk(
    androidAppId: 'com.tajershops.tajer',
    tikTokAndroidId: '7608560967040483336',
    iosAppId: '1511303897', // if same, otherwise use iOS one
    tiktokIosId: '7608438154462265351',
    isDebugMode: false,               // Turn on debug logging
    logLevel: TikTokLogLevel.warn,
    androidOptions: androidOptions,
    iosOptions: iosOptions,
  );
  runApp(RestartWidget(child: MyRootApp()));
}



// --------------------------------------------------
// FCM INITIALIZATION (PERMISSIONS + TOKEN + HANDLERS)
// --------------------------------------------------
Future<void> _initializeFirebaseAsync() async {
  try {
  // iOS Permissions
  //   await FirebaseMessaging.instance.requestPermission(
  //     alert: true,
  //     badge: true,
  //     sound: true,
  //   );

    // APNs token (iOS only)
    if (Platform.isIOS) {
      final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      print("🍏 APNs Token: $apnsToken");
    }

    // Save FCM Token to backend
    await AppFunction.saveFcmTokenIfReady();

    print("🔥 Firebase + FCM Initialized");
  } catch (e) {
    print("❌ Firebase init error: $e");
  }

  // --------------------------------------------------
  // FOREGROUND MESSAGES → SHOW LOCAL NOTIFICATION
  // --------------------------------------------------
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📨 Foreground Message: ${message.notification?.title}");
    _showLocalNotification(message);
  });

  // --------------------------------------------------
  // APP OPENED FROM NOTIFICATION (TAP)
  // --------------------------------------------------
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("📬 App opened from notification");

    // Example navigation:
    // Get.toNamed(AppRoutes.notification);
  });
}

// --------------------------------------------------
// SHOW LOCAL NOTIFICATION
// --------------------------------------------------
Future<void> _showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'default_channel',
    'General Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.notification?.title ?? "New Notification",
    message.notification?.body ?? "",
    details,
    payload: message.data['payload'] ?? "",
  );
}

