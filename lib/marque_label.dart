import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:tajer/utils/app_colors.dart';
import 'package:tajer/utils/pref_store.dart';
import 'app/core/constants/app_constants.dart';

extension MarqueeLabelExtension on String {
  Widget marqueeLabel({
    double height = 25,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    double fontSize = 13,
    FontWeight fontWeight = FontWeight.w600,
    double velocity = 60,
    EdgeInsets padding =
    const EdgeInsets.symmetric(horizontal: 12),
    bool forceShow = false,
  }) {
    if (forceShow || PrefStore().loadString(AppConstants.promoBannerEnabled) == "1") {
      // 1. Fetch values from PrefStore
      final prefBgColor = PrefStore().loadString(AppConstants.promoBannerColor);
      final prefTextColor = PrefStore().loadString(AppConstants.promoBannerTextColor);

      // 2. Parse background color safely
      Color resolvedBgColor = backgroundColor;
      if (prefBgColor != null && prefBgColor.isNotEmpty) {
        resolvedBgColor = prefBgColor.hexToColor;
      }

      // 3. Parse text color safely
      Color resolvedTextColor = textColor;
      if (prefTextColor != null && prefTextColor.isNotEmpty) {
        resolvedTextColor = prefTextColor.hexToColor;
      }

      return Container(
        width: double.infinity,
        height: height,
        color: resolvedBgColor,
        alignment: Alignment.centerLeft,
        padding: padding,
        child: Marquee(
          text: this,
          style: TextStyle(
            color: resolvedTextColor,
            fontWeight: fontWeight,
            fontSize: fontSize,
            fontFamily: "Nunito",
          ),
          scrollAxis: Axis.horizontal,
          blankSpace: 40,
          velocity: velocity,
          pauseAfterRound: const Duration(seconds: 1),
        ),
      );
    }
    else {
      return const SizedBox();
    }
  }

}

