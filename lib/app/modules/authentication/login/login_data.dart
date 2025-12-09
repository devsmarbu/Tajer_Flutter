class LoginData {
  final String? currencySymbol;
  final String? totalFavouriteItems;
  final String? totalUnreadMessageCount;
  final String? totalUnreadNotificationCount;
  final String? cartItemsCount;
  final String? userName;
  final String? userId;
  final String? userPhoneDcode;
  final String? userPhone;
  final String? credentialEmail;
  final String? token;
  final String? userImage;

  LoginData({
    this.currencySymbol,
    this.totalFavouriteItems,
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.userName,
    this.userId,
    this.userPhoneDcode,
    this.userPhone,
    this.credentialEmail,
    this.token,
    this.userImage,
  });

  factory LoginData.fromJson(Map<String, dynamic> json) {
    return LoginData(
      currencySymbol: json['currencySymbol'],
      totalFavouriteItems: json['totalFavouriteItems'],
      totalUnreadMessageCount: json['totalUnreadMessageCount'],
      totalUnreadNotificationCount: json['totalUnreadNotificationCount'],
      cartItemsCount: json['cartItemsCount'],
      userName: json['user_name'],
      userId: json['user_id'],
      userPhoneDcode: json['user_phone_dcode'],
      userPhone: json['user_phone'],
      credentialEmail: json['credential_email'],
      token: json['token'],
      userImage: json['user_image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currencySymbol': currencySymbol,
      'totalFavouriteItems': totalFavouriteItems,
      'totalUnreadMessageCount': totalUnreadMessageCount,
      'totalUnreadNotificationCount': totalUnreadNotificationCount,
      'cartItemsCount': cartItemsCount,
      'user_name': userName,
      'user_id': userId,
      'user_phone_dcode': userPhoneDcode,
      'user_phone': userPhone,
      'credential_email': credentialEmail,
      'token': token,
      'user_image': userImage,
    };
  }
}