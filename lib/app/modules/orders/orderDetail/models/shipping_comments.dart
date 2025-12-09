class ShippingComments {
  String? oshistoryId;
  String? oshistoryOrderId;
  String? opOrderId;
  String? opProductDimensionUnit;
  String? opshippingBySellerUserId;
  String? orderIsPaid;
  String? opReviewReminderCount;
  String? oshistoryDateAdded;
  String? opSelprodSku;
  String? opRefundAmount;
  String? opProductWeight;
  String? scompanyName;
  String? opQty;
  String? oshistoryCustomerNotified;
  String? opRefundCommission;
  String? opIsBatch;
  String? opShopOwnerEmail;
  String? opProductModel;
  String? opShopId;
  String? opCompletionDate;
  String? opBrandName;
  String? opshippingCompanyId;
  String? opShopName;
  String? oshistoryTrackingNumber;
  String? oshistoryTrackingUrl;
  String? opProductName;
  String? opSentReviewReminder;
  String? opSelprodDownloadValidityInDays;
  String? opRefundAffiliateCommission;
  String? opSelprodCode;
  String? oshistoryComments;
  String? opSelprodCondition;
  String? opCommissionCharged;
  String? opProductWidth;
  String? opSelprodMaxDownloadTimes;
  String? oshistoryOrderstatusId;
  String? orderShippingapiName;
  String? oshistoryOrderPaymentStatus;
  String? opProductHeight;
  String? opShippedDate;
  String? opInvoiceNumber;
  String? opRefundShipping;
  String? opAffiliateCommissionCharged;
  String? opSentLastReminder;
  String? opCommissionPercentage;
  String? opBatchSelprodId;
  String? opSelprodUserId;
  String? opShopOwnerName;
  String? opStatusId;
  String? opOtherCharges;
  String? opShopOwnerUsername;
  String? opFreeShipUpto;
  String? opRefundQty;
  String? opProductLength;
  String? opUnitPrice;
  String? opShippingDurationName;
  String? opSdurationId;
  String? orderstatusName;
  String? opId;
  String? opActualShippingCharges;
  String? opProductType;
  String? opUnitCost;
  String? opAffiliateCommissionPercentage;
  String? opProductWeightUnit;
  String? opShopOwnerPhone;
  String? orderLanguageId;
  String? opSelprodOptions;
  String? opSelprodId;
  String? oshistoryOpId;
  String? oshistoryCourier;

  ShippingComments({
    this.oshistoryId,
    this.oshistoryOrderId,
    this.opOrderId,
    this.opProductDimensionUnit,
    this.opshippingBySellerUserId,
    this.orderIsPaid,
    this.opReviewReminderCount,
    this.oshistoryDateAdded,
    this.opSelprodSku,
    this.opRefundAmount,
    this.opProductWeight,
    this.scompanyName,
    this.opQty,
    this.oshistoryCustomerNotified,
    this.opRefundCommission,
    this.opIsBatch,
    this.opShopOwnerEmail,
    this.opProductModel,
    this.opShopId,
    this.opCompletionDate,
    this.opBrandName,
    this.opshippingCompanyId,
    this.opShopName,
    this.oshistoryTrackingNumber,
    this.oshistoryTrackingUrl,
    this.opProductName,
    this.opSentReviewReminder,
    this.opSelprodDownloadValidityInDays,
    this.opRefundAffiliateCommission,
    this.opSelprodCode,
    this.oshistoryComments,
    this.opSelprodCondition,
    this.opCommissionCharged,
    this.opProductWidth,
    this.opSelprodMaxDownloadTimes,
    this.oshistoryOrderstatusId,
    this.orderShippingapiName,
    this.oshistoryOrderPaymentStatus,
    this.opProductHeight,
    this.opShippedDate,
    this.opInvoiceNumber,
    this.opRefundShipping,
    this.opAffiliateCommissionCharged,
    this.opSentLastReminder,
    this.opCommissionPercentage,
    this.opBatchSelprodId,
    this.opSelprodUserId,
    this.opShopOwnerName,
    this.opStatusId,
    this.opOtherCharges,
    this.opShopOwnerUsername,
    this.opFreeShipUpto,
    this.opRefundQty,
    this.opProductLength,
    this.opUnitPrice,
    this.opShippingDurationName,
    this.opSdurationId,
    this.orderstatusName,
    this.opId,
    this.opActualShippingCharges,
    this.opProductType,
    this.opUnitCost,
    this.opAffiliateCommissionPercentage,
    this.opProductWeightUnit,
    this.opShopOwnerPhone,
    this.orderLanguageId,
    this.opSelprodOptions,
    this.opSelprodId,
    this.oshistoryOpId,
    this.oshistoryCourier,
  });

  factory ShippingComments.fromJson(Map<String, dynamic> json) {
    return ShippingComments(
      oshistoryId: json["oshistory_id"],
      oshistoryOrderId: json["oshistory_order_id"],
      opOrderId: json["op_order_id"],
      opProductDimensionUnit: json["op_product_dimension_unit"],
      opshippingBySellerUserId: json["opshipping_by_seller_user_id"],
      orderIsPaid: json["order_is_paid"],
      opReviewReminderCount: json["op_review_reminder_count"],
      oshistoryDateAdded: json["oshistory_date_added"],
      opSelprodSku: json["op_selprod_sku"],
      opRefundAmount: json["op_refund_amount"],
      opProductWeight: json["op_product_weight"],
      scompanyName: json["scompany_name"],
      opQty: json["op_qty"],
      oshistoryCustomerNotified: json["oshistory_customer_notified"],
      opRefundCommission: json["op_refund_commission"],
      opIsBatch: json["op_is_batch"],
      opShopOwnerEmail: json["op_shop_owner_email"],
      opProductModel: json["op_product_model"],
      opShopId: json["op_shop_id"],
      opCompletionDate: json["op_completion_date"],
      opBrandName: json["op_brand_name"],
      opshippingCompanyId: json["opshipping_company_id"],
      opShopName: json["op_shop_name"],
      oshistoryTrackingNumber: json["oshistory_tracking_number"],
      oshistoryTrackingUrl: json["oshistory_tracking_url"],
      opProductName: json["op_product_name"],
      opSentReviewReminder: json["op_sent_review_reminder"],
      opSelprodDownloadValidityInDays: json["op_selprod_download_validity_in_days"],
      opRefundAffiliateCommission: json["op_refund_affiliate_commission"],
      opSelprodCode: json["op_selprod_code"],
      oshistoryComments: json["oshistory_comments"],
      opSelprodCondition: json["op_selprod_condition"],
      opCommissionCharged: json["op_commission_charged"],
      opProductWidth: json["op_product_width"],
      opSelprodMaxDownloadTimes: json["op_selprod_max_download_times"],
      oshistoryOrderstatusId: json["oshistory_orderstatus_id"],
      orderShippingapiName: json["order_shippingapi_name"],
      oshistoryOrderPaymentStatus: json["oshistory_order_payment_status"],
      opProductHeight: json["op_product_height"],
      opShippedDate: json["op_shipped_date"],
      opInvoiceNumber: json["op_invoice_number"],
      opRefundShipping: json["op_refund_shipping"],
      opAffiliateCommissionCharged: json["op_affiliate_commission_charged"],
      opSentLastReminder: json["op_sent_last_reminder"],
      opCommissionPercentage: json["op_commission_percentage"],
      opBatchSelprodId: json["op_batch_selprod_id"],
      opSelprodUserId: json["op_selprod_user_id"],
      opShopOwnerName: json["op_shop_owner_name"],
      opStatusId: json["op_status_id"],
      opOtherCharges: json["op_other_charges"],
      opShopOwnerUsername: json["op_shop_owner_username"],
      opFreeShipUpto: json["op_free_ship_upto"],
      opRefundQty: json["op_refund_qty"],
      opProductLength: json["op_product_length"],
      opUnitPrice: json["op_unit_price"],
      opShippingDurationName: json["op_shipping_duration_name"],
      opSdurationId: json["op_sduration_id"],
      orderstatusName: json["orderstatus_name"],
      opId: json["op_id"],
      opActualShippingCharges: json["op_actual_shipping_charges"],
      opProductType: json["op_product_type"],
      opUnitCost: json["op_unit_cost"],
      opAffiliateCommissionPercentage: json["op_affiliate_commission_percentage"],
      opProductWeightUnit: json["op_product_weight_unit"],
      opShopOwnerPhone: json["op_shop_owner_phone"],
      orderLanguageId: json["order_language_id"],
      opSelprodOptions: json["op_selprod_options"],
      opSelprodId: json["op_selprod_id"],
      oshistoryOpId: json["oshistory_op_id"],
      oshistoryCourier: json["oshistory_courier"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "oshistory_id": oshistoryId,
      "oshistory_order_id": oshistoryOrderId,
      "op_order_id": opOrderId,
      "op_product_dimension_unit": opProductDimensionUnit,
      "opshipping_by_seller_user_id": opshippingBySellerUserId,
      "order_is_paid": orderIsPaid,
      "op_review_reminder_count": opReviewReminderCount,
      "oshistory_date_added": oshistoryDateAdded,
      "op_selprod_sku": opSelprodSku,
      "op_refund_amount": opRefundAmount,
      "op_product_weight": opProductWeight,
      "scompany_name": scompanyName,
      "op_qty": opQty,
      "oshistory_customer_notified": oshistoryCustomerNotified,
      "op_refund_commission": opRefundCommission,
      "op_is_batch": opIsBatch,
      "op_shop_owner_email": opShopOwnerEmail,
      "op_product_model": opProductModel,
      "op_shop_id": opShopId,
      "op_completion_date": opCompletionDate,
      "op_brand_name": opBrandName,
      "opshipping_company_id": opshippingCompanyId,
      "op_shop_name": opShopName,
      "oshistory_tracking_number": oshistoryTrackingNumber,
      "oshistory_tracking_url": oshistoryTrackingUrl,
      "op_product_name": opProductName,
      "op_sent_review_reminder": opSentReviewReminder,
      "op_selprod_download_validity_in_days": opSelprodDownloadValidityInDays,
      "op_refund_affiliate_commission": opRefundAffiliateCommission,
      "op_selprod_code": opSelprodCode,
      "oshistory_comments": oshistoryComments,
      "op_selprod_condition": opSelprodCondition,
      "op_commission_charged": opCommissionCharged,
      "op_product_width": opProductWidth,
      "op_selprod_max_download_times": opSelprodMaxDownloadTimes,
      "oshistory_orderstatus_id": oshistoryOrderstatusId,
      "order_shippingapi_name": orderShippingapiName,
      "oshistory_order_payment_status": oshistoryOrderPaymentStatus,
      "op_product_height": opProductHeight,
      "op_shipped_date": opShippedDate,
      "op_invoice_number": opInvoiceNumber,
      "op_refund_shipping": opRefundShipping,
      "op_affiliate_commission_charged": opAffiliateCommissionCharged,
      "op_sent_last_reminder": opSentLastReminder,
      "op_commission_percentage": opCommissionPercentage,
      "op_batch_selprod_id": opBatchSelprodId,
      "op_selprod_user_id": opSelprodUserId,
      "op_shop_owner_name": opShopOwnerName,
      "op_status_id": opStatusId,
      "op_other_charges": opOtherCharges,
      "op_shop_owner_username": opShopOwnerUsername,
      "op_free_ship_upto": opFreeShipUpto,
      "op_refund_qty": opRefundQty,
      "op_product_length": opProductLength,
      "op_unit_price": opUnitPrice,
      "op_shipping_duration_name": opShippingDurationName,
      "op_sduration_id": opSdurationId,
      "orderstatus_name": orderstatusName,
      "op_id": opId,
      "op_actual_shipping_charges": opActualShippingCharges,
      "op_product_type": opProductType,
      "op_unit_cost": opUnitCost,
      "op_affiliate_commission_percentage": opAffiliateCommissionPercentage,
      "op_product_weight_unit": opProductWeightUnit,
      "op_shop_owner_phone": opShopOwnerPhone,
      "order_language_id": orderLanguageId,
      "op_selprod_options": opSelprodOptions,
      "op_selprod_id": opSelprodId,
      "oshistory_op_id": oshistoryOpId,
      "oshistory_courier": oshistoryCourier,
    };
  }
}
