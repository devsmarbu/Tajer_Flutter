import 'dart:convert';

class BankInfo {
  String? ubUserId;
  String? ubBankAddress;
  String? ubIfscSwiftCode;
  String? ubBankName;
  String? ubAccountNumber;
  String? ubAccountHolderName;

  BankInfo({
    this.ubUserId,
    this.ubBankAddress,
    this.ubIfscSwiftCode,
    this.ubBankName,
    this.ubAccountNumber,
    this.ubAccountHolderName,
  });

  /// ✅ From JSON
  factory BankInfo.fromJson(Map<String, dynamic> json) {
    return BankInfo(
      ubUserId: json['ub_user_id']?.toString(),
      ubBankAddress: json['ub_bank_address']?.toString(),
      ubIfscSwiftCode: json['ub_ifsc_swift_code']?.toString(),
      ubBankName: json['ub_bank_name']?.toString(),
      ubAccountNumber: json['ub_account_number']?.toString(),
      ubAccountHolderName: json['ub_account_holder_name']?.toString(),
    );
  }

  /// ✅ To JSON
  Map<String, dynamic> toJson() {
    return {
      'ub_user_id': ubUserId,
      'ub_bank_address': ubBankAddress,
      'ub_ifsc_swift_code': ubIfscSwiftCode,
      'ub_bank_name': ubBankName,
      'ub_account_number': ubAccountNumber,
      'ub_account_holder_name': ubAccountHolderName,
    };
  }

  /// ✅ String representation (like Java toString)
  @override
  String toString() {
    return '''
BankInfo{
  ub_user_id: $ubUserId,
  ub_bank_address: $ubBankAddress,
  ub_ifsc_swift_code: $ubIfscSwiftCode,
  ub_bank_name: $ubBankName,
  ub_account_number: $ubAccountNumber,
  ub_account_holder_name: $ubAccountHolderName
}''';
  }

  /// ✅ Helper for converting from JSON string directly
  static BankInfo fromJsonString(String jsonString) =>
      BankInfo.fromJson(json.decode(jsonString));

  /// ✅ Helper for converting to JSON string
  String toJsonString() => json.encode(toJson());
}
