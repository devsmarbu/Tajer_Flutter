import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:tajer/utils/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utils/pref_store.dart';
import '../../../core/constants/app_constants.dart';

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

    debugPrint("is force update: $isForceUpdate");
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
    String bundleId,
    String currentVersion,
    bool isForce,
  ) async {
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
    final checkLatestVersion = (_isNewer(storeVersion, currentVersion));
    debugPrint("check latest version or not $checkLatestVersion");
    if (checkLatestVersion) {
      debugPrint("yes newer version available");
       if (isForce) {
      _showUpdateDialog(
        (PrefStore().loadString(AppConstants.languageCode) ==
            "AR") ?
        "الإصدار الجديد ($storeVersion) متوفر." :
        "New version ($storeVersion) is available.",
        trackUrl,
        isForce,
      );
       }
    }
  }

  // -------------------------------
  // 🤖 Android Play Store Scrape
  // -------------------------------
  Future<void> _checkAndroid(
    String package,
    String currentVersion,
    bool isForce,
  ) async {
    final url = "https://play.google.com/store/apps/details?id=$package&hl=en";

    final response = await _dio.get(url);

    if (response.statusCode != 200) return;

    final body = response.data.toString();
    final reg = RegExp(r'\[\"([0-9]+\.[0-9]+\.[0-9]+)\"\]');
    final match = reg.firstMatch(body);

    if (match == null) return;

    final storeVersion = match.group(1)!;
    final playUrl = "https://play.google.com/store/apps/details?id=$package";

    final checkLatestVersion = (_isNewer(storeVersion, currentVersion));
    debugPrint("check latest version or not $checkLatestVersion");
    if (checkLatestVersion) {
      debugPrint("yes newer version available");
       if (isForce) {
      _showUpdateDialog(
        (PrefStore().loadString(AppConstants.languageCode) ==
            "AR") ?
        "الإصدار الجديد ($storeVersion) متوفر." :
        "New version ($storeVersion) is available.",
        playUrl,
        isForce,
      );
       }
    }
  }

  // -------------------------------
  // 🔢 Version Comparison
  // -------------------------------
  bool _isNewer(String store, String current) {
    final s = store.split('.').map(int.parse).toList();
    final c = current.split('.').map(int.parse).toList();

    final maxLen = s.length > c.length ? s.length : c.length;

    for (int i = 0; i < maxLen; i++) {
      final sv = i < s.length ? s[i] : 0;
      final cv = i < c.length ? c[i] : 0;

      if (sv > cv) return true;
      if (sv < cv) return false;
    }
    return false;
  }
  // -------------------------------
  // 🔔 Update Dialog
  // -------------------------------
  void _showUpdateDialog(String message, String url, bool isForce) {
    if (forceUpdateRequired.value && Get.isDialogOpen == true) return;

    if (isForce) {
      forceUpdateRequired.value = true;
    }

    final context = Get.overlayContext;
    if (context == null) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: !isForce,
      barrierLabel: "APP_UPDATE".tr,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (ctx, anim1, anim2) {
        return PopScope(
          canPop: !isForce, // ⛔ disable back
          child: AlertDialog(
            title: Text((PrefStore().loadString(AppConstants.languageCode) ==
                "AR") ? 'الإصدار الجديد متاح' :
            'New Version Available' ,style: TextStyle(fontFamily: 'Nunito',fontSize: 15,fontWeight: FontWeight.w600)),
            content: Text(message,style: TextStyle(fontFamily: 'Nunito',fontSize: 12,fontWeight: FontWeight.w500)),
            actions: [
               if (!isForce)
                TextButton(
                  onPressed: () => Get.back(),
                  child: Text("APP_LATER".tr,style: TextStyle(fontFamily: 'Nunito',fontSize: 15,fontWeight: FontWeight.w600,color: Colors.black)),
                ),
              TextButton(
                onPressed: () async {
                  final uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    launchUrl(uri, mode: LaunchMode.externalApplication);
                  }
                },
                child: Text("APP_UPDATE".tr,style: TextStyle(fontFamily: 'Nunito',fontSize: 15,fontWeight: FontWeight.w600,color: Colors.black)),
              ),
            ],
          ),
        );
      },
    );
  }
}
