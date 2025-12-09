import 'dart:convert';

class NotificationData {
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  String? cartItemsCount;
  String? totalRecords;
  String? currencySymbol;
  String? totalPages;
  String? totalFavouriteItems;
  List<PushNotificationsItem>? pnotifications;
  List<NotificationsItem>? notifications;

  NotificationData({
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.cartItemsCount,
    this.totalRecords,
    this.currencySymbol,
    this.totalPages,
    this.totalFavouriteItems,
    this.pnotifications,
    this.notifications,
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) {
    return NotificationData(
      totalUnreadMessageCount: json["totalUnreadMessageCount"],
      totalUnreadNotificationCount: json["totalUnreadNotificationCount"],
      cartItemsCount: json["cartItemsCount"],
      totalRecords: json["total_records"],
      currencySymbol: json["currencySymbol"],
      totalPages: json["total_pages"],
      totalFavouriteItems: json["totalFavouriteItems"],
      pnotifications: json["pnotifications"] == null
          ? []
          : (json["pnotifications"] as List)
          .map((e) => PushNotificationsItem.fromJson(e))
          .toList(),
      notifications: json["notifications"] == null
          ? []
          : (json["notifications"] as List)
          .map((e) => NotificationsItem.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    "totalUnreadMessageCount": totalUnreadMessageCount,
    "totalUnreadNotificationCount": totalUnreadNotificationCount,
    "cartItemsCount": cartItemsCount,
    "total_records": totalRecords,
    "currencySymbol": currencySymbol,
    "total_pages": totalPages,
    "totalFavouriteItems": totalFavouriteItems,
    "pnotifications":
    pnotifications?.map((e) => e.toJson()).toList() ?? [],
    "notifications":
    notifications?.map((e) => e.toJson()).toList() ?? [],
  };
}

// ===================================================================
// Notifications Item
// ===================================================================

class NotificationsItem {
  String? unotificationBody;
  String? unotificationType;
  String? unotificationId;
  String? unotificationUserId;
  String? unotificationIsRead;
  String? unotificationDate;
  NotificationDetail? unotificationData;

  NotificationsItem({
    this.unotificationBody,
    this.unotificationType,
    this.unotificationId,
    this.unotificationUserId,
    this.unotificationIsRead,
    this.unotificationDate,
    this.unotificationData,
  });

  factory NotificationsItem.fromJson(Map<String, dynamic> json) {
    return NotificationsItem(
      unotificationBody: json["unotification_body"],
      unotificationType: json["unotification_type"],
      unotificationId: json["unotification_id"],
      unotificationUserId: json["unotification_user_id"],
      unotificationIsRead: json["unotification_is_read"],
      unotificationDate: json["unotification_date"],
      unotificationData: json["unotification_data"] == null
          ? null
          : NotificationDetail.fromJson(json["unotification_data"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "unotification_body": unotificationBody,
    "unotification_type": unotificationType,
    "unotification_id": unotificationId,
    "unotification_user_id": unotificationUserId,
    "unotification_is_read": unotificationIsRead,
    "unotification_date": unotificationDate,
    "unotification_data": unotificationData?.toJson(),
  };
}

// ===================================================================
// Notification Detail
// ===================================================================

class NotificationDetail {
  String? orderId;
  String? username;
  String? orderProductId;
  String? threadId;

  NotificationDetail({
    this.orderId,
    this.username,
    this.orderProductId,
    this.threadId,
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) {
    return NotificationDetail(
      orderId: json["orderId"],
      username: json["username"],
      orderProductId: json["orderProductId"],
      threadId: json["threadId"],
    );
  }

  Map<String, dynamic> toJson() => {
    "orderId": orderId,
    "username": username,
    "orderProductId": orderProductId,
    "threadId": threadId,
  };
}

// ===================================================================
// Push Notifications Item
// ===================================================================

class PushNotificationsItem {
  String? pnotificationTitle;
  String? pnotificationDescription;
  UrlDetail? urlDetail;

  PushNotificationsItem({
    this.pnotificationTitle,
    this.pnotificationDescription,
    this.urlDetail,
  });

  factory PushNotificationsItem.fromJson(Map<String, dynamic> json) {
    return PushNotificationsItem(
      pnotificationTitle: json["pnotification_title"],
      pnotificationDescription: json["pnotification_description"],
      urlDetail: json["urlDetail"] == null
          ? null
          : UrlDetail.fromJson(json["urlDetail"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "pnotification_title": pnotificationTitle,
    "pnotification_description": pnotificationDescription,
    "urlDetail": urlDetail?.toJson(),
  };
}

// ===================================================================
// Url Detail
// ===================================================================

class UrlDetail {
  String? url;
  String? recordId;
  String? urlType;

  UrlDetail({
    this.url,
    this.recordId,
    this.urlType,
  });

  factory UrlDetail.fromJson(Map<String, dynamic> json) {
    return UrlDetail(
      url: json["url"],
      recordId: json["recordId"],
      urlType: json["urlType"],
    );
  }

  Map<String, dynamic> toJson() => {
    "url": url,
    "recordId": recordId,
    "urlType": urlType,
  };
}
