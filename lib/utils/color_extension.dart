import 'package:flutter/material.dart';

extension HexColorExtension on String {
  Color get hexToColor {
    String hex = replaceAll('#', '');

    if (hex.length == 6) {
      hex = 'FF$hex'; // add opacity if missing
    }

    return Color(int.parse(hex, radix: 16));
  }
}