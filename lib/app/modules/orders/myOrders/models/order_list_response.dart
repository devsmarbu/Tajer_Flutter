import 'package:tajer/app/modules/orders/orderDetail/models/order_detail.dart';


class OrderListResponse {
  final String totalUnreadMessageCount;
  final String totalUnreadNotificationCount;
  final String pageCount;
  final String cartItemsCount;
  final String recordCount;
  final String currencySymbol;
  final List<OrderDetail> orders;
  final String page;
  final String totalFavouriteItems;
  final List<OrderStatusModel> orderStatuses;

  OrderListResponse({
    required this.totalUnreadMessageCount,
    required this.totalUnreadNotificationCount,
    required this.pageCount,
    required this.cartItemsCount,
    required this.recordCount,
    required this.currencySymbol,
    required this.orders,
    required this.page,
    required this.totalFavouriteItems,
    required this.orderStatuses,
  });

  factory OrderListResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json; // handle both direct & nested cases
    return OrderListResponse(
      totalUnreadMessageCount: data['totalUnreadMessageCount']?.toString() ?? '0',
      totalUnreadNotificationCount: data['totalUnreadNotificationCount']?.toString() ?? '0',
      pageCount: data['pageCount']?.toString() ?? '1',
      cartItemsCount: data['cartItemsCount']?.toString() ?? '0',
      recordCount: data['recordCount']?.toString() ?? '0',
      currencySymbol: data['currencySymbol'] ?? '',
      orders: (data['orders'] as List? ?? [])
          .map((e) => OrderDetail.fromJson(e))
          .toList(),
      page: data['page']?.toString() ?? '1',
      totalFavouriteItems: data['totalFavouriteItems']?.toString() ?? '0',
      orderStatuses: (data['orderStatuses'] as List? ?? [])
          .map((e) => OrderStatusModel.fromJson(e))
          .toList(),
    );
  }
}



class OrderStatusModel {
  final String orderStatusId;
  final String orderstatusName;

  OrderStatusModel({
    required this.orderStatusId,
    required this.orderstatusName
  });

  factory OrderStatusModel.fromJson(Map<String, dynamic> json) {
    return OrderStatusModel(
    orderStatusId: json['orderstatus_id']?.toString() ?? '',
orderstatusName: json['orderstatus_name'] ?? '',
    );
  }
}
