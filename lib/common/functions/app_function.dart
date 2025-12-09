import 'dart:convert';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import 'package:tajer/utils/pref_store.dart';

import '../../app/modules/authentication/login/login_data.dart';

mixin AppFunction {

  static Future<bool> isInternetAvailable() async {
    // ✅ Fix: checkConnectivity() now returns List<ConnectivityResult>
    final List<ConnectivityResult> results = await Connectivity().checkConnectivity();

    if (results.contains(ConnectivityResult.none)) {
      Get.snackbar(AppConstants.appName, "No internet connection");
      return false;
    }

    // ✅ Optional: Check actual internet access
    try {
      final lookup = await InternetAddress.lookup('example.com');
      if (lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      Get.snackbar(AppConstants.appName, "No internet access");
      return false;
    }

    return false;
  }

  Future<bool> isRequestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('✅ Permission granted');
      return true;
    } else {
      print('❌ Permission denied');
      return false;
    }
  }

  static Future<String> saveFcmToken(PrefStore pref) async {
    String? token = await FirebaseMessaging.instance.getToken();
    pref.saveString(AppConstants.fcmToken, token??"");
    print('🔹 FCM Token: $token');
    return token??"";
  }

  static Future<void> saveFcmTokenIfReady() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        final pref = PrefStore();
        await AppFunction.saveFcmToken(pref);
        print('✅ FCM token saved');
      } else {
        print('⚠️ FCM token not ready yet');
      }
    } catch (e) {
      print('❌ Error saving FCM token: $e');
    }
  }

  static String getDateFormat(String date, String format) {
    try {
      final inputFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
      final dateTime = inputFormat.parse(date);
      final outputFormat = DateFormat(format);
      return outputFormat.format(dateTime);
    } catch (e) {
      return "xx";
    }
  }

  Future<LoginData?> getSavedLoginData(PrefStore pref) async {
    final jsonString = await pref.loadString(AppConstants.loginData);
    if (jsonString == null || jsonString.isEmpty) return null;

    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    return LoginData.fromJson(jsonMap);
  }

}
