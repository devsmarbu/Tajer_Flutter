import 'language.dart';

class LanguageResponse {
  final String currencySymbol;
  final String totalFavouriteItems;
  final String totalUnreadMessageCount;
  final String totalUnreadNotificationCount;
  final String cartItemsCount;
  final List<Language> languages;

  LanguageResponse({
    required this.currencySymbol,
    required this.totalFavouriteItems,
    required this.totalUnreadMessageCount,
    required this.totalUnreadNotificationCount,
    required this.cartItemsCount,
    required this.languages,
  });

  factory LanguageResponse.fromJson(Map<String, dynamic> json) {
    return LanguageResponse(
      currencySymbol: json['currencySymbol'] ?? '',
      totalFavouriteItems: json['totalFavouriteItems'] ?? 0,
      totalUnreadMessageCount: json['totalUnreadMessageCount'] ?? 0,
      totalUnreadNotificationCount: json['totalUnreadNotificationCount'] ?? 0,
      cartItemsCount: json['cartItemsCount'] ?? 0,
      languages: (json['languages'] as List<dynamic>?)
          ?.map((e) => Language.fromJson(e))
          .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'currencySymbol': currencySymbol,
    'totalFavouriteItems': totalFavouriteItems,
    'totalUnreadMessageCount': totalUnreadMessageCount,
    'totalUnreadNotificationCount': totalUnreadNotificationCount,
    'cartItemsCount': cartItemsCount,
    'languages': languages.map((e) => e.toJson()).toList(),
  };
}
