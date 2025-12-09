import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tajer/utils/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class AppUpdateService {
  static final AppUpdateService instance = AppUpdateService._();
  AppUpdateService._();

  final Dio _dio = Dio();

  /// 🔥 When force update is required, this becomes TRUE
  RxBool forceUpdateRequired = false.obs;

  Future<void> checkForUpdate({bool isForceUpdate = false}) async {
    final info = await PackageInfo.fromPlatform();
    final bundleId = info.packageName;
    final currentVersion = info.version;

    if (Platform.isIOS) {
      await _checkIOS(bundleId, currentVersion, isForceUpdate);
    } else {
      await _checkAndroid(bundleId, currentVersion, isForceUpdate);
    }
  }

  // -------------------------------
  // 📱 iOS App Store Lookup
  // -------------------------------
  Future<void> _checkIOS(
      String bundleId, String currentVersion, bool isForce) async {
    final url = "https://itunes.apple.com/lookup?bundleId=$bundleId";

    debugPrint("url: $url");

    final response = await _dio.get(url);

    if (response.statusCode != 200) return;

    final Map<String, dynamic> json = response.data is String
        ? jsonDecode(response.data)
        : response.data;
    if (json["resultCount"] == 0) return;

    final storeVersion = json["results"][0]["version"];
    final trackUrl = json["results"][0]["trackViewUrl"];
    debugPrint("current version: $currentVersion");
    debugPrint("store version: $storeVersion");

    if (_isNewer(storeVersion, currentVersion)) {
      _showUpdateDialog(
          "New version ($storeVersion) is available.", trackUrl, isForce);
    }
  }

  // -------------------------------
  // 🤖 Android Play Store Scrape
  // -------------------------------
  Future<void> _checkAndroid(
      String package, String currentVersion, bool isForce) async {
    final url =
        "https://play.google.com/store/apps/details?id=$package&hl=en";

    final response = await _dio.get(url);

    if (response.statusCode != 200) return;

    final body = response.data.toString();
    final reg = RegExp(r'\[\"([0-9]+\.[0-9]+\.[0-9]+)\"\]');
    final match = reg.firstMatch(body);

    if (match == null) return;

    final storeVersion = match.group(1)!;
    final playUrl =
        "https://play.google.com/store/apps/details?id=$package";

    if (_isNewer(storeVersion, currentVersion)) {
      _showUpdateDialog(
          "New version ($storeVersion) is available.", playUrl, isForce);
    }
  }

  // -------------------------------
  // 🔢 Version Comparison
  // -------------------------------
  bool _isNewer(String store, String current) {
    final s = store.split('.').map(int.parse).toList();
    final c = current.split('.').map(int.parse).toList();

    for (int i = 0; i < s.length; i++) {
      if (s[i] > c[i]) return true;
      if (s[i] < c[i]) return false;
    }
    return false;
  }

  // -------------------------------
  // 🔔 Update Dialog
  // -------------------------------
  void _showUpdateDialog(String message, String url, bool isForce) {
    if (isForce) {
      forceUpdateRequired.value = true; // 🔥 BLOCK EVERYTHING
    }

    Get.dialog(
      AlertDialog(
        title: const Text("New Version Available"),
        content: Text(message),
        actions: [
          if (!isForce)
            TextButton(
              onPressed: () => Get.back(),
              child: Text("Later",style: TextStyle(color: Colors.black)),
            ),
          TextButton(
            onPressed: () async {
              final uri = Uri.parse(url);
              if (await canLaunchUrl(uri)) {
                launchUrl(uri, mode: LaunchMode.externalApplication);
              }
            },
            child: Text("Update",style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
      barrierDismissible: !isForce,
    );
  }
}