class Threads {
  String? messageToEmail;
  String? threadStartedByEmail;
  String? messageId;
  String? threadStartedByName;
  String? threadStartedBy;
  String? messageFromEmail;
  String? threadStartDate;
  String? threadStartedByUsername;
  String? threadSubject;
  String? messageToUserId;
  String? messageFromName;
  String? messageFromShopName;
  String? messageToShopName;
  String? threadId;
  String? messageText;
  String? messageToName;
  String? messageIsUnread;
  String? messageTo;
  String? messageFromProfileUrl;
  String? messageToProfileUrl;
  String? messageTimestamp;
  String? messageFromUsername;
  String? messageToUsername;
  String? threadType;
  String? messageDate;
  String? messageFromUserId;
  String? threadRecordId;

  Threads({
    this.messageToEmail,
    this.threadStartedByEmail,
    this.messageId,
    this.threadStartedByName,
    this.threadStartedBy,
    this.messageFromEmail,
    this.threadStartDate,
    this.threadStartedByUsername,
    this.threadSubject,
    this.messageToUserId,
    this.messageFromName,
    this.messageFromShopName,
    this.messageToShopName,
    this.threadId,
    this.messageText,
    this.messageToName,
    this.messageIsUnread,
    this.messageTo,
    this.messageFromProfileUrl,
    this.messageToProfileUrl,
    this.messageTimestamp,
    this.messageFromUsername,
    this.messageToUsername,
    this.threadType,
    this.messageDate,
    this.messageFromUserId,
    this.threadRecordId,
  });

  factory Threads.fromJson(Map<String, dynamic> json) {
    return Threads(
      messageToEmail: json['message_to_email'],
      threadStartedByEmail: json['thread_started_by_email'],
      messageId: json['message_id'],
      threadStartedByName: json['thread_started_by_name'],
      threadStartedBy: json['thread_started_by'],
      messageFromEmail: json['message_from_email'],
      threadStartDate: json['thread_start_date'],
      threadStartedByUsername: json['thread_started_by_username'],
      threadSubject: json['thread_subject'],
      messageToUserId: json['message_to_user_id'],
      messageFromName: json['message_from_name'],
      messageFromShopName: json['message_from_shop_name'],
      messageToShopName: json['message_to_shop_name'],
      threadId: json['thread_id'],
      messageText: json['message_text'],
      messageToName: json['message_to_name'],
      messageIsUnread: json['message_is_unread'],
      messageTo: json['message_to'],
      messageFromProfileUrl: json['message_from_profile_url'],
      messageToProfileUrl: json['message_to_profile_url'],
      messageTimestamp: json['message_timestamp'],
      messageFromUsername: json['message_from_username'],
      messageToUsername: json['message_to_username'],
      threadType: json['thread_type'],
      messageDate: json['message_date'],
      messageFromUserId: json['message_from_user_id'],
      threadRecordId: json['thread_record_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message_to_email': messageToEmail,
      'thread_started_by_email': threadStartedByEmail,
      'message_id': messageId,
      'thread_started_by_name': threadStartedByName,
      'thread_started_by': threadStartedBy,
      'message_from_email': messageFromEmail,
      'thread_start_date': threadStartDate,
      'thread_started_by_username': threadStartedByUsername,
      'thread_subject': threadSubject,
      'message_to_user_id': messageToUserId,
      'message_from_name': messageFromName,
      'message_from_shop_name': messageFromShopName,
      'message_to_shop_name': messageToShopName,
      'thread_id': threadId,
      'message_text': messageText,
      'message_to_name': messageToName,
      'message_is_unread': messageIsUnread,
      'message_to': messageTo,
      'message_from_profile_url': messageFromProfileUrl,
      'message_to_profile_url': messageToProfileUrl,
      'message_timestamp': messageTimestamp,
      'message_from_username': messageFromUsername,
      'message_to_username': messageToUsername,
      'thread_type': threadType,
      'message_date': messageDate,
      'message_from_user_id': messageFromUserId,
      'thread_record_id': threadRecordId,
    };
  }
}
