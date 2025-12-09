class Address {
  final String? addrId;
  final String? addrTitle;
  final String? addrName;
  final String? addrAddress1;
  final String? addrAddress2;
  final String? addrCity;
  final String? addrStateId;
  final String? addrCountryId;
  final String? addrPhone;
  final String? addrZone;
  final String? addrStreet;
  final String? addrBuildingNo;
  final String? addrUnitNo;
  final String? addrPhoneDcode;
  final String? addrZip;
  final String? addrLat;
  final String? addrLng;
  final String? addrIsDefault;
  final String? addrDeleted;
  final String? stateCode;
  final String? countryCode;
  final String? countryName;
  final String? stateName;
  final String? isShippingAddress;

  Address({
    this.addrId,
    this.addrTitle,
    this.addrName,
    this.addrAddress1,
    this.addrAddress2,
    this.addrCity,
    this.addrStateId,
    this.addrCountryId,
    this.addrPhone,
    this.addrZone,
    this.addrStreet,
    this.addrBuildingNo,
    this.addrUnitNo,
    this.addrPhoneDcode,
    this.addrZip,
    this.addrLat,
    this.addrLng,
    this.addrIsDefault,
    this.addrDeleted,
    this.stateCode,
    this.countryCode,
    this.countryName,
    this.stateName,
    this.isShippingAddress,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    addrId: json["addr_id"],
    addrTitle: json["addr_title"],
    addrName: json["addr_name"],
    addrAddress1: json["addr_address1"],
    addrAddress2: json["addr_address2"],
    addrCity: json["addr_city"],
    addrStateId: json["addr_state_id"],
    addrCountryId: json["addr_country_id"],
    addrPhone: json["addr_phone"],
    addrZone: json["addr_zone"],
    addrStreet: json["addr_street"],
    addrBuildingNo: json["addr_building_no"],
    addrUnitNo: json["addr_unit_no"],
    addrPhoneDcode: json["addr_phone_dcode"],
    addrZip: json["addr_zip"],
    addrLat: json["addr_lat"],
    addrLng: json["addr_lng"],
    addrIsDefault: json["addr_is_default"],
    addrDeleted: json["addr_deleted"],
    stateCode: json["state_code"],
    countryCode: json["country_code"],
    countryName: json["country_name"],
    stateName: json["state_name"],
    isShippingAddress: json["isShippingAddress"],
  );

  Map<String, dynamic> toJson() => {
    "addr_id": addrId,
    "addr_title": addrTitle,
    "addr_name": addrName,
    "addr_address1": addrAddress1,
    "addr_address2": addrAddress2,
    "addr_city": addrCity,
    "addr_state_id": addrStateId,
    "addr_country_id": addrCountryId,
    "addr_phone": addrPhone,
    "addr_zone": addrZone,
    "addr_street": addrStreet,
    "addr_building_no": addrBuildingNo,
    "addr_unit_no": addrUnitNo,
    "addr_phone_dcode": addrPhoneDcode,
    "addr_zip": addrZip,
    "addr_lat": addrLat,
    "addr_lng": addrLng,
    "addr_is_default": addrIsDefault,
    "addr_deleted": addrDeleted,
    "state_code": stateCode,
    "country_code": countryCode,
    "country_name": countryName,
    "state_name": stateName,
    "isShippingAddress": isShippingAddress,
  };
}