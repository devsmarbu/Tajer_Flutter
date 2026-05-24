import 'package:flutter/cupertino.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:tajer/app/core/constants/app_constants.dart';
import '../../main_extension.dart';
import '../../utils/app_loader.dart';

var redirectionURL = "";

class OneSignalNotification {
  static Future<void> init() async {
    OneSignal.initialize(AppConstants.oneSignalAppId);
    //OneSignal.Notifications.requestPermission(true);

    OneSignal.Notifications.addClickListener((event) async {
      print("🔔 Notification Clicked");

      try {
        // 1️⃣ Convert whole payload to string
        final payload = event.notification.jsonRepresentation();
        print("📦 RAW PAYLOAD: $payload");

        // 2️⃣ Extract any HTTPS link
        final url = _findUrls(payload);
        print("🌐 Extracted URL: $url");
        redirectionURL = url.first;
        if (AppState.isReady == true) {
          debugPrint('this is universal navigation 2');
          UrlHandling.shared.universalUrlDetailsAPI(redirectionURL);
        }
      } catch (e) {
        print("❌ Error handling OneSignal payload: $e");
      }
    });
  }

  static List<String> _findUrls(dynamic json) {
    List<String> urls = [];
    final urlRegex = RegExp(r'(https?:\/\/[^\s"]+)', caseSensitive: false);
    final imageRegex = RegExp(r'\.(jpg|jpeg|png|gif|webp|bmp|svg)$', caseSensitive: false);

    void search(dynamic value) {
      if (value is String) {
        for (var m in urlRegex.allMatches(value)) {
          final url = m.group(0)!;

          // ❌ Skip image URLs
          if (!imageRegex.hasMatch(url)) {
            urls.add(url);
          }
        }
      } else if (value is Map) {
        value.forEach((_, val) => search(val));
      } else if (value is List) {
        for (var item in value) {
          search(item);
        }
      }
    }

    search(json);
    return urls;
  }

  // 👇 ADD THIS
  static Future<void> setLanguage(String languageCode) async {
    try {
      await OneSignal.User.setLanguage(languageCode);
      debugPrint("🌍 OneSignal language synced: $languageCode");
    } catch (e) {
      debugPrint("❌ OneSignal language error: $e");
    }
  }
}
