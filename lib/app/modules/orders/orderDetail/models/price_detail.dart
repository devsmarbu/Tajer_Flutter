
import 'package:tajer/app/modules/orders/orderDetail/models/rates.dart';
import 'package:tajer/app/modules/orders/orderDetail/models/time_slot.dart';

import 'address.dart';

class PriceDetail {
  final String key;
  final String value;
  final bool isBold;

  PriceDetail({
    required this.key,
    required this.value,
    required this.isBold,
  });

  // Factory constructor to create PriceDetail from JSON
  factory PriceDetail.fromJson(Map<String, dynamic> json) {
    return PriceDetail(
      key: json['key'] ?? '',
      value: json['value'] ?? '',
      isBold: json['isBold'] ?? false,
    );
  }

  // Method to convert PriceDetail to JSON
  Map<String, dynamic> toJson() {
    return {
      'key': key,
      'value': value,
      'isBold': isBold,
    };
  }
}


class ProductItems {
  final String title;
  final List<ProductData> data;
  String pickupBy;
  final List<Address> pickupAddresses;
  final List<Products> products;
  Address? selectedPickUpAddress;
  int selectedDate;
  TimeSlot selectedTimeSlot;
  Address pickupAddress;

  ProductItems({
    required this.title,
    this.data = const [],
    required this.pickupBy,
    this.pickupAddresses = const [],
    this.products = const [],
    this.selectedPickUpAddress,
    this.selectedDate = 0,
    required this.selectedTimeSlot,
    required this.pickupAddress,
  });
}

class ProductData {
  final Rates rates;
  final List<Products> products;
  final String shipLevel;

  ProductData({
    required this.rates,
    this.products = const [],
    required this.shipLevel,
  });
}

// Define Products class
class Products {
  final String productId;
  final String productType;
  final String productShipFree;
  final String selprodId;
  final String selprodCode;
  final String selprodStock;
  final String inStock;
  final String selprodMinOrderQty;
  final String specialPriceFound;
  final String thePrice;
  final String? discount;
  final String shopId;
  final String shopFreeShipUpto;
  final String splpriceDisplayListPrice;
  final String splpriceDisplayDisVal;
  final String splpriceDisplayDisType;
  final String selprodPrice;
  final String selprodCost;
  final String productSellerId;
  final String productCodEnabled;
  final String shopFulfillmentType;
  final String selprodFulfillmentType;
  final String selprodCodEnabled;
  final String productName;
  String? opComments;
  bool? isDeliver;
  final String selprodTitle;
  final String brandName;
  final String shopName;
  final String isInAnyWishlist;
  final String uwlpUwlistId;
  final String volumeDiscount;
  final String volumeDiscountPercentage;
  final String volumeDiscountTotal;
  final String shippingCost;
  final String total;
  final String netTotal;
  final int isDigitalProduct;
  final int isServiceProduct;
  final int isPhysicalProduct;
  final List<Options> options;
  final String isProductShippedBySeller;
  final String fulfillmentType;
  final String key;
  final String quantity;
  final String hasPhysicalProduct;
  final String hasDigitalProduct;
  final String isCodEnabled;
  final String productUrl;
  final String shopUrl;
  final String imageUrl;

  Products({
    required this.productId,
    required this.productType,
    required this.productShipFree,
    required this.selprodId,
    required this.selprodCode,
    required this.selprodStock,
    required this.inStock,
    required this.selprodMinOrderQty,
    required this.specialPriceFound,
    required this.thePrice,
    this.discount,
    required this.shopId,
    required this.shopFreeShipUpto,
    required this.splpriceDisplayListPrice,
    required this.splpriceDisplayDisVal,
    required this.splpriceDisplayDisType,
    required this.selprodPrice,
    required this.selprodCost,
    required this.productSellerId,
    required this.productCodEnabled,
    required this.shopFulfillmentType,
    required this.selprodFulfillmentType,
    required this.selprodCodEnabled,
    required this.productName,
    this.opComments,
    this.isDeliver,
    required this.selprodTitle,
    required this.brandName,
    required this.shopName,
    required this.isInAnyWishlist,
    required this.uwlpUwlistId,
    required this.volumeDiscount,
    required this.volumeDiscountPercentage,
    required this.volumeDiscountTotal,
    required this.shippingCost,
    required this.total,
    required this.netTotal,
    required this.isDigitalProduct,
    required this.isServiceProduct,
    required this.isPhysicalProduct,
    this.options = const [],
    required this.isProductShippedBySeller,
    required this.fulfillmentType,
    required this.key,
    required this.quantity,
    required this.hasPhysicalProduct,
    required this.hasDigitalProduct,
    required this.isCodEnabled,
    required this.productUrl,
    required this.shopUrl,
    required this.imageUrl,
  });
}

class Options {
  final int optionId;
  final int optionvalueId;
  final String optionName;
  final String optionvalueName;

  Options({
    required this.optionId,
    required this.optionvalueId,
    required this.optionName,
    required this.optionvalueName,
  });
}


