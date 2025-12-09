import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ShareProductUtil {
  static Future<void> shareProduct({
    required BuildContext context,
    required String productUrl,
    required String productTitle,
  }) async {
    try {
      final shareText = "$productTitle\n$productUrl";

      // iOS requires a non-zero valid rect
      final box = context.findRenderObject() as RenderBox?;

      final shareOrigin = Platform.isIOS
          ? (box != null && box.hasSize
          ? box.localToGlobal(Offset.zero) & box.size
          : const Rect.fromLTWH(100, 100, 200, 200))  // Fallback rect
          : null;

      await Share.share(
        shareText,
        subject: productTitle,
        sharePositionOrigin: shareOrigin,
      );
    } catch (e) {
      debugPrint("❌ Error while sharing: $e");
    }
  }
}