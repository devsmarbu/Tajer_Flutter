import 'package:tajer/app/modules/wallet/myWallet/models/payout_plugin.dart';

class WalletPayout {
  final String currencySymbol;
  final String totalFavouriteItems;
  final String totalUnreadMessageCount;
  final String totalUnreadNotificationCount;
  final String cartItemsCount;
  final String isBankPayoutEnabled;
  final List<PayoutPlugin> payoutPlugins;

  WalletPayout({
    required this.currencySymbol,
    required this.totalFavouriteItems,
    required this.totalUnreadMessageCount,
    required this.totalUnreadNotificationCount,
    required this.cartItemsCount,
    required this.isBankPayoutEnabled,
    required this.payoutPlugins,
  });

  /// ✅ Factory constructor for JSON parsing
  factory WalletPayout.fromJson(Map<String, dynamic> json) {
    return WalletPayout(
      currencySymbol: json['currencySymbol'] ?? '',
      totalFavouriteItems: json['totalFavouriteItems'] ?? '',
      totalUnreadMessageCount: json['totalUnreadMessageCount'] ?? '',
      totalUnreadNotificationCount: json['totalUnreadNotificationCount'] ?? '',
      cartItemsCount: json['cartItemsCount'] ?? '',
      isBankPayoutEnabled: json['isBankPayoutEnabled'] ?? 0,
      payoutPlugins: (json['payoutPlugins'] as List<dynamic>?)
          ?.map((e) => PayoutPlugin.fromJson(e))
          .toList() ??
          [],
    );
  }

  /// ✅ Convert model to JSON (optional)
  Map<String, dynamic> toJson() {
    return {
      'currencySymbol': currencySymbol,
      'totalFavouriteItems': totalFavouriteItems,
      'totalUnreadMessageCount': totalUnreadMessageCount,
      'totalUnreadNotificationCount': totalUnreadNotificationCount,
      'cartItemsCount': cartItemsCount,
      'isBankPayoutEnabled': isBankPayoutEnabled,
      'payoutPlugins': payoutPlugins.map((e) => e.toJson()).toList(),
    };
  }
}

