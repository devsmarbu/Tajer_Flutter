import 'dart:convert';

import 'package:tajer/app/modules/orders/orderDetail/models/address.dart';

AddressData addressDataFromJson(String str) =>
    AddressData.fromJson(json.decode(str));

String addressDataToJson(AddressData data) => json.encode(data.toJson());

class AddressData {
  final String? totalUnreadMessageCount;
  final String? totalUnreadNotificationCount;
  final List<Address>? addresses;
  final String? cartItemsCount;
  final String? currencySymbol;
  final String? totalFavouriteItems;
  final Map<String, dynamic>? verifiedNumbers;

  AddressData({
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.addresses,
    this.cartItemsCount,
    this.currencySymbol,
    this.totalFavouriteItems,
    this.verifiedNumbers,
  });

  factory AddressData.fromJson(Map<String, dynamic> json) => AddressData(
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    addresses: json["addresses"] == null
        ? []
        : List<Address>.from(
        json["addresses"].map((x) => Address.fromJson(x))),
    cartItemsCount: json["cartItemsCount"],
    currencySymbol: json["currencySymbol"],
    totalFavouriteItems: json["totalFavouriteItems"],
    verifiedNumbers: json["verified_numbers"] == null
        ? null
        : Map<String, dynamic>.from(json["verified_numbers"]),
  );

  Map<String, dynamic> toJson() => {
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "addresses": addresses == null
        ? []
        : List<dynamic>.from(addresses!.map((x) => x.toJson())),
    "cartItemsCount": cartItemsCount,
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
    "verified_numbers": verifiedNumbers,
  };
}