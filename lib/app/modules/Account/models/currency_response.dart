class CurrencyResponse {
  final String currencySymbol;
  final String totalFavouriteItems;
  final String totalUnreadMessageCount;
  final String totalUnreadNotificationCount;
  final String cartItemsCount;
  final List<Currency> currencies;

  CurrencyResponse({
    required this.currencySymbol,
    required this.totalFavouriteItems,
    required this.totalUnreadMessageCount,
    required this.totalUnreadNotificationCount,
    required this.cartItemsCount,
    required this.currencies,
  });

  factory CurrencyResponse.fromJson(Map<String, dynamic> json) {
    return CurrencyResponse(
      currencySymbol: json['currencySymbol'],
      totalFavouriteItems: json['totalFavouriteItems'],
      totalUnreadMessageCount: json['totalUnreadMessageCount'],
      totalUnreadNotificationCount: json['totalUnreadNotificationCount'],
      cartItemsCount: json['cartItemsCount'],
      currencies: (json['currencies'] as List)
          .map((e) => Currency.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencySymbol': currencySymbol,
      'totalFavouriteItems': totalFavouriteItems,
      'totalUnreadMessageCount': totalUnreadMessageCount,
      'totalUnreadNotificationCount': totalUnreadNotificationCount,
      'cartItemsCount': cartItemsCount,
      'currencies': currencies.map((e) => e.toJson()).toList(),
    };
  }
}

class Currency {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String isDefault;

  Currency({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.isDefault,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      currencyId: json['currency_id'],
      currencyCode: json['currency_code'],
      currencyName: json['currency_name'],
      isDefault: json['isDefault'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency_id': currencyId,
      'currency_code': currencyCode,
      'currency_name': currencyName,
      'isDefault': isDefault,
    };
  }
}