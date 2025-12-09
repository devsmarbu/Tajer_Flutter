class ReturnMessage {
  String? orrmsgMsg;
  String? orrmsgFromAdminId;
  String? orrequestStatus;
  String? msgUserName;
  String? orrmsgId;
  String? opSelprodUserId;
  String? orrmsgDate;
  String? adminName;
  String? shopIdentifier;
  String? orrmsgFromUserId;

  ReturnMessage({
    this.orrmsgMsg,
    this.orrmsgFromAdminId,
    this.orrequestStatus,
    this.msgUserName,
    this.orrmsgId,
    this.opSelprodUserId,
    this.orrmsgDate,
    this.adminName,
    this.shopIdentifier,
    this.orrmsgFromUserId,
  });

  factory ReturnMessage.fromJson(Map<String, dynamic> json) {
    return ReturnMessage(
      orrmsgMsg: json['orrmsg_msg'],
      orrmsgFromAdminId: json['orrmsg_from_admin_id'],
      orrequestStatus: json['orrequest_status'],
      msgUserName: json['msg_user_name'],
      orrmsgId: json['orrmsg_id'],
      opSelprodUserId: json['op_selprod_user_id'],
      orrmsgDate: json['orrmsg_date'],
      adminName: json['admin_name'],
      shopIdentifier: json['shop_identifier'],
      orrmsgFromUserId: json['orrmsg_from_user_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orrmsg_msg': orrmsgMsg,
      'orrmsg_from_admin_id': orrmsgFromAdminId,
      'orrequest_status': orrequestStatus,
      'msg_user_name': msgUserName,
      'orrmsg_id': orrmsgId,
      'op_selprod_user_id': opSelprodUserId,
      'orrmsg_date': orrmsgDate,
      'admin_name': adminName,
      'shop_identifier': shopIdentifier,
      'orrmsg_from_user_id': orrmsgFromUserId,
    };
  }

  @override
  String toString() {
    return 'ReturnMessage{orrmsg_msg: $orrmsgMsg, orrmsg_from_admin_id: $orrmsgFromAdminId, orrequest_status: $orrequestStatus, msg_user_name: $msgUserName, orrmsg_id: $orrmsgId, op_selprod_user_id: $opSelprodUserId, orrmsg_date: $orrmsgDate, admin_name: $adminName, shop_identifier: $shopIdentifier, orrmsg_from_user_id: $orrmsgFromUserId}';
  }
}
