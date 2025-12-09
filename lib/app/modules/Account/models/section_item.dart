import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class SectionItem {
  final String key;   // translation key = "APP_SHIPPING_ADDRESS"
  final String icon;

  SectionItem({required this.key, required this.icon});

  String get title => key.tr;
}
