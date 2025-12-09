import 'dart:convert';

import 'package:tajer/app/modules/address/addAddress/models/state_item.dart';

import 'country_item.dart';

CountryData countryDataFromJson(String str) =>
    CountryData.fromJson(json.decode(str));

String countryDataToJson(CountryData data) => json.encode(data.toJson());

class CountryData {
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  String? cartItemsCount;
  String? currencySymbol;
  List<CountryItem>? countries;
  List<StateItem>? states;
  String? totalFavouriteItems;

  CountryData({
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.currencySymbol,
    this.countries,
    this.states,
    this.totalFavouriteItems,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    cartItemsCount: json["cartItemsCount"],
    currencySymbol: json["currencySymbol"],
    countries: json["countries"] == null
        ? []
        : List<CountryItem>.from(
        json["countries"].map((x) => CountryItem.fromJson(x))),
    states: json["states"] == null
        ? []
        : List<StateItem>.from(
        json["states"].map((x) => StateItem.fromJson(x))),
    totalFavouriteItems: json["totalFavouriteItems"],
  );

  Map<String, dynamic> toJson() => {
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "currencySymbol": currencySymbol,
    "countries": countries == null
        ? []
        : List<dynamic>.from(countries!.map((x) => x.toJson())),
    "states":
    states == null ? [] : List<dynamic>.from(states!.map((x) => x.toJson())),
    "totalFavouriteItems": totalFavouriteItems,
  };
}




