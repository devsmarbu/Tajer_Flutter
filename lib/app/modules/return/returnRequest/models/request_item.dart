class RequestItem {
  String? orrequestId;
  String? orrequestUserId;
  String? orrequestQty;
  String? orrequestType;
  String? orrequestReference;
  String? orrequestDate;
  String? oerequestDate;
  String? ocrequestDate;
  String? orrequestStatus;
  String? orReasonTitle;
  String? opInvoiceNumber;
  String? opSelprodTitle;
  String? opProductName;
  String? opBrandName;
  String? opSelprodOptions;
  String? opSelprodSku;
  dynamic opProductModel; // can be String or double
  String? opId;
  String? opIsBatch;
  String? opSelprodId;
  String? orderId;
  String? orderNumber;
  String? selprodProductId;
  String? selprodTitle;
  String? requestReason;
  String? statusName;
  String? orrequestTypeTitle;
  String? productImageUrl;
  String? opRefundAmount;
  String? orRequestStatusTitle;
  String? attachmentFile;
  String? oeRequestId;
  String? ocReasonTitle;

  RequestItem({
    this.orrequestId,
    this.orrequestUserId,
    this.orrequestQty,
    this.orrequestType,
    this.orrequestReference,
    this.orrequestDate,
    this.oerequestDate,
    this.ocrequestDate,
    this.orrequestStatus,
    this.opInvoiceNumber,
    this.opSelprodTitle,
    this.opProductName,
    this.opBrandName,
    this.opSelprodOptions,
    this.opSelprodSku,
    this.opProductModel,
    this.opId,
    this.opIsBatch,
    this.opSelprodId,
    this.orderId,
    this.orderNumber,
    this.selprodProductId,
    this.selprodTitle,
    this.requestReason,
    this.statusName,
    this.orrequestTypeTitle,
    this.productImageUrl,
    this.opRefundAmount,
    this.orRequestStatusTitle,
    this.orReasonTitle,
    this.attachmentFile,
    this.oeRequestId,
    this.ocReasonTitle,
  });

  factory RequestItem.fromJson(Map<String, dynamic> json) => RequestItem(
    orrequestId: json['orrequest_id'],
    orrequestUserId: json['orrequest_user_id'],
    orrequestQty: json['orrequest_qty'],
    orrequestType: json['orrequest_type'],
    orrequestReference: json['orrequest_reference'],
    orrequestDate: json['orrequest_date'],
    oerequestDate: json['oerequest_date'],
    ocrequestDate: json['ocrequest_date'],
    orrequestStatus: json['orrequest_status'],
    opInvoiceNumber: json['op_invoice_number'],
    opSelprodTitle: json['op_selprod_title'],
    opProductName: json['op_product_name'],
    opBrandName: json['op_brand_name'],
    opSelprodOptions: json['op_selprod_options'],
    opSelprodSku: json['op_selprod_sku'],
    opProductModel: json['op_product_model'],
    opId: json['op_id'],
    opIsBatch: json['op_is_batch'],
    opSelprodId: json['op_selprod_id'],
    orderId: json['order_id'],
    orderNumber: json['order_number'],
    selprodProductId: json['selprod_product_id'],
    selprodTitle: json['selprod_title'],
    requestReason: json['requestReason'],
    statusName: json['statusName'],
    orrequestTypeTitle: json['orrequestTypeTitle'],
    productImageUrl: json['product_image_url'],
    opRefundAmount: json['op_refund_amount'],
    orRequestStatusTitle: json['orRequestStatusTitle'],
    orReasonTitle: json['orreason_title'],
    attachmentFile: json['attachmentFile'],
    oeRequestId: json['oerequest_id'],
    ocReasonTitle: json['ocreason_title'],
  );

  Map<String, dynamic> toJson() => {
    'orrequest_id': orrequestId,
    'orrequest_user_id': orrequestUserId,
    'orrequest_qty': orrequestQty,
    'orrequest_type': orrequestType,
    'orrequest_reference': orrequestReference,
    'orrequest_date': orrequestDate,
    'oerequest_date': oerequestDate,
    'ocrequest_date': ocrequestDate,
    'orrequest_status': orrequestStatus,
    'op_invoice_number': opInvoiceNumber,
    'op_selprod_title': opSelprodTitle,
    'op_product_name': opProductName,
    'op_brand_name': opBrandName,
    'op_selprod_options': opSelprodOptions,
    'op_selprod_sku': opSelprodSku,
    'op_product_model': opProductModel,
    'op_id': opId,
    'op_is_batch': opIsBatch,
    'op_selprod_id': opSelprodId,
    'order_id': orderId,
    'order_number': orderNumber,
    'selprod_product_id': selprodProductId,
    'selprod_title': selprodTitle,
    'requestReason': requestReason,
    'statusName': statusName,
    'orrequestTypeTitle': orrequestTypeTitle,
    'product_image_url': productImageUrl,
    'op_refund_amount': opRefundAmount,
    'orRequestStatusTitle': orRequestStatusTitle,
    'orreason_title': orReasonTitle,
    'attachmentFile': attachmentFile,
    'oerequest_id': oeRequestId,
    'ocreason_title': ocReasonTitle,
  };
}