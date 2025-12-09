import 'login_status.dart';

class SocialAuthStatusModel {
  final String currencySymbol;
  final String totalFavouriteItems;
  final String totalUnreadMessageCount;
  final String totalUnreadNotificationCount;
  final String cartItemsCount;
  final LoginStatus status;

  SocialAuthStatusModel({
    required this.currencySymbol,
    required this.totalFavouriteItems,
    required this.totalUnreadMessageCount,
    required this.totalUnreadNotificationCount,
    required this.cartItemsCount,
    required this.status,
  });

  factory SocialAuthStatusModel.fromJson(Map<String, dynamic> json) {
    return SocialAuthStatusModel(
      currencySymbol: json['currencySymbol']?.toString() ?? '',
      totalFavouriteItems: json['totalFavouriteItems']?.toString() ?? '0',
      totalUnreadMessageCount: json['totalUnreadMessageCount']?.toString() ?? '0',
      totalUnreadNotificationCount: json['totalUnreadNotificationCount']?.toString() ?? '0',
      cartItemsCount: json['cartItemsCount']?.toString() ?? '0',
      status: LoginStatus.fromJson(Map<String, dynamic>.from(json['status'] ?? {})),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencySymbol': currencySymbol,
      'totalFavouriteItems': totalFavouriteItems,
      'totalUnreadMessageCount': totalUnreadMessageCount,
      'totalUnreadNotificationCount': totalUnreadNotificationCount,
      'cartItemsCount': cartItemsCount,
      'status': status.toJson(),
    };
  }
}
