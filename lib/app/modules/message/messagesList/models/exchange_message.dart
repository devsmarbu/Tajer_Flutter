class ExchangeMessage {
  String? adminName;
  String? msgUserName;
  String? oerequestStatus;
  String? oermsgDate;
  String? oermsgFromAdminId;
  String? oermsgFromUserId;
  String? oermsgId;
  String? oermsgMsg;
  String? opRoundingOff;
  String? opSelprodUserId;
  String? shopId;
  String? shopName;

  ExchangeMessage({
    this.adminName,
    this.msgUserName,
    this.oerequestStatus,
    this.oermsgDate,
    this.oermsgFromAdminId,
    this.oermsgFromUserId,
    this.oermsgId,
    this.oermsgMsg,
    this.opRoundingOff,
    this.opSelprodUserId,
    this.shopId,
    this.shopName,
  });

  factory ExchangeMessage.fromJson(Map<String, dynamic> json) {
    return ExchangeMessage(
      adminName: json['admin_name'],
      msgUserName: json['msg_user_name'],
      oerequestStatus: json['oerequest_status'],
      oermsgDate: json['oermsg_date'],
      oermsgFromAdminId: json['oermsg_from_admin_id'],
      oermsgFromUserId: json['oermsg_from_user_id'],
      oermsgId: json['oermsg_id'],
      oermsgMsg: json['oermsg_msg'],
      opRoundingOff: json['op_rounding_off'],
      opSelprodUserId: json['op_selprod_user_id'],
      shopId: json['shop_id'],
      shopName: json['shop_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'admin_name': adminName,
      'msg_user_name': msgUserName,
      'oerequest_status': oerequestStatus,
      'oermsg_date': oermsgDate,
      'oermsg_from_admin_id': oermsgFromAdminId,
      'oermsg_from_user_id': oermsgFromUserId,
      'oermsg_id': oermsgId,
      'oermsg_msg': oermsgMsg,
      'op_rounding_off': opRoundingOff,
      'op_selprod_user_id': opSelprodUserId,
      'shop_id': shopId,
      'shop_name': shopName,
    };
  }

  @override
  String toString() {
    return 'ExchangeMessage{admin_name: $adminName, msg_user_name: $msgUserName, oerequest_status: $oerequestStatus, oermsg_date: $oermsgDate, oermsg_from_admin_id: $oermsgFromAdminId, oermsg_from_user_id: $oermsgFromUserId, oermsg_id: $oermsgId, oermsg_msg: $oermsgMsg, op_rounding_off: $opRoundingOff, op_selprod_user_id: $opSelprodUserId, shop_id: $shopId, shop_name: $shopName}';
  }
}
