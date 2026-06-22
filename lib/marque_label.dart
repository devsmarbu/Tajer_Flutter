import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'package:tajer/utils/pref_store.dart';
import 'app/core/constants/app_constants.dart';
// import 'package:marquee_widget/marquee_widget.dart';

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
  }) {
    if (PrefStore().loadString(AppConstants.promoBannerEnabled) == "1") {
      return Container(
        width: double.infinity,
        height: height,
        color: backgroundColor,
        alignment: Alignment.centerLeft,
        padding: padding,
        child: Marquee(
          text: this,
          style: TextStyle(
            color: textColor,
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
      return SizedBox();
    }
  }
}

