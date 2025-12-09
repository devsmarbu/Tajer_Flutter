import 'dart:convert';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import '../../main_extension.dart';

class OneSignalNotification {
  static Future<void> init() async {
    OneSignal.initialize(AppConstants.oneSignalAppId);
    OneSignal.Notifications.requestPermission(true);

    OneSignal.Notifications.addClickListener((event) async {
      print("🔔 Notification Clicked");

      try {
        // 1️⃣ Convert whole payload to string
        final payload = event.notification.jsonRepresentation();
        print("📦 RAW PAYLOAD: $payload");

        // 2️⃣ Extract any HTTPS link
        final url = _findUrls(payload);
        print("🌐 Extracted URL: $url");

        // 3️⃣ Delay (like your Swift code)
        await Future.delayed(const Duration(milliseconds: 300));

        UrlHandling.shared.universalUrlDetailsAPI(url.first);
      } catch (e) {
        print("❌ Error handling OneSignal payload: $e");
      }
    });
  }

  static List<String> _findUrls(dynamic json) {
    List<String> urls = [];
    final regex = RegExp(r'(https?:\/\/[^\s"]+)', caseSensitive: false);

    void search(dynamic value) {
      if (value is String) {
        for (var m in regex.allMatches(value)) {
          urls.add(m.group(0)!);
        }
      } else if (value is Map) {
        value.forEach((key, val) => search(val));
      } else if (value is List) {
        for (var item in value) {
          search(item);
        }
      }
    }
    search(json);
    return urls;
  }
}
