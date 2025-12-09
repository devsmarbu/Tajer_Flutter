import 'package:tajer/app/modules/message/messagesList/models/return_message.dart';
import 'package:tajer/app/modules/message/messagesList/models/threads.dart';

import 'exchange_message.dart';

class MessageData {
  String? totalUnreadMessageCount;
  String? totalUnreadNotificationCount;
  String? pageCount;
  String? cartItemsCount;
  String? recordCount;
  String? totalRecords;
  String? currencySymbol;
  List<Threads>? threads;
  List<Threads>? messages; // for last messages list
  List<ReturnMessage>? messagesList;
  List<ExchangeMessage>? exchangeMessagesList;
  String? pageSize;
  String? page;
  String? totalFavouriteItems;

  MessageData({
    this.totalUnreadMessageCount,
    this.totalUnreadNotificationCount,
    this.pageCount,
    this.cartItemsCount,
    this.recordCount,
    this.totalRecords,
    this.currencySymbol,
    this.threads,
    this.messages,
    this.messagesList,
    this.exchangeMessagesList,
    this.pageSize,
    this.page,
    this.totalFavouriteItems,
  });

  factory MessageData.fromJson(Map<String, dynamic> json) {
    return MessageData(
      totalUnreadMessageCount: json['totalUnreadMessageCount'],
      totalUnreadNotificationCount: json['totalUnreadNotificationCount'],
      pageCount: json['pageCount'],
      cartItemsCount: json['cartItemsCount'],
      recordCount: json['recordCount'],
      totalRecords: json['totalRecords'],
      currencySymbol: json['currencySymbol'],
      threads: (json['threads'] as List?)
          ?.map((e) => Threads.fromJson(e))
          .toList(),
      messages: (json['messages'] as List?)
          ?.map((e) => Threads.fromJson(e))
          .toList(),
      messagesList: (json['messagesList'] as List?)
          ?.map((e) => ReturnMessage.fromJson(e))
          .toList(),
      exchangeMessagesList: (json['exchangeMessagesList'] as List?)
          ?.map((e) => ExchangeMessage.fromJson(e))
          .toList(),
      pageSize: json['pageSize'],
      page: json['page'],
      totalFavouriteItems: json['totalFavouriteItems'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalUnreadMessageCount': totalUnreadMessageCount,
      'totalUnreadNotificationCount': totalUnreadNotificationCount,
      'pageCount': pageCount,
      'cartItemsCount': cartItemsCount,
      'recordCount': recordCount,
      'totalRecords': totalRecords,
      'currencySymbol': currencySymbol,
      'threads': threads?.map((e) => e.toJson()).toList(),
      'messages': messages?.map((e) => e.toJson()).toList(),
      'messagesList': messagesList?.map((e) => e.toJson()).toList(),
      'exchangeMessagesList': exchangeMessagesList?.map((e) => e.toJson()).toList(),
      'pageSize': pageSize,
      'page': page,
      'totalFavouriteItems': totalFavouriteItems,
    };
  }
}
