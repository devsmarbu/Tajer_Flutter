import 'dart:convert';

class ShippingAddress {
  String? ouaName;
  String? ouaAddress1;
  String? ouaAddress2;
  String? ouaPhone;
  String? ouaZip;
  String? ouaZone;
  String? ouaUnitNo;
  String? ouaStreet;
  String? ouaBuildingNo;
  String? ouaState;
  String? ouaCity;
  String? ouaOrderId;
  String? ouaType;
  String? ouaCountryCode;
  String? ouaCountry;
  String? ouaPhoneDcode;

  ShippingAddress({
    this.ouaName,
    this.ouaAddress1,
    this.ouaAddress2,
    this.ouaPhone,
    this.ouaZip,
    this.ouaZone,
    this.ouaUnitNo,
    this.ouaStreet,
    this.ouaBuildingNo,
    this.ouaState,
    this.ouaCity,
    this.ouaOrderId,
    this.ouaType,
    this.ouaCountryCode,
    this.ouaCountry,
    this.ouaPhoneDcode,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      ouaName: json["oua_name"],
      ouaAddress1: json["oua_address1"],
      ouaAddress2: json["oua_address2"],
      ouaPhone: json["oua_phone"],
      ouaZip: json["oua_zip"],
      ouaZone: json["oua_zone"],
      ouaUnitNo: json["oua_unit_no"],
      ouaStreet: json["oua_street"],
      ouaBuildingNo: json["oua_building_no"],
      ouaState: json["oua_state"],
      ouaCity: json["oua_city"],
      ouaOrderId: json["oua_order_id"],
      ouaType: json["oua_type"],
      ouaCountryCode: json["oua_country_code"],
      ouaCountry: json["oua_country"],
      ouaPhoneDcode: json["oua_phone_dcode"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "oua_name": ouaName,
      "oua_address1": ouaAddress1,
      "oua_address2": ouaAddress2,
      "oua_phone": ouaPhone,
      "oua_zip": ouaZip,
      "oua_zone": ouaZone,
      "oua_unit_no": ouaUnitNo,
      "oua_street": ouaStreet,
      "oua_building_no": ouaBuildingNo,
      "oua_state": ouaState,
      "oua_city": ouaCity,
      "oua_order_id": ouaOrderId,
      "oua_type": ouaType,
      "oua_country_code": ouaCountryCode,
      "oua_country": ouaCountry,
      "oua_phone_dcode": ouaPhoneDcode,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
