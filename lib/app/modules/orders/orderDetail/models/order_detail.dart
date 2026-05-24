import 'charges.dart';
import 'comments.dart';
import 'package:flutter/material.dart';

class OrderDetail {
  String? orderId;
  String? orderNumber;
  String? orderUserId;
  String? orderDateAdded;
  String? orderNetAmount;
  String? opInvoiceNumber;
  String? totOrders;
  String? opSelprodId;
  String? opSelprodTitle;
  String? opProductName;
  String? opId;
  String? opOtherCharges;
  String? opUnitPrice;
  String? opQty;
  String? opTotalPrice;
  String? opSelprodOptions;
  String? opBrandName;
  String? opShopName;
  String? opStatusId;
  String? opProductType;
  String? orderstatusName;
  String? orderstatusColorClass;
  String? orderPmethodId;
  String? orderStatus;
  String? pluginName;
  String? returnRequest;
  String? cancelRequest;
  String? exchangeRequest;
  String? opSelprodReturnAge;
  String? opSelprodCancellationAge;
  String? opSelprodExchangeAge;
  String? orderPaymentStatus;
  String? orderDeleted;
  String? pluginCode;
  String? opshippingFulfillmentType;
  String? opRoundingOff;
  String? selprodProductId;
  String? orderstatusId;
  String? orderDiscountInfo;
 // List<Charges>? charges;
  String? orderstatusColorCode;
  String? productImageUrl;
  String? orderstatusColorClassAlt;

  String? cancel_until_date;
  String? return_until_date;
  String? exchange_until_date;
  String? missing_until_date;
  String? message_count;
  String? canReturnOrder;
  String? canExchangeOrder;

  String? return_request_date;
  String? exchange_request_date;

  OrderDetail({
    this.orderId,
    this.orderNumber,
    this.orderUserId,
    this.orderDateAdded,
    this.orderNetAmount,
    this.opInvoiceNumber,
    this.totOrders,
    this.opSelprodId,
    this.opSelprodTitle,
    this.opProductName,
    this.opId,
    this.opOtherCharges,
    this.opUnitPrice,
    this.opQty,
    this.opSelprodOptions,
    this.opBrandName,
    this.opShopName,
    this.opStatusId,
    this.opProductType,
    this.orderstatusName,
    this.orderstatusColorClass,
    this.orderPmethodId,
    this.orderStatus,
    this.pluginName,
    this.returnRequest,
    this.cancelRequest,
    this.exchangeRequest,
    this.opSelprodReturnAge,
    this.opSelprodCancellationAge,
    this.opSelprodExchangeAge,
    this.orderPaymentStatus,
    this.orderDeleted,
    this.pluginCode,
    this.opshippingFulfillmentType,
    this.opRoundingOff,
    this.selprodProductId,
    this.orderstatusId,
    this.orderDiscountInfo,
   // this.charges,
    this.orderstatusColorCode,
    this.productImageUrl,
    this.orderstatusColorClassAlt,
    this.cancel_until_date,
    this.exchange_until_date,
    this.return_until_date,
    this.missing_until_date,
    this.message_count,
    this.canExchangeOrder,
    this.canReturnOrder,
    this.exchange_request_date,
    this.return_request_date,
    this.opTotalPrice
  });

  OrderDetail.fromJson(Map<String, dynamic> json) {
    orderId = json['order_id'];
    orderNumber = json['order_number'];
    orderUserId = json['order_user_id'];
    orderDateAdded = json['order_date_added'];
    orderNetAmount = json['order_net_amount'];
    opInvoiceNumber = json['op_invoice_number'];
    totOrders = json['totOrders'];
    opSelprodId = json['op_selprod_id'];
    opSelprodTitle = json['op_selprod_title'];
    opProductName = json['op_product_name'];
    opId = json['op_id'];
    opOtherCharges = json['op_other_charges'];
    opUnitPrice = json['op_unit_price'];
    opQty = json['op_qty'];
    opTotalPrice = json['op_total_price'];
    opSelprodOptions = json['op_selprod_options'];
    opBrandName = json['op_brand_name'];
    opShopName = json['op_shop_name'];
    opStatusId = json['op_status_id'];
    opProductType = json['op_product_type'];
    orderstatusName = json['orderstatus_name'];
    orderstatusColorClass = json['orderstatus_color_class'];
    orderPmethodId = json['order_pmethod_id'];
    orderStatus = json['order_status'];
    pluginName = json['plugin_name'];
    returnRequest = json['return_request'];
    cancelRequest = json['cancel_request'];
    exchangeRequest = json['exchange_request'];
    opSelprodReturnAge = json['op_selprod_return_age'];
    opSelprodCancellationAge = json['op_selprod_cancellation_age'];
    opSelprodExchangeAge = json['op_selprod_exchange_age'];
    orderPaymentStatus = json['order_payment_status'];
    orderDeleted = json['order_deleted'];
    pluginCode = json['plugin_code'];
    opshippingFulfillmentType = json['opshipping_fulfillment_type'];
    opRoundingOff = json['op_rounding_off'];
    selprodProductId = json['selprod_product_id'];
    orderstatusId = json['orderstatus_id'];
    orderDiscountInfo = json['order_discount_info'];
    // if (json['charges'] != null) {
    //   charges = <Charges>[];
    //   json['charges'].forEach((v) {
    //     charges!.add(Charges.fromJson(v));
    //   });
    // }
    orderstatusColorCode = json['orderstatus_color_code'];
    productImageUrl = json['product_image_url'];
    orderstatusColorClassAlt = json['ord_status_color_class'];
    cancel_until_date = json['cancel_until_date'];
    return_until_date = json['return_until_date'];
    exchange_until_date = json['exchange_until_date'];
    missing_until_date = json['missing_until_date'];
    message_count = json['message_count'];
    canExchangeOrder = json['canExchangeOrder'];
    canReturnOrder = json['canReturnOrder'];
    return_request_date = json['return_request_date'];
    exchange_request_date = json['exchange_request_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['order_id'] = orderId;
    data['order_number'] = orderNumber;
    data['order_user_id'] = orderUserId;
    data['order_date_added'] = orderDateAdded;
    data['order_net_amount'] = orderNetAmount;
    data['op_invoice_number'] = opInvoiceNumber;
    data['totOrders'] = totOrders;
    data['op_selprod_id'] = opSelprodId;
    data['op_selprod_title'] = opSelprodTitle;
    data['op_product_name'] = opProductName;
    data['op_id'] = opId;
    data['op_other_charges'] = opOtherCharges;
    data['op_unit_price'] = opUnitPrice;
    data['op_qty'] = opQty;
    data['op_total_price'] = opTotalPrice;
    data['op_selprod_options'] = opSelprodOptions;
    data['op_brand_name'] = opBrandName;
    data['op_shop_name'] = opShopName;
    data['op_status_id'] = opStatusId;
    data['op_product_type'] = opProductType;
    data['orderstatus_name'] = orderstatusName;
    data['orderstatus_color_class'] = orderstatusColorClass;
    data['order_pmethod_id'] = orderPmethodId;
    data['order_status'] = orderStatus;
    data['plugin_name'] = pluginName;
    data['return_request'] = returnRequest;
    data['cancel_request'] = cancelRequest;
    data['exchange_request'] = exchangeRequest;
    data['op_selprod_return_age'] = opSelprodReturnAge;
    data['op_selprod_cancellation_age'] = opSelprodCancellationAge;
    data['op_selprod_exchange_age'] = opSelprodExchangeAge;
    data['order_payment_status'] = orderPaymentStatus;
    data['order_deleted'] = orderDeleted;
    data['plugin_code'] = pluginCode;
    data['opshipping_fulfillment_type'] = opshippingFulfillmentType;
    data['op_rounding_off'] = opRoundingOff;
    data['selprod_product_id'] = selprodProductId;
    data['orderstatus_id'] = orderstatusId;
    data['order_discount_info'] = orderDiscountInfo;
    // if (charges != null) {
    //   data['charges'] = charges!.map((v) => v.toJson()).toList();
    // }
    data['orderstatus_color_code'] = orderstatusColorCode;
    data['product_image_url'] = productImageUrl;
    data['ord_status_color_class'] = orderstatusColorClassAlt;

    data['cancel_until_date'] = cancel_until_date;
    data['return_until_date'] = return_until_date;
    data['exchange_until_date'] = exchange_until_date;
    data['missing_until_date'] = missing_until_date;
    data['message_count'] = message_count;
    data['canReturnOrder'] = canReturnOrder;
    data['canExchangeOrder'] = canExchangeOrder;
    data['return_request_date'] = return_request_date;
    data['exchange_request_date'] = exchange_request_date;


    return data;
  }

  String get statusIcon {
    switch (opStatusId) {
      case '2': // Payment Confirmed
        return 'assets/icons/Check.svg';

      case '3': // In Process
        return 'assets/icons/Clock.svg';

      case '4': // Shipped
        return 'assets/icons/Package.svg';

      case '5': // Delivered
        return 'assets/icons/Check.svg';

      case '7': // Completed
        return 'assets/icons/Check.svg';

      case '6': // Return Requested
        return 'assets/icons/ArrowUDownLeft.svg';

      case '20': // Exchange Requested
        return 'assets/icons/ArrowsLeftRight.svg';

      case '19': // Missing Requested
        return 'assets/icons/QuestionMark.svg';

      case '8': // Cancelled
        return 'assets/icons/X.svg';

      case '9': // Refunded/Completed
        return 'assets/icons/Check.svg';

      case '16': // Cash on Delivery
        return 'assets/icons/Money.svg';

      case '17': // Pay at Store
        return 'assets/icons/Money.svg';

      case '18': // Ready for Pickup
        return 'assets/icons/Check.svg';

      case '15': // Approved
        return 'assets/icons/Check.svg';

      default:
        return 'assets/icons/Check.svg';
    }
  }
}

class OtherOrderProduct {
  String? opId;
  String? productName;
  String? qty;
  String? price;
  String? image;
  String? op_selprod_options;

  OtherOrderProduct({
    this.opId,
    this.productName,
    this.qty,
    this.price,
    this.image,
    this.op_selprod_options
  });

  factory OtherOrderProduct.fromJson(Map<String, dynamic> json) {
    return OtherOrderProduct(
      opId: json['op_id']?.toString(),
      productName: json['product_name']?.toString(),
      qty: json['op_qty']?.toString(),
      price: json['op_unit_price']?.toString(),
      image: json['product_image_url']?.toString(),
      op_selprod_options: json['op_selprod_options']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'op_id': opId,
      'product_name': productName,
      'op_qty': qty,
      'op_unit_price': price,
      'product_image_url': image,
      'op_selprod_options': op_selprod_options,
    };
  }
}