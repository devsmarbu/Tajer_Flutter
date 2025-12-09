import 'dart:convert';

CommonData commonDataFromJson(String str) => CommonData.fromJson(json.decode(str));
String commonDataToJson(CommonData data) => json.encode(data.toJson());

class CommonData {
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  String? cartItemsCount;
  String? currencySymbol;
  String? totalFavouriteItems;
  String? trackingUrl;
  String? wishListId;
  String? verified;
  String? responseCode;
  String? userId;
  String? downloadUrl;
  String? langLabelUpdatedAt;
  String? languageCode;
  String? tempUserId;
  String? link;
  String? tempToken;
  String? privacyPolicyLink;
  String? faqLink;
  String? termsAndConditionsLink;
  String? userAggrementLink;
  String? warrantyExchangeLink;
  String? suggestionLink;
  String? isUserAggrementLink;
  List<OptionRowsItem>? options;
  String? orderPayment;
  String? file;

  CommonData({
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.currencySymbol,
    this.totalFavouriteItems,
    this.trackingUrl,
    this.wishListId,
    this.verified,
    this.responseCode,
    this.userId,
    this.downloadUrl,
    this.langLabelUpdatedAt,
    this.languageCode,
    this.tempUserId,
    this.link,
    this.tempToken,
    this.privacyPolicyLink,
    this.faqLink,
    this.termsAndConditionsLink,
    this.userAggrementLink,
    this.warrantyExchangeLink,
    this.suggestionLink,
    this.isUserAggrementLink,
    this.options,
    this.orderPayment,
    this.file,
  });

  factory CommonData.fromJson(Map<String, dynamic> json) => CommonData(
    totalUnreadMessageCount: json["totalUnreadMessageCount"],
    totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
    cartItemsCount: json["cartItemsCount"],
    currencySymbol: json["currencySymbol"],
    totalFavouriteItems: json["totalFavouriteItems"],
    trackingUrl: json["trackingUrl"],
    wishListId: json["wish_list_id"],
    verified: json["verified"],
    responseCode: json["responseCode"],
    userId: json["user_id"],
    downloadUrl: json["downloadUrl"],
    langLabelUpdatedAt: json["langLabelUpdatedAt"],
    languageCode: json["languageCode"],
    tempUserId: json["tempUserId"],
    link: json["link"],
    tempToken: json["tempToken"],
    privacyPolicyLink: json["privacyPolicyLink"],
    faqLink: json["faqLink"],
    termsAndConditionsLink: json["termsAndConditionsLink"],
    userAggrementLink: json["userAggrementLink"],
    warrantyExchangeLink: json["warrantyExchangeLink"],
    suggestionLink: json["suggestionLink"],
    isUserAggrementLink: json["isUserAggrementLink"],
    options: json["options"] == null
        ? []
        : List<OptionRowsItem>.from(
        json["options"].map((x) => OptionRowsItem.fromJson(x))),
    orderPayment: json["orderPayment"],
    file: json["file"],
  );

  Map<String, dynamic> toJson() => {
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "currencySymbol": currencySymbol,
    "totalFavouriteItems": totalFavouriteItems,
    "trackingUrl": trackingUrl,
    "wish_list_id": wishListId,
    "verified": verified,
    "responseCode": responseCode,
    "user_id": userId,
    "downloadUrl": downloadUrl,
    "langLabelUpdatedAt": langLabelUpdatedAt,
    "languageCode": languageCode,
    "tempUserId": tempUserId,
    "link": link,
    "tempToken": tempToken,
    "privacyPolicyLink": privacyPolicyLink,
    "faqLink": faqLink,
    "termsAndConditionsLink": termsAndConditionsLink,
    "userAggrementLink": userAggrementLink,
    "warrantyExchangeLink": warrantyExchangeLink,
    "suggestionLink": suggestionLink,
    "isUserAggrementLink": isUserAggrementLink,
    "options": options == null
        ? []
        : List<dynamic>.from(options!.map((x) => x.toJson())),
    "orderPayment": orderPayment,
    "file": file,
  };
}

class OptionRowsItem {
  String? id;
  String? name;

  OptionRowsItem({this.id, this.name});

  factory OptionRowsItem.fromJson(Map<String, dynamic> json) => OptionRowsItem(
    id: json["id"]?.toString(),
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
  };
}

