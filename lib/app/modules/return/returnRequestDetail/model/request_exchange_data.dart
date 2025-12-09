class RequestExchangeData {
  String? attachmentFile;
  String? oerequestDate;
  String? oerequestId;
  String? oerequestOpId;
  String? oerequestQty;
  String? oerequestReference;
  String? oerequestStatus;
  String? oerequestUserId;
  String? opActualShippingCharges;
  String? opAffiliateCommissionPercentage;
  String? opBrandName;
  String? opCommissionIncludeShipping;
  String? opCommissionIncludeTax;
  String? opCommissionPercentage;
  String? opFreeShipUpto;
  String? opInvoiceNumber;
  String? opOtherCharges;
  String? opProductModel;
  String? opProductName;
  String? opQty;
  String? opRefundAmount;
  String? opRoundingOff;
  String? opSelprodId;
  String? opSelprodOptions;
  String? opSelprodSku;
  String? opSelprodTitle;
  String? opSelprodUserId;
  String? opShopId;
  String? opShopName;
  String? opShopOwnerName;
  String? opTaxAfterDiscount;
  String? opUnitPrice;
  String? opShippingBySellerUserId;
  String? orRequestStatusTitle;
  String? orderTaxCharged;
  String? orreasonTitle;
  String? selprodProductId;

  RequestExchangeData({
    this.attachmentFile,
    this.oerequestDate,
    this.oerequestId,
    this.oerequestOpId,
    this.oerequestQty,
    this.oerequestReference,
    this.oerequestStatus,
    this.oerequestUserId,
    this.opActualShippingCharges,
    this.opAffiliateCommissionPercentage,
    this.opBrandName,
    this.opCommissionIncludeShipping,
    this.opCommissionIncludeTax,
    this.opCommissionPercentage,
    this.opFreeShipUpto,
    this.opInvoiceNumber,
    this.opOtherCharges,
    this.opProductModel,
    this.opProductName,
    this.opQty,
    this.opRefundAmount,
    this.opRoundingOff,
    this.opSelprodId,
    this.opSelprodOptions,
    this.opSelprodSku,
    this.opSelprodTitle,
    this.opSelprodUserId,
    this.opShopId,
    this.opShopName,
    this.opShopOwnerName,
    this.opTaxAfterDiscount,
    this.opUnitPrice,
    this.opShippingBySellerUserId,
    this.orRequestStatusTitle,
    this.orderTaxCharged,
    this.orreasonTitle,
    this.selprodProductId,
  });

  factory RequestExchangeData.fromJson(Map<String, dynamic> json) =>
      RequestExchangeData(
        attachmentFile: json['attachmentFile'],
        oerequestDate: json['oerequest_date'],
        oerequestId: json['oerequest_id'],
        oerequestOpId: json['oerequest_op_id'],
        oerequestQty: json['oerequest_qty'],
        oerequestReference: json['oerequest_reference'],
        oerequestStatus: json['oerequest_status'],
        oerequestUserId: json['oerequest_user_id'],
        opActualShippingCharges: json['op_actual_shipping_charges'],
        opAffiliateCommissionPercentage: json['op_affiliate_commission_percentage'],
        opBrandName: json['op_brand_name'],
        opCommissionIncludeShipping: json['op_commission_include_shipping'],
        opCommissionIncludeTax: json['op_commission_include_tax'],
        opCommissionPercentage: json['op_commission_percentage'],
        opFreeShipUpto: json['op_free_ship_upto'],
        opInvoiceNumber: json['op_invoice_number'],
        opOtherCharges: json['op_other_charges'],
        opProductModel: json['op_product_model'],
        opProductName: json['op_product_name'],
        opQty: json['op_qty'],
        opRefundAmount: json['op_refund_amount'],
        opRoundingOff: json['op_rounding_off'],
        opSelprodId: json['op_selprod_id'],
        opSelprodOptions: json['op_selprod_options'],
        opSelprodSku: json['op_selprod_sku'],
        opSelprodTitle: json['op_selprod_title'],
        opSelprodUserId: json['op_selprod_user_id'],
        opShopId: json['op_shop_id'],
        opShopName: json['op_shop_name'],
        opShopOwnerName: json['op_shop_owner_name'],
        opTaxAfterDiscount: json['op_tax_after_discount'],
        opUnitPrice: json['op_unit_price'],
        opShippingBySellerUserId: json['opshipping_by_seller_user_id'],
        orRequestStatusTitle: json['orRequestStatusTitle'],
        orderTaxCharged: json['order_tax_charged'],
        orreasonTitle: json['orreason_title'],
        selprodProductId: json['selprod_product_id'],
      );

  Map<String, dynamic> toJson() => {
    'attachmentFile': attachmentFile,
    'oerequest_date': oerequestDate,
    'oerequest_id': oerequestId,
    'oerequest_op_id': oerequestOpId,
    'oerequest_qty': oerequestQty,
    'oerequest_reference': oerequestReference,
    'oerequest_status': oerequestStatus,
    'oerequest_user_id': oerequestUserId,
    'op_actual_shipping_charges': opActualShippingCharges,
    'op_affiliate_commission_percentage': opAffiliateCommissionPercentage,
    'op_brand_name': opBrandName,
    'op_commission_include_shipping': opCommissionIncludeShipping,
    'op_commission_include_tax': opCommissionIncludeTax,
    'op_commission_percentage': opCommissionPercentage,
    'op_free_ship_upto': opFreeShipUpto,
    'op_invoice_number': opInvoiceNumber,
    'op_other_charges': opOtherCharges,
    'op_product_model': opProductModel,
    'op_product_name': opProductName,
    'op_qty': opQty,
    'op_refund_amount': opRefundAmount,
    'op_rounding_off': opRoundingOff,
    'op_selprod_id': opSelprodId,
    'op_selprod_options': opSelprodOptions,
    'op_selprod_sku': opSelprodSku,
    'op_selprod_title': opSelprodTitle,
    'op_selprod_user_id': opSelprodUserId,
    'op_shop_id': opShopId,
    'op_shop_name': opShopName,
    'op_shop_owner_name': opShopOwnerName,
    'op_tax_after_discount': opTaxAfterDiscount,
    'op_unit_price': opUnitPrice,
    'opshipping_by_seller_user_id': opShippingBySellerUserId,
    'orRequestStatusTitle': orRequestStatusTitle,
    'order_tax_charged': orderTaxCharged,
    'orreason_title': orreasonTitle,
    'selprod_product_id': selprodProductId,
  };
}
