import 'package:tajer/app/modules/orders/orderDetail/models/address.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/price_detail.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/shipping_guidelines.dart';

import 'net_payable.dart';

class ShippingDataNew {
  final String currencySymbol;
  final int totalFavouriteItems;
  final int totalUnreadMessageCount;
  final int totalUnreadNotificationCount;
  final int cartItemsCount;
  final int fulfillmentType;
  final String productsCount;
  final String hasPhysicalProd;
  final Address addresses;
  final List<ProductItems> productItems;
  final int isShippingPluginActive;
  final ShippingGuidelines? shippingGuidelines;
  final List<PriceDetail> priceDetail;
  final NetPayable netPayable;

  ShippingDataNew({
    required this.currencySymbol,
    required this.totalFavouriteItems,
    required this.totalUnreadMessageCount,
    required this.totalUnreadNotificationCount,
    required this.cartItemsCount,
    required this.fulfillmentType,
    required this.productsCount,
    required this.hasPhysicalProd,
    required this.addresses,
    required this.productItems,
    required this.isShippingPluginActive,
    this.shippingGuidelines,
    required this.priceDetail,
    required this.netPayable,
  });
}